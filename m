Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Jun 2007 23:08:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5C682Wt010354
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2007 23:08:04 -0700
Date: Tue, 12 Jun 2007 16:08:00 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: factor extracting extent size hints from the inode
Message-ID: <20070612060800.GP86004887@sgi.com>
References: <20070604052333.GR85884050@sgi.com> <466E2B76.7010707@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466E2B76.7010707@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Vlad Apostolov <vapo@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Jun 12, 2007 at 03:13:26PM +1000, Vlad Apostolov wrote:
> David Chinner wrote:
> >Replace frequently repeated, open coded extraction of the
> >extent size hint from the xfs_inode with a single helper
> >function.
> >
> >Cheers,
> >
> >Dave.
> >  
> Dave,
> 
> I think XFS_DIFLAG_REALTIME and XFS_DIFLAG_EXTSIZE flags are
> mutually exclusive.

No, that's not true.

> XFS_DIFLAG_REALTIME and di_extsize have been introduced and used
> on Irix and Linux before XFS_DIFLAG_EXTSIZE.

Sure, but look at how we are supposed to set the extent size hint.
i.e XFS_IOC_FSSETXATTR, which by your own account should have the
XFS_XFLAG_EXTSIZE bit set in it. And that does not matter if
the file is realtime or not.

See the xfs_io code that sets the extent size hint:

    567         if (S_ISREG(stat.st_mode)) {
    568                 fsx.fsx_xflags |= XFS_XFLAG_EXTSIZE;
    569         } else if (S_ISDIR(stat.st_mode)) {
    570                 fsx.fsx_xflags |= XFS_XFLAG_EXTSZINHERIT;
    571         } else {
    572                 printf(_("invalid target file type - file %s\n"), path);
    573                 return 0;
    574         }
    575         fsx.fsx_extsize = extsz;
    576
    577         if ((xfsctl(path, fd, XFS_IOC_FSSETXATTR, &fsx)) < 0) {
    578                 printf("%s: XFS_IOC_FSSETXATTR %s: %s\n",
    579                         progname, path, strerror(errno));
    580                 return 0;
    581         }

If you use this method of setting the extent size hint, then you will
*always* get the XFS_DIFLAG_EXTSIZE flag set when you have an extent
size hint, regardless of whether it is a realtime file or not.

> This code:
> 
> +	if (unlikely(ip->i_d.di_flags & XFS_DIFLAG_REALTIME)) {
> +		extsz = (ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE)
> +				? ip->i_d.di_extsize
> +				: ip->i_mount->m_sb.sb_rextsize;
> +		ASSERT(extsz);
> +	} else {
> 
> shouldn't test for XFS_DIFLAG_EXTSIZE but use di_extsize if non zero.

Hmmmm - I think having one rule for realtime and a different rule
for data to do exactly the same thing is busted.

Like the realtime code, there are many places the non-realtime
code don't bother to check for a valid extent size hint flag - it
just read it blindly. That was part of the problem that the DMF
folks tripped over - the flag wasn't set but the hint was, and bad
things were happening because it wasn't consistently applied.

Also, if we want to fix up the setting of the extent size hint
so that it errors out if you don't set the XFS_XFLAG_EXTSIZE as
well, then we'd have to make an exception for the realtime inodes.

So, there's plenty of reasons for leaving this code as it stands
and have both realtime and non-realtime behave the same way.

Thoughts?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
