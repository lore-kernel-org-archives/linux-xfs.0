Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:38758 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750891AbdAHT0i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jan 2017 14:26:38 -0500
Date: Sun, 8 Jan 2017 19:26:34 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: xfs:  commit 6552321831dc "xfs: remove i_iolock and use i_rwsem
 in the VFS inode instead"  change causes hang
Message-ID: <20170108192634.GM1555@ZenIV.linux.org.uk>
References: <1483886924.8189.81.camel@linux.vnet.ibm.com>
 <20170108145200.GA29570@lst.de>
 <1483898365.2542.13.camel@HansenPartnership.com>
 <20170108181856.GA781@lst.de>
 <1483901848.2542.27.camel@HansenPartnership.com>
 <20170108190955.GA1489@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170108190955.GA1489@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Sun, Jan 08, 2017 at 08:09:55PM +0100, Christoph Hellwig wrote:

> No.  We need an ->ima_measure file_operation, guts of process_measurement
> turned into a library function that the FS can call after taking fs-specific
> locks.  And maybe also a small wrapper around it that takes ilock and
> can be used directly for file systems not needing special locking.

Incidentally, it had been literally years since the problems with their
pathname handling had been brought up and we *still* have got no answer.

In the current tree, ima_d_path() is quite capable of returning
path->dentry->d_name.name.  Which gets used by subsequent code,
even though there is no warranty whatsoever that it won't be
pointing to freed memory by the time the caller of ima_d_path()
gets it.

Could IMA folks be bothered to explain how the hell is that supposed to
work?  Note that the race window is *not* narrow - it includes reading the
file contents, for fuck sake!  A plenty of time for the file to be
renamed, and if the name had been long enough to be stored separately,
for the original to be freed/reused/whatnot.

Better yet, in ima_collect_measurement() they have another user of
->d_name.name, with all the same issues.
