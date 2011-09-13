Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8DFZVMS068087 for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 10:35:32 -0500
Received: from mail-gx0-f178.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8DBFA13E531F
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 08:40:09 -0700 (PDT)
Received: from mail-gx0-f178.google.com (mail-gx0-f178.google.com
	[209.85.161.178]) by cuda.sgi.com with ESMTP id
	iIOsdFYOF1Z4MbPF for <xfs@oss.sgi.com>;
	Tue, 13 Sep 2011 08:40:09 -0700 (PDT)
Received: by gxk8 with SMTP id 8so681983gxk.37
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 08:35:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1109130722210.21380@p34.internal.lan>
References: <alpine.DEB.2.02.1109110511250.8626@p34.internal.lan>
	<CAEuXFEzs1f7n5taYzupux3AtKmRcY4P0m7yjkUQA8aLyS8eujw@mail.gmail.com>
	<1315886706.2556.11.camel@edumazet-laptop>
	<alpine.DEB.2.02.1109130722210.21380@p34.internal.lan>
Date: Tue, 13 Sep 2011 10:35:29 -0500
Message-ID: <CAMaF-rN-qeXBDoc9=7kwu40Wj8=G8YuPKWXPRhOuhdYX_VO34w@mail.gmail.com>
Subject: Re: 3.1-rc4: spectacular kernel errors / filesystem crash
From: Jon Mason <mason@myri.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, NetDEV list <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Jesse Brandeburg <jesse.brandeburg@gmail.com>, Alan Piszcz <ap@solarrain.com>

On Tue, Sep 13, 2011 at 9:54 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wr=
ote:
>
>
> On Tue, 13 Sep 2011, Eric Dumazet wrote:
>
>> Please Justin make sure you pulled commit
>> commit ed2888e906b56769b4ffabb9c577190438aa68b8
>> Author: Jon Mason <mason@myri.com>
>> Date: =A0 Thu Sep 8 16:41:18 2011 -0500
>>
>> =A0 PCI: Remove MRRS modification from MPS setting code
>>
>> =A0 Modifying the Maximum Read Request Size to 0 (value of 128Bytes) has
>> =A0 massive negative ramifications on some devices. =A0Without knowing w=
hich
>> =A0 devices have this issue, do not modify from the default value when
>> =A0 walking the PCI-E bus in pcie_bus_safe mode. =A0Also, make pcie_bus_=
safe
>> =A0 the default procedure.
>>
>> =A0 Tested-by: Sven Schnelle <svens@stackframe.org>
>> =A0 Tested-by: Simon Kirby <sim@hostway.ca>
>> =A0 Tested-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>> =A0 Reported-and-tested-by: Eric Dumazet <eric.dumazet@gmail.com>
>> =A0 Reported-and-tested-by: Niels Ole Salscheider
>> <niels_ole@salscheider-online.
>> =A0 References: https://bugzilla.kernel.org/show_bug.cgi?id=3D42162
>> =A0 Signed-off-by: Jon Mason <mason@myri.com>
>> =A0 Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>> =A0 Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>
> Hello,
>
> I found this commit here:
> http://permalink.gmane.org/gmane.linux.kernel.pci/11700

This is an early version of the patch.  This is the patch that you want:
https://github.com/torvalds/linux/commit/ed2888e906b56769b4ffabb9c577190438=
aa68b8

It appears that this patch didn't make it to lkml or linux-pci list
due to kernel.org DNS being down when it was sent.

Thanks,
Jon

>
> Applied:
> # patch -p1 < ../ed2888e906b56769b4ffabb9c577190438aa68b8.txt patching fi=
le
> drivers/pci/probe.c
>
> I will update this thread if the problem recurs, can someone also please
> advise
> which DEBUG options I should have enabled to catch further SLAB/RCU issue=
s?
>
> So far, I have the following enabled:
>
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=3Dy
> CONFIG_HAVE_DMA_API_DEBUG=3Dy
> CONFIG_X86_DEBUGCTLMSR=3Dy
> CONFIG_DEBUG_FS=3Dy
> CONFIG_DEBUG_KERNEL=3Dy
> CONFIG_DEBUG_SLAB=3Dy
> CONFIG_DEBUG_SLAB_LEAK=3Dy
> CONFIG_DEBUG_KMEMLEAK=3Dy
> CONFIG_DEBUG_STACK_USAGE=3Dy
> CONFIG_DEBUG_BUGVERBOSE=3Dy
> CONFIG_DEBUG_INFO=3Dy
> CONFIG_DEBUG_VM=3Dy
> CONFIG_DEBUG_VIRTUAL=3Dy
> CONFIG_DEBUG_MEMORY_INIT=3Dy
> CONFIG_DEBUG_PER_CPU_MAPS=3Dy
> CONFIG_DEBUG_PAGEALLOC=3Dy
> CONFIG_DEBUG_STACKOVERFLOW=3Dy
> CONFIG_DEBUG_RODATA=3Dy
>
> Thanks,
>
> Justin.
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
