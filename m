Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9BLe82r243539 for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 16:40:09 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	df5bIPyFW7Y7Q0Lv (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 14:41:40 -0700 (PDT)
Date: Thu, 11 Oct 2012 17:41:39 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/19] xfs: verify superblocks as they are read from disk
Message-ID: <20121011214139.GD6346@infradead.org>
References: <1349754670-32009-1-git-send-email-david@fromorbit.com>
	<1349754670-32009-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1349754670-32009-5-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 09, 2012 at 02:50:55PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add a superblock verify callback function and pass it into the
> buffer read functions. Remove the now redundant verification code
> that is currently in use.
> 
> Adding verification shows that secondary superblocks never have
> their "sb_inprogress" flag cleared by mkfs.xfs, so when validating
> the secondary superblocks during a grow operation we have to avoid
> checking this field. Even if we fix mkfs, we will still have to
> ignore this field for verification purposes unless a version of mkfs
> that does not have this bug was used.

> @@ -304,9 +304,8 @@ STATIC int
>  xfs_mount_validate_sb(
>  	xfs_mount_t	*mp,
>  	xfs_sb_t	*sbp,
> -	int		flags)
> +	bool		check_inprogress)
>  {
> -	int		loud = !(flags & XFS_MFSI_QUIET);

I don't think removing this is a good idea.  The quiet flag is used
to silence all filesystem warnings when the kernel is blindly trying
all filesystem types when searching for the correct root fs type.

If we always print warnings here people will get annoying messages
when that happens for a non-XFS rootfs that we're asked to verify.

I'd rather make check_inprogress another flag here.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
