Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.161.177]:36511 "EHLO
        mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751605AbdHPQ3Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Aug 2017 12:29:25 -0400
Received: by mail-yw0-f177.google.com with SMTP id u207so25856566ywc.3
        for <linux-xfs@vger.kernel.org>; Wed, 16 Aug 2017 09:29:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170816111244.uxx6kvbi3cn5clqd@node.shutemov.name>
References: <150286944610.8837.9513410258028246174.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150286946864.8837.17147962029964281564.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170816111244.uxx6kvbi3cn5clqd@node.shutemov.name>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 16 Aug 2017 09:29:24 -0700
Message-ID: <CAPcyv4iFzbVMgEJen--QNnFH7uuU7PWCV6S9c3fPwDMrr3iZjA@mail.gmail.com>
Subject: Re: [PATCH v5 4/5] fs, xfs: introduce MAP_DIRECT for creating
 block-map-atomic file ranges
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux API <linux-api@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Jeff Moyer <jmoyer@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>

On Wed, Aug 16, 2017 at 4:12 AM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
> On Wed, Aug 16, 2017 at 12:44:28AM -0700, Dan Williams wrote:
>> @@ -1411,6 +1422,9 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
>>
>>                       /* fall through */
>>               case MAP_PRIVATE:
>> +                     if ((flags & (MAP_PRIVATE|MAP_DIRECT))
>> +                                     == (MAP_PRIVATE|MAP_DIRECT))
>> +                             return -EINVAL;
>
> We've already checked for MAP_PRIVATE in this codepath. Simple (flags &
> MAP_DIRECT) would be enough.

True, willl fix.
