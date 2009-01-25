Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0PDG7Zl126496 for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 07:16:09 -0600
Received: from isrv.corpit.ru (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F1991BAB4CF
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 05:15:19 -0800 (PST)
Received: from isrv.corpit.ru (isrv.corpit.ru [81.13.33.159]) by cuda.sgi.com
	with ESMTP id 9OXtSo870uyw2d5X for <xfs@oss.sgi.com>;
	Sun, 25 Jan 2009 05:15:19 -0800 (PST)
Message-ID: <497C65E4.2040302@msgid.tls.msk.ru>
Date: Sun, 25 Jan 2009 16:15:16 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
MIME-Version: 1.0
Subject: Re: Switching from (deprecated) IDE driver -> SATA (PATA support)
	(found solution (scratch that))
References: <alpine.DEB.1.10.0901250553430.2441@p34.internal.lan>
	<20090125110742.4ba54c0b@lxorguk.ukuu.org.uk>
	<alpine.DEB.1.10.0901250705300.6888@p34.internal.lan>
	<alpine.DEB.1.10.0901250715030.10379@p34.internal.lan>
	<alpine.DEB.1.10.0901250726530.10805@p34.internal.lan>
	<alpine.DEB.1.10.0901250740360.11258@p34.internal.lan>
	<alpine.DEB.1.10.0901250752020.11258@p34.internal.lan>
	<alpine.DEB.1.10.0901250808020.15073@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0901250808020.15073@p34.internal.lan>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, xfs@oss.sgi.com

Justin Piszcz wrote:
> 
> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>>> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>>>> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>>>>> On Sun, 25 Jan 2009, Justin Piszcz wrote:

Wow, that's quite some ping-pong!.. ;)

[]
> Hm, I may have spoke too fast:
> 
> Added: (IDE ONLY), no SATA:
> image=/boot/2.6.26-6
>         label=2.6.26-6
>         read-only
>         root=current
> 
> p254:/boot# lilo
> Added 2.6.26-6 *
> Added 2.6.28-4
> p254:/boot#
> 
> Set to current.
> 
> p254:/boot# grep =current /etc/lilo.conf
> root=current
>         root=current
> p254:/boot#
> 
> The reason current may have worked before is because I manually booted with
> root=/dev/sdd2 (after I saw the error that it could not find root,302, etc)
> 
> So I am booting the old kernel without the SATA drivers with root=current
> to see if it works..
> 
> Nope, so I need to figure out how to get the UUID= option working in LILO.

There's no way without using initramfs.  Lilo only records the unix device
number (like 8:1 for /dev/sda1) and passes it to kernel (replacing `current'
with that number).  But for different kernels (IDE vs PATA drivers) the
number will be different.  Lilo itself - when booting at least - can not
know which device it will be.

The only universal solution is to use smart initramfs that will populate
/dev/disk/by-label/ etc (using udev maybe).

Another solution is to explicitly specify root=/dev/sda1 or root=/dev/hda1
when using pata- or ide-enabled kernels, in lilo.conf.

/mjt

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
