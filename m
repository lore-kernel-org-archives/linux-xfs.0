Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:46456 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751275AbeECVpZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 May 2018 17:45:25 -0400
Date: Thu, 3 May 2018 14:44:59 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/9] xfs_db: add a superblock info command
Message-ID: <20180503214459.GC26569@magnolia>
References: <152401952391.13048.15040850425873030425.stgit@magnolia>
 <152401955677.13048.14823962842951881263.stgit@magnolia>
 <aca4261a-84cf-802d-ba01-406305ed38b1@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aca4261a-84cf-802d-ba01-406305ed38b1@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, May 03, 2018 at 03:53:30PM -0500, Eric Sandeen wrote:
> On 4/17/18 9:45 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add an 'info' command to pretty-print the superblock geometry.
> 
> This seems ... fine, it's a bit out of xfs_db's charter but ...
> I see where you're going with this ... ;)
> 
> A little nitpicky below though.
> 
> > +static void
> > +info_help(void)
> > +{
> > +	dbprintf(_(
> > +"\n"
> > +" Pretty-prints the filesystem geometry as derived from the superblock.\n"
> > +" The output has the same format as mkfs.\n"
> 
> mkfs.xfs, xfs_info, and other utilities. ?

Ok.  It seems a little ouroborousy for one of the (future) xfs_info
backends to say that it behaves like xfs_info but eh that's fine. :)

> > +"\n"
> > +));
> > +
> > +}
> > +
> > +static int
> > +info_f(
> > +	int			argc,
> > +	char			**argv)
> > +{
> > +	struct xfs_fsop_geom	geo;
> > +	int			error;
> > +
> > +	error = -libxfs_fs_geometry(&mp->m_sb, &geo,
> > +			XFS_FS_GEOM_MAX_STRUCT_VER);
> > +	if (error) {
> > +		dbprintf(_("could not obtain geometry\n"));
> > +		exitcode = 1;
> > +		return 0;
> > +	}
> > +
> > +	xfs_report_geom(&geo, fsdevice, x.logname, x.rtname);
> > +	return 0;
> > +}
> > +
> > +static const struct cmdinfo info_cmd = {
> > +	.name =		"info",
> > +	.altname =	"i",
> > +	.cfunc =	info_f,
> > +	.argmin =	0,
> > +	.argmax =	0,
> > +	.canpush =	0,
> > +	.args =		NULL,
> > +	.oneline =	N_("dump superblock info"),
> 
> "pretty-print superblock geometry info"  ?

Ok.

> > +	.help =		info_help,
> > +};
> > +
> > +void
> > +info_init(void)
> > +{
> > +	add_command(&info_cmd);
> > +}
> > diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> > index 524b1ef..e29821e 100644
> > --- a/man/man8/xfs_db.8
> > +++ b/man/man8/xfs_db.8
> > @@ -670,6 +670,12 @@ using the hash function of the XFS directory and attribute implementation.
> >  .BI "help [" command ]
> >  Print help for one or all commands.
> >  .TP
> > +.B info
> > +Displays selected geometry information about the filesystem.
> > +The output will have the same format that
> > +.BR "mkfs.xfs" "(8)"
> > +prints when creating a filesystem.
> 
> Again adding xfs_info here might be nice too?
> 
> Just seems a little odd to single out one utility, not a huge deal tho.
> 
> I could just add these if you agree.  Or drop it if not ;)

Sure, it's fine by me.

--D

> > +.TP
> >  .BI "inode [" inode# ]
> >  Set the current inode number. If no
> >  .I inode#
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
