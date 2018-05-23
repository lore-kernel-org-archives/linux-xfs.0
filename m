Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:39001 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754656AbeEWQUS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 May 2018 12:20:18 -0400
Date: Wed, 23 May 2018 09:20:15 -0700
From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: INFO: task hung in xlog_grant_head_check
Message-ID: <20180523162015.GA3684@sol.localdomain>
References: <000000000000457b2d056cbb0044@google.com>
 <20180522123107.GC3751@bfoster.bfoster>
 <20180522222620.GW23861@dastard>
 <20180522225208.GB658@sol.localdomain>
 <20180523074425.GM14384@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180523074425.GM14384@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>, syzbot <syzbot+568245b88fbaedcb1959@syzkaller.appspotmail.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com

Hi Darrick,

On Wed, May 23, 2018 at 12:44:25AM -0700, Darrick J. Wong wrote:
> On Tue, May 22, 2018 at 03:52:08PM -0700, Eric Biggers wrote:
> > On Wed, May 23, 2018 at 08:26:20AM +1000, Dave Chinner wrote:
> > > On Tue, May 22, 2018 at 08:31:08AM -0400, Brian Foster wrote:
> > > > On Mon, May 21, 2018 at 10:55:02AM -0700, syzbot wrote:
> > > > > Hello,
> > > > > 
> > > > > syzbot found the following crash on:
> > > > > 
> > > > > HEAD commit:    203ec2fed17a Merge tag 'armsoc-fixes' of git://git.kernel...
> > > > > git tree:       upstream
> > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=11c1ad77800000
> > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=f3b4e30da84ec1ed
> > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=568245b88fbaedcb1959
> > > > > compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> > > > > syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=122c7427800000
> > > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10387057800000
> > > > > 
> > > > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > > > Reported-by: syzbot+568245b88fbaedcb1959@syzkaller.appspotmail.com
> > > > > 
> > > > >         (ptrval): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > > > ................
> > > > >         (ptrval): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > > > ................
> > > > > XFS (loop0): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x2 len
> > > > > 1 error 117
> > > > > XFS (loop0): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -117,
> > > > > agno 0
> > > > > XFS (loop0): failed to read root inode
> > > > 
> > > > FWIW, the initial console output is actually:
> > > > 
> > > > [  448.028253] XFS (loop0): Mounting V4 Filesystem
> > > > [  448.033540] XFS (loop0): Log size 9371840 blocks too large, maximum size is 1048576 blocks
> > > > [  448.042287] XFS (loop0): Log size out of supported range.
> > > > [  448.047841] XFS (loop0): Continuing onwards, but if log hangs are experienced then please report this message in the bug report.
> > > > [  448.060712] XFS (loop0): totally zeroed log
> > > > 
> > > > ... which warns about an oversized log and resulting log hangs. Not
> > > > having dug into the details of why this occurs so quickly in this mount
> > > > failure path,
> > > 
> > > I suspect that it is a head and/or log tail pointer overflow, so when it
> > > tries to do the first trans reserve of the mount - to write the
> > > unmount record - it says "no log space available, please wait".
> > > 
> > > > it does look like we'd never have got past this point on a
> > > > v5 fs (i.e., the above warning would become an error and we'd not enter
> > > > the xfs_log_mount_cancel() path).
> > > 
> > > And this comes back to my repeated comments about fuzzers needing
> > > to fuzz properly made V5 filesystems as we catch and error out on
> > > things like this. Fuzzing random collections of v4 filesystem
> > > fragments will continue to trip over problems we've avoided with v5
> > > filesystems, and this is further evidence to point to that.
> > >
> > > 
> > > I'd suggest that at this point, syzbot XFS reports should be
> > > redirected to /dev/null. It's not worth our time to triage
> > > unreviewed bot generated bug reports until the syzbot developers
> > > start listening and acting on what we have been telling them
> > > about fuzzing filesystems and reproducing bugs that are meaningful
> > > and useful to us.
> > 
> > The whole point of fuzzing is to provide improper inputs.  A kernel
> > bug is a kernel bug, even if it's in deprecated/unmaintained code, or
> > involves userspace doing something unexpected.  If you have known
> > buggy code in XFS that you refuse to fix,
> 
> Ok, that's it.
> 
> I disagree with Google's syzbot strategy, and I dissent most vehemently!
> 
> The whole point of constructing free software in public is that we
> people communally build things that anyone can use for any purpose and
> that anyone can modify.  That privilege comes with a societal
> expectation that the people using this commons will contribute to the
> upkeep of that commons or it rots.  For end users that means helping us
> to find the gaps, but for software developers at large multinational
> companies that means (to a first approximation) pitching in to write the
> code, write the documentation, and to fix the problems.
> 
> Yes, there are many places where fs metadata validation is insufficient
> to avoid misbehavior.  Google's strategy of dumping vulnerability
> disclosures on public mailing lists every week, demanding that other
> people regularly reallocate their time to fix these problems, and not
> helping to fix anything breaks our free software societal norms.  Again,
> the whole point of free software is to share the responsibility, share
> the work, and share the gains.  That is how collaboration works.
> 
> Help us to improve the software so that we all will be better off.
> 
> Figure out how to strengthen the validation, figure out how to balance
> the risk of exposure against the risk of nonfunctionality, and figure
> out how to discuss with this community.  That is how the game works.
> 
> Google has enough money and smart people that you have (collectively)
> learned how to spoof humans, so you can well afford to spend a small
> fraction of that hiring some developers and writers and putting them to
> work with us.
> 
> If you refuse to do this, you already /have/ a config option to turn off
> the 'known buggy/unmaintained code in [your] kernel'; use it.  I will
> not repeat this message again[1].
> 

