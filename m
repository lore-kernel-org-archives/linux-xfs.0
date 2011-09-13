Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8DFgdQZ068317 for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 10:42:39 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7B6A454E27A
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2011 08:42:38 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [72.73.18.11]) by cuda.sgi.com
	with ESMTP id 3SSQi5ztb3eqCotn for <xfs@oss.sgi.com>;
	Tue, 13 Sep 2011 08:42:38 -0700 (PDT)
Date: Tue, 13 Sep 2011 11:42:38 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 3.1-rc4: spectacular kernel errors / filesystem crash
In-Reply-To: <CAMaF-rN-qeXBDoc9=7kwu40Wj8=G8YuPKWXPRhOuhdYX_VO34w@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1109131142010.7113@p34.internal.lan>
References: <alpine.DEB.2.02.1109110511250.8626@p34.internal.lan>
	<CAEuXFEzs1f7n5taYzupux3AtKmRcY4P0m7yjkUQA8aLyS8eujw@mail.gmail.com>
	<1315886706.2556.11.camel@edumazet-laptop>
	<alpine.DEB.2.02.1109130722210.21380@p34.internal.lan>
	<CAMaF-rN-qeXBDoc9=7kwu40Wj8=G8YuPKWXPRhOuhdYX_VO34w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="655872-1916408521-1315928558=:7113"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jon Mason <mason@myri.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, NetDEV list <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Jesse Brandeburg <jesse.brandeburg@gmail.com>, Alan Piszcz <ap@solarrain.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--655872-1916408521-1315928558=:7113
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 13 Sep 2011, Jon Mason wrote:

> On Tue, Sep 13, 2011 at 9:54 AM, Justin Piszcz <jpiszcz@lucidpixels.com> =
wrote:
>>
>>
>> On Tue, 13 Sep 2011, Eric Dumazet wrote:
>>
>>> Please Justin make sure you pulled commit
>>> commit ed2888e906b56769b4ffabb9c577190438aa68b8
>>> Author: Jon Mason <mason@myri.com>
>>> Date: =A0 Thu Sep 8 16:41:18 2011 -0500
>>>
>>> =A0 PCI: Remove MRRS modification from MPS setting code
>>>
>>> =A0 Modifying the Maximum Read Request Size to 0 (value of 128Bytes) ha=
s
>>> =A0 massive negative ramifications on some devices. =A0Without knowing =
which
>>> =A0 devices have this issue, do not modify from the default value when
>>> =A0 walking the PCI-E bus in pcie_bus_safe mode. =A0Also, make pcie_bus=
_safe
>>> =A0 the default procedure.
>>>
>>> =A0 Tested-by: Sven Schnelle <svens@stackframe.org>
>>> =A0 Tested-by: Simon Kirby <sim@hostway.ca>
>>> =A0 Tested-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>>> =A0 Reported-and-tested-by: Eric Dumazet <eric.dumazet@gmail.com>
>>> =A0 Reported-and-tested-by: Niels Ole Salscheider
>>> <niels_ole@salscheider-online.
>>> =A0 References: https://bugzilla.kernel.org/show_bug.cgi?id=3D42162
>>> =A0 Signed-off-by: Jon Mason <mason@myri.com>
>>> =A0 Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>>> =A0 Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>>
>> Hello,
>>
>> I found this commit here:
>> http://permalink.gmane.org/gmane.linux.kernel.pci/11700
>
> This is an early version of the patch.  This is the patch that you want:
> https://github.com/torvalds/linux/commit/ed2888e906b56769b4ffabb9c5771904=
38aa68b8
>
> It appears that this patch didn't make it to lkml or linux-pci list
> due to kernel.org DNS being down when it was sent.
>
> Thanks,
> Jon

I need to learn how to use git at some point, can you please provide plain
text patches so I can apply them and reboot?

Justin.

--655872-1916408521-1315928558=:7113
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--655872-1916408521-1315928558=:7113--
