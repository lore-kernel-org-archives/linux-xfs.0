Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:35641 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751121AbdHZWqY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 26 Aug 2017 18:46:24 -0400
Received: by mail-oi0-f45.google.com with SMTP id k77so22384423oib.2
        for <linux-xfs@vger.kernel.org>; Sat, 26 Aug 2017 15:46:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <35692b04-eb4f-740c-e35c-8ccbf69e0e97@gmx.de>
References: <150353211413.5039.5228914877418362329.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150353213097.5039.6729469069608762658.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170824165546.GA3121@infradead.org> <CAPcyv4iN0QpUSgOUvisnNQsiV1Pp=4dh7CwAV8FFj=_rFU=aug@mail.gmail.com>
 <20170825130011.GA30072@infradead.org> <20170825155803.4km7wttzadfqw2vb@node.shutemov.name>
 <20170825160236.GA2561@infradead.org> <20170825161607.6v6beg4zjktllt2z@node.shutemov.name>
 <4de21e8d-5e10-ec40-c731-0c079953cf48@gmx.de> <CAPcyv4jeZc8P+E0aHNChzy-wfNpOx3GehKck1nXqJ1b9JdydFA@mail.gmail.com>
 <20170826074047.GA6292@ls3530.fritz.box> <CAPcyv4ic0zxQzWEipZ=1LpDC8VnmphGzVSYmrFcjOAgX7esfUw@mail.gmail.com>
 <35692b04-eb4f-740c-e35c-8ccbf69e0e97@gmx.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 26 Aug 2017 15:46:22 -0700
Message-ID: <CAPcyv4i0+3Smg9bfynKa150y7qvQ-WVRBHyCrK=R1b4oVj3URA@mail.gmail.com>
Subject: Re: [PATCH v6 3/5] mm: introduce mmap3 for safely defining new mmap flags
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Helge Deller <deller@gmx.de>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-parisc@vger.kernel.org

On Sat, Aug 26, 2017 at 12:50 PM, Helge Deller <deller@gmx.de> wrote:
> On 26.08.2017 17:15, Dan Williams wrote:
[..]
>> I have not seen any patches for parisc pmem+dax enabling so it seems
>> too early to worry about these "last mile" enabling features of
>> MAP_DIRECT and MAP_SYNC. In particular parisc doesn't appear to have
>> ARCH_ENABLE_MEMORY_HOTPLUG, so as far as I can see it can't yet
>> support the ZONE_DEVICE scheme that is a pre-requisite for MAP_DIRECT.
>
> I see, but then it's probably best to not to define any MAP_DIRECT or
> MAP_SYNC at all in the headers of those arches which don't support
> pmem+dax (parisc, m68k, alpha, and probably quite some others).
> That way applications can detect at configure time if the platform
> supports that, and can leave out the functionality completely.

Yes, that's a good idea we can handle this similar to
CONFIG_MMAP_ALLOW_UNINITIALIZED. These patches will also modify
'struct file_operations' so that do_mmap() can validate whether a flag
is supported on per architecture basis. Also the plan is to plumb the
flags passed to the syscall all the way down to the individual mmap
implementations. The ext4 and xfs ->mmap() operations will be able to
return -EOPNOTSUP based on runtime variables.
