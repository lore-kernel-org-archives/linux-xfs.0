Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57989 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752987AbdAHPbd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jan 2017 10:31:33 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id v08FSjbu086186
        for <linux-xfs@vger.kernel.org>; Sun, 8 Jan 2017 10:31:32 -0500
Received: from e23smtp09.au.ibm.com (e23smtp09.au.ibm.com [202.81.31.142])
        by mx0b-001b2d01.pphosted.com with ESMTP id 27ttu4atnq-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Sun, 08 Jan 2017 10:31:32 -0500
Received: from localhost
        by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
        Mon, 9 Jan 2017 01:31:29 +1000
Subject: Re: xfs:  commit 6552321831dc "xfs: remove i_iolock and use    i_rwsem
 in the VFS inode instead"  change causes hang
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date: Sun, 08 Jan 2017 10:31:22 -0500
In-Reply-To: <20170108151430.GA29847@lst.de>
References: <1483886924.8189.81.camel@linux.vnet.ibm.com>
         <20170108145200.GA29570@lst.de>
         <1483887789.8189.90.camel@linux.vnet.ibm.com>
         <20170108151430.GA29847@lst.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <1483889482.8189.104.camel@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>

On Sun, 2017-01-08 at 16:14 +0100, Christoph Hellwig wrote:
> On Sun, Jan 08, 2017 at 10:03:09AM -0500, Mimi Zohar wrote:
> > But not normally for a normal file read.
> 
> Depends on the file system.  In addition to XFS at least the NFS
> also uses i_rwsem by default.  Also all file systems supporting
> a DAX I/O path.

We're only interested in the integrity of the local file system.

> > Unless something has changed recently, to synchronize reading files to
> > calculate the file hash and writing xattrs it has to take the i_rwsem
> > prior to reading the file.
> 
> No, you must simply not do this at all.  If you take a lock that
> belongs to the fs and is not your own over ->read_iter you're toast
> as you've seen.

Christoph,  this isn't a new story and telling me this isn't very
productive.  Originally there was an IMA specific lock.  The i_mutex was
taken just to access the xattr.   Unforutnately, having two locks caused
a lockdep between the normal read/validate and setxattr.  As a result,
we dropped the IMA specific lock.

IMA needs a mechanism for quickly reading a file to calculate the file
hash and validate (or set) the file signature/hash stored as an xattr,
prior to any other process getting access to the file.

Mimi

