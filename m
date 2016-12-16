Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33162 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754045AbcLPBrL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Dec 2016 20:47:11 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id uBG1kjWK030996
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Dec 2016 01:46:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id uBG1kjBx013118
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Dec 2016 01:46:45 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id uBG1kjR6019729
        for <linux-xfs@vger.kernel.org>; Fri, 16 Dec 2016 01:46:45 GMT
Date: Thu, 15 Dec 2016 17:46:42 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [bug report] xfs: connect refcount adjust functions to upper
 layers
Message-ID: <20161216014642.GI5357@birch.djwong.org>
References: <20161215122357.GA13876@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161215122357.GA13876@elgon.mountain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Dec 15, 2016 at 03:23:57PM +0300, Dan Carpenter wrote:
> Hello Darrick J. Wong,
> 
> The patch 33ba61292084: "xfs: connect refcount adjust functions to
> upper layers" from Oct 3, 2016, leads to the following static checker
> warning:
> 
> 	fs/xfs/xfs_refcount_item.c:535 xfs_cui_recover()
> 	warn: passing freed memory 'rcur'
> 
> fs/xfs/xfs_refcount_item.c
>    523                  }
>    524          }
>    525  
>    526          xfs_refcount_finish_one_cleanup(tp, rcur, error);
>                                                     ^^^^
> Freed here.
> 
>    527          error = xfs_defer_finish(&tp, &dfops, NULL);
>    528          if (error)
>    529                  goto abort_error;
>    530          set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
>    531          error = xfs_trans_commit(tp);
>    532          return error;
>    533  
>    534  abort_error:
>    535          xfs_refcount_finish_one_cleanup(tp, rcur, error);
>                                                     ^^^^
> Again here...

Yep, definitely a bug.  I'll make a fix.

--D

> 
>    536          xfs_defer_cancel(&dfops);
>    537          xfs_trans_cancel(tp);
>    538          return error;
>    539  }
> 
> regards,
> dan carpenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
