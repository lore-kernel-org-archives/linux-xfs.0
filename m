Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5ABD57F3F
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2015 14:44:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2BE82304048
	for <xfs@oss.sgi.com>; Mon, 14 Sep 2015 12:44:15 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ZPRorkQiIjGybivC (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Sep 2015 12:44:14 -0700 (PDT)
Date: Mon, 14 Sep 2015 15:44:12 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 09/13] xfs_repair: better checking of v5 attributes
Message-ID: <20150914194412.GJ34083@bfoster.bfoster>
References: <1441827251-13128-1-git-send-email-sandeen@sandeen.net>
	<1441827251-13128-10-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1441827251-13128-10-git-send-email-sandeen@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Wed, Sep 09, 2015 at 02:34:07PM -0500, Eric Sandeen wrote:
> The commit:
> 
> 0519f66 xfs_repair: better checking of v5 metadata fields
> 
> added new corruption checks to dir2.c but missed the similar
> code in attr_repair.c; add that here.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
>  repair/attr_repair.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index 2aafdf6..c8ba484 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -201,6 +201,15 @@ traverse_int_dablock(xfs_mount_t	*mp,
>  			goto error_out;
>  		}
>  
> +		/* corrupt node; rebuild the dir. */
> +		if (bp->b_error == -EFSBADCRC || bp->b_error == -EFSCORRUPTED) {
> +			libxfs_putbuf(bp);
> +			do_warn(
> +_("corrupt tree block %u for directory inode %" PRIu64 "\n"),
> +				bno, da_cursor->ino);
> +			goto error_out;
> +		}
> +

Hmm, well this certainly looks similar, but is it the right thing to do
for xattrs? I haven't followed through how exactly directories are
rebuilt, but there does appear to be a recovery path in the dir2
context. A failure there simply puts the inode on a "bad" list to be
rebuilt later, presumably from data collected from all of the inodes.

If we fail here, it looks like we just clear the attribute fork. So are
we failing too hard, too soon here if a dablock crc happens to be
incorrect?

Brian

>  		if (nodehdr.count > geo->node_ents)  {
>  			do_warn(_("bad record count in inode %" PRIu64 ", "
>  				  "count = %d, max = %d\n"),
> -- 
> 1.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
