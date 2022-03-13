Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BDD5C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 13 Mar 2022 22:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235625AbiCMWri (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 13 Mar 2022 18:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235614AbiCMWrh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 13 Mar 2022 18:47:37 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 245717460C
        for <linux-xfs@vger.kernel.org>; Sun, 13 Mar 2022 15:46:28 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 5CF6E532BFC;
        Mon, 14 Mar 2022 09:46:24 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nTWym-0058K1-1Q; Mon, 14 Mar 2022 09:46:24 +1100
Date:   Mon, 14 Mar 2022 09:46:24 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Manfred Spraul <manfred@colorfullife.com>
Cc:     linux-xfs@vger.kernel.org,
        "Spraul Manfred (XC/QMM21-CT)" <Manfred.Spraul@de.bosch.com>
Subject: Re: Metadata CRC error detected at
 xfs_dir3_block_read_verify+0x9e/0xc0 [xfs], xfs_dir3_block block 0x86f58
Message-ID: <20220313224624.GJ3927073@dread.disaster.area>
References: <613af505-7646-366c-428a-b64659e1f7cf@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <613af505-7646-366c-428a-b64659e1f7cf@colorfullife.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=622e7442
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=8nJEP1OIZ-IA:10 a=o8Y5sQTvuykA:10 a=NEAV23lmAAAA:8 a=7-415B0cAAAA:8
        a=cHkwaeUAlEJFQVVEHK4A:9 a=wPNLvfGTeEIA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 13, 2022 at 04:47:19PM +0100, Manfred Spraul wrote:
> Hello together,
> 
> 
> after a simulated power failure, I have observed:
> 
> >>>
> 
> Metadata CRC error detected at xfs_dir3_block_read_verify+0x9e/0xc0 [xfs],
> xfs_dir3_block block 0x86f58
> [14768.047531] XFS (loop0): Unmount and run xfs_repair
> [14768.047534] XFS (loop0): First 128 bytes of corrupted metadata buffer:
> [14768.047537] 00000000: 58 44 42 33 9f ab d7 f4 00 00 00 00 00 08 6f 58 
> XDB3..........oX

For future reference, please paste the entire log message, from
the time that the fs was mounted to the end of the hexdump output.
You might not think the hexdump output is important, but as you'll
see later....

> <<<
> 
> Is this a known issue?

Is what a known issue? All this is XFS finding a corrupt metadata
block because a CRC is invalid, which is exactly what it's supposed
to do.

As it is, CRC errors are indicative of storage problem such as bit
errors and torn writes, because what has been read from disk does
not match what XFS wrote when it calculated the CRC.

> The image file is here: https://github.com/manfred-colorfu/nbd-datalog-referencefiles/blob/main/xfs-02/result/data-1821799.img.xz
> 
> As first question:
> 
> Are 512 byte sectors supported, or does xfs assume that 4096 byte writes are
> atomic?

512 byte *IO* is supported on devices that have 512 byte sector
support, but there are other rules that XFS sets for metadata. e.g.
that metadata writes are expected to be written completely or
replayed completely as a whole unit regardless of their length. This
is bookended by the use of cache flushes and FUAs to ensure that
multi-sector writes are wholly completed before the recovery
information is tossed away.

If a cache flush has not been issued, then the metadata block
recvoery information is whole in the journal, and so if we crash or
lose power then journal recovery replays the changes and overwrites
whatever is on the disk with the correct, consistent metadata.

Log recovery will also issue large writes and cache flushes will
occur as part of the process so that the recovered metadata is whole
on stable storage before it is removed from the journal.

IOWs, if the storage ends up doing a partial write as a result of a
power failure, log recovery fixes that up if it is still in the
journal. If it is not in the journal then a cache flush *must* have
happened, and hence the metadata is complete on disk.

So....

> How were the power failures simulated:
> 
> I added support to nbd to log all write operations, including the written
> data. This got merged into nbd-3.24
> 
> I've used that to create a log of running dbench (+ a few tar/rm/manual
> tests) on a 500 MB image file.
> 
> In total, 2.9 mio 512-byte sector writes. The datalog is ~1.5 GB long.
> 
> If replaying the initial 1,821,799, 1,821,800, 1,821,801 or 1,821,802
> blocks, the above listed error message is shown.
> 
> After 1,821,799 or 1,821,803 sectors, everything is ok.
> 
> (block numbers are 0-based)
> 
> > > H=2400000047010000 C=0x00000001 (NBD_CMD_WRITE+NONE)
> > O=0000000010deb000 L=00001000
> > block 1821795 (0x1bcc63): writing to offset 283029504 (0x10deb000), len
> > 512 (0x200).
> > block 1821796 (0x1bcc64): writing to offset 283030016 (0x10deb200), len
> > 512 (0x200).
> > block 1821797 (0x1bcc65): writing to offset 283030528 (0x10deb400), len
> > 512 (0x200).  << OK
> > block 1821798 (0x1bcc66): writing to offset 283031040 (0x10deb600), len
> > 512 (0x200).  FAIL
> > block 1821799 (0x1bcc67): writing to offset 283031552 (0x10deb800), len
> > 512 (0x200).  FAIL
> > block 1821800 (0x1bcc68): writing to offset 283032064 (0x10deba00), len
> > 512 (0x200).  FAIL
> > block 1821801 (0x1bcc69): writing to offset 283032576 (0x10debc00), len
> > 512 (0x200).  FAIL
> > block 1821802 (0x1bcc6a): writing to offset 283033088 (0x10debe00), len
> > 512 (0x200). << OK

