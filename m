Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from pavilion.ashurst.eu.org ([85.119.82.45]:36758 "EHLO
        pavilion.ashurst.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751558AbdGZWMZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jul 2017 18:12:25 -0400
From: Andy Bennett <andyjpb@ashurst.eu.org>
Date: Wed, 26 Jul 2017 23:12:19 +0100
MIME-Version: 1.0
Message-ID: <0e11333c-0f02-4e4d-8ab2-0d86cb78d7e4@ashurst.eu.org>
In-Reply-To: <20170726111541.GB59833@bfoster.bfoster>
References: <575c9d8d-04c9-4d60-93d2-ccc86ec893a9@ashurst.eu.org>
 <20170726111541.GB59833@bfoster.bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Subject: Re: Recover file after truncate
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

Hi,


>> A quick experiment with xxd suggests that the inode of the 
>> file remains the
>> same if it exists before xxd writes to it. So my new file 
>> still has the same
>> inode as the one I want to recover.
>> 
>> There hasn't been any write activity on this file system since 
>> I made this ...
>
> I suspect that most of your file data currently sits on free blocks in
> the filesystem. If you had a bmap from before this incident, you could
> probably point to exactly where they are. Since I assume that is
> unlikely,

Yeah... I captured the file and subsequently managed to delete it before I 
had a chance to run a backup! :-(


> you'd have to run something like you have below to try and
> identify where that data is in the block device and try to piece
> together the starting block and length of the associated extents.
>
> I suppose that if you can distinguish the file data in any particular 4k
> block from other random data then it might be possible to identify the
> exact start/length values of the extents directly from the block device.

The actual data is IQ samples that I've captured from a device I hired but 
have now sent back. ...so it's essentially random binary data and I 
wouldn't like to try to write a classifier for it but I can easily pipe it 
through my toolchain without header or framing woes and see if it produces 
output that is pleasing.

So, to that extent, if I can get in the general vicinity of the file I can 
just chop the edges around until I'm happy. Hey, my 6 minute sample was a 
little over 6GiB so I'm sure I could just listen to the whole block device 
in a few hours. :-)


> If you are luckier still and the original file was allocated with only
> one or two extents similar to the above example, then you may be able to
> piece together the file by putting the extents in the appropriate order.
> FWIW, there are tools such as photorec that supposedly are able to do
> this kind of thing with known file formats.

I'm hoping it's in a couple of extents. How do I identify extents on disk?


> Note that I don't think there's any way to reassign the blocks to the
> inode without doing some form of manual surgery on the filesystem, which
> I would not recommend. If you actually were able to locate the file data
> on the raw block device, the best course of action is to copy the data
> from the block device to a new file on a separate filesystem and then
> copy that file back into the original fs.

That sounds good, thanks.


> Also note that once you start
> writing anything to the original fs, the original data is at risk of
> being overwritten. You may want to decommission the original storage or
> make a copy to preserve the original state.


> What does the xfs_logprint output look like?

Piping `xfs_logprint /dev/nvme0n1p8 ` thru' tail gives me this:


-----
Oper (13): tid: 4d4486ed  len: 16  clientid: TRANS  flags: none
EXTENTS inode data
----------------------------------------------------------------------------
Oper (14): tid: 4d4486ed  len: 0  clientid: TRANS  flags: COMMIT 

============================================================================
cycle: 1        version: 2              lsn: 1,211073   tail_lsn: 1,211069
length of Log Record: 512       prev offset: 211069             num ops: 5
uuid: 7274488e-64ab-4d2a-8f4d-cedec4db7e6f   format: little endian linux
h_size: 32768
----------------------------------------------------------------------------
Oper (0): tid: 94e15a8b  len: 0  clientid: TRANS  flags: START 
----------------------------------------------------------------------------
Oper (1): tid: 94e15a8b  len: 16  clientid: TRANS  flags: none
TRAN:    type: SWAPEXT       tid: 94e15a8b       num_items: 2
----------------------------------------------------------------------------
Oper (2): tid: 94e15a8b  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 0 (0x0)  len: 1  bmap size: 1  flags: 0x9000
Oper (3): tid: 94e15a8b  len: 384  clientid: TRANS  flags: none
SUPER BLOCK Buffer: 
icount: 6360863066640355328  ifree: 94813521  fdblks: 0  frext: 0
----------------------------------------------------------------------------
Oper (4): tid: 94e15a8b  len: 0  clientid: TRANS  flags: COMMIT 

============================================================================
cycle: 1        version: 2              lsn: 1,211075   tail_lsn: 1,211073
length of Log Record: 512       prev offset: 211073             num ops: 5
uuid: 7274488e-64ab-4d2a-8f4d-cedec4db7e6f   format: little endian linux
h_size: 32768
----------------------------------------------------------------------------
Oper (0): tid: 9f4540d0  len: 0  clientid: TRANS  flags: START 
----------------------------------------------------------------------------
Oper (1): tid: 9f4540d0  len: 16  clientid: TRANS  flags: none
TRAN:    type: SWAPEXT       tid: 9f4540d0       num_items: 2
----------------------------------------------------------------------------
Oper (2): tid: 9f4540d0  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 0 (0x0)  len: 1  bmap size: 1  flags: 0x9000
Oper (3): tid: 9f4540d0  len: 384  clientid: TRANS  flags: none
SUPER BLOCK Buffer: 
icount: 6360863066640355328  ifree: 94813521  fdblks: 0  frext: 0
----------------------------------------------------------------------------
Oper (4): tid: 9f4540d0  len: 0  clientid: TRANS  flags: COMMIT 

============================================================================
xfs_logprint: skipped 159283 zeroed blocks in range: 211077 - 370359
xfs_logprint: physical end of log
============================================================================
xfs_logprint: logical end of log
============================================================================
-----


The whole log is currently 4,044,259 lines long.



> Also, what is the inode
> number of the original file?

314798163



> It is possible to get a hint on the
> startblock and length of the original extent(s) if the log still has
> EFI/EFD items present that describe the extent free operations, and that
> information can be corroborated against either the inode information
> and/or with the regions where file data is found in the blockdev scan.

Piping `xfs_logprint /dev/nvme0n1p8 ` thru' less, seeking to the end and 
searching backwards for 'EFI' gives me this:

-----
============================================================================
cycle: 1        version: 2              lsn: 1,211069   tail_lsn: 1,211067
length of Log Record: 1536      prev offset: 211067             num ops: 15
uuid: 7274488e-64ab-4d2a-8f4d-cedec4db7e6f   format: little endian linux
h_size: 32768
----------------------------------------------------------------------------
Oper (0): tid: 4d4486ed  len: 0  clientid: TRANS  flags: START 
----------------------------------------------------------------------------
Oper (1): tid: 4d4486ed  len: 16  clientid: TRANS  flags: none
TRAN:    type: SWAPEXT       tid: 4d4486ed       num_items: 12
----------------------------------------------------------------------------
Oper (2): tid: 4d4486ed  len: 32  clientid: TRANS  flags: none
EFI:  #regs: 1    num_extents: 1  id: 0xffff8bff07e21e58
(s: 0x114112b, l: 1363) 
----------------------------------------------------------------------------
Oper (3): tid: 4d4486ed  len: 32  clientid: TRANS  flags: none
EFD:  #regs: 1    num_extents: 1  id: 0xffff8bff07e21e58
----------------------------------------------------------------------------
Oper (4): tid: 4d4486ed  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 1 (0x1)  len: 1  bmap size: 1  flags: 0x2800
Oper (5): tid: 4d4486ed  len: 128  clientid: TRANS  flags: none
AGF Buffer: XAGF  Out of space
----------------------------------------------------------------------------
Oper (6): tid: 4d4486ed  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 2   start blkno: 8 (0x8)  len: 8  bmap size: 1  flags: 0x2000
Oper (7): tid: 4d4486ed  len: 128  clientid: TRANS  flags: none
BUF DATA
----------------------------------------------------------------------------
Oper (8): tid: 4d4486ed  len: 24  clientid: TRANS  flags: none
BUF:  #regs: 3   start blkno: 16 (0x10)  len: 8  bmap size: 1  flags: 
0x2000
Oper (9): tid: 4d4486ed  len: 128  clientid: TRANS  flags: none
BUF DATA
Oper (10): tid: 4d4486ed  len: 128  clientid: TRANS  flags: none
BUF DATA
----------------------------------------------------------------------------
Oper (11): tid: 4d4486ed  len: 56  clientid: TRANS  flags: none
INODE: #regs: 3   ino: 0x89c95dd  flags: 0x5   dsize: 16
        blkno: 144479680  len: 32  boff: 14848
Oper (12): tid: 4d4486ed  len: 176  clientid: TRANS  flags: none
INODE CORE
magic 0x494e mode 0100600 version 3 format 2
nlink 1 uid 501 gid 100
atime 0x59790f5b mtime 0x59790f6d ctime 0x59790f6d
size 0x3a9c161 nblocks 0x3a9d extsize 0x0 nextents 0x1
naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
flags 0x0 gen 0x51eeced9
Oper (13): tid: 4d4486ed  len: 16  clientid: TRANS  flags: none
EXTENTS inode data
----------------------------------------------------------------------------
Oper (14): tid: 4d4486ed  len: 0  clientid: TRANS  flags: COMMIT 
-----


> Do note that the simple act of mounting the filesystem runs the risk of
> overwriting previous log data. An 'xfs_metadump -go' might be a good way
> to preserve current log content.

I've been hibernating the machine and haven't tried remounting it 
read-only: I'm not expecting anything to do any serious writes on that 
partition and I don't think there will be anything much at all that tries 
to write there.


> Brian

Thanks for your help!




Regards,
@ndy

-- 
andyjpb@ashurst.eu.org
http://www.ashurst.eu.org/
0x7EBA75FF
