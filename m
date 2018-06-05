Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:43623 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751303AbeFEDcb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jun 2018 23:32:31 -0400
Received: by mail-ot0-f196.google.com with SMTP id i19-v6so1041723otk.10
        for <linux-xfs@vger.kernel.org>; Mon, 04 Jun 2018 20:32:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4iVU3n3G3Vxf9e6cKuCtQtmrm6+R6vS379NyHX6eTZ5Lg@mail.gmail.com>
References: <20180529195106.14268-1-ross.zwisler@linux.intel.com>
 <20180529195106.14268-3-ross.zwisler@linux.intel.com> <20180529212510.GJ30110@magnolia>
 <20180529220114.GA13948@linux.intel.com> <20180531191332.GB7825@magnolia>
 <20180601012657.GQ10363@dastard> <CAPcyv4g6dv9sG9dR-iY+aEfSi2r3ey1dXGbX-nexKsN72t0QMw@mail.gmail.com>
 <20180601022418.GR10363@dastard> <CAPcyv4iXTsxmQgjoLs2E_8QrLHrFOV_58T7UYf0zPJuB2744qQ@mail.gmail.com>
 <20180603222038.GS10363@dastard> <20180604002525.GI10363@dastard>
 <CAPcyv4jL5AKgP3io_hBZxkrKzBZq8wtuqk49L48v=XRiOHdoEw@mail.gmail.com> <CAPcyv4iVU3n3G3Vxf9e6cKuCtQtmrm6+R6vS379NyHX6eTZ5Lg@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 4 Jun 2018 20:32:30 -0700
Message-ID: <CAPcyv4i-ocx3-9dCsKfyhf=vBtYnfJwzYyCU2jektHZ2LPL0rA@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] dax: change bdev_dax_supported() to support
 boolean returns
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Mike Snitzer <snitzer@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Alexander Potapenko <glider@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>

[ adding KASAN devs...]

On Mon, Jun 4, 2018 at 4:40 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Sun, Jun 3, 2018 at 6:48 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> On Sun, Jun 3, 2018 at 5:25 PM, Dave Chinner <david@fromorbit.com> wrote:
>>> On Mon, Jun 04, 2018 at 08:20:38AM +1000, Dave Chinner wrote:
>>>> On Thu, May 31, 2018 at 09:02:52PM -0700, Dan Williams wrote:
>>>> > On Thu, May 31, 2018 at 7:24 PM, Dave Chinner <david@fromorbit.com> wrote:
>>>> > > On Thu, May 31, 2018 at 06:57:33PM -0700, Dan Williams wrote:
>>>> > >> > FWIW, XFS+DAX used to just work on this setup (I hadn't even
>>>> > >> > installed ndctl until this morning!) but after changing the kernel
>>>> > >> > it no longer works. That would make it a regression, yes?
>>>>
>>>> [....]
>>>>
>>>> > >> I suspect your kernel does not have CONFIG_ZONE_DEVICE enabled which
>>>> > >> has the following dependencies:
>>>> > >>
>>>> > >>         depends on MEMORY_HOTPLUG
>>>> > >>         depends on MEMORY_HOTREMOVE
>>>> > >>         depends on SPARSEMEM_VMEMMAP
>>>> > >
>>>> > > Filesystem DAX now has a dependency on memory hotplug?
>>>>
>>>> [....]
>>>>
>>>> > > OK, works now I've found the magic config incantantions to turn
>>>> > > everything I now need on.
>>>>
>>>> By enabling these options, my test VM now has a ~30s pause in the
>>>> boot very soon after the nvdimm subsystem is initialised.
>>>>
>>>> [    1.523718] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
>>>> [    1.550353] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
>>>> [    1.552175] Non-volatile memory driver v1.3
>>>> [    2.332045] tsc: Refined TSC clocksource calibration: 2199.909 MHz
>>>> [    2.333280] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x1fb5dcd4620, max_idle_ns: 440795264143 ns
>>>> [   37.217453] brd: module loaded
>>>> [   37.225423] loop: module loaded
>>>> [   37.228441] virtio_blk virtio2: [vda] 10485760 512-byte logical blocks (5.37 GB/5.00 GiB)
>>>> [   37.245418] virtio_blk virtio3: [vdb] 146800640 512-byte logical blocks (75.2 GB/70.0 GiB)
>>>> [   37.255794] virtio_blk virtio4: [vdc] 1073741824000 512-byte logical blocks (550 TB/500 TiB)
>>>> [   37.265403] nd_pmem namespace1.0: unable to guarantee persistence of writes
>>>> [   37.265618] nd_pmem namespace0.0: unable to guarantee persistence of writes
>>>>
>>>> The system does not appear to be consuming CPU, but it is blocking
>>>> NMIs so I can't get a CPU trace. For a VM that I rely on booting in
>>>> a few seconds because I reboot it tens of times a day, this is a
>>>> problem....
>>>
>>> And when I turn on KASAN, the kernel fails to boot to a login prompt
>>> because:
>>
>> What's your qemu and kernel command line? I'll take look at this first
>> thing tomorrow.
>
> I was able to reproduce this crash by just turning on KASAN...
> investigating. It would still help to have your config for our own
> regression testing purposes it makes sense for us to prioritize
> "Dave's test config", similar to the priority of not breaking Linus'
> laptop.

I believe this is a bug in KASAN, or a bug in devm_memremap_pages(),
depends on your point of view. At the very least it is a mismatch of
assumptions. KASAN learns of hot added memory via the memory hotplug
notifier. However, the devm_memremap_pages() implementation is
intentionally limited to the "first half" of the memory hotplug
procedure. I.e. it does just enough to setup the linear map for
pfn_to_page() and initialize the "struct page" memmap, but then stops
short of onlining the pages. This is why we are getting a NULL ptr
deref and not a KASAN report, because KASAN has no shadow area setup
for the linearly mapped pmem range.

In terms of solving it we could refactor kasan_mem_notifier() so that
devm_memremap_pages() can call it outside of the notifier... I'll give
this a shot.
