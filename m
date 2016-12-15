Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:20997 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757430AbcLOPTY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Dec 2016 10:19:24 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id uBFCP9B8030836
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 15 Dec 2016 12:25:09 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id uBFCO8JN014465
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 15 Dec 2016 12:24:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id uBFCO7aK028566
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 15 Dec 2016 12:24:08 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id uBFCO6ae003826
        for <linux-xfs@vger.kernel.org>; Thu, 15 Dec 2016 12:24:07 GMT
Date: Thu, 15 Dec 2016 15:23:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] xfs: connect refcount adjust functions to upper layers
Message-ID: <20161215122357.GA13876@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hello Darrick J. Wong,

The patch 33ba61292084: "xfs: connect refcount adjust functions to
upper layers" from Oct 3, 2016, leads to the following static checker
warning:

	fs/xfs/xfs_refcount_item.c:535 xfs_cui_recover()
	warn: passing freed memory 'rcur'

fs/xfs/xfs_refcount_item.c
   523                  }
   524          }
   525  
   526          xfs_refcount_finish_one_cleanup(tp, rcur, error);
                                                    ^^^^
Freed here.

   527          error = xfs_defer_finish(&tp, &dfops, NULL);
   528          if (error)
   529                  goto abort_error;
   530          set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
   531          error = xfs_trans_commit(tp);
   532          return error;
   533  
   534  abort_error:
   535          xfs_refcount_finish_one_cleanup(tp, rcur, error);
                                                    ^^^^
Again here...

   536          xfs_defer_cancel(&dfops);
   537          xfs_trans_cancel(tp);
   538          return error;
   539  }

regards,
dan carpenter
