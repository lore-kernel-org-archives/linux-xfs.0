Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AC3AA7F50
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 11:42:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9A1698F8087
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 09:42:36 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id iEyy4W4QufvxepNA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 27 May 2015 09:42:35 -0700 (PDT)
Date: Wed, 27 May 2015 09:42:31 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 1/5] xfs_repair: refuse to run if we don't recognize
	version or feature flags
Message-ID: <20150527164231.GC10175@birch.djwong.org>
References: <20150527054536.GB10175@birch.djwong.org>
	<5565E064.8060105@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5565E064.8060105@gmail.com>
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
To: Fanael Linithien <fanael4@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, May 27, 2015 at 05:19:00PM +0200, Fanael Linithien wrote:
> > Apparently xfs_repair running on a v5 filesystem doesn't check the
> > compat, rocompat, or incompat feature flags for bits that it doesn't
> > know about, which means that old xfs_repairs can wreak havoc. So,
> > strengthen the checks to prevent repair from "repairing" anything it
> > doesn't understand.
> >
> > v2: Move the complaint code after the version number check, and print
> > the actual feature bits that we don't recognize.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong at oracle.com>
> > ---
> >  repair/versions.c |   33 +++++++++++++++++++++++++++++++++
> >  1 file changed, 33 insertions(+)
> >
> > diff --git a/repair/versions.c b/repair/versions.c
> > index c1dff72..dbe41a4 100644
> > --- a/repair/versions.c
> > +++ b/repair/versions.c
> > @@ -175,6 +175,39 @@ _("WARNING:  you have disallowed
> superblock-feature-bits-allowed\n"
> >          }
> >      }
> >
> > +    /* Look for V5 feature flags we don't know about */
> > +    if (XFS_SB_VERSION_NUM(sb) >= XFS_SB_VERSION_5) {
> > +        if (xfs_sb_has_ro_compat_feature(sb,
> > +                XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
> > +            do_warn(
> > +_("Superblock has unknown read-only compatible features (0x%x)
> enabled.\n"
> > +"Using a more recent xfs_repair is recommended.\n"),
> > +                sb->sb_features_ro_compat &
> > +                        XFS_SB_FEAT_RO_COMPAT_UNKNOWN);
> > +            issue_warning = 1;
> > +        }
> > +        if (xfs_sb_has_incompat_feature(sb,
> > +                XFS_SB_FEAT_INCOMPAT_UNKNOWN)) {
> > +            do_warn(
> > +_("Superblock has unknown read-only compatible features (0x%x)
> enabled.\n"
> > +"Using a more recent xfs_repair is recommended.\n"),
> > +                sb->sb_features_ro_compat &
> > +                        XFS_SB_FEAT_RO_COMPAT_UNKNOWN);
> 
> Copy/paste error, do you mean incompat?
> 
> > +            issue_warning = 1;
> > +        }
> > +        if (xfs_sb_has_compat_feature(sb,
> > +                XFS_SB_FEAT_COMPAT_UNKNOWN)) {
> > +            do_warn(
> > +_("Superblock has unknown compatible features (0x%x) enabled.\n"
> > +"Using a more recent xfs_repair is recommended.\n"),
> > +                sb->sb_features_ro_compat &
> > +                        XFS_SB_FEAT_RO_COMPAT_UNKNOWN);
> 
> compat here?

Err, yes.  Thank you for catching all these.  No more patching past 10pm for
me.... :)

--D

> 
> > +            issue_warning = 1;
> > +        }
> > +        if (issue_warning)
> > +            return 1;
> > +    }
> > +
> >      if (xfs_sb_version_hasattr(sb))  {
> >          if (!fs_attributes_allowed)  {
> >              if (!no_modify)  {
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