OK, this test is explicitly tearing writes at the storage level.
When there is an update to multiple sectors of the metadata block,
the metadata will be inconsistent on disk while those individual
sector writes are replayed.

For example the problem here is likely the LSN that this write
stamps into the header along with the updated CRC. Log recovery
doesn't actually check the incoming CRC because it might be invalid
(say, due to a torn write) but it does check the magic number and
then the LSN that is stamped into the metadata block to determine if
it should be replayed or not (i.e. we have metadata version
checks in recovery).

If the LSN that is stamped into the header is more recent that the
object version that log recovery is trying to replay, it will skip
replay because that can result in unnecessary transient corruption
of the metadata on disk that doesn't get corrected until later in
the recovery process. This is bad - if log recovery then fails
before we recover then more recent changes, we've created new
on-disk corruption and made things worse, not better....

So, let's find the log recovery lsn (same in all images) via
logprint - it's last logged as part of this transaction:

LOG REC AT LSN cycle 15 block 604 (0xf, 0x25c)                                   
============================================================================     
TRANS: tid:0x6d1b8e4f  #items:201  trans:0x6d1b8e4f q:0x5608eeb23bd0 

And there are 3 data regions in it:

BUF: cnt:4 total:4 a:0x5608eeb23f60 len:24 a:0x5608eeb20f70 len:128 a:0x5608eeb23970 len:384 a:0x5608eeb22130 len:256 
        BUF:  #regs:4   start blkno:0x86f58   len:8   bmap size:1   flags:0x5000 
        BUF DATA                                                                 
        BUF DATA                                                                 
        BUF DATA 

The three regions are 128 bytes, 384 bytes and 256 bytes long. The
first chunk is clearly the first 128 bytes of the sector:

40       69    4123c    85000    86f58        0        1 c000001d 4f8e1b6d       
            buf item             daddr			  TID
48 80000000       69 33424458 b21e33d9        0 586f0800  e000000 29580000       
   ophdr flags   ID  XDB3     CRC   		daddr     CYCLE    BLCK
50 23355a53 f14c2c57 b07cac8d b7eca938        0 25690800 400d2802 30006801       
58 3000c801        0        0 25690800    22e01 40000000        0 4d0a0c00       
60  22e2e02 50000000        0 26690800 5244430b 534c4f52 4746432e 60000001       
68        0 27690800 4f8e1b6d

So, when this item was logged, the LSN in the in memory buffer was
(0xe,0x5829), and it is being replayed at (0xf,0x25c). That's good,
it indicates what is in the journal is valid but what is in the
block on disk?

xfs_db> daddr 0x86f58 
xfs_db> p
000: 58444233 9fabd7f4 00000000 00086f58 0000000f 0000025c 535a3523 572c4cf1
     magic    crc               daddr     block    cycle   ....

Oh, I didn't need to get it off disk like this - it's in the second
line of the hexdump output in the corruption reports:

[15063.024355] XFS (loop0): Metadata CRC error detected at xfs_dir3_block_read_verify+0x9e/0xc0 [xfs], xfs_dir3_block block 0x86f58 
[15063.024466] XFS (loop0): Unmount and run xfs_repair
[15063.024468] XFS (loop0): First 128 bytes of corrupted metadata buffer:
[15063.024471] 00000000: 58 44 42 33 9f ab d7 f4 00 00 00 00 00 08 6f 58  XDB3..........oX
[15063.024474] 00000010: 00 00 00 0f 00 00 02 5c 53 5a 35 23 57 2c 4c f1  .......\SZ5#W,L.
                         CYCLE       BLOCK

Yup, there we go. The LSN is (0xf,0x25c), which tells log recovery
not to recover it because it's the same as the LSN as the last
journal checkpoint that records changes to the block has.

So the write that the test is tearing up is the in-place metadata
overwrite, so it's creating physical metadata corruption in the
storage. That corruption persists until all the sectors in the
metadata block have been updated, at which point your test failures
go away again.

Hence to answer your original question: Yes, XFS is behaving exactly
as it was designed to behave. The metadata verifiers have correctly
detected corruption that has resulted from the storage tearing all
it's writes to little pieces and that journal recovery couldn't
automatically repair after the fact. We failed to repair it
automatically beacuse the nature of the torn write told log recovery
"don't recover this metadata from the journal because it is already
up to date". Instead, the problem was detected on first access to
the torn up metadata, and by xfs_repair.

IOWs, there is no problems with XFS here. If there is any issue at
all, it is with the assumption that filesystems can always cleanly
recovery from massively (or randomly) torn writes. The fact is that
they can't and that's why we have things like CRCs and self
describing metadata to detect when unexpected or unrecoverable torn
or misplaced writes occur deep down in the storage layers...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
