Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3444D7F37
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 16:27:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0F48D8F8040
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 14:27:48 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	j4kHdxvIO8OGgPmA for <xfs@oss.sgi.com>;
	Tue, 22 Sep 2015 14:27:43 -0700 (PDT)
Date: Wed, 23 Sep 2015 07:27:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests, bad generic tests 009 and 308
Message-ID: <20150922212740.GJ19114@dastard>
References: <55FC3E0E.9060506@nomovok.com> <20150918224412.GE26895@dastard>
	<55FFE665.7040004@nomovok.com> <20150921225244.GD19114@dastard>
	<56014C62.1070403@nomovok.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56014C62.1070403@nomovok.com>
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
To: Angelo Dureghello <angelo.dureghello@nomovok.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 22, 2015 at 02:41:06PM +0200, Angelo Dureghello wrote:
> >>I have a 16MB partition, and wondering why xfs allows from test 308
> >>to create a 16TB file.
> >>
> >>-rw------- 1 root root  17592186044415 Sep 18 09:40 testfile.308
> >https://en.wikipedia.org/wiki/Sparse_file
> >
> >>QA output created by 009
> >>	1. into a hole
> >>0: [0..39]: hole
> >>daa100df6e6711906b61c9ab5aa16032
> >>	2. into allocated space
> >>cc58a7417c2d7763adc45b6fcd3fa024
> >>	3. into unwritten space
> >>daa100df6e6711906b61c9ab5aa16032
> >I don't need to look any further to see that something is badly
> >wrong here. This is telling me that no extents are being allocated
> >at all, which indicates either fiemap is broken, awk/sed is
> >broken or misbehaving (and hence mangling the output) or something
> >deep in the filesystem code is fundamentally broken in some
> >strange, silent way.
> >
> >Can you create an xfs filesystem on your scratch device, and
> >manually run this command and post the output:
> >
> ># mkfs.xfs -V
> ># mkfs.xfs <dev>
> ># mount <dev> /mnt/xfs
> ># xfs_io -f -c "pwrite 0 64k" -c sync \
> >	    -c "bmap -vp" -c "fiemap -v" \
> >	    -c "falloc 1024k 256k" -c sync \
> >	    -c "pwrite 1088k 64k" -c sync \
> >	    -c "bmap -vp" -c "fiemap -v" \
> >	    /mnt/xfs/testfile
> >
> >and attach the entire output?
> 
> I attached the output.

Urk, the command should be "fsync", not "sync". Regardless, the
last bmap/fiemap pair shows something interesting:

bmap-vp:

> /media/p6/testfile:
>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
>    0: [0..127]:        96..223           0 (96..223)          128 00000
>    1: [128..2047]:     hole                                  1920
>    2: [2048..2559]:    2144..2655        0 (2144..2655)       512 10000

fiemap -v:

> /media/p6/testfile:
>  EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>    0: [0..127]:        96..223            128   0x0
>    1: [128..2047]:     hole              1920
>    2: [2048..2175]:    2144..2271         128 0x800
>    3: [2176..2303]:    2272..2399         128   0x0
>    4: [2304..2559]:    2400..2655         256 0x801

Note that they are different - the former shows an unwritten extent
of 256k @ offset 1MB, the later shows that extent split by 64k of
data @ 1088k.

The bmap -vp output is incorrect - it is supposed to sync data first
and so should look the same as the fiemap output. Can you run this
test again, this time with s/sync/fsync so the files are clean when
bmap/fiemap are run? Can you run it a second time (umount/mkfs
again) but with fiemap run first? i.e '-c "fiemap -v" -c "bmap -vp" \' 
instead of the original order?

Next, can you compile your kernel with CONFIG_XFS_DEBUG=y and rerun
the tests? Does anything interesting appear in dmesg during the test
run?

> I can be completely wrong, but file system
> seems quite reliable for rootfs operations until now. At least,
> never had any issue after installing and removing several and several
> debian packages.

right, normal distro operation doesn't use preallocation or hole
punching, so you won't have seen issues with that.

> Ok, about test 308, the 2 xfs_io operations passes, it stops on the
> rm exiting
> the tests, while trying to erase the 16t file.
> 
> # Create a sparse file with an extent lays at one block before old
> s_maxbytes
> offset=$(((2**32 - 2) * $block_size))
> $XFS_IO_PROG -f -c "pwrite $offset $block_size" -c fsync $testfile
> >$seqres.full 2>&1
> 
> rm can remove remove correctly this file (17592186040320)

What is the large number here?

offset:		(2**32 - 2) * 4096 = 17592186036224
end file size:	(2**32 - 2) * 4096 + 4096 = 17592186040320

So it is the end file size.

> # Write to the block after the extent just created
> offset=$(((2**32 - 1) * $block_size))
> $XFS_IO_PROG -f -c "pwrite $offset $block_size" -c fsync $testfile
> >>$seqres.full 2>&1

This should fail with -EFBIG

> while rm hangs on removing this file (17592186044415)

offset:         (2**32 - 1) * 4096 = 17592186040320
end file size:	(2**32 - 1) * 4096 + 4096 = 17592186044416

Hmmm - that file is truncated by one byte. We set sb->s_maxbytes to
17592186044415 in xfs_max_file_offset() on 32 bit systems, so this
truncation is expected.

Most definitely need to run this under CONFIG_XFS_DEBUG=y - you
should enable this whenever running xfstests to check things are
working correctly as it enables all sorts of internal consistency
and constraint checking (i.e. checking things that "should never,
ever happen" haven't actually occurred).

> Magic sysrq l or t is not helping, nothing useful comes out.
> But i collected the strace log. Since the issue is at unlinkat().

Not actually useful - I need to know what is happening inside the
unlinkat() call.  I'm going to need a trace-cmd event dump of that
xfs_io command and the subsequent rm (at least for the first couple
of seconds of the rm). Please put the output file from the trace-cmd
record command on a tmpfs filesystem so it doesn't pollute the xfs
event trace ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
