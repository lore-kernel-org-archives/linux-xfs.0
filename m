Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 848247F50
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 12:44:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 31709AC005
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 10:44:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CgSNM446NjW3bH64 for
	<xfs@oss.sgi.com>; Wed, 27 Mar 2013 10:44:01 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2RHi0XL027113
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 13:44:01 -0400
Date: Wed, 27 Mar 2013 14:43:56 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: remove newlines from 3 xfs_alert_tag error strings
Message-ID: <20130327174355.GA22675@andromeda.usersys.redhat.com>
References: <5151ECCD.2080704@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5151ECCD.2080704@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Looks good,

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

On Tue, Mar 26, 2013 at 01:45:33PM -0500, Eric Sandeen wrote:
> xfs_alert_tag passes the format string to __xfs_printk,
> which adds its own "\n".  Having it in the original string
> leads to unintentional blank lines from these messages.
> 
> Most format strings have no newline, but these 3 do, leading to
> i.e.:
> 
> [ 7347.119911] XFS (sdb2): Access to block zero in inode 132 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1a05
> [ 7347.119911] 
> [ 7347.119919] XFS (sdb2): Access to block zero in inode 132 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1a05
> [ 7347.119919] 
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> p.s. - next up, why am I getting those messages . . . ?
> 
> 
> diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
> index b44af92..53db41f 100644
> --- a/fs/xfs/xfs_bmap.c
> +++ b/fs/xfs/xfs_bmap.c
> @@ -3425,7 +3425,7 @@ xfs_bmap_search_extents(
>  		xfs_alert_tag(ip->i_mount, XFS_PTAG_FSBLOCK_ZERO,
>  				"Access to block zero in inode %llu "
>  				"start_block: %llx start_off: %llx "
> -				"blkcnt: %llx extent-state: %x lastx: %x\n",
> +				"blkcnt: %llx extent-state: %x lastx: %x",
>  			(unsigned long long)ip->i_ino,
>  			(unsigned long long)gotp->br_startblock,
>  			(unsigned long long)gotp->br_startoff,
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 6104560..ac5faf5 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -160,7 +160,7 @@ xfs_error_report(
>  {
>  	if (level <= xfs_error_level) {
>  		xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
> -		"Internal error %s at line %d of file %s.  Caller 0x%p\n",
> +		"Internal error %s at line %d of file %s.  Caller 0x%p",
>  			    tag, linenum, filename, ra);
>  
>  		xfs_stack_trace();
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 5a30dd8..65412c2 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -107,7 +107,7 @@ xfs_alert_fsblock_zero(
>  	xfs_alert_tag(ip->i_mount, XFS_PTAG_FSBLOCK_ZERO,
>  			"Access to block zero in inode %llu "
>  			"start_block: %llx start_off: %llx "
> -			"blkcnt: %llx extent-state: %x\n",
> +			"blkcnt: %llx extent-state: %x",
>  		(unsigned long long)ip->i_ino,
>  		(unsigned long long)imap->br_startblock,
>  		(unsigned long long)imap->br_startoff,
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
