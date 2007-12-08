Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Dec 2007 14:10:11 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lBAMA6cH016919
	for <linux-xfs@oss.sgi.com>; Mon, 10 Dec 2007 14:10:07 -0800
Received: from wa-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D997FB24AE1
	for <linux-xfs@oss.sgi.com>; Mon, 10 Dec 2007 13:59:02 -0800 (PST)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.176]) by cuda.sgi.com with ESMTP id NkbCM7XRFwH2IHg1 for <linux-xfs@oss.sgi.com>; Mon, 10 Dec 2007 13:59:02 -0800 (PST)
Received: by wa-out-1112.google.com with SMTP id k22so3863136waf
        for <linux-xfs@oss.sgi.com>; Mon, 10 Dec 2007 13:59:01 -0800 (PST)
Message-ID: <5d96567b0712081142r4ebb4f2dk25c8b00c30afe0b5@mail.gmail.com>
Date: Sat, 8 Dec 2007 21:42:34 +0200
From: Raz <raziebe@gmail.com>
Subject: Re: mounting raid5 with different unit values
In-Reply-To: <20071008004513.GA13543@puku.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5d96567b0710070015j723810aag20dc3e2866868684@mail.gmail.com>
	 <20071007145213.GA4504@puku.stupidest.org>
	 <Pine.LNX.4.64.0710071147390.22702@p34.internal.lan>
	 <20071008004513.GA13543@puku.stupidest.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: linux-xfs@oss.sgi.com, Linux RAID Mailing List <linux-raid@vger.kernel.org>

Well... this thing actually works just fine with a newer kernel (
2.6.18-8-el5 centos5 ). I managed to mount / mkfs.xfs over raid5 with
a pseudo raid5 unit size, and with the appropriate raid 5 patches and
user space access-pattern, I elimintaed in 99% cases the read penalty
.
I sincerly hope I won't be getting any crashes with this file system tunnings.
so ... first, chris and all you xfs guys, many many thanks.
Chris,  How "dangerous" these tunnings are ? Am I to expect "weird"
behaviour of the file system ?

On 10/8/07, Chris Wedgwood <cw@f00f.org> wrote:
> On Sun, Oct 07, 2007 at 11:48:14AM -0400, Justin Piszcz wrote:
>
> > man mount :)
>
> Ah of course.
>
> But those will be more restrictive that what you can specify when you
> make the file-system (because mkfs.xfs can aligned the AGs to suit).
>


-- 
Raz
