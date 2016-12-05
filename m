Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f175.google.com ([209.85.213.175]:32823 "EHLO
        mail-yb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751464AbcLEPwG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Dec 2016 10:52:06 -0500
Received: by mail-yb0-f175.google.com with SMTP id v132so58597865yba.0
        for <linux-xfs@vger.kernel.org>; Mon, 05 Dec 2016 07:51:50 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.1 \(3251\))
Subject: Re: XFS: possible memory allocation deadlock in kmem_alloc on
 glusterfs setup
From: Cyril Peponnet <cyril.peponnet@nuagenetworks.net>
In-Reply-To: <20161205074645.GB4326@dastard>
Date: Mon, 5 Dec 2016 07:51:45 -0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <07D60BAA-A340-4AB0-9F22-D962A0478891@nuagenetworks.net>
References: <E861E5C1-D1C2-4368-8BFC-505533C9A3A3@nuagenetworks.net>
 <20161204214950.GL31101@dastard>
 <9B23CFED-4AFC-46FC-8E35-AD85B11FEA02@nuagenetworks.net>
 <20161204224604.GN31101@dastard>
 <D3BB642A-1CBB-47CB-89AA-E99837228F35@nuagenetworks.net>
 <20161204235059.GO31101@dastard>
 <A9F9389E-0CD8-4A85-BA08-C5503B781679@nuagenetworks.net>
 <20161205012243.GQ31101@dastard>
 <C07DD929-5600-4934-A6B0-C0A7D83D7247@nuagenetworks.net>
 <20161205074645.GB4326@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org


> On Dec 4, 2016, at 11:46 PM, Dave Chinner <david@fromorbit.com> wrote:
>=20
> On Sun, Dec 04, 2016 at 05:47:04PM -0800, Cyril Peponnet wrote:
>>> On Dec 4, 2016, at 5:22 PM, Dave Chinner <david@fromorbit.com>
>>> wrote: What deadlock is that? XFS is reporting memory allocation
>>> issues, not that there is a filesystem deadlock. Your comments
>>> that dropping caches make the problem go away indicate that
>>> there isn't any deadlock, just blocking on memory allocation
>>> that is taking a long time to resolve=E2=80=A6
>>=20
>> You are right by deadlock I meant that mount point hang for ls
>> commands for instance (from the server it self) and basically the
>> glusterfs mount on the hypervisors is also hanging for all vms (it
>> makes the vms to remount RO).
>=20
> So everything is /blocked/, not deadlocked. If the memory allocation
> then makes progress, we're all ok.
>=20
>> On this server I have 1200 living snapshots, usually not too much
>> write in it except for some of them=E2=80=A6
>>=20
>> Is there a way to optimize the memory allocation? Or we likely
>> need to add more ram=E2=80=A6
>=20
> More RAM won't help - it's likely a memory fragmentation problem
> made worse by the fact that older kernels won't do memory compaction
> (i.e. memory defrag) when high order memory allocation fails. If the
> problem is file fragmentation, then the best you can probably do
> right now is limit fragmentation.
>=20
> Stopping qcow2 from fragmenting the crap out of the files will
> prevent the problem from re-occurring. This is the primary use case
> for extent size hints in XFS these days, though I know you can't
> actually control the gluster back end to use this. perhaps there are
> other tweaks to qcow formats (cluster size?) or gluster config to
> limit the amount of fragmentation=E2=80=A6.


I had the issue again but I don=E2=80=99t have more output in dmesg or =
journalctl even with the echo 11 > /proc/sys/fs/xfs/error_level set.

Is there another location where I should look at ?

Thanks

>=20
> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com

