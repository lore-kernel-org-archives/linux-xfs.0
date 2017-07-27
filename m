Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47794 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751458AbdG0Mnv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Jul 2017 08:43:51 -0400
Date: Thu, 27 Jul 2017 08:43:50 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Recover file after truncate
Message-ID: <20170727124350.GB3858@bfoster.bfoster>
References: <575c9d8d-04c9-4d60-93d2-ccc86ec893a9@ashurst.eu.org>
 <20170726111541.GB59833@bfoster.bfoster>
 <0e11333c-0f02-4e4d-8ab2-0d86cb78d7e4@ashurst.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e11333c-0f02-4e4d-8ab2-0d86cb78d7e4@ashurst.eu.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Bennett <andyjpb@ashurst.eu.org>
Cc: linux-xfs@vger.kernel.org

On Wed, Jul 26, 2017 at 11:12:19PM +0100, Andy Bennett wrote:
> Hi,
> 
> 
...
> 
> 
> > If you are luckier still and the original file was allocated with only
> > one or two extents similar to the above example, then you may be able to
> > piece together the file by putting the extents in the appropriate order.
> > FWIW, there are tools such as photorec that supposedly are able to do
> > this kind of thing with known file formats.
> 
> I'm hoping it's in a couple of extents. How do I identify extents on disk?
> 

File extents can be listed via userspace tools like xfs_bmap, as you've
shown previously. Once blocks are freed from a file, they are returned
to per allocation group btree data structures on disk. Note that the
extents in the btree may no longer represent the exact extents allocated
to your file because other, contiguous free space could have been merged
to form larger free extents.

The free space btree can be traversed offline via the xfs_db utility.
Something like the following could give you the free extent information
for each AG in the fs.

for i in $(seq 0 <maxag>); do
	echo agno $i
	xfs_db -c "agf $i" -c "addr bnoroot" -c "btdump"  <dev>
done

You can obtain the AG count of the fs via 'xfs_info <mnt>' or:

xfs_db -c "sb 0" -c "p agcount" <dev>

If I were you, I would probably take the following high level approach
to attempt a recovery:

- grep/search through the block device for blocks that appear to be
  associated with your file.

- For each identified offset in the raw blockdev, convert the 4k block
  address to an AG number and AG relative block:

xfs_db -c "convert daddr <block> agno" -c "convert daddr <block> agbno" <dev>

- Attempt to locate a free extent that covers that block in the free
  extent output for the associated AG number. Note that all of the btump
  output collected above is in the form of AG relative block offsets, so
  each AG has a block 0, 1, etc.

- If found, convert the starting agblock of the free extent back to a
  disk address:

xfs_db -c "convert agno N agbno B daddr" <dev>

- Based on the size of the free extent, dd that number of blocks off the
  raw block device to a file on a separate device:

dd if=<dev> bs=4k skip=<freeblockaddr> count=<count> of=extentfile.N

  Verify the file contains the data you expect based on the initial
  search.

- Repeat until you've copied each candidate extent to its own file on
  the separate fs. Then try to piece the individual extent files
  together into a new file that resembles the original file, combining
  them however necessary and/or trimming the extents if the boundaries
  seem to include unrelated data, etc.

> 
...
> > What does the xfs_logprint output look like?
> 
...
> Piping `xfs_logprint /dev/nvme0n1p8 ` thru' less, seeking to the end and
> searching backwards for 'EFI' gives me this:
> 
> -----
> ============================================================================
> cycle: 1        version: 2              lsn: 1,211069   tail_lsn: 1,211067
> length of Log Record: 1536      prev offset: 211067             num ops: 15
> uuid: 7274488e-64ab-4d2a-8f4d-cedec4db7e6f   format: little endian linux
> h_size: 32768
> ----------------------------------------------------------------------------
...
> ----------------------------------------------------------------------------
> Oper (2): tid: 4d4486ed  len: 32  clientid: TRANS  flags: none
> EFI:  #regs: 1    num_extents: 1  id: 0xffff8bff07e21e58
> (s: 0x114112b, l: 1363)

A 1363 block extent == ~5MB, so probably not a candidate unless your
file was more fragmented than anticipated.

Are you filtering the xfs_logprint output here? If so, please attach the
full output from xfs_logprint.

Brian

> ----------------------------------------------------------------------------
> Oper (3): tid: 4d4486ed  len: 32  clientid: TRANS  flags: none
> EFD:  #regs: 1    num_extents: 1  id: 0xffff8bff07e21e58
> ----------------------------------------------------------------------------
> Oper (4): tid: 4d4486ed  len: 24  clientid: TRANS  flags: none
> BUF:  #regs: 2   start blkno: 1 (0x1)  len: 1  bmap size: 1  flags: 0x2800
> Oper (5): tid: 4d4486ed  len: 128  clientid: TRANS  flags: none
> AGF Buffer: XAGF  Out of space
> ----------------------------------------------------------------------------
> Oper (6): tid: 4d4486ed  len: 24  clientid: TRANS  flags: none
> BUF:  #regs: 2   start blkno: 8 (0x8)  len: 8  bmap size: 1  flags: 0x2000
> Oper (7): tid: 4d4486ed  len: 128  clientid: TRANS  flags: none
> BUF DATA
> ----------------------------------------------------------------------------
> Oper (8): tid: 4d4486ed  len: 24  clientid: TRANS  flags: none
> BUF:  #regs: 3   start blkno: 16 (0x10)  len: 8  bmap size: 1  flags: 0x2000
> Oper (9): tid: 4d4486ed  len: 128  clientid: TRANS  flags: none
> BUF DATA
> Oper (10): tid: 4d4486ed  len: 128  clientid: TRANS  flags: none
> BUF DATA
> ----------------------------------------------------------------------------
> Oper (11): tid: 4d4486ed  len: 56  clientid: TRANS  flags: none
> INODE: #regs: 3   ino: 0x89c95dd  flags: 0x5   dsize: 16
>        blkno: 144479680  len: 32  boff: 14848
> Oper (12): tid: 4d4486ed  len: 176  clientid: TRANS  flags: none
> INODE CORE
> magic 0x494e mode 0100600 version 3 format 2
> nlink 1 uid 501 gid 100
> atime 0x59790f5b mtime 0x59790f6d ctime 0x59790f6d
> size 0x3a9c161 nblocks 0x3a9d extsize 0x0 nextents 0x1
> naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
> flags 0x0 gen 0x51eeced9
> Oper (13): tid: 4d4486ed  len: 16  clientid: TRANS  flags: none
> EXTENTS inode data
> ----------------------------------------------------------------------------
> Oper (14): tid: 4d4486ed  len: 0  clientid: TRANS  flags: COMMIT -----
> 
> 
> > Do note that the simple act of mounting the filesystem runs the risk of
> > overwriting previous log data. An 'xfs_metadump -go' might be a good way
> > to preserve current log content.
> 
> I've been hibernating the machine and haven't tried remounting it read-only:
> I'm not expecting anything to do any serious writes on that partition and I
> don't think there will be anything much at all that tries to write there.
> 
> 
> > Brian
> 
> Thanks for your help!
> 
> 
> 
> 
> Regards,
> @ndy
> 
> -- 
> andyjpb@ashurst.eu.org
> http://www.ashurst.eu.org/
> 0x7EBA75FF
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
