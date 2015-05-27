Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7B9187F50
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 13:42:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 40B358F8081
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 11:42:29 -0700 (PDT)
Received: from mail-oi0-f51.google.com (mail-oi0-f51.google.com
	[209.85.218.51]) by cuda.sgi.com with ESMTP id dBfrS0C4AyMPbMj0
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 27 May 2015 11:42:27 -0700 (PDT)
Received: by oiww2 with SMTP id w2so14620723oiw.0
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 11:42:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150527181503.GE10175@birch.djwong.org>
References: <20150526225132.26434.82404.stgit@birch.djwong.org>
	<20150527181503.GE10175@birch.djwong.org>
Date: Wed, 27 May 2015 20:42:27 +0200
Message-ID: <CA+o=1OUNtoqLxxdByRh8fcefN-zQHet5=dWWWPWN-byzmFnxtw@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] xfs_repair: refuse to run if we don't recognize
	version or feature flags
From: Fanael Linithien <fanael4@gmail.com>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

2015-05-27 20:15 GMT+02:00 Darrick J. Wong <darrick.wong@oracle.com>:
> Apparently xfs_repair running on a v5 filesystem doesn't check the
> compat, rocompat, or incompat feature flags for bits that it doesn't
> know about, which means that old xfs_repairs can wreak havoc.  So,
> strengthen the checks to prevent repair from "repairing" anything it
> doesn't understand.
>
> v2: Move the complaint code after the version number check, and print
> the actual feature bits that we don't recognize.
>
> v3: Fix some copy-pasta errors, and simpify the warning messages.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Fanael Linithien <fanael4@gmail.com>

>  repair/versions.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/repair/versions.c b/repair/versions.c
> index c1dff72..10bcd29 100644
> --- a/repair/versions.c
> +++ b/repair/versions.c
> @@ -175,6 +175,20 @@ _("WARNING:  you have disallowed superblock-feature-bits-allowed\n"
>                 }
>         }
>
> +       /* Look for V5 feature flags we don't know about */
> +       if (XFS_SB_VERSION_NUM(sb) >= XFS_SB_VERSION_5 &&
> +           (xfs_sb_has_compat_feature(sb, XFS_SB_FEAT_COMPAT_UNKNOWN) ||
> +            xfs_sb_has_ro_compat_feature(sb, XFS_SB_FEAT_RO_COMPAT_UNKNOWN) ||
> +            xfs_sb_has_incompat_feature(sb, XFS_SB_FEAT_INCOMPAT_UNKNOWN))) {
> +               do_warn(
> +_("Superblock has unknown compat/rocompat/incompat features (0x%x/0x%x/0x%x).\n"
> +  "Using a more recent xfs_repair is recommended.\n"),
> +                       sb->sb_features_compat & XFS_SB_FEAT_COMPAT_UNKNOWN,
> +                       sb->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_UNKNOWN,
> +                       sb->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_UNKNOWN);
> +               return 1;
> +       }
> +
>         if (xfs_sb_version_hasattr(sb))  {
>                 if (!fs_attributes_allowed)  {
>                         if (!no_modify)  {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