I actually agree that Google should doing more, but I think you're also shooting
the messenger.  The fact is that these bugs exist, a not-insignificant number of
which are exploitable security vulnerabilities, and *everyone* needs to be doing
more to address them.  I'm not sure you're aware, but Google employees have
already fixed around 200 syzkaller/syzbot reported bugs in the last 6 months;
that's hardly "not helping to fix anything".  Unfortunately it's still not
enough to even keep up with the rate of new bugs being reported, so we need to
be doing more still.  (And for context, as at other companies it's unfortunately
difficult to get organizational support for kernel-wide work; I'm not actually
on the syzbot team and have so far ended up working quite a bit on this in my
"free time" on this, fixing 35+ bugs, because I care, and I know that other
people care too, about the security and reliability of the Linux kernel.)

But even with more resources, the kernel is a huge project and there are always
going to be some subsystems without in-house experts.  For example, AFAIK Google
doesn't use XFS for anything, and CONFIG_XFS_FS isn't even enabled in Google's
production, Android, or Chrome OS.  Given that you are actually apparently paid
to work on XFS, I'd really hope you'd have a better attitude towards receiving
XFS bug reports with reproducers.  Other maintainers have responded differently
and it's unclear why XFS is so different.  For example the F2FS maintainer
immediately fixed all the syzbot bugs that were reported to them, and
maintainers of some networking subsystems have also been very responsive and
positive about receiving bug reports.  Though, unfortunately there seems to be a
lot of de-facto unmaintained code in the kernel too (or alternatively: Andrew
and Linus are the "maintainers"), so I will at least give you more credit than
that :-)

Now, if you *really* don't want syzbot to report XFS bugs as you believe XFS
contains known unfixable bugs or for other reasons, you can formally ask Dmitry
to remove CONFIG_XFS_FS from the syzbot config.  But of course that doesn't make
the bugs go away, it just makes the bug reports go away; you'll have to fix them
eventually anyway, one way or another.  I do think you're drastically
underestimating how useful the syzbot bug reports can be too -- note e.g. that
the bug Dave fixed by "fs: don't scan the inode cache before SB_BORN is set"
took only 3 days to be reported by syzbot after it gained support for mounting
XFS filesystems.  AFAICS that bug was in XFS for 7 years and was causing
production systems to mysteriously crash (very rarely), yet it took syzbot only
3 days to send you a C reproducer.

This is only at the early stage too --- syzkaller doesn't know how to fuzz the
XFS-specific ioctls yet, for example, but it could be taught.  It's already been
finding ext4 bugs that allowed anyone with access to an ext4 directory to
corrupt the filesystem and crash the kernel.  And note that syzkaller is
coverage-guided, using CONFIG_KCOV, so it *will* find bugs that you never
thought to test for in manually written (fuzz) tests.  Non-coverage-guided
fuzzers are no longer state of the art.  I've been really amazed at the bugs
syzkaller been able to find in other kernel subsystems, e.g. obscure races that
no one would have ever thought to test for.

Anyone is welcome to contribute to syzkaller and syzbot too; all the code is on
Github and Apache licensed.  AFAIK the only thing missing from the git repo is a
few configuration files that control how the specific syzbot installation that
Dmitry is running is set up (like how many VMs to use, the credentials, etc.)

Anyway, I'm going to keep helping with bugs either way.  Getting into arguments
like this is just a waste of time, and distracts from the real work getting
done.

Thanks,

- Eric
