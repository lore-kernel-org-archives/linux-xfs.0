Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22638 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751089AbdENEZM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 May 2017 00:25:12 -0400
Date: Sat, 13 May 2017 21:25:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ioctl_getfsmap.2: document the GETFSMAP ioctl
Message-ID: <20170514042500.GA4510@birch.djwong.org>
References: <CAG48ez3e+2VuvjtEfJuMujEo6PWBO3z8oM-otN2juq96jKdjCw@mail.gmail.com>
 <20170508204738.GL5973@birch.djwong.org>
 <CAG48ez0iLRazKvXty9CG8ENXvkG6b1xjO0Q75p+16HKNptFnow@mail.gmail.com>
 <20170509015324.GM5973@birch.djwong.org>
 <20170509211746.GA87747@gmail.com>
 <20170510163818.7bleiykxgnx3pkds@thunk.org>
 <87mvakpl5m.fsf@xmission.com>
 <20170510201437.GA9854@birch.djwong.org>
 <20170511051051.GA7533@zzz>
 <38F56772-7836-4902-929C-80908BFBEA7B@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38F56772-7836-4902-929C-80908BFBEA7B@dilger.ca>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Dilger <adilger@dilger.ca>
Cc: Eric Biggers <ebiggers3@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Theodore Ts'o <tytso@mit.edu>, Jann Horn <jannh@google.com>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, linux-man@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>

