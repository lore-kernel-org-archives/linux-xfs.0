Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46459 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752185AbdKDICu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 4 Nov 2017 04:02:50 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA482odU017180
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 4 Nov 2017 08:02:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vA482n9o010829
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 4 Nov 2017 08:02:49 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vA482nHZ009105
        for <linux-xfs@vger.kernel.org>; Sat, 4 Nov 2017 08:02:49 GMT
Date: Sat, 4 Nov 2017 11:02:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] xfs: scrub inodes
Message-ID: <20171104080243.b5gchkmrofmkdbdf@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hello Darrick J. Wong,

This is a semi-automatic email about new static checker warnings.

The patch 80e4e1268802: "xfs: scrub inodes" from Oct 17, 2017, leads 
to the following Smatch complaint:

fs/xfs/scrub/inode.c:356 xfs_scrub_dinode()
	 error: we previously assumed 'sc->ip' could be null (see line 338)

fs/xfs/scrub/inode.c
   337	
   338			if (dip->di_mode == 0 && sc->ip)
                                                 ^^^^^^
The patch adds a check if sc->ip is NULL

   339				xfs_scrub_ino_set_corrupt(sc, ino, bp);
   340	
   341			if (dip->di_projid_hi != 0 &&
   342			    !xfs_sb_version_hasprojid32bit(&mp->m_sb))
   343				xfs_scrub_ino_set_corrupt(sc, ino, bp);
   344			break;
   345		default:
   346			xfs_scrub_ino_set_corrupt(sc, ino, bp);
   347			return;
   348		}
   349	
   350		/*
   351		 * di_uid/di_gid -- -1 isn't invalid, but there's no way that
   352		 * userspace could have created that.
   353		 */
   354		if (dip->di_uid == cpu_to_be32(-1U) ||
   355		    dip->di_gid == cpu_to_be32(-1U))
   356			xfs_scrub_ino_set_warning(sc, bp);
                                                  ^^
But later we pass it to xfs_scrub_ino_set_warning() and it gets
dereferenced without checking...  I don't know the rules about sc->ip
well enough to say when it's NULL or not...

   357	
   358		/* di_format */

regards,
dan carpenter
