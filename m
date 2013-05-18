Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4AB5929DF8
	for <xfs@oss.sgi.com>; Sat, 18 May 2013 00:41:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B35C8AC002
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 22:41:07 -0700 (PDT)
Received: from mail-ie0-f177.google.com (mail-ie0-f177.google.com
	[209.85.223.177]) by cuda.sgi.com with ESMTP id
	LzYLFzrfdF9cWEPK (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 22:41:05 -0700 (PDT)
Received: by mail-ie0-f177.google.com with SMTP id 9so10937185iec.36
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 22:41:05 -0700 (PDT)
Message-ID: <51971457.7060903@gmail.com>
Date: Sat, 18 May 2013 01:40:39 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 00/30] xfsprogs: Initial CRC support
References: <1368789205-19969-1-git-send-email-david@fromorbit.com>
	<51969917.2080209@gmail.com> <20130518032507.GA6495@dastard>
In-Reply-To: <20130518032507.GA6495@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 05/17/2013 11:25 PM, Dave Chinner wrote:
> On Fri, May 17, 2013 at 04:54:47PM -0400, Michael L. Semon wrote:
>> On 05/17/2013 07:12 AM, Dave Chinner wrote:
>>> Hi Folks,
>>>
>>> This is the first real "works ok" CRC patchset for xfsprogs. It
>>> provides full support for mkfs.xfs and xfs_repair, and partial
>>> read-only support for xfs_db.
>>>
>>> For mkfs.xfs, it does everything properly, and filesystems that are
>>> freshly made also run cleanly through xfs_repair and mount and run
>>> just fine.
>>>
>>> For xfs_repair, it reads and writes all metadata with CRC checks,
>>> calculations and validation just like the kernel code does, but it
>>> currently silently ignores the validation done in the IO layer.
>>> Enabling that is future work - it involves adding buffer error checking to
>>> every libxfs_readbuf() call that is made, and we do none of that
>>> right now. It does, however, fully validate all the non-CRC format
>>> metadata just as it does for non-CRC filesystems, and so the
>>> coverage it has is the same for both CRC and non-CRC filesystems.
>>>
>>> For xfs_db, there is read-only support for looking at the filesystem
>>> as the xfs_db IO stack does not support CRCs at all. We need to
>>> convert xfs_db to use the libxfs infrastructure to enable that.
>>> Apart from that, xfs_db has partial support for the extended
>>> metadata fields - the directory/attribute blocks don't have extended
>>> support yet, but everything else does.
>>>
>>> xfs_check is made special. It currently detects a version 5
>>> superblock, and immediately exits with success. Hence it always says
>>> CRC enabled filesystems are OK. This is a temporary change that
>>> enables running xfstests without full support in xfs_db for all the
>>> new metadata structures (like headers in remote symlink and
>>> attribute blocks). Depending on if we want to keep xfs-check useful
>>> for xfstests, we can revisit this bypass hack once xfs_db has been
>>> converted to use the libxfs IO engine.
>>>
>>> Overall, xfstests is now running enough to start to find bugs in the
>>> kernel CRC code - I'm mainly hitting remote attribute block bugs
>>> right now (generic/117!) but there's certainly less problems being
>>> reported than I expected.
>>>
>>> Oh, and I've tested it with external log devices and real time
>>> devices, too.
>>>
>>> Comments, thoughts, flames, and testing all welcome!
>>>
>>> Cheers,
>>>
>>> Dave.
>>
>> OK.  The basics look good so far.  The patchset applied without need
>> for additional work with vi and patch.  Whitespace errors were
>> reported for Patches 8, 14, 16, 17, 24, 25, and 27.  xfsprogs built
>> with no additional errors over a normal xfsprogs build.
>
> Can you send me the output indicating where the whitespace errors
> are? I don't get any warnings from guilt about them when I apply the
> patchset here...

If it makes any difference at all, I'm saving these patches using 
Thunderbird...

The pre-patchset xfsprogs has been saved as a tarball, so I can provide 
a non-git patch session if necessary.  Sorry so vague last time:  I was 
overjoyed that everything went through git so cleanly.

This is the result of the patches about which `git am` complained:

PATCH 08:

Applying: libxfs: add support for crc headers on remote symlinks
/usr/src/xfs/xfsprogs/.git/rebase-apply/patch:282: new blank line at EOF.
+

PATCH 14:

Applying: xfs: add CRCs to dir2/da node blocks
/usr/src/xfs/xfsprogs/.git/rebase-apply/patch:61: trailing whitespace.
                                         nodehdr.level, id->ino,
warning: 1 line adds whitespace errors.

PATCH 16:

Applying: xfs: split remote attribute code out
/usr/src/xfs/xfsprogs/.git/rebase-apply/patch:722: new blank line at EOF.
+
warning: 1 line adds whitespace errors.

PATCH 17:

Applying: xfs: add CRC protection to remote attributes
/usr/src/xfs/xfsprogs/.git/rebase-apply/patch:340: trailing whitespace.
          * allocating the blocks below.
warning: 1 line adds whitespace errors.

PATCH 24:

Applying: xfsprogs: add crc format support to repair
/usr/src/xfs/xfsprogs/.git/rebase-apply/patch:574: trailing whitespace.
                 if (scan_lbtree(be64_to_cpu(pp[i]), level, scan_bmapbt, 
type,
warning: 1 line adds whitespace errors.

PATCH 25:

Applying: xfs_repair: update for dir/attr crc format changes.
/usr/src/xfs/xfsprogs/.git/rebase-apply/patch:128: trailing whitespace.
                 if ((leafhdr.holes == 0 &&
/usr/src/xfs/xfsprogs/.git/rebase-apply/patch:130: space before tab in 
indent.
                                 leafhdr.firstused > firstb)  {
/usr/src/xfs/xfsprogs/.git/rebase-apply/patch:136: trailing whitespace.
                                         leafhdr.firstused,
/usr/src/xfs/xfsprogs/.git/rebase-apply/patch:146: trailing whitespace.
                                         leafhdr.firstused,
/usr/src/xfs/xfsprogs/.git/rebase-apply/patch:158: trailing whitespace.
                                         leafhdr.usedbytes,
warning: squelched 1 whitespace error
warning: 6 lines add whitespace errors.

PATCH 27:

Applying: xfs_db: disable modification for CRC enabled filessytems.
/usr/src/xfs/xfsprogs/.git/rebase-apply/patch:20: trailing whitespace.
                 fprintf(stderr,
warning: 1 line adds whitespace errors.

>> That all stated, the `tar -xvf qt-source.tar.xz` still fails on a
>> CRC-enabled filesystem.
>
> Not surprising - I haven't got a crc enabled filesystem all the way
> through xfstests yet. remote attributes are the current piece I'm
> working on getting fixed.
>
>> Worse, until I return home, I won't be able
>> to do serial-console capture of hard oopses.  However, the initial
>> oops I got was a soft one, so it is included after my closing.  The
>> kernel is this...
>>
>> last night's kernel git
>>
>> last night's xfs-oss/master
>>
>> some of your recent patches (didn't apply your 6_5 patch yet)
>>
>> J. Liu's most recent patchset + 2 older bitness patches
>>
>> Chandra's v8 pquota/gquota patchset + one E-mail fix
>>
>> Shaggy's JFS patch to make it through the old xfstests #068 on JFS
>>
>> an NILFS2 patch to address broken bmap handling, lurked from the
>> NILFS2 mailing list
>>
>> one local removed assert to make it through the old xfstests #111
>>
>> maybe one or two XFS patches beyond this
>>
>> ...all on a 32-bit Pentium 4.
>
> And reporting bugs :)
>
>> What I'm trying to state is that a lot is in there, but the PC is
>> spinning like a top, and xfstests results are really good right now.
>> However, if I feel the need to provide a fresh environment, patch
>> management is taking some time.
>
> How are you managing patches right now? When taking in a new
> patchset from a mailing list, I save them all in a mbox file,
> then use git-am to apply them to a temporary git branch. I then move
> to my real working branch, and do a 'guilt import-commit x..y' to
> convert the commits in the temporary branch to a set of guilt
> patches, and then go from there....

The patches themselves are stored as individual files, in case they need 
to be applied again.  Separate git branches are used for kernel patches, 
but for the XFS suite, I keep backup tarballs and work directly off of 
master.

A new branch is started at strategic points.  If you mention "this is 
based on 3.9.2 + xfsdev", kernel 3.9.2 is checked out into a new branch, 
xfs-oss/master is updated and merged, and the patches are reapplied.  It 
takes time but is the best way, until I can find the `git 
--backout-this-patch-cleanly --i-really-mean-it-this-time 
--do-not-bother-to-suggest-git-am-resolved-if-it-cannot-be-done` command.

The trick is to remember which patches to apply, so I might have a 
directory that has five great patches and one that no longer applies.

> The worst step for me is, by far, the git-am step. Resolving patch
> conflicts is painful because you have to manually apply the patch,
> then remember to git add all the files modified by the patch, etc.

I don't know how to use git to properly back out a patch that was made 
at some time in the past.  Disaster management in particular has left me 
to backup at strategic points.  On these older PCs, restore operations 
can be much faster than git recovery attempts.

`git am` is hard because that diagnostic "Patch does not apply" is not 
helpful, and the --ignore-whitespace option can cause trouble very quickly.

Any patches that don't apply by `git am` are reduced from E-mail to 
ordinary diffs and sent through `git apply`.  If that doesn't work, they 
go through patch; vimdiff is used to help splice the patches in by hand. 
  `git add` is then used to add the files.

> It'd be really cool if guilt could do the import directly from the
> mbox file without applying the patches, so the normal guilt
> force-push-fix-and-refresh method of solving patch conflicts could
> be used instead of git-am.
>
> /me wonders if #jeffpc is listening here....
>
>> Great job on a fine patchset so far, and good luck!

> Keep the bug reports rolling in, Michael. ;)

Thanks!  It's all good fun :-)

>>
>> Michael
>>
>> [ 6188.126012] XFS: Assertion failed: first <= last && last <
>> BBTOB(bp->b_length), file: fs/xfs/xfs_trans_buf.c, line: 569
>
> Hmmm - that seems familiar - I thought I'd already fixed a bug like
> that previously...

You may have fixed it already.  If there's a patch, either I don't have 
it, or it's stuck on my main xfstests PC at home.  Was this the issue 
that was triggered easily by xfstests xfs/017?

>> [ 6188.147632]  [<c11c6d67>] xfs_trans_log_buf+0x64/0x11b
>> [ 6188.147632]  [<c11a0653>] xfs_dir2_data_log_unused+0x7b/0x83
>> [ 6188.147632]  [<c11a0e45>] xfs_dir2_data_use_free+0x1bf/0x41a
>> [ 6188.147632]  [<c11a308b>] xfs_dir2_leaf_addname+0x307/0x6f2
>> [ 6188.147632]  [<c119d32f>] xfs_dir_createname+0x113/0x129
>> [ 6188.147632]  [<c1174633>] xfs_create+0x3e0/0x4fb
>
> I'll look into that further - it's a different problem to what I'm
> stuck on at the moment...
>
> Cheers,
>
> Dave.
>

No worries.  It will take a while to compile an initial xfstests report 
with CRC-enabled filesystems.

Thanks again!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
