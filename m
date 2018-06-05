Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:32927 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750959AbeFEEWR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 00:22:17 -0400
Received: by mail-ot0-f194.google.com with SMTP id h6-v6so1180417otj.0
        for <linux-xfs@vger.kernel.org>; Mon, 04 Jun 2018 21:22:17 -0700 (PDT)
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 4 Jun 2018 21:22:15 -0700
Message-ID: <CAPcyv4hJOzRBR0hg=xBZkd_oLtQRZeTXShYChdu8VA+GgTqUvg@mail.gmail.com>
Subject: KASAN vs ZONE_DEVICE (was: Re: [PATCH v2 2/7] dax: change bdev_dax_supported()...)
Content-Type: multipart/mixed; boundary="00000000000037aa32056ddd659f"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Mike Snitzer <snitzer@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Alexander Potapenko <glider@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>

--00000000000037aa32056ddd659f
Content-Type: text/plain; charset="UTF-8"

On Mon, Jun 4, 2018 at 8:32 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> [ adding KASAN devs...]
>
> On Mon, Jun 4, 2018 at 4:40 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> On Sun, Jun 3, 2018 at 6:48 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>>> On Sun, Jun 3, 2018 at 5:25 PM, Dave Chinner <david@fromorbit.com> wrote:
>>>> On Mon, Jun 04, 2018 at 08:20:38AM +1000, Dave Chinner wrote:
>>>>> On Thu, May 31, 2018 at 09:02:52PM -0700, Dan Williams wrote:
>>>>> > On Thu, May 31, 2018 at 7:24 PM, Dave Chinner <david@fromorbit.com> wrote:
>>>>> > > On Thu, May 31, 2018 at 06:57:33PM -0700, Dan Williams wrote:
>>>>> > >> > FWIW, XFS+DAX used to just work on this setup (I hadn't even
>>>>> > >> > installed ndctl until this morning!) but after changing the kernel
>>>>> > >> > it no longer works. That would make it a regression, yes?
>>>>>
>>>>> [....]
>>>>>
>>>>> > >> I suspect your kernel does not have CONFIG_ZONE_DEVICE enabled which
>>>>> > >> has the following dependencies:
>>>>> > >>
>>>>> > >>         depends on MEMORY_HOTPLUG
>>>>> > >>         depends on MEMORY_HOTREMOVE
>>>>> > >>         depends on SPARSEMEM_VMEMMAP
>>>>> > >
>>>>> > > Filesystem DAX now has a dependency on memory hotplug?
>>>>>
>>>>> [....]
>>>>>
>>>>> > > OK, works now I've found the magic config incantantions to turn
>>>>> > > everything I now need on.
>>>>>
>>>>> By enabling these options, my test VM now has a ~30s pause in the
>>>>> boot very soon after the nvdimm subsystem is initialised.
>>>>>
>>>>> [    1.523718] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
>>>>> [    1.550353] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
>>>>> [    1.552175] Non-volatile memory driver v1.3
>>>>> [    2.332045] tsc: Refined TSC clocksource calibration: 2199.909 MHz
>>>>> [    2.333280] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x1fb5dcd4620, max_idle_ns: 440795264143 ns
>>>>> [   37.217453] brd: module loaded
>>>>> [   37.225423] loop: module loaded
>>>>> [   37.228441] virtio_blk virtio2: [vda] 10485760 512-byte logical blocks (5.37 GB/5.00 GiB)
>>>>> [   37.245418] virtio_blk virtio3: [vdb] 146800640 512-byte logical blocks (75.2 GB/70.0 GiB)
>>>>> [   37.255794] virtio_blk virtio4: [vdc] 1073741824000 512-byte logical blocks (550 TB/500 TiB)
>>>>> [   37.265403] nd_pmem namespace1.0: unable to guarantee persistence of writes
>>>>> [   37.265618] nd_pmem namespace0.0: unable to guarantee persistence of writes
>>>>>
>>>>> The system does not appear to be consuming CPU, but it is blocking
>>>>> NMIs so I can't get a CPU trace. For a VM that I rely on booting in
>>>>> a few seconds because I reboot it tens of times a day, this is a
>>>>> problem....
>>>>
>>>> And when I turn on KASAN, the kernel fails to boot to a login prompt
>>>> because:
>>>
>>> What's your qemu and kernel command line? I'll take look at this first
>>> thing tomorrow.
>>
>> I was able to reproduce this crash by just turning on KASAN...
>> investigating. It would still help to have your config for our own
>> regression testing purposes it makes sense for us to prioritize
>> "Dave's test config", similar to the priority of not breaking Linus'
>> laptop.
>
> I believe this is a bug in KASAN, or a bug in devm_memremap_pages(),
> depends on your point of view. At the very least it is a mismatch of
> assumptions. KASAN learns of hot added memory via the memory hotplug
> notifier. However, the devm_memremap_pages() implementation is
> intentionally limited to the "first half" of the memory hotplug
> procedure. I.e. it does just enough to setup the linear map for
> pfn_to_page() and initialize the "struct page" memmap, but then stops
> short of onlining the pages. This is why we are getting a NULL ptr
> deref and not a KASAN report, because KASAN has no shadow area setup
> for the linearly mapped pmem range.
>
> In terms of solving it we could refactor kasan_mem_notifier() so that
> devm_memremap_pages() can call it outside of the notifier... I'll give
> this a shot.

