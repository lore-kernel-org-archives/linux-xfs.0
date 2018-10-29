Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from esa18.fujitsucc.c3s2.iphmx.com ([216.71.158.38]:46078 "EHLO
        esa18.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729455AbeJ2Rz7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Oct 2018 13:55:59 -0400
From: "y-goto@fujitsu.com" <y-goto@fujitsu.com>
Subject: About remain issues of FS-DAX
Date: Mon, 29 Oct 2018 08:57:54 +0000
Message-ID: <TYAPR01MB32611EC1FF23669346456BEB90F30@TYAPR01MB3261.jpnprd01.prod.outlook.com>
Content-Language: ja-JP
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-nvdimm <linux-nvdimm@lists.01.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "'linux-ext4@vger.kernel.org'" <linux-ext4@vger.kernel.org>
Cc: 'Dan Williams' <dan.j.williams@intel.com>, 'Dave Chinner' <david@fromorbit.com>


Hello,

I noticed the discussion what is necessary for fs-dax
in the following thread of xfs/ext4 Mailing list.

https://patchwork.kernel.org/cover/10631363/

(I didn't subscribe xfs or ext4 ML, so I didn't know at first.)

Though there may be discussed them already,
I would like to mention my humble opinion about them from normal user's vie=
w point
(or as technical support engineers)

I hope this is good for progress to remove "Experimental" status of FS-DAX.

>From Dave Chinner
-----
> I think we need to decide on:
>=20
> - default filesystem behaviour on dax-capable block devices

In my first impression of filesystem DAX, I felt that "-o dax" mount option
was a bit strange. Because system administrator can specify fs-dax capable =
area
by ndctl create-namespace. Then I couldn't find why he/she need to specify
dax again at mount option. It is second time of specify fsdax, I thought it=
 is not needed.

So, I think Filesystem should detect FS-DAX capable area,
and should enable it. It is easier for administrator to use fs-dax.


> - what information about DAX do applications actually need? What
>   makes sense to provide them with that information?

I suppose that application should not grep dax mount option to confirm "fs-=
dax enabled".
Instead, OS should provide information fs-dax is certainly enabled or not f=
or application.

> - how to provide hints to the kernel for desired behaviour
>  - on-disk inode flags, or something else?
>  - dax/nodax mount options or root dir inode flags become default
>    global hints?
>  - is a single hint flag sufficient or do we also need an
>    explicit "do not use dax" flag?

Are there any reason each inode must be remember dax flags?
It seems to be simpler that the root dir inode only know it as a global hin=
t.

> - behaviour of MAP_SYNC w.r.t. non-DAX filesystems that can provide
>   required MAP_SYNC semnatics

Hmm, if there is a usecase of MAP_SYNC with non-DAX filesystem,
It should be allowed.
But I could not find any positive reason for it....


> - behaviour of MAP_DIRECT - hint like O_DIRECT or guarantee?

I would like to bet "guarantee".
If system cannot use the feature which user specified,
then I suppose system should return error to notify it.

If there is no way of guarantee due to technical reason, and
system selects falling back from MAP_DIRECT, then I think system
should notify or output somewhere for user to detect such event.

> - default read/write path behaviour of dax-capable block devices
>   - automatically bypass the pagecache if bdev is capable?

I prefer automatically bypass the pagecache for users to use easily...


> - default mmap behaviour on dax capable devices
>   - use dax always?

I suppose "always" is easy for user to understand.....
If not, I suppose document should describe what is necessary to use dax.


> - DAX vs get_user_pages_longterm
>   - turns off DAX dynamically?

If turn off can not be avoided, its event notification will be necessary
for software using DAX and/or for system administrator.

>   - how do DAX-enabled filesystems interact with page fault capable
>     hardware? Can we allow DAX in those cases?

I have no comment here.=20
(To be honest, I don't understand what is problem...
 I'm glad if someone tell me it.)

>From Dan Williams
---
> - Is MADV_DIRECT_ACCESS a hint or a requirement?

If MADV_DIRECT_ACCESS becomes a hint, how and when FS-DAX is falling down?
In such case, a software needs to change its behavior to call msync()
instead of cpu cache flush to make persistent data.

So, I suppose requirement is better....


> - How does the kernel communicate the effective mode of a mapping
>   taking into account madvise(), inode flags, mount options, and / or
>   default fs behavior? New madvice() syscall?

hmmmmmm,  sysfs?


> - What is the behavior of dax in the presence of reflink'd extents?
>   Just failing seems the 'experimental' behavior. What to do about
>   page->index when page belongs to more than 1 file via reflink?

Sorry, I don't have good idea about this.
To be honest, I'm not sure how reflink is necessary for NVDIMM...


> - Is there ever a case to force disable dax operation? To date we've
>   only ever thought about interfaces to force *enable* dax operation

If something becomes wrong on dax, administrator may want to disable dax fo=
rcely
as a emergency mode and try to rescue the data in the filesystem.

Maybe "-o nodax" option?

> - The virtio-pmem use case wants dax mappings but requires an explicit
>   fsync() instead of MAP_SYNC to flush software buffers, it's a DAX
>   sub-set, should it have it's own name?

Is this just naming problem?
"DAX_with sync"?

> - DAX operation is loosely tied to block devices. There has been
>   discussions of mounting filesystems on /dev/dax devices directly.
>   Should we take that to its logical conclusion and support a
>   block-layer-less conversion of dax-capable file systems?

To be honest, I'm not sure how this is necessary.
May I have what is use-case?
It seems to be not current issue, but it is feature request=20
for future. IOW, it seems not to be cause of "Experimental" at least.

> - Willy has proposed that the Xarray cache file-offset-to-physical
>   address lookups, currently it only tracks dirty mapping state

It seems to be refactoring or some kind of code improvements for future, ri=
ght?
Or, is it essential to solve a problem?

> - The NVDIMM sub-system tracks badblocks, but the filesytem currently
>   only finds out about them late when it attempts dax_direct_access().
>   Applications want to be able to list files+offsets that have
>   experienced media corruption.

I suppose it will be necessary.=20
However, IIRC, there many objection about it due to cause of layer destruct=
ion
among filesystem, mm, and block layer....

If I overlooked something like current background, sorry for noise...

Thanks,
---
Yasunori Goto
