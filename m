Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0PD9kSj125787 for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 07:09:47 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 96A871BAB993
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 05:09:03 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id INYpv8FwDWeQudtT for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 05:09:03 -0800 (PST)
Date: Sun, 25 Jan 2009 08:08:32 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Switching from (deprecated) IDE driver -> SATA (PATA support)
	(found solution (scratch that))
In-Reply-To: <alpine.DEB.1.10.0901250752020.11258@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0901250808020.15073@p34.internal.lan>
References: <alpine.DEB.1.10.0901250553430.2441@p34.internal.lan>
	<20090125110742.4ba54c0b@lxorguk.ukuu.org.uk>
	<alpine.DEB.1.10.0901250705300.6888@p34.internal.lan>
	<alpine.DEB.1.10.0901250715030.10379@p34.internal.lan>
	<alpine.DEB.1.10.0901250726530.10805@p34.internal.lan>
	<alpine.DEB.1.10.0901250740360.11258@p34.internal.lan>
	<alpine.DEB.1.10.0901250752020.11258@p34.internal.lan>
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
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Sun, 25 Jan 2009, Justin Piszcz wrote:

>
>
> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>
>> 
>> 
>> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>> 
>>> 
>>> 
>>> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>>> 
>>>> 
>>>> 
>>>> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>>>> 
>>>>> 
>>>>> 
>>>>> On Sun, 25 Jan 2009, Alan Cox wrote:

Hm, I may have spoke too fast:

Added: (IDE ONLY), no SATA:
image=/boot/2.6.26-6
         label=2.6.26-6
         read-only
         root=current

p254:/boot# lilo
Added 2.6.26-6 *
Added 2.6.28-4
p254:/boot#

Set to current.

p254:/boot# grep =current /etc/lilo.conf
root=current
         root=current
p254:/boot#

The reason current may have worked before is because I manually booted with
root=/dev/sdd2 (after I saw the error that it could not find root,302, etc)

So I am booting the old kernel without the SATA drivers with root=current
to see if it works..

Nope, so I need to figure out how to get the UUID= option working in LILO.

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