Well, the attached patch got me slightly further, but only slightly...

[   14.998394] BUG: KASAN: unknown-crash in pmem_do_bvec+0x19e/0x790 [nd_pmem]
[   15.000006] Read of size 4096 at addr ffff880200000000 by task
systemd-udevd/915
[   15.001991]
[   15.002590] CPU: 15 PID: 915 Comm: systemd-udevd Tainted: G
  OE     4.17.0-rc5+ #1
982
[   15.004783] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.11.1-0-g0551a
4be2c-prebuilt.qemu-project.org 04/01/2014
[   15.007652] Call Trace:
[   15.008339]  dump_stack+0x9a/0xeb
[   15.009344]  print_address_description+0x73/0x280
[   15.010524]  kasan_report+0x258/0x380
[   15.011528]  ? pmem_do_bvec+0x19e/0x790 [nd_pmem]
[   15.012747]  memcpy+0x1f/0x50
[   15.013659]  pmem_do_bvec+0x19e/0x790 [nd_pmem]

...I've exhausted my limited kasan internals knowledge, any ideas what
it's missing?

--00000000000037aa32056ddd659f
Content-Type: application/octet-stream; name=patch
Content-Disposition: attachment; filename=patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ji16cnvt0

ZGlmZiAtLWdpdCBhL2tlcm5lbC9tZW1yZW1hcC5jIGIva2VybmVsL21lbXJlbWFwLmMKaW5kZXgg
ODk1ZTZiNzZiMjVlLi5iNmY0Nzg2NTg3MTkgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9tZW1yZW1hcC5j
CisrKyBiL2tlcm5lbC9tZW1yZW1hcC5jCkBAIC0yMCw2ICsyMCwxMCBAQAogI2luY2x1ZGUgPGxp
bnV4L3N3YXAuaD4KICNpbmNsdWRlIDxsaW51eC9zd2Fwb3BzLmg+CiAKKy8qIGZvciBtYW51YWxs
eSBub3RpZnlpbmcgb2YgbGluZWFyIG1hcCBhZGRpdGlvbnMgKi8KKyNpbmNsdWRlIDxsaW51eC9t
ZW1vcnkuaD4KKyNpbmNsdWRlICIuLi9tbS9rYXNhbi9rYXNhbi5oIgorCiAjaWZuZGVmIGlvcmVt
YXBfY2FjaGUKIC8qIHRlbXBvcmFyeSB3aGlsZSB3ZSBjb252ZXJ0IGV4aXN0aW5nIGlvcmVtYXBf
Y2FjaGUgdXNlcnMgdG8gbWVtcmVtYXAgKi8KIF9fd2VhayB2b2lkIF9faW9tZW0gKmlvcmVtYXBf
Y2FjaGUocmVzb3VyY2Vfc2l6ZV90IG9mZnNldCwgdW5zaWduZWQgbG9uZyBzaXplKQpAQCAtMjkx
LDYgKzI5NSw3IEBAIHN0YXRpYyB2b2lkIGRldm1fbWVtcmVtYXBfcGFnZXNfcmVsZWFzZSh2b2lk
ICpkYXRhKQogCXN0cnVjdCBkZXZpY2UgKmRldiA9IHBnbWFwLT5kZXY7CiAJc3RydWN0IHJlc291
cmNlICpyZXMgPSAmcGdtYXAtPnJlczsKIAlyZXNvdXJjZV9zaXplX3QgYWxpZ25fc3RhcnQsIGFs
aWduX3NpemU7CisJc3RydWN0IG1lbW9yeV9ub3RpZnkgYXJnOwogCXVuc2lnbmVkIGxvbmcgcGZu
OwogCiAJZm9yX2VhY2hfZGV2aWNlX3BmbihwZm4sIHBnbWFwKQpAQCAtMzA5LDYgKzMxNCw5IEBA
IHN0YXRpYyB2b2lkIGRldm1fbWVtcmVtYXBfcGFnZXNfcmVsZWFzZSh2b2lkICpkYXRhKQogCW1l
bV9ob3RwbHVnX2JlZ2luKCk7CiAJYXJjaF9yZW1vdmVfbWVtb3J5KGFsaWduX3N0YXJ0LCBhbGln
bl9zaXplLCBwZ21hcC0+YWx0bWFwX3ZhbGlkID8KIAkJCSZwZ21hcC0+YWx0bWFwIDogTlVMTCk7
CisJYXJnLnN0YXJ0X3BmbiA9IGFsaWduX3N0YXJ0ID4+IFBBR0VfU0hJRlQ7CisJYXJnLm5yX3Bh
Z2VzID0gYWxpZ25fc2l6ZSA+PiBQQUdFX1NISUZUOworCWthc2FuX21lbV9ub3RpZmllcihOVUxM
LCBNRU1fR09JTkdfT0ZGTElORSwgJmFyZyk7CiAJbWVtX2hvdHBsdWdfZG9uZSgpOwogCiAJdW50
cmFja19wZm4oTlVMTCwgUEhZU19QRk4oYWxpZ25fc3RhcnQpLCBhbGlnbl9zaXplKTsKQEAgLTM5
NiwxMCArNDA0LDE2IEBAIHZvaWQgKmRldm1fbWVtcmVtYXBfcGFnZXMoc3RydWN0IGRldmljZSAq
ZGV2LCBzdHJ1Y3QgZGV2X3BhZ2VtYXAgKnBnbWFwKQogCiAJbWVtX2hvdHBsdWdfYmVnaW4oKTsK
IAllcnJvciA9IGFyY2hfYWRkX21lbW9yeShuaWQsIGFsaWduX3N0YXJ0LCBhbGlnbl9zaXplLCBh
bHRtYXAsIGZhbHNlKTsKLQlpZiAoIWVycm9yKQorCWlmICghZXJyb3IpIHsKKwkJc3RydWN0IG1l
bW9yeV9ub3RpZnkgYXJnID0geworCQkJLnN0YXJ0X3BmbiA9IGFsaWduX3N0YXJ0ID4+IFBBR0Vf
U0hJRlQsCisJCQkubnJfcGFnZXMgPSBhbGlnbl9zaXplID4+IFBBR0VfU0hJRlQsCisJCX07CisK
IAkJbW92ZV9wZm5fcmFuZ2VfdG9fem9uZSgmTk9ERV9EQVRBKG5pZCktPm5vZGVfem9uZXNbWk9O
RV9ERVZJQ0VdLAotCQkJCQlhbGlnbl9zdGFydCA+PiBQQUdFX1NISUZULAotCQkJCQlhbGlnbl9z
aXplID4+IFBBR0VfU0hJRlQsIGFsdG1hcCk7CisJCQkJCWFyZy5zdGFydF9wZm4sIGFyZy5ucl9w
YWdlcywgYWx0bWFwKTsKKwkJa2FzYW5fbWVtX25vdGlmaWVyKE5VTEwsIE1FTV9HT0lOR19PTkxJ
TkUsICZhcmcpOworCX0KIAltZW1faG90cGx1Z19kb25lKCk7CiAJaWYgKGVycm9yKQogCQlnb3Rv
IGVycl9hZGRfbWVtb3J5OwpkaWZmIC0tZ2l0IGEvbW0va2FzYW4va2FzYW4uYyBiL21tL2thc2Fu
L2thc2FuLmMKaW5kZXggYmMwZTY4ZjdkYzc1Li4yNzU2MGFlYTVlNjcgMTAwNjQ0Ci0tLSBhL21t
L2thc2FuL2thc2FuLmMKKysrIGIvbW0va2FzYW4va2FzYW4uYwpAQCAtNzkyLDggKzc5Miw4IEBA
IERFRklORV9BU0FOX1NFVF9TSEFET1coZjUpOwogREVGSU5FX0FTQU5fU0VUX1NIQURPVyhmOCk7
CiAKICNpZmRlZiBDT05GSUdfTUVNT1JZX0hPVFBMVUcKLXN0YXRpYyBpbnQgX19tZW1pbml0IGth
c2FuX21lbV9ub3RpZmllcihzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgKm5iLAotCQkJdW5zaWduZWQg
bG9uZyBhY3Rpb24sIHZvaWQgKmRhdGEpCitpbnQga2FzYW5fbWVtX25vdGlmaWVyKHN0cnVjdCBu
b3RpZmllcl9ibG9jayAqbmIsIHVuc2lnbmVkIGxvbmcgYWN0aW9uLAorCQl2b2lkICpkYXRhKQog
ewogCXN0cnVjdCBtZW1vcnlfbm90aWZ5ICptZW1fZGF0YSA9IGRhdGE7CiAJdW5zaWduZWQgbG9u
ZyBucl9zaGFkb3dfcGFnZXMsIHN0YXJ0X2thZGRyLCBzaGFkb3dfc3RhcnQ7CmRpZmYgLS1naXQg
YS9tbS9rYXNhbi9rYXNhbi5oIGIvbW0va2FzYW4va2FzYW4uaAppbmRleCBjMTJkY2ZkZTJlYmQu
LmY1NmQ1YWU2MDUzNiAxMDA2NDQKLS0tIGEvbW0va2FzYW4va2FzYW4uaAorKysgYi9tbS9rYXNh
bi9rYXNhbi5oCkBAIC0xMjAsNiArMTIwLDE3IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBxdWFyYW50
aW5lX3JlZHVjZSh2b2lkKSB7IH0KIHN0YXRpYyBpbmxpbmUgdm9pZCBxdWFyYW50aW5lX3JlbW92
ZV9jYWNoZShzdHJ1Y3Qga21lbV9jYWNoZSAqY2FjaGUpIHsgfQogI2VuZGlmCiAKKyNpZiBkZWZp
bmVkKENPTkZJR19NRU1PUllfSE9UUExVRykgJiYgZGVmaW5lZChDT05GSUdfS0FTQU4pCitpbnQg
a2FzYW5fbWVtX25vdGlmaWVyKHN0cnVjdCBub3RpZmllcl9ibG9jayAqbmIsIHVuc2lnbmVkIGxv
bmcgYWN0aW9uLAorCQl2b2lkICpkYXRhKTsKKyNlbHNlCitzdGF0aWMgaW5saW5lIGludCBrYXNh
bl9tZW1fbm90aWZpZXIoc3RydWN0IG5vdGlmaWVyX2Jsb2NrICpuYiwKKwkJdW5zaWduZWQgbG9u
ZyBhY3Rpb24sIHZvaWQgKmRhdGEpCit7CisJcmV0dXJuIE5PVElGWV9PSzsKK30KKyNlbmRpZgor
CiAvKgogICogRXhwb3J0ZWQgZnVuY3Rpb25zIGZvciBpbnRlcmZhY2VzIGNhbGxlZCBmcm9tIGFz
c2VtYmx5IG9yIGZyb20gZ2VuZXJhdGVkCiAgKiBjb2RlLiBEZWNsYXJhdGlvbnMgaGVyZSB0byBh
dm9pZCB3YXJuaW5nIGFib3V0IG1pc3NpbmcgZGVjbGFyYXRpb25zLgo=
--00000000000037aa32056ddd659f--
