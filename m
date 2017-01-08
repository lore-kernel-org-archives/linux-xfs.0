Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36350 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751818AbdAHPDS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jan 2017 10:03:18 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id v08EwwqW035117
        for <linux-xfs@vger.kernel.org>; Sun, 8 Jan 2017 10:03:18 -0500
Received: from e23smtp02.au.ibm.com (e23smtp02.au.ibm.com [202.81.31.144])
        by mx0a-001b2d01.pphosted.com with ESMTP id 27upx116pb-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Sun, 08 Jan 2017 10:03:17 -0500
Received: from localhost
        by e23smtp02.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
        Mon, 9 Jan 2017 01:03:15 +1000
Subject: Re: xfs:  commit 6552321831dc "xfs: remove i_iolock and use    i_rwsem
 in the VFS inode instead"  change causes hang
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date: Sun, 08 Jan 2017 10:03:09 -0500
In-Reply-To: <20170108145200.GA29570@lst.de>
References: <1483886924.8189.81.camel@linux.vnet.ibm.com>
         <20170108145200.GA29570@lst.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <1483887789.8189.90.camel@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>

On Sun, 2017-01-08 at 15:52 +0100, Christoph Hellwig wrote:
> On Sun, Jan 08, 2017 at 09:48:44AM -0500, Mimi Zohar wrote:
> > IMA takes the i_rwsem (fomerly i_mutex) before reading the file to
> > synchronize calculating the file hash and validating the file's
> > hash/signature stored as security.ima xattr
> 
> Well, it shouldn't do that.  In the I/O path i_rwsem is up to the
> fs to use.  Various other file systems also take it internally for
> reads, although mostly only for direct I/O.

But not normally for a normal file read.  For direct I/O, IMA fails the
file hash/signature verification, measurement, audit unless the IMA
"permit_directio" rule is defined.

> So the answer here is that ima needs to stop playing with i_rwsem.

Unless something has changed recently, to synchronize reading files to
calculate the file hash and writing xattrs it has to take the i_rwsem
prior to reading the file.

Mimi

