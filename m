Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A5D117F5A
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 18:51:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3F4A2AC006
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 16:51:16 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	OX8e70jGTdk8WG87 for <xfs@oss.sgi.com>;
	Mon, 22 Jul 2013 16:51:14 -0700 (PDT)
Date: Tue, 23 Jul 2013 09:50:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Start using pquotaino from the superblock.
Message-ID: <20130722235058.GF19986@dastard>
References: <1374273362.8941.2086.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1374273362.8941.2086.camel@chandra-dt.ibm.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Fri, Jul 19, 2013 at 05:36:02PM -0500, Chandra Seetharaman wrote:
> Change from the previous version:
> Addressed Ben's comments
>  - removed unnecessary sb_gquotino == NULLFSINO check in
>    xfs_sb_quota_to_disk()
>  - Changed the fs_quota_stat logic to not fail with EINVAL if
>    both gquota and pquota are available. Instead, fill fs_quota_stat
>    only with gquota information.
> ----
> 
> Start using pquotino and define a macro to check if the
> superblock has pquotino.
> 
> Keep backward compatibilty by alowing mount of older superblock
> with no separate pquota inode.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Chandra, now that this has been comitted, can you make sure that
the userspace tools handle the separate pquota inode correctly (i.e.
reapir, db, etc). You'll probably be best to work from the crc-dev
branch of the xfsprogs tree...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
