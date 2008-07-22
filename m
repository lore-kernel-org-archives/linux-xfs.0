Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 23:20:03 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6M6Jvm4027859
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 23:19:58 -0700
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id QAA07736; Tue, 22 Jul 2008 16:20:56 +1000
Message-ID: <48857C4A.6060004@sgi.com>
Date: Tue, 22 Jul 2008 16:20:58 +1000
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: xfsrestore over ssh?
References: <2d460de70807211317m75bc236y403d8fa57514262e@mail.gmail.com>	 <4884F2A5.5050507@sgi.com>	 <2d460de70807212002k1a95706ic8291e2abd8796b8@mail.gmail.com>	 <48855B16.4050208@sgi.com> <2d460de70807212143j1f80e016y6a48cab966091215@mail.gmail.com>
In-Reply-To: <2d460de70807212143j1f80e016y6a48cab966091215@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Richard Hartmann <richih.mailinglist@gmail.com>
Cc: Timothy Shimmin <tes@sgi.com>, Bill Kendall <wkendall@sgi.com>, xfs@oss.sgi.com

Richard Hartmann wrote:
> On Tue, Jul 22, 2008 at 05:59, Timothy Shimmin <tes@sgi.com> wrote:
> 
> 
>> xfsrestore just uses standard posix calls for the most part to
>> restore the files (seeks, writes, etc...) to a mounted filesystem -
>> and in many circumstances can restore on a non-xfs mounted filesystem.
>> It is _NOT_ a low level file system restorer to an unmounted filesystem
>> like some other restorers.
> 
> True, this is why I told it to use /mnt/sda3, not a raw device :)

:), looks like we both misread that.

Should be working then. If you hexdump the start of the dump does it look
reasonable? It should be something like:

molten:/home/donaldd # hexdump -C dump | head
00000000  78 46 53 64 75 6d 70 30  00 00 00 02 02 05 e8 49  |xFSdump0.......I|
00000010  48 85 7c cc 00 00 00 00  00 00 00 00 0e 86 21 36  |H.|...........!6|
00000020  86 06 e5 1d 17 32 49 a0  ad ea 5d 1d a2 7c d9 a3  |.....2I...]..|..|
00000030  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000100  6d 6f 6c 74 65 6e 00 00  00 00 00 00 00 00 00 00  |molten..........|
00000110  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000200  73 6f 6d 65 6c 61 62 65  6c 00 00 00 00 00 00 00  |somelabel.......|
00000210  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
