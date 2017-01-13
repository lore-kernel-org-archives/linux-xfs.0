Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33585 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751131AbdAMHP4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Jan 2017 02:15:56 -0500
Received: by mail-oi0-f67.google.com with SMTP id j15so5855465oih.0
        for <linux-xfs@vger.kernel.org>; Thu, 12 Jan 2017 23:15:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170113070214.GE14038@birch.djwong.org>
References: <20170110194249.GK14038@birch.djwong.org> <CAOQ4uxggOoFJ_KR40XX2hU+bSr9zqXu9y_7HWqVxTfQ6ETC4hA@mail.gmail.com>
 <CAOQ4uxj+H4ZAXkPgob5ANJW=BDBzj6P2nKbb3aE9w1igGmcRfw@mail.gmail.com>
 <20170111173227.GS14038@birch.djwong.org> <CAOQ4uxhGrREM54VdnOMct9CZTcNeMZz6CxYgNdbVvJn5J80KLg@mail.gmail.com>
 <20170113010614.GD14038@birch.djwong.org> <20170113070214.GE14038@birch.djwong.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 13 Jan 2017 09:07:09 +0200
Message-ID: <CAOQ4uxgqS-9G01WRECz+mqfxL1WhXBS44tDjAtYe7Wzk08b-pw@mail.gmail.com>
Subject: Re: [RFC PATCH] xfs_db: sanitize geometry on load
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

On Fri, Jan 13, 2017 at 9:02 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Thu, Jan 12, 2017 at 05:06:14PM -0800, Darrick J. Wong wrote:
>> On Thu, Jan 12, 2017 at 10:01:54AM +0200, Amir Goldstein wrote:
>> > On Wed, Jan 11, 2017 at 7:32 PM, Darrick J. Wong
>> > <darrick.wong@oracle.com> wrote:
>> > > On Wed, Jan 11, 2017 at 12:01:22PM +0200, Amir Goldstein wrote:
>> > >> On Wed, Jan 11, 2017 at 10:34 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> > >> > On Tue, Jan 10, 2017 at 9:42 PM, Darrick J. Wong
>> > >> > <darrick.wong@oracle.com> wrote:
>> > >> >> xfs_db doesn't check the filesystem geometry when it's mounting, which
>> > >> >> means that garbage agcount values can cause OOMs when we try to allocate
>> > >> >> all the per-AG incore metadata.  If we see geometry that looks
>> > >> >> suspicious, try to derive the actual AG geometry to avoid crashing the
>> > >> >> system.  This should help with xfs/1301 fuzzing.
>> > >> >>
>> > >> >> Also fix up xfs_repair to use the min/max dblocks macros.
>> > >> >>
>> > >> >> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>> > >> >
>> > >> > Test machine is back to health with this patch, but some test are failing due
>> > >> > to the new error messages.
>> > >> > I guess its no surprise to you.
>> > >> >
>> > >> >
>> > >> > xfs/1300 5s ... 5s
>> > >> > xfs/1301         - output mismatch (see
>> > >> > /home/amir/src/xfstests-dev/results//xfs/1301.out.bad)
>> > >> >     --- tests/xfs/1301.out      2017-01-08 15:35:07.647897359 +0200
>> > >> >     +++ /home/amir/src/xfstests-dev/results//xfs/1301.out.bad
>> > >> > 2017-01-11 09:58:10.981678272 +0200
>> > >> >     @@ -1,4 +1,61 @@
>> > >> >      QA output created by 1301
>> > >> >      Format and populate
>> > >> >      Fuzz superblock
>> > >> >     +xfs_db: device /dev/mapper/storage-scratch AG geometry is insane.
>> > >> > Using agcount=4.
>> > >> >     +SB sanity check failed
>> > >> >     +Metadata corruption detected at xfs_sb block 0x0/0x200
>> > >> >     +xfs_db: device /dev/mapper/storage-scratch AG geometry is insane.
>> > >> > Using agcount=4.
>
> Pah, what a dunce I am!  I think I figured out the cause of this.  The
> inner loop of _scratch_xfs_fuzz_metadata is created by calling xfs_db on
> the scratch filesystem to enumerate the available fuzz verbs.  This is
> bad because sb 0 could be trashed (it certainly is in 1301) and crash
> the debugger... and it's also unnecessary since the verb list doesn't
> change.
>
> I'll change the double loop to precompute the field and verb list and
> use the precomputed value, saving us a potentially fraught call to
> xfs_db for every field.
>
> This also fixes the problem wherein xfs_repair fails to fix some field
> in the superblock and the whole test suddenly stops working because the
> scratch fs is toast.
>

Nice :)
This was also the case I was referring to where strerr is not redirected to
stdout, which was causing the errors above to get to 1301.out.bad.
