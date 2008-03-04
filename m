Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 04 Mar 2008 14:16:11 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m24MFnAd002936
	for <xfs@oss.sgi.com>; Tue, 4 Mar 2008 14:15:51 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 54BB4650A89
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2008 14:16:19 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id ZN2u6mViTEoEgMhu for <xfs@oss.sgi.com>; Tue, 04 Mar 2008 14:16:19 -0800 (PST)
Message-ID: <47CDCA12.5060107@sandeen.net>
Date: Tue, 04 Mar 2008 16:15:46 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: corruption in xfs_end_bio_unwritten
References: <629727.55106.qm@web32504.mail.mud.yahoo.com>
In-Reply-To: <629727.55106.qm@web32504.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ravi Wijayaratne <ravi_wija@yahoo.com>
Cc: xfs@oss.sgi.com

Ravi Wijayaratne wrote:
> Hi all,
> 
> I am seeing data corruption in xfs_end_bio_unwritten. Possibly the corruption is happening before.
> Here is what I see.

what kernel, for starters?

> The ioend->io_offset and ioend->io_size is completely beyond the range of the size of the file or
> the device altogether. The problem occurs under heavy I/O stress on 4 20GB files that was created
> using XFS_IOC_RESVSP64 ioctl. For a sparse file of the same size the problem does not occur. Also
> the problem is not seen on moderate the low system I/O loads(Created by I/O meter) 
> 
> It trips on the VOP_BMP(..) call that eventually calls xfs_btree_check_lblock. I am aware that
> this function has changed in the tip to call xfs_iomap_write_unwritten directly instead of calling
> xfs_iomap via VOP_BMAP. I believe that even if I change the code to what is in the tip I would
> still stumble some where on the fact that a write to a undefined range was completed. The call
> stack that was dumped by XFS_ERROR_REPORT was as follows
> 
> Any thoughts how I could fix this?
> 
> Thanks in advance
> 
