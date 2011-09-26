Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8Q5RVHL120329 for <xfs@oss.sgi.com>; Mon, 26 Sep 2011 00:27:31 -0500
Received: from mail.uscreen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ABE4D141E1ED
	for <xfs@oss.sgi.com>; Sun, 25 Sep 2011 22:33:19 -0700 (PDT)
Received: from mail.uscreen.net (mail.uscreen.net [62.67.233.10]) by
	cuda.sgi.com with ESMTP id 8pmYzXBz9U67tvGl for
	<xfs@oss.sgi.com>; Sun, 25 Sep 2011 22:33:19 -0700 (PDT)
Message-ID: <4E800D38.8000903@u-club.de>
Date: Mon, 26 Sep 2011 07:27:20 +0200
From: Christoph <cr2005@u-club.de>
MIME-Version: 1.0
Subject: Re: [PATCH] PM / Freezer: Freeze filesystems while freezing processes
	(v2)
References: <4E1C70AD.1010101@u-club.de>
	<201109251532.20025.rjw@sisk.pl>	<4E7FA3C7.5050503@u-club.de>
	<201109260010.50649.rjw@sisk.pl>
In-Reply-To: <201109260010.50649.rjw@sisk.pl>
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
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Theodore Ts'o <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Nigel Cunningham <nigel@tuxonice.net>, Pavel Machek <pavel@ucw.cz>, linux-fsdevel@vger.kernel.org, Linux PM mailing list <linux-pm@lists.linux-foundation.org>, linux-ext4@vger.kernel.org


On 26.09.2011 00:10, Rafael J. Wysocki wrote:
> On Sunday, September 25, 2011, Christoph wrote:
>> On 25.09.2011 15:32, Rafael J. Wysocki wrote:
>>> On Sunday, September 25, 2011, Christoph wrote:
>>>> test results of the patch below:
>>>>
>>>> 1. real machine
>>>>
>>>> suspends fine but on wakeup, after loading image: hard reset. nvidia
>>>> gpu => disabled compitz  => wakeup worked two times.
>>>
>>> Hmm, so there's a separate bug related to NVidia I guess.
>>
>> Maybe.
>>
>> Just made another test: the machine (macbook) woke up, loaded image, thaw.
>> It got stuck at vt#1, displaying console with login. Cursor blinking, but
>> no (usb) keyboard or network enabled. Bricked?!!
>>
>>
>> On the other hand I've got another box with nvidia gpu:
>>
>> debian5 32bit
>> 2.6.38.2+ #3 SMP Fri Apr 1
>> nvidia 260.19.36
>>
>> It's up since I compiled the kernel: I use it twice a week and I kept it
>> freezed all the time. It was solid rock until today: hard reset on resume.
>> WTF? (I remember this version combo was stable on the macbook but the
>> kernel lacks a solid wireless driver).
> 
> If that's an x86_64 system, there is a known bug causing problems like
> this to happen.  There's a patch fixing it, but not conclusive:
> http://marc.info/?l=linux-kernel&m=131653513414314&w=2

very good. seems to fix resume, at least the 2 times I tested so far.

tx! :)

chris


> 
> Thanks,
> Rafael
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
