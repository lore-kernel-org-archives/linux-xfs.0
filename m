Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 41A3F7F3F
	for <xfs@oss.sgi.com>; Tue, 26 May 2015 18:49:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2EA6A304039
	for <xfs@oss.sgi.com>; Tue, 26 May 2015 16:49:27 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id f4mqgPO4fClLe9CE for <xfs@oss.sgi.com>;
	Tue, 26 May 2015 16:49:24 -0700 (PDT)
Message-ID: <55650687.5000905@sandeen.net>
Date: Tue, 26 May 2015 18:49:27 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/5] xfs_repair: refuse to run if we don't recognize
	version or feature flags
References: <20150526225126.26434.69010.stgit@birch.djwong.org>
	<20150526225132.26434.82404.stgit@birch.djwong.org>
In-Reply-To: <20150526225132.26434.82404.stgit@birch.djwong.org>
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

On 5/26/15 5:51 PM, Darrick J. Wong wrote:
> Apparently xfs_repair running on a v5 filesystem doesn't check the
> compat, rocompat, or incompat feature flags for bits that it doesn't
> know about, which means that old xfs_repairs can wreak havoc.  So,
> strengthen the checks to prevent repair from "repairing" anything it
> doesn't understand.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/versions.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> 
> diff --git a/repair/versions.c b/repair/versions.c
> index c1dff72..e60574d 100644
> --- a/repair/versions.c
> +++ b/repair/versions.c
> @@ -141,6 +141,13 @@ parse_sb_version(xfs_sb_t *sb)
>  		}
>  	}
>  
> +	/* Look for V5 feature flags we don't know about */
> +	if (XFS_SB_VERSION_NUM(sb) >= XFS_SB_VERSION_5 &&
> +	    (xfs_sb_has_ro_compat_feature(sb, XFS_SB_FEAT_RO_COMPAT_UNKNOWN) ||
> +	     xfs_sb_has_incompat_feature(sb, XFS_SB_FEAT_INCOMPAT_UNKNOWN) ||
> +	     xfs_sb_has_compat_feature(sb, XFS_SB_FEAT_COMPAT_UNKNOWN)))
> +		issue_warning = 1;
> +

should this go after the xfs_sb_good_version() check?

Seems like it's more of a fine-grained check on features for a given super
version, and should come after that check.

i.e. if for some reason XFS_SB_VERSION_NUM == 6, the root problem isn't
the feature set, it's the superblock version number.

And; would it be worth printing out what the features are?  I guess we have
no good existing mechanism for that, and could really only print hex values...
still, might be useful for bug reports...

-Eric


>  	if (issue_warning)  {
>  		do_warn(
>  _("This filesystem uses feature(s) not yet supported in this release.\n"
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
