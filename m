Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44190 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751122AbdG0PET (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Jul 2017 11:04:19 -0400
Date: Thu, 27 Jul 2017 11:04:18 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Recover file after truncate
Message-ID: <20170727150416.GB5597@bfoster.bfoster>
References: <575c9d8d-04c9-4d60-93d2-ccc86ec893a9@ashurst.eu.org>
 <20170726111541.GB59833@bfoster.bfoster>
 <0e11333c-0f02-4e4d-8ab2-0d86cb78d7e4@ashurst.eu.org>
 <20170727124350.GB3858@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170727124350.GB3858@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Bennett <andyjpb@ashurst.eu.org>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 27, 2017 at 08:43:50AM -0400, Brian Foster wrote:
> On Wed, Jul 26, 2017 at 11:12:19PM +0100, Andy Bennett wrote:
> > Hi,
> > 
> > 
...
> 
> Are you filtering the xfs_logprint output here? If so, please attach the
> full output from xfs_logprint.
> 

Andy sent the logprint output privately due to the size of the
attachment.

Andy,

The last reference I see of your inode in the log before the size goes
to zero is this:

----------------------------------------------------------------------------                                           
Oper (2): tid: c6720129  len: 56  clientid: TRANS  flags: none                                                         
INODE: #regs: 2   ino: 0x12c37053  flags: 0x1   dsize: 0   
        blkno: 235989736  len: 32  boff: 9728              
Oper (3): tid: c6720129  len: 176  clientid: TRANS  flags: none                                                        
INODE CORE                                                 
magic 0x494e mode 0100644 version 3 format 2               
nlink 1 uid 501 gid 100                                    
atime 0x5977c96e mtime 0x5973ac16 ctime 0x5973ac16         
size 0x1a81f2218 nblocks 0x1a81f3 extsize 0x0 nextents 0x2 
naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0           
flags 0x0 gen 0xb8791e20                                   
----------------------------------------------------------------------------

This suggests the file size was 0x1a81f2218 (7115579928) and it had
0x1a81f3 (1737203) blocks across two extents (roughly 6.6GB). Note that
the file size is not exactly aligned to the (blockcount * 4096).

Further along, the following EFI exists:

----------------------------------------------------------------------------
Oper (19): tid: 6a85c7fc  len: 48  clientid: TRANS  flags: none
EFI:  #regs: 1    num_extents: 2  id: 0xffff8bfcb4f38990
(s: 0x12a9233, l: 688643) (s: 0x34ae0d5, l: 1048560)
----------------------------------------------------------------------------

... which frees two extents that add up to 688643 + 1048560 = 1737203
(0x1a81f3) blocks. The starting filesystem blocks for these extents are
0x12a9233 and 0x34ae0d5, respectively.

If you can convert those starting fsb values to agno/agbno combinations
as shown in my previous mail, you could confirm whether they reside in
the free space btrees for the associated allocation group of each
extent. If so, you could convert each start fsb to a raw daddr (xfs_db
-c "convert fsb 0x12a9233 daddr" <dev>) and use that to try and read
each extent off the raw device as previously discussed.

I have no idea whether those extents contain the file data you're after
(note that I'm not sure we've actually confirmed your file data would
have made it to disk), but if the file size values look sane that might
be worth a try before you go fishing the device for raw data.

Brian

> Brian
> 
> > ----------------------------------------------------------------------------
> > Oper (3): tid: 4d4486ed  len: 32  clientid: TRANS  flags: none
> > EFD:  #regs: 1    num_extents: 1  id: 0xffff8bff07e21e58
> > ----------------------------------------------------------------------------
> > Oper (4): tid: 4d4486ed  len: 24  clientid: TRANS  flags: none
> > BUF:  #regs: 2   start blkno: 1 (0x1)  len: 1  bmap size: 1  flags: 0x2800
> > Oper (5): tid: 4d4486ed  len: 128  clientid: TRANS  flags: none
> > AGF Buffer: XAGF  Out of space
> > ----------------------------------------------------------------------------
> > Oper (6): tid: 4d4486ed  len: 24  clientid: TRANS  flags: none
> > BUF:  #regs: 2   start blkno: 8 (0x8)  len: 8  bmap size: 1  flags: 0x2000
> > Oper (7): tid: 4d4486ed  len: 128  clientid: TRANS  flags: none
> > BUF DATA
> > ----------------------------------------------------------------------------
> > Oper (8): tid: 4d4486ed  len: 24  clientid: TRANS  flags: none
> > BUF:  #regs: 3   start blkno: 16 (0x10)  len: 8  bmap size: 1  flags: 0x2000
> > Oper (9): tid: 4d4486ed  len: 128  clientid: TRANS  flags: none
> > BUF DATA
> > Oper (10): tid: 4d4486ed  len: 128  clientid: TRANS  flags: none
> > BUF DATA
> > ----------------------------------------------------------------------------
> > Oper (11): tid: 4d4486ed  len: 56  clientid: TRANS  flags: none
> > INODE: #regs: 3   ino: 0x89c95dd  flags: 0x5   dsize: 16
> >        blkno: 144479680  len: 32  boff: 14848
> > Oper (12): tid: 4d4486ed  len: 176  clientid: TRANS  flags: none
> > INODE CORE
> > magic 0x494e mode 0100600 version 3 format 2
> > nlink 1 uid 501 gid 100
> > atime 0x59790f5b mtime 0x59790f6d ctime 0x59790f6d
> > size 0x3a9c161 nblocks 0x3a9d extsize 0x0 nextents 0x1
> > naextents 0x0 forkoff 0 dmevmask 0x0 dmstate 0x0
> > flags 0x0 gen 0x51eeced9
> > Oper (13): tid: 4d4486ed  len: 16  clientid: TRANS  flags: none
> > EXTENTS inode data
> > ----------------------------------------------------------------------------
> > Oper (14): tid: 4d4486ed  len: 0  clientid: TRANS  flags: COMMIT -----
> > 
> > 
> > > Do note that the simple act of mounting the filesystem runs the risk of
> > > overwriting previous log data. An 'xfs_metadump -go' might be a good way
> > > to preserve current log content.
> > 
> > I've been hibernating the machine and haven't tried remounting it read-only:
> > I'm not expecting anything to do any serious writes on that partition and I
> > don't think there will be anything much at all that tries to write there.
> > 
> > 
> > > Brian
> > 
> > Thanks for your help!
> > 
> > 
> > 
> > 
> > Regards,
> > @ndy
> > 
> > -- 
> > andyjpb@ashurst.eu.org
> > http://www.ashurst.eu.org/
> > 0x7EBA75FF
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
