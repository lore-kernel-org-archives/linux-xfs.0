Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 12 May 2007 06:02:22 -0700 (PDT)
Received: from mailer.gwdg.de (mailer.gwdg.de [134.76.10.26])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4CD2AfB028338
	for <xfs@oss.sgi.com>; Sat, 12 May 2007 06:02:12 -0700
Date: Sat, 12 May 2007 13:21:41 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an
 nlink problem?
In-Reply-To: <20070510153832.GQ11115@waste.org>
Message-ID: <Pine.LNX.4.61.0705121320240.9570@yvahk01.tjqt.qr>
References: <4642389E.4080804@goop.org> <20070509231643.GM85884050@sgi.com>
 <4642598E.3000607@goop.org> <20070510000119.GO85884050@sgi.com>
 <46426194.3040403@goop.org> <20070510004918.GS85884050@sgi.com>
 <46426D31.8070000@goop.org> <20070510012609.GU85884050@sgi.com>
 <46433049.4020003@goop.org> <20070510153832.GQ11115@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, David Chinner <dgc@sgi.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, michal.k.k.piotrowski@gmail.com


On May 10 2007 10:38, Matt Mackall wrote:
>> 
>>     for i in `seq 20`; do
>>     	hg clone -U --pull a b-$i
>>     	hg verify b-$i		# always OK
>>     	umount /home
>>     	sleep 5
>>     	mount /home
>>     	hg verify b-$i		# often found truncated files
>>     done
>>       
[...]
>
>This test looks like it should consist solely of open-for-append and
>write on about 20k files in the target directory. Because of the
>--pull, no hardlinks are involved. It shouldn't be all that different
>from doing tar cf - a | tar xf - b.
>
>The files get visited in alphabetical order, so the start of the
>corruption may be telling.

You should not assume alphabetical order. Filesystems may be free to
reorder things and return them (1) randomly like in a hash (2) by
creation time during readdir().


	Jan
-- 
