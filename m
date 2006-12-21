Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Dec 2006 20:02:55 -0800 (PST)
Received: from amsfep17-int.chello.nl (amsfep17-int.chello.nl [62.179.120.12])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBL42mqw006654
	for <xfs@oss.sgi.com>; Wed, 20 Dec 2006 20:02:51 -0800
Received: from cable-213-132-153-91.upc.chello.be ([213.132.153.91])
          by amsfep17-int.chello.nl
          (InterMail vM.6.01.04.04 201-2131-118-104-20050224) with ESMTP
          id <20061221034235.NMSH8808.amsfep17-int.chello.nl@cable-213-132-153-91.upc.chello.be>
          for <xfs@oss.sgi.com>; Thu, 21 Dec 2006 04:42:35 +0100
From: Grozdan Nikolov <microchip@chello.be>
Subject: adding more redundancy in XFS?
Date: Thu, 21 Dec 2006 04:42:32 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200612210442.33706.microchip@chello.be>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

I have a simple question regarding XFS. A while back ago I read a research 
paper about the IRON (Internal Robustness) of file systems that tests and 
compares various Linux file systems on how they handle data-integrity in case 
of a unclean unmount or power failure or even a disk failure. Though I'm not 
a file system guru like you guys I learned that XFS does a fairly good job 
but fails bad in specific areas, like, and I quote from the paper: "when an 
ordered data block write fails, XFS continues to log the failed transaction 
to the journal resulting in data corruption"

The paper can be downloaded here: http://www.cs.wisc.edu/adsl/Publications/
(just click on the IRON file systems link for a PDF)

My question is, is it possible to add to XFS more sanity checking (maybe even 
CRC checks?) on things like inodes, bitmaps, indirect pointers, etc to 
further improve the integrity of XFS?

Thanks, GN
-- 
Windows: a 64-bit service pack to a 32-bit extension and GUI shell to a 16-bit 
patch to an 8-bit operating system originally coded for a 4-bit 
microprocessor and sold by a 2-bit company than can't stand 1-bit of 
competition
