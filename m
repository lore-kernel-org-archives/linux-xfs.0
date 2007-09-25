Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Sep 2007 05:50:19 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8PCoDQ3015336
	for <linux-xfs@oss.sgi.com>; Tue, 25 Sep 2007 05:50:15 -0700
Date: Tue, 25 Sep 2007 08:50:15 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
In-Reply-To: <20070925123501.GA20499@p15145560.pureserver.info>
Message-ID: <Pine.LNX.4.64.0709250849560.11391@p34.internal.lan>
References: <20070923093841.GH19983@p15145560.pureserver.info>
 <20070924173155.GI19983@p15145560.pureserver.info>
 <Pine.LNX.4.64.0709241400370.12025@p34.internal.lan>
 <20070924203958.GA4082@p15145560.pureserver.info>
 <Pine.LNX.4.64.0709241642110.19847@p34.internal.lan>
 <20070924213358.GB4082@p15145560.pureserver.info>
 <Pine.LNX.4.64.0709241736370.19847@p34.internal.lan>
 <20070924215223.GC4082@p15145560.pureserver.info>
 <20070925123501.GA20499@p15145560.pureserver.info>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-6325792-1190724615=:11391"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ralf Gross <Ralf-Lists@ralfgross.de>
Cc: linux-xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-6325792-1190724615=:11391
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 25 Sep 2007, Ralf Gross wrote:

> Ralf Gross schrieb:
>>> What do you get when (reading) from the raw device?
>>>
>>> dd if=3D/dev/sda bs=3D1M count=3D10240
>>
>> The server has 16 GB RAM, so I tried it with 20 GB of data.
>>
>> dd if=3D/dev/sdd of=3D/dev/null bs=3D1M count=3D20480
>> 20480+0 Datens=E4tze ein
>> 20480+0 Datens=E4tze aus
>> 21474836480 Bytes (21 GB) kopiert, 95,3738 Sekunden, 225 MB/s
>>
>> and a second try:
>>
>> dd if=3D/dev/sdd of=3D/dev/null bs=3D1M count=3D20480
>> 20480+0 Datens=E4tze ein
>> 20480+0 Datens=E4tze aus
>> 21474836480 Bytes (21 GB) kopiert, 123,78 Sekunden, 173 MB/s
>>
>> I'm taoo tired to interprete these numbers at the moment, I'll do some
>> more testing tomorrow.
>
> There is a second RAID device attached to the server (24x RAID5). The
> numbers I get from this device are a bit worse than the 16x RAID 5
> numbers (150MB/s read with dd).
>
> I'm really wondering how people can achieve transfer rates of
> 400MB/s and more. I know that I'm limited by the FC controller, but
> I don't even get >200MB/s.
>
> Ralf
>
>

Perhaps something is wrong with your setup?

Here are my 10 raptors in RAID5 using Software RAID (no hw raid=20
controller):

p34:~# dd if=3D/dev/md3 of=3D/dev/null bs=3D1M count=3D16384
16384+0 records in
16384+0 records out
17179869184 bytes (17 GB) copied, 29.8193 seconds, 576 MB/s
p34:~#

---1463747160-6325792-1190724615=:11391--
