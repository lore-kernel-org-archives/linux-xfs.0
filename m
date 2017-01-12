Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36655 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750932AbdALICA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Jan 2017 03:02:00 -0500
Received: by mail-oi0-f67.google.com with SMTP id u143so1756771oif.3
        for <linux-xfs@vger.kernel.org>; Thu, 12 Jan 2017 00:01:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170111173227.GS14038@birch.djwong.org>
References: <20170110194249.GK14038@birch.djwong.org> <CAOQ4uxggOoFJ_KR40XX2hU+bSr9zqXu9y_7HWqVxTfQ6ETC4hA@mail.gmail.com>
 <CAOQ4uxj+H4ZAXkPgob5ANJW=BDBzj6P2nKbb3aE9w1igGmcRfw@mail.gmail.com> <20170111173227.GS14038@birch.djwong.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 12 Jan 2017 10:01:54 +0200
Message-ID: <CAOQ4uxhGrREM54VdnOMct9CZTcNeMZz6CxYgNdbVvJn5J80KLg@mail.gmail.com>
Subject: Re: [RFC PATCH] xfs_db: sanitize geometry on load
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

On Wed, Jan 11, 2017 at 7:32 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Wed, Jan 11, 2017 at 12:01:22PM +0200, Amir Goldstein wrote:
>> On Wed, Jan 11, 2017 at 10:34 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> > On Tue, Jan 10, 2017 at 9:42 PM, Darrick J. Wong
>> > <darrick.wong@oracle.com> wrote:
>> >> xfs_db doesn't check the filesystem geometry when it's mounting, which
>> >> means that garbage agcount values can cause OOMs when we try to allocate
>> >> all the per-AG incore metadata.  If we see geometry that looks
>> >> suspicious, try to derive the actual AG geometry to avoid crashing the
>> >> system.  This should help with xfs/1301 fuzzing.
>> >>
>> >> Also fix up xfs_repair to use the min/max dblocks macros.
>> >>
>> >> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>> >
>> > Test machine is back to health with this patch, but some test are failing due
>> > to the new error messages.
>> > I guess its no surprise to you.
>> >
>> >
>> > xfs/1300 5s ... 5s
>> > xfs/1301         - output mismatch (see
>> > /home/amir/src/xfstests-dev/results//xfs/1301.out.bad)
>> >     --- tests/xfs/1301.out      2017-01-08 15:35:07.647897359 +0200
>> >     +++ /home/amir/src/xfstests-dev/results//xfs/1301.out.bad
>> > 2017-01-11 09:58:10.981678272 +0200
>> >     @@ -1,4 +1,61 @@
>> >      QA output created by 1301
>> >      Format and populate
>> >      Fuzz superblock
>> >     +xfs_db: device /dev/mapper/storage-scratch AG geometry is insane.
>> > Using agcount=4.
>> >     +SB sanity check failed
>> >     +Metadata corruption detected at xfs_sb block 0x0/0x200
>> >     +xfs_db: device /dev/mapper/storage-scratch AG geometry is insane.
>> > Using agcount=4.
>> >     ...
>> >     (Run 'diff -u tests/xfs/1301.out
>> > /home/amir/src/xfstests-dev/results//xfs/1301.out.bad'  to see the
>
> Uh.... this is odd, all that stuff should go into 1301.full.
>

Darrick,

I see that you went down the problematic path of redirecting input to
interactive xfs_db shell.

I say problematic, because I went down that path with xfs_io when
I wrote test overlay/016, because xfs_io -c "open foo" was broken:
http://www.spinics.net/lists/fstests/msg04526.html

What I found out is that on some systems, the "xfs_io>" echo appears
in output and on some systems it does not. It is not related to xfs_io
itself, but to something else in the environment, presumably, the shell
or the terminal?
I was running the same test with same version of xfs_io on
debian Jessie inside kvm-xfstests and on Ubuntu 16.04 (ssh+tmux)
and got different results.

Can you rearrange all the fuzzy helpers to use xfs_db -c instead of
redirecting stdin to xfs_db?

Regarding xfs/1301, all output from xfs_db should go to 1301.full, so
the existence of the "xfs_db>" prompt is probably not important, but
perhaps there are other factors in play which cause stderr from xfs_db
to get to 1301.out.bad on my system.
I must say that I looked to see where in xfs/1301 or in common/fuzzy
you redirect stderr to stdout and didn't find it.
Please enlighten me.

Amir.
