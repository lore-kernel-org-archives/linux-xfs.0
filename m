Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50133 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750891AbdAHTkB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jan 2017 14:40:01 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id v08JcrW6085676
        for <linux-xfs@vger.kernel.org>; Sun, 8 Jan 2017 14:40:00 -0500
Received: from e23smtp08.au.ibm.com (e23smtp08.au.ibm.com [202.81.31.141])
        by mx0a-001b2d01.pphosted.com with ESMTP id 27twr44q6n-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Sun, 08 Jan 2017 14:40:00 -0500
Received: from localhost
        by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
        Mon, 9 Jan 2017 05:39:57 +1000
Subject: Re: xfs:  commit 6552321831dc "xfs: remove i_iolock and use    i_rwsem
 in the VFS inode instead"  change causes hang
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date: Sun, 08 Jan 2017 14:39:49 -0500
In-Reply-To: <20170108190955.GA1489@lst.de>
References: <1483886924.8189.81.camel@linux.vnet.ibm.com>
         <20170108145200.GA29570@lst.de>
         <1483898365.2542.13.camel@HansenPartnership.com>
         <20170108181856.GA781@lst.de>
         <1483901848.2542.27.camel@HansenPartnership.com>
         <20170108190955.GA1489@lst.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <1483904389.2956.43.camel@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>

On Sun, 2017-01-08 at 20:09 +0100, Christoph Hellwig wrote:
> On Sun, Jan 08, 2017 at 10:57:28AM -0800, James Bottomley wrote:
> > I'm unsure about the DIO case, so lets try defining the semantics and
> > see if they're implementable for DIO, otherwise simply exclude it.
> 
> Let's start with the semantics.  First we need to write down what
> IMA requires from the FS, and have an interface how the FS can declare
> that it supports these features.  As far as I can tell there are not
> proper feature checks anywhere right now.  Once we have done that
> we can move forward from there.
> 
> As you seem to be interested in IMA how about you spearhead documenting
> the requirements and adding xfstests support?

In addition to calculating the file hash on open and validating the
hash/signature stored as an xattr, we need a safe mechanism for writing
the file hash on the last __fput(), which is currently being deferred
due to locking issues.

> > OK, so how about we define it.  I think we need two vfs calls:
> > 
> > inode_block_local_writes(inode)
> > inode_unblock_local_writes(inode)
> 
> No.  We need an ->ima_measure file_operation, guts of process_measurement
> turned into a library function that the FS can call after taking fs-specific
> locks.  And maybe also a small wrapper around it that takes ilock and
> can be used directly for file systems not needing special locking.

So a vfs generic version for those that don't need special locking, with
the option of replacing the vfs generic version with a filesystem
specific one that directly calls the library function.

process_measurements() is a lot more than just calculating the file
hash, adding the hash to the measurement list and extending the TPM.  We
could limit it to just calculating the file hash and name it
ima_collect.  Or, if you prefer all of process_measurements() it could
be named just ima.

Mimi

> > With semantics that between these two, all write attempts to the file
> > backed by the inode on this system block but reads of the underlying
> > file are allowed (I added local so we don't have to implement for
> > remote filesystems).
> 
> How do you define local?  Are GFS2 and OCFS2 local?  Is XFS with
> outstanding pNFS layout local?  Is NFS with the block or SCSI layout
> local because it operates on a block device?
> 
> The only sane way is to make INA opt-in with a check list of features
> that need to be supported, and declared to be supported by the fs,
> similar to how we handle NFS exporting.
> 


