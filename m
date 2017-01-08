Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34605 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750956AbdAHUKh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jan 2017 15:10:37 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id v08K8Vcw008998
        for <linux-xfs@vger.kernel.org>; Sun, 8 Jan 2017 15:10:37 -0500
Received: from e23smtp08.au.ibm.com (e23smtp08.au.ibm.com [202.81.31.141])
        by mx0a-001b2d01.pphosted.com with ESMTP id 27unkea8fp-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Sun, 08 Jan 2017 15:10:36 -0500
Received: from localhost
        by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
        Mon, 9 Jan 2017 06:10:34 +1000
Subject: Re: xfs:  commit 6552321831dc "xfs: remove i_iolock and use i_rwsem
 in the VFS inode instead"  change causes hang
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date: Sun, 08 Jan 2017 15:10:28 -0500
In-Reply-To: <20170108192634.GM1555@ZenIV.linux.org.uk>
References: <1483886924.8189.81.camel@linux.vnet.ibm.com>
         <20170108145200.GA29570@lst.de>
         <1483898365.2542.13.camel@HansenPartnership.com>
         <20170108181856.GA781@lst.de>
         <1483901848.2542.27.camel@HansenPartnership.com>
         <20170108190955.GA1489@lst.de> <20170108192634.GM1555@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <1483906228.2956.59.camel@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Sun, 2017-01-08 at 19:26 +0000, Al Viro wrote:
> On Sun, Jan 08, 2017 at 08:09:55PM +0100, Christoph Hellwig wrote:
> 
> > No.  We need an ->ima_measure file_operation, guts of process_measurement
> > turned into a library function that the FS can call after taking fs-specific
> > locks.  And maybe also a small wrapper around it that takes ilock and
> > can be used directly for file systems not needing special locking.
> 
> Incidentally, it had been literally years since the problems with their
> pathname handling had been brought up and we *still* have got no answer.

> In the current tree, ima_d_path() is quite capable of returning
> path->dentry->d_name.name.  Which gets used by subsequent code,
> even though there is no warranty whatsoever that it won't be
> pointing to freed memory by the time the caller of ima_d_path()
> gets it.

The pathname/filename is being used in the measurement list and for
audit logging.  It's currently using d_absolute_path() to get the full
pathname, but falls back to using the dentry->d_name.name on failure.
Ok, so instead of returning the dentry->d_name.name, we should make a
copy it, assuming the error isn't memory related.

Mimi

