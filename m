Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2IGHGAB044092 for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 11:17:21 -0500
Received: from mail.moocowproductions.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 53814360BB6
	for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 09:20:03 -0700 (PDT)
Received: from mail.moocowproductions.org (mail.moocowproductions.org
	[50.56.82.78]) by cuda.sgi.com with SMTP id QEuqxDX6SHxxNPrD
	for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 09:20:03 -0700 (PDT)
Subject: Re: 2.6.38: XFS/USB/HW issue, or failing USB stick?
Mime-Version: 1.0 (Apple Message framework v1082)
From: Tim Soderstrom <tim@moocowproductions.org>
In-Reply-To: <201103181659.46558.arnd@arndb.de>
Date: Fri, 18 Mar 2011 11:20:01 -0500
Message-Id: <74AA2E38-9C4E-45EB-B810-2B64EC731F24@moocowproductions.org>
References: <alpine.DEB.2.02.1103181104020.30018@p34.internal.lan>
	<30463798-7ACB-4248-8CDC-CEFCB6ABC0BE@moocowproductions.org>
	<201103181659.46558.arnd@arndb.de>
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
To: Arnd Bergmann <arnd@arndb.de>
Cc: xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, Justin Piszcz <jpiszcz@lucidpixels.com>


On Mar 18, 2011, at 10:59 AM, Arnd Bergmann wrote:

> On Friday 18 March 2011, Tim Soderstrom wrote:
> 
>>> 
>>> However, after some amount of time, the errors occur below, is this USB
>>> stick failing?  Since it has no SMART, is there any other way to verify
>>> the 'health' of a USB stick?
>> 
>> What prompted you to go with XFS over, say, ext2? The journal will generally
>> cause quite a bit more writes onto your USB device. I use ext2 on my CF card 
>> in my NAS for that reason (the spinning media is on XFS of course). I know
>> that's not an answer to your problem but thought I would add it as a suggestion :)
> 
> Using ext2 on flash media instead of ext3 or other file systems is
> recommended a lot, but the situation is actually much more complex.
> In https://lwn.net/Articles/428584/, I explain how these things work
> under the cover. For a drive that can only have very few erase blocks
> open, using a journaled file system will always mean thrashing, but
> for drives with more open erase blocks, it's probably better to
> use a journal than not.

Wow that's a great article, thanks for the link!

Tim

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
