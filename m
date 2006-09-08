Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Sep 2006 08:05:45 -0700 (PDT)
Received: from a.mx.filmlight.ltd.uk (host217-40-27-25.in-addr.btopenworld.com [217.40.27.25])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k88F5LDW005483
	for <xfs@oss.sgi.com>; Fri, 8 Sep 2006 08:05:24 -0700
Subject: Re: race in xfs_rename? (fwd)
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <20060906023128.GN10950339@melbourne.sgi.com>
References: <20060906083448.J3365803@wobbly.melbourne.sgi.com>
	 <20060906023128.GN10950339@melbourne.sgi.com>
Content-Type: text/plain
Message-Id: <1157724365.873.71.camel@orthia.filmlight.ltd.uk>
Mime-Version: 1.0
Date: 08 Sep 2006 15:06:05 +0100
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Nathan Scott <nathans@xfs.org>, xfs@oss.sgi.com

On Wed, 2006-09-06 at 03:31, David Chinner wrote:
> On Wed, Sep 06, 2006 at 08:34:48AM +1000, Nathan Scott wrote:
> > Hi Roger,
> > 
> > I'm gonna be rude and fwd your mail to the list - in the hope
> > someone there will be able to help you.  I'm running out of time
> > @sgi and have a bunch of stuff still to get done before I skip
> > outta here - having to look at the xfs_rename locking right now
> > might just be enough to make my head explode. ;)
> > 
> > cheers.
> > 
> > ----- Forwarded message from Roger Willcocks <roger@filmlight.ltd.uk> -----
> > 
> > Date: 05 Sep 2006 14:30:30 +0100
> > To: nathans@sgi.com
> > X-Mailer: Ximian Evolution 1.2.2 (1.2.2-4) 
> > From: Roger Willcocks <roger@filmlight.ltd.uk>
> > Subject: race in xfs_rename?
> > 
> > Hi Nathan,
> > 
> > I think I must be missing something here:
> > 
> > xfs_rename calls xfs_lock_for_rename, which i-locks the source file and
> > directory, target directory, and (if it already exists) the target file.
> > 
> > It returns a two-to-four entry list of participating inodes.
> > 
> > xfs_rename unlocks them all, creates a transaction, and then locks them
> > all again.
> > 
> > Surely while they're unlocked, another processor could jump in and
> > fiddle with the underlying files and directories?
> 
> I don't think that can happen due to i_mutex locking at the vfs layer
> i.e. in do_rename() via lock_rename() and in vfs_rename_{dir,other}().
> Hence I think it is safe for XFS to do what it does.
> 
> FWIW, in Irix where there is no higher layer locking, XFS has extra
> checks and locks (ancestor lock, inode generation count checks, etc)
> to ensure nothing changed when the locks were dropped and regained.
> AFAICT, the Linux XFS code doesn't need to do of this because the VFS
> guarantees us that things won't change.....
> 
> Cheers,
> 
> Dave.

Hi Dave & Nathan,

yes that makes sense. I'm currently chasing a couple of xfs shutdowns on
customer clusters, and 'rename' seems to be a factor, although it could
just as well be a dodgy network driver, or whatever. I'll let you know
if I find a reproducible test case.

I've also been looking into a couple of 'LEAFN node level is X' warnings
from xfs_repair, and it seems to me that leaf nodes don't actually have
a /level/ member, although internal nodes do (compare
xfs_dir2_leaf_hdr_t and xfs_da_intnode_t). The value being tested by
xfs_repair is actually leaf->hdr.stale, so the warning is bogus.

Or so it seems to me...

--
Roger
