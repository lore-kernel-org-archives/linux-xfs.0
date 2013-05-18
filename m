Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AD7817F3F
	for <xfs@oss.sgi.com>; Sat, 18 May 2013 00:07:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 90C138F8068
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 22:07:38 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id PgNSooLvb1hSwIKS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 22:07:37 -0700 (PDT)
Message-ID: <51970C90.5050005@oracle.com>
Date: Sat, 18 May 2013 13:07:28 +0800
From: Jeff Liu <jeff.liu@oracle.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, xfs@oss.sgi.com

On 05/18/2013 11:25 AM, Dave Chinner wrote:
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
> 
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
> 
> The worst step for me is, by far, the git-am step. Resolving patch
> conflicts is painful because you have to manually apply the patch,
> then remember to git add all the files modified by the patch, etc.
> 
> It'd be really cool if guilt could do the import directly from the
> mbox file without applying the patches, so the normal guilt
> force-push-fix-and-refresh method of solving patch conflicts could
> be used instead of git-am.
> 
> /me wonders if #jeffpc is listening here....
Ah? #jeffpc == me ? #jeffpc is up and listening... : just ignore;

Looks our test for 32-bit system is insufficient.  There has another bug
reports regarding 32-bit yesterday:
http://oss.sgi.com/archives/xfs/2013-05/msg00494.html

So I'm going to setup a 32-bit test environment for such tests together
with Michael.

Thanks,
-Jeff
> 
>> Great job on a fine patchset so far, and good luck!
> 
> Keep the bug reports rolling in, Michael. ;)
> 
>>
>> Michael
>>
>> [ 6188.126012] XFS: Assertion failed: first <= last && last <
>> BBTOB(bp->b_length), file: fs/xfs/xfs_trans_buf.c, line: 569
> 
> Hmmm - that seems familiar - I thought I'd already fixed a bug like
> that previously...
> 
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
