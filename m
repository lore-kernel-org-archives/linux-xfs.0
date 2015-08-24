Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F3DF97F37
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 07:41:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CD22B8F8040
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 05:41:15 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6670fRWISor7XKu7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Aug 2015 05:41:14 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 710FEABE
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 12:41:13 +0000 (UTC)
Date: Mon, 24 Aug 2015 08:41:12 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: collapse allocsize and biosize mount option handling
Message-ID: <20150824124110.GC50895@bfoster.bfoster>
References: <55D79504.6040305@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55D79504.6040305@redhat.com>
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

On Fri, Aug 21, 2015 at 04:15:48PM -0500, Eric Sandeen wrote:
> The allocsize and biosize mount options are handled identically,
> other than allocsize accepting suffixes.  suffix_kstrtoint handles
> bare numbers just fine too, so these can be collapsed.
> 
> (In other news, though, maybe biosize needs to be deprecated?
> XFS_IOC_SETBIOSIZE and XFS_IOC_GETBIOSIZE are deprecated, and
> "biosize" was removed from Documentation/ back in 2005 ...)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 1fb1656..4bd6c0d 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -261,16 +261,8 @@ xfs_parseargs(
>  			mp->m_rtname = kstrndup(value, MAXNAMELEN, GFP_KERNEL);
>  			if (!mp->m_rtname)
>  				return -ENOMEM;
> -		} else if (!strcmp(this_char, MNTOPT_BIOSIZE)) {
> -			if (!value || !*value) {
> -				xfs_warn(mp, "%s option requires an argument",
> -					this_char);
> -				return -EINVAL;
> -			}
> -			if (kstrtoint(value, 10, &iosize))
> -				return -EINVAL;
> -			iosizelog = ffs(iosize) - 1;
> -		} else if (!strcmp(this_char, MNTOPT_ALLOCSIZE)) {
> +		} else if (!strcmp(this_char, MNTOPT_ALLOCSIZE) ||
> +			   !strcmp(this_char, MNTOPT_BIOSIZE)) {
>  			if (!value || !*value) {
>  				xfs_warn(mp, "%s option requires an argument",
>  					this_char);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
