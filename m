Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51299 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751066AbdAMHCV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Jan 2017 02:02:21 -0500
Date: Thu, 12 Jan 2017 23:02:14 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] xfs_db: sanitize geometry on load
Message-ID: <20170113070214.GE14038@birch.djwong.org>
References: <20170110194249.GK14038@birch.djwong.org>
 <CAOQ4uxggOoFJ_KR40XX2hU+bSr9zqXu9y_7HWqVxTfQ6ETC4hA@mail.gmail.com>
 <CAOQ4uxj+H4ZAXkPgob5ANJW=BDBzj6P2nKbb3aE9w1igGmcRfw@mail.gmail.com>
 <20170111173227.GS14038@birch.djwong.org>
 <CAOQ4uxhGrREM54VdnOMct9CZTcNeMZz6CxYgNdbVvJn5J80KLg@mail.gmail.com>
 <20170113010614.GD14038@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170113010614.GD14038@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

On Thu, Jan 12, 2017 at 05:06:14PM -0800, Darrick J. Wong wrote:
> On Thu, Jan 12, 2017 at 10:01:54AM +0200, Amir Goldstein wrote:
> > On Wed, Jan 11, 2017 at 7:32 PM, Darrick J. Wong
> > <darrick.wong@oracle.com> wrote:
> > > On Wed, Jan 11, 2017 at 12:01:22PM +0200, Amir Goldstein wrote:
> > >> On Wed, Jan 11, 2017 at 10:34 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> > >> > On Tue, Jan 10, 2017 at 9:42 PM, Darrick J. Wong
> > >> > <darrick.wong@oracle.com> wrote:
> > >> >> xfs_db doesn't check the filesystem geometry when it's mounting, which
> > >> >> means that garbage agcount values can cause OOMs when we try to allocate
> > >> >> all the per-AG incore metadata.  If we see geometry that looks
> > >> >> suspicious, try to derive the actual AG geometry to avoid crashing the
> > >> >> system.  This should help with xfs/1301 fuzzing.
> > >> >>
> > >> >> Also fix up xfs_repair to use the min/max dblocks macros.
> > >> >>
> > >> >> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > >> >
> > >> > Test machine is back to health with this patch, but some test are failing due
> > >> > to the new error messages.
> > >> > I guess its no surprise to you.
> > >> >
> > >> >
> > >> > xfs/1300 5s ... 5s
> > >> > xfs/1301         - output mismatch (see
> > >> > /home/amir/src/xfstests-dev/results//xfs/1301.out.bad)
> > >> >     --- tests/xfs/1301.out      2017-01-08 15:35:07.647897359 +0200
> > >> >     +++ /home/amir/src/xfstests-dev/results//xfs/1301.out.bad
> > >> > 2017-01-11 09:58:10.981678272 +0200
> > >> >     @@ -1,4 +1,61 @@
> > >> >      QA output created by 1301
> > >> >      Format and populate
> > >> >      Fuzz superblock
> > >> >     +xfs_db: device /dev/mapper/storage-scratch AG geometry is insane.
> > >> > Using agcount=4.
> > >> >     +SB sanity check failed
> > >> >     +Metadata corruption detected at xfs_sb block 0x0/0x200
> > >> >     +xfs_db: device /dev/mapper/storage-scratch AG geometry is insane.
> > >> > Using agcount=4.

Pah, what a dunce I am!  I think I figured out the cause of this.  The
inner loop of _scratch_xfs_fuzz_metadata is created by calling xfs_db on
the scratch filesystem to enumerate the available fuzz verbs.  This is
bad because sb 0 could be trashed (it certainly is in 1301) and crash
the debugger... and it's also unnecessary since the verb list doesn't
change.

I'll change the double loop to precompute the field and verb list and
use the precomputed value, saving us a potentially fraught call to
xfs_db for every field.

This also fixes the problem wherein xfs_repair fails to fix some field
in the superblock and the whole test suddenly stops working because the
scratch fs is toast.

--D

> > >> >     ...
> > >> >     (Run 'diff -u tests/xfs/1301.out
> > >> > /home/amir/src/xfstests-dev/results//xfs/1301.out.bad'  to see the
> > >
> > > Uh.... this is odd, all that stuff should go into 1301.full.
> > >
> > 
> > Darrick,
> > 
> > I see that you went down the problematic path of redirecting input to
> > interactive xfs_db shell.
> > 
> > I say problematic, because I went down that path with xfs_io when
> > I wrote test overlay/016, because xfs_io -c "open foo" was broken:
> > http://www.spinics.net/lists/fstests/msg04526.html
> >
> > What I found out is that on some systems, the "xfs_io>" echo appears
> > in output and on some systems it does not. It is not related to xfs_io
> > itself, but to something else in the environment, presumably, the shell
> > or the terminal?
> > I was running the same test with same version of xfs_io on
> > debian Jessie inside kvm-xfstests and on Ubuntu 16.04 (ssh+tmux)
> > and got different results.
> 
> I get the feeling this could be related to readline -- on my systems I
> build with libreadline6-dev installed and configure picks it up.  ISTR
> if configure doesn't find a libreadline xfs_db'll do things a little
> differently wrt printing the prompt... and that might be why you see
> stray "xfs_db>" and I don't.  Or maybe you're linking against a
> different version, or... ugh, what a mess.
> 
> > Can you rearrange all the fuzzy helpers to use xfs_db -c instead of
> > redirecting stdin to xfs_db?
> 
> I changed the tests to dump commands to a file and run:
> 
> _scratch_xfs_db -c "source $seqres.cmd"
> 
> but then discovered that the source command is just plain broken when
> invoked via -c, so I fixed that.  Then I noticed that you changed
> common/fuzzy to use a bash array and sent the patch to me, and now I'm
> wondering if that's a better solution than making tempfiles everywhere.
> 
> > Regarding xfs/1301, all output from xfs_db should go to 1301.full, so
> > the existence of the "xfs_db>" prompt is probably not important, but
> > perhaps there are other factors in play which cause stderr from xfs_db
> > to get to 1301.out.bad on my system.
> > I must say that I looked to see where in xfs/1301 or in common/fuzzy
> > you redirect stderr to stdout and didn't find it.
> 
> /me is confused; there should be a bunch of places where stderr gets
> redirected to stdout.
> 
> $ grep '2>' common/fuzzy -n
> 32:     find "${SCRATCH_MNT}/" -type f 2> /dev/null | head -n "${nr}" | while read f; do
> 52:     ls -laR "${SCRATCH_MNT}/test.1/" >/dev/null 2>&1
> 55:     (find "${SCRATCH_MNT}/test.1/" -type f -size -1048576k -print0 | xargs -0 cat) >/dev/null 2>&1
> 180:    newval="$(_scratch_xfs_get_metadata_field "${key}" "$@" 2> /dev/null)"
> 191:    while _scratch_unmount 2>/dev/null; do sleep 0.2; done
> 227:    _scratch_mount 2>&1
> 231:            _scratch_scrub -n -a 1 -e continue 2>&1
> 239:                    _scratch_scrub -y 2>&1
> 253:            _repair_scratch_fs 2>&1
> 261:        _scratch_xfs_repair -n 2>&1
> 268:    _scratch_mount 2>&1
> 271:            _scratch_scrub -e continue 2>&1
> 278:            _scratch_fuzz_modify 100 2>&1
> 286:    _scratch_xfs_repair -n 2>&1
> 298:    _scratch_mkfs_xfs >/dev/null 2>&1
> 
> Sorry this has been such a mess. :/
> 
> --D
> 
> > Please enlighten me.
> > 
> > Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
