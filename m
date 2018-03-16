Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:46789 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752106AbeCPTKH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Mar 2018 15:10:07 -0400
Received: by mail-oi0-f67.google.com with SMTP id x12so9472555oie.13
        for <linux-xfs@vger.kernel.org>; Fri, 16 Mar 2018 12:10:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180316190443.GF3671@lst.de>
References: <152112908134.24669.10222746224538377035.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152112914933.24669.5543317105428477772.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180316190443.GF3671@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 16 Mar 2018 12:10:05 -0700
Message-ID: <CAPcyv4iii7i-W-NvX+PaPfwATuWJamD38cdNUHvP=Cn-5vL3Ww@mail.gmail.com>
Subject: Re: [PATCH v6 12/15] xfs: require mmap lock for xfs_break_layouts()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Fri, Mar 16, 2018 at 12:04 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Thu, Mar 15, 2018 at 08:52:29AM -0700, Dan Williams wrote:
>> In preparation for adding coordination between truncate operations and
>> busy dax-pages, extend xfs_break_layouts() to assume it must be called
>> with the mmap lock held. This locking scheme will be required for
>> coordinating the break of 'dax layouts' (non-idle dax (ZONE_DEVICE)
>> pages mapped into the file's address space).
>
> This requirement wasn't really there in the last series, why do we
> require it now?

It seems I misinterpreted your feedback.

>
> As far as I can tell all we'd need is to just drop this assert:
>
>> -     ASSERT(xfs_isilocked(ip, XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL));
>> +     ASSERT(xfs_isilocked(ip, XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL
>> +                             | XFS_MMAPLOCK_EXCL));
>
> entirely.
>
>>       while ((error = break_layout(inode, false) == -EWOULDBLOCK)) {
>>               xfs_iunlock(ip, *iolock);
>>               error = break_layout(inode, true);
>> -             *iolock = XFS_IOLOCK_EXCL;
>> +             *iolock &= ~XFS_IOLOCK_SHARED;
>> +             *iolock |= XFS_IOLOCK_EXCL;
>>               xfs_ilock(ip, *iolock);
>
> And take this one hunk from your patch.
>
> To enable the DAX use case.

Yeah, that looks good to me.
