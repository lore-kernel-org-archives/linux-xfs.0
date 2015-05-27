Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E98147F50
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 09:54:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D8185304032
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 07:54:34 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id UjdhUGyXaBgHE4Qu for <xfs@oss.sgi.com>;
	Wed, 27 May 2015 07:54:32 -0700 (PDT)
Message-ID: <5565DAA7.4040406@sandeen.net>
Date: Wed, 27 May 2015 09:54:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/5] xfs_repair: refuse to run if we don't recognize
	version or feature flags
References: <20150526225126.26434.69010.stgit@birch.djwong.org>	<20150526225132.26434.82404.stgit@birch.djwong.org>
	<20150527054536.GB10175@birch.djwong.org>
In-Reply-To: <20150527054536.GB10175@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>, david@fromorbit.com
Cc: xfs@oss.sgi.com

On 5/27/15 12:45 AM, Darrick J. Wong wrote:
> Apparently xfs_repair running on a v5 filesystem doesn't check the
> compat, rocompat, or incompat feature flags for bits that it doesn't
> know about, which means that old xfs_repairs can wreak havoc.  So,
> strengthen the checks to prevent repair from "repairing" anything it
> doesn't understand.
> 
> v2: Move the complaint code after the version number check, and print
> the actual feature bits that we don't recognize.

Thanks.  That's a bit more wordy, but probably better, in the end.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/versions.c |   33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/repair/versions.c b/repair/versions.c
> index c1dff72..dbe41a4 100644
> --- a/repair/versions.c
> +++ b/repair/versions.c
> @@ -175,6 +175,39 @@ _("WARNING:  you have disallowed superblock-feature-bits-allowed\n"
>  		}
>  	}
>  
> +	/* Look for V5 feature flags we don't know about */
> +	if (XFS_SB_VERSION_NUM(sb) >= XFS_SB_VERSION_5) {
> +		if (xfs_sb_has_ro_compat_feature(sb,
> +				XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
> +			do_warn(
> +_("Superblock has unknown read-only compatible features (0x%x) enabled.\n"
> +"Using a more recent xfs_repair is recommended.\n"),
> +				sb->sb_features_ro_compat &
> +						XFS_SB_FEAT_RO_COMPAT_UNKNOWN);
> +			issue_warning = 1;
> +		}
> +		if (xfs_sb_has_incompat_feature(sb,
> +				XFS_SB_FEAT_INCOMPAT_UNKNOWN)) {
> +			do_warn(
> +_("Superblock has unknown read-only compatible features (0x%x) enabled.\n"
> +"Using a more recent xfs_repair is recommended.\n"),
> +				sb->sb_features_ro_compat &
> +						XFS_SB_FEAT_RO_COMPAT_UNKNOWN);
> +			issue_warning = 1;
> +		}
> +		if (xfs_sb_has_compat_feature(sb,
> +				XFS_SB_FEAT_COMPAT_UNKNOWN)) {
> +			do_warn(
> +_("Superblock has unknown compatible features (0x%x) enabled.\n"
> +"Using a more recent xfs_repair is recommended.\n"),
> +				sb->sb_features_ro_compat &
> +						XFS_SB_FEAT_RO_COMPAT_UNKNOWN);
> +			issue_warning = 1;
> +		}
> +		if (issue_warning)
> +			return 1;
> +	}
> +
>  	if (xfs_sb_version_hasattr(sb))  {
>  		if (!fs_attributes_allowed)  {
>  			if (!no_modify)  {
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