On Sat, May 13, 2017 at 07:41:24PM -0600, Andreas Dilger wrote:
> On May 10, 2017, at 11:10 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
> > 
> > On Wed, May 10, 2017 at 01:14:37PM -0700, Darrick J. Wong wrote:
> >> [cc btrfs, since afaict that's where most of the dedupe tool authors hang out]
> >> 
> >> On Wed, May 10, 2017 at 02:27:33PM -0500, Eric W. Biederman wrote:
> >>> Theodore Ts'o <tytso@mit.edu> writes:
> >>> 
> >>>> On Tue, May 09, 2017 at 02:17:46PM -0700, Eric Biggers wrote:
> >>>>> 1.) Privacy implications.  Say the filesystem is being shared between multiple
> >>>>>    users, and one user unpacks foo.tar.gz into their home directory, which
> >>>>>    they've set to mode 700 to hide from other users.  Because of this new
> >>>>>    ioctl, all users will be able to see every (inode number, size in blocks)
> >>>>>    pair that was added to the filesystem, as well as the exact layout of the
> >>>>>    physical block allocations which might hint at how the files were created.
> >>>>>    If there is a known "fingerprint" for the unpacked foo.tar.gz in this
> >>>>>    regard, its presence on the filesystem will be revealed to all users.  And
> >>>>>    if any filesystems happen to prefer allocating blocks near the containing
> >>>>>    directory, the directory the files are in would likely be revealed too.
> >> 
> >> Frankly, why are container users even allowed to make unrestricted ioctl
> >> calls?  I thought we had a bunch of security infrastructure to constrain
> >> what userspace can do to a system, so why don't ioctls fall under these
> >> same protections?  If your containers are really that adversarial, you
> >> ought to be blacklisting as much as you can.
> >> 
> > 
> > Personally I don't find the presence of sandboxing features to be a very good
> > excuse for introducing random insecure ioctls.  Not everyone has everything
> > perfectly "sandboxed" all the time, for obvious reasons.  It's easy to forget
> > about the filesystem ioctls, too, since they can be executed on any regular
> > file, without having to open some device node in /dev.
> > 
> > (And this actually does happen; the SELinux policy in Android, for example,
> > still allows apps to call any ioctl on their data files, despite all the effort
> > that has gone into whitelisting other types of ioctls.  Which should be fixed,
> > of course, but it shows that this kind of mistake is very easy to make.)
> > 
> >>>> Unix/Linux has historically not been terribly concerned about trying
> >>>> to protect this kind of privacy between users.  So for example, in
> >>>> order to do this, you would have to call GETFSMAP continously to track
> >>>> this sort of thing.  Someone who wanted to do this could probably get
> >>>> this information (and much, much more) by continuously running "ps" to
> >>>> see what processes are running.
> >>>> 
> >>>> (I will note. wryly, that in the bad old days, when dozens of users
> >>>> were sharing a one MIPS Vax/780, it was considered a *good* thing
> >>>> that social pressure could be applied when it was found that someone
> >>>> was running a CPU or memory hogger on a time sharing system.  The
> >>>> privacy right of someone running "xtrek" to be able to hide this from
> >>>> other users on the system was never considered important at all.  :-)
> >> 
> >> Not to mention someone running GETFSMAP in a loop will be pretty obvious
> >> both from the high kernel cpu usage and the huge number of metadata
> >> operations.
> > 
> > Well, only if that someone running GETFSMAP actually wants to watch things in
> > real-time (it's not necessary for all scenarios that have been mentioned), *and*
> > there is monitoring in place which actually detects it and can do something
> > about it.
> > 
> > Yes, PIDs have traditionally been global, but today we have PID namespaces, and
> > many other isolation features such as mount namespaces.  Nothing is perfect, of
> > course, and containers are a lot worse than VMs, but it seems weird to use that
> > as an excuse to knowingly make things worse...
> > 
> >> 
> >>>> Fortunately, the days of timesharing seem to well behind us.  For
> >>>> those people who think that containers are as secure as VM's (hah,
> >>>> hah, hah), it might be that best way to handle this is to have a mount
> >>>> option that requires root access to this functionality.  For those
> >>>> people who really care about this, they can disable access.
> >> 
> >> Or use separate filesystems for each container so that exploitable bugs
> >> that shut down the filesystem can't be used to kill the other
> >> containers.  You could use a torrent of metadata-heavy operations
> >> (fallocate a huge file, punch every block, truncate file, repeat) to DoS
> >> the other containers.
> >> 
> >>> What would be the reason for not putting this behind
> >>> capable(CAP_SYS_ADMIN)?
> >>> 
> >>> What possible legitimate function could this functionality serve to
> >>> users who don't own your filesystem?
> >> 
> >> As I've said before, it's to enable dedupe tools to decide, given a set
> >> of files with shareable blocks, roughly how many other times each of
> >> those shareable blocks are shared so that they can make better decisions
> >> about which file keeps its shareable blocks, and which file gets
> >> remapped.  Dedupe is not a privileged operation, nor are any of the
> >> tools.
> >> 
> > 
> > So why does the ioctl need to return all extent mappings for the entire
> > filesystem, instead of just the share count of each block in the file that the
> > ioctl is called on?
> 
> One possibility is that the ioctl() can return the mapping for all inodes
> owned by the calling PID (or others if CAP_SYS_ADMIN, CAP_DAC_OVERRIDE,
> or CAP_FOWNER is set), and return an "filesystem aggregate inode" (or more
> than one if there is a reason to do so) with all the other allocated blocks
> for inodes the user doesn't have permission to access?

Hmm, CAP_DAC_OVERRIDE/CAP_FOWNER?  That might be a reasonable set of
capabilities to grant access...

> IMHO, this would allow a non-root user the main benefit of GETFSMAP,  which
> is trying to determine how fragmented their files are and/or how fragmented
> the free space is, without leaking any information about file sizes, location,
> or other information the user can't already get today in a less efficient
> manner.
> 
> I don't know how hard this is to implement, but seems not impossible.

It's already implemented in both XFS and ext4. <cough>

File extents are marked as "owned" by "unknown".

Now, I suppose one could devise a scheme such that files that the caller
can open actually do get inode numbers returned, but ... that's more
engineering work, let's see if anyone asks for that (vs. asks for any of
the magic capability bits).

--D

> 
> Cheers, Andreas
> 
> 
> 
> 
> 


