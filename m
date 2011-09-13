Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8DGWMg5070728 for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 11:32:22 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7781915933D
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 09:32:21 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [72.73.18.11]) by cuda.sgi.com
	with ESMTP id jdPOFaYROK1OUDbC for <xfs@oss.sgi.com>;
	Tue, 13 Sep 2011 09:32:21 -0700 (PDT)
Date: Tue, 13 Sep 2011 12:32:20 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 3.1-rc4: spectacular kernel errors / filesystem crash
In-Reply-To: <CAMaF-rMxTWRAO7WRdYoEM57k66MC6Vuwk1mcfgCgMO6Z+KBvzQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1109131156050.7113@p34.internal.lan>
References: <alpine.DEB.2.02.1109110511250.8626@p34.internal.lan>
	<CAEuXFEzs1f7n5taYzupux3AtKmRcY4P0m7yjkUQA8aLyS8eujw@mail.gmail.com>
	<1315886706.2556.11.camel@edumazet-laptop>
	<alpine.DEB.2.02.1109130722210.21380@p34.internal.lan>
	<CAMaF-rN-qeXBDoc9=7kwu40Wj8=G8YuPKWXPRhOuhdYX_VO34w@mail.gmail.com>
	<alpine.DEB.2.02.1109131142010.7113@p34.internal.lan>
	<CAMaF-rMxTWRAO7WRdYoEM57k66MC6Vuwk1mcfgCgMO6Z+KBvzQ@mail.gmail.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jon Mason <mason@myri.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, NetDEV list <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Jesse Brandeburg <jesse.brandeburg@gmail.com>, Alan Piszcz <ap@solarrain.com>



On Tue, 13 Sep 2011, Jon Mason wrote:

> On Tue, Sep 13, 2011 at 10:42 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>>
>>
>> On Tue, 13 Sep 2011, Jon Mason wrote:
>>
>>> On Tue, Sep 13, 2011 at 9:54 AM, Justin Piszcz <jpiszcz@lucidpixels.com>
>>> wrote:
>>>>
>>>>
>>>> On Tue, 13 Sep 2011, Eric Dumazet wrote:
>>>>

Thanks,

# patch -p1 < ../0001-Fix-pointer-dereference-before-call-to-pcie_bus_conf.patch
patching file arch/x86/pci/acpi.c
patching file drivers/pci/hotplug/pcihp_slot.c
patching file drivers/pci/probe.c
# patch -p1 < ../0002-PCI-Remove-MRRS-modification-from-MPS-setting-code.patch
patching file drivers/pci/pci.c
patching file drivers/pci/probe.c
#

Rebooted & running with new patches for 3.1-rc4.
Will let you know if any further issues, I wonder if this will fix
the RCU/SLAB issues too, thanks.

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
