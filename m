Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47286 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753566AbdAHQij (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jan 2017 11:38:39 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id v08GY3JM098463
        for <linux-xfs@vger.kernel.org>; Sun, 8 Jan 2017 11:38:38 -0500
Received: from e23smtp03.au.ibm.com (e23smtp03.au.ibm.com [202.81.31.145])
        by mx0a-001b2d01.pphosted.com with ESMTP id 27urhtrvdj-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Sun, 08 Jan 2017 11:38:38 -0500
Received: from localhost
        by e23smtp03.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
        Mon, 9 Jan 2017 02:38:35 +1000
Subject: Re: xfs:  commit 6552321831dc "xfs: remove i_iolock and use    i_rwsem
 in the VFS inode instead"  change causes hang
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date: Sun, 08 Jan 2017 11:38:26 -0500
In-Reply-To: <20170108153725.GA30270@lst.de>
References: <1483886924.8189.81.camel@linux.vnet.ibm.com>
         <20170108145200.GA29570@lst.de>
         <1483887789.8189.90.camel@linux.vnet.ibm.com>
         <20170108151430.GA29847@lst.de>
         <1483889482.8189.104.camel@linux.vnet.ibm.com>
         <20170108153725.GA30270@lst.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <1483893506.8189.147.camel@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>, James Morris <jmorris@namei.org>, Andrew Morton <akpm@linux-foundation.org>, David Safford <david.safford@ge.com>

On Sun, 2017-01-08 at 16:37 +0100, Christoph Hellwig wrote:
> On Sun, Jan 08, 2017 at 10:31:22AM -0500, Mimi Zohar wrote:
> > > Depends on the file system.  In addition to XFS at least the NFS
> > > also uses i_rwsem by default.  Also all file systems supporting
> > > a DAX I/O path.
> > 
> > We're only interested in the integrity of the local file system.
> 
> And I'm only interested in supporting sane use cases that don't include
> IMA.

Nothing new, you haven't changed your position all these years.  I'm not
sure whether your problem is with the concepts that the integrity
subsystem provides (eg. extending secure and trusted boot to the OS,
auditing file hashes for use in forensics) or just with the
implementation.

Others are interested in these features and are using the integrity
subsystem (eg. David Safford LSS 2016 "Design and Implementation of a
Security Architecture for Critical Infrastructure"
(https://www.youtube.com/watch?v=LDQxzz42Bs0),  Eric Richter's LSS 2016
talk "(Ab)using Linux as a Trusted Bootloader",  and many, many others).

> But even if you only care about local file systems IMA is simply
> fundamentally broken.  Read/Write zerialization in Linux has always been
> in the fs (or generic library called by it) and not by the caller.
> 
> > IMA needs a mechanism for quickly reading a file to calculate the file
> > hash and validate (or set) the file signature/hash stored as an xattr,
> > prior to any other process getting access to the file.
> 
> And that's simply not doable in Linux from a layer outside the file system.
> And really questionable even from inside the fs.    We should simply drop
> IMA from the tree in the current state because it's obviously broken.

True, it is now broken on XFS, but please don't generalize this XFS
regression to all file systems.

> If you can convince fs maintainers to do the right calls from the file
> systems itself for given file systems (and only support IMA for those)
> we can add it back just for those.

We definitely need VFS help in resolving this regression.  As a last
resort, we could always update the default IMA builtin policy to exclude
XFS.

Mimi

