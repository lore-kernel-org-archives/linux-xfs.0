Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8C07C7F50
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 10:10:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6ADD6304051
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 08:10:51 -0700 (PDT)
Received: from mail-la0-f52.google.com (mail-la0-f52.google.com
	[209.85.215.52]) by cuda.sgi.com with ESMTP id ovnKgGsqrXaj6EdX
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 27 May 2015 08:10:49 -0700 (PDT)
Received: by labko7 with SMTP id ko7so6048008lab.2
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 08:10:48 -0700 (PDT)
Received: from [192.168.1.189] (78-31-92-147.ostrog.net.pl. [78.31.92.147])
	by mx.google.com with ESMTPSA id
	mx10sm3897897lbb.20.2015.05.27.08.10.46 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Wed, 27 May 2015 08:10:47 -0700 (PDT)
Message-ID: <5565E064.8060105@gmail.com>
Date: Wed, 27 May 2015 17:19:00 +0200
From: Fanael Linithien <fanael4@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/5] xfs_repair: refuse to run if we don't recognize
	version or feature flags
References: <20150527054536.GB10175@birch.djwong.org>
In-Reply-To: <20150527054536.GB10175@birch.djwong.org>
In-Reply-To: <20150527054536.GB10175@birch.djwong.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

 > Apparently xfs_repair running on a v5 filesystem doesn't check the
 > compat, rocompat, or incompat feature flags for bits that it doesn't
 > know about, which means that old xfs_repairs can wreak havoc. So,
 > strengthen the checks to prevent repair from "repairing" anything it
 > doesn't understand.
 >
 > v2: Move the complaint code after the version number check, and print
 > the actual feature bits that we don't recognize.
 >
 > Signed-off-by: Darrick J. Wong <darrick.wong at oracle.com>
 > ---
 >  repair/versions.c |   33 +++++++++++++++++++++++++++++++++
 >  1 file changed, 33 insertions(+)
 >
 > diff --git a/repair/versions.c b/repair/versions.c
 > index c1dff72..dbe41a4 100644
 > --- a/repair/versions.c
 > +++ b/repair/versions.c
 > @@ -175,6 +175,39 @@ _("WARNING:  you have disallowed 
superblock-feature-bits-allowed\n"
 >          }
 >      }
 >
 > +    /* Look for V5 feature flags we don't know about */
 > +    if (XFS_SB_VERSION_NUM(sb) >= XFS_SB_VERSION_5) {
 > +        if (xfs_sb_has_ro_compat_feature(sb,
 > +                XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
 > +            do_warn(
 > +_("Superblock has unknown read-only compatible features (0x%x) 
enabled.\n"
 > +"Using a more recent xfs_repair is recommended.\n"),
 > +                sb->sb_features_ro_compat &
 > +                        XFS_SB_FEAT_RO_COMPAT_UNKNOWN);
 > +            issue_warning = 1;
 > +        }
 > +        if (xfs_sb_has_incompat_feature(sb,
 > +                XFS_SB_FEAT_INCOMPAT_UNKNOWN)) {
 > +            do_warn(
 > +_("Superblock has unknown read-only compatible features (0x%x) 
enabled.\n"
 > +"Using a more recent xfs_repair is recommended.\n"),
 > +                sb->sb_features_ro_compat &
 > +                        XFS_SB_FEAT_RO_COMPAT_UNKNOWN);

Copy/paste error, do you mean incompat?

 > +            issue_warning = 1;
 > +        }
 > +        if (xfs_sb_has_compat_feature(sb,
 > +                XFS_SB_FEAT_COMPAT_UNKNOWN)) {
 > +            do_warn(
 > +_("Superblock has unknown compatible features (0x%x) enabled.\n"
 > +"Using a more recent xfs_repair is recommended.\n"),
 > +                sb->sb_features_ro_compat &
 > +                        XFS_SB_FEAT_RO_COMPAT_UNKNOWN);

compat here?

 > +            issue_warning = 1;
 > +        }
 > +        if (issue_warning)
 > +            return 1;
 > +    }
 > +
 >      if (xfs_sb_version_hasattr(sb))  {
 >          if (!fs_attributes_allowed)  {
 >              if (!no_modify)  {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
