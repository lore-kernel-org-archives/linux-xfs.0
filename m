Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f180.google.com ([74.125.82.180]:43080 "EHLO
        mail-ot0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751464AbeCVPuo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Mar 2018 11:50:44 -0400
Received: by mail-ot0-f180.google.com with SMTP id m22-v6so9954152otf.10
        for <linux-xfs@vger.kernel.org>; Thu, 22 Mar 2018 08:50:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180322072734.GB28713@lst.de>
References: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152167310580.5268.18270880990191450094.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180322072734.GB28713@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 22 Mar 2018 08:50:43 -0700
Message-ID: <CAPcyv4hPR4fFH61Vg5ik=GCnBgrC9+vN==A146YqB9Dts8Fv0g@mail.gmail.com>
Subject: Re: [PATCH v7 13/14] xfs: prepare xfs_break_layouts() for another
 layout type
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dave Chinner <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>

On Thu, Mar 22, 2018 at 12:27 AM, Christoph Hellwig <hch@lst.de> wrote:
>> +     ASSERT(xfs_isilocked(ip, XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL
>> +                             | (reason == BREAK_UNMAPI
>> +                                     ? XFS_MMAPLOCK_EXCL : 0)));
>
> please split the assert, e.g.:
>
>         ASSERT(xfs_isilocked(ip, XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL));
>
>         switch (reason) {
> +       case BREAK_UNMAPI:
>                 ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));

Sure, I was thinking to keep it out of the loop, but the common case
is that this loop only iterates once.

>> +             /* fall through */
>> +     case BREAK_WRITE:
>> +             error = xfs_break_leased_layouts(inode, iolock, &did_unlock);
>> +             break;
>> +     default:
>> +             error = -EINVAL;
>> +             break;
>> +     }
>> +
>> +     return error;
>
> I have to say I'd prefer BREAK_UNMAP over BREAK_UNMAPI given that weird
> I suffix doesn't buy us anything, but that's just a minor issue.

Ok will do.

> Otherwise looks good:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
