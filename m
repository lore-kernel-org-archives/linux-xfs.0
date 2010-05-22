Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4MDqJkK069842 for <xfs@oss.sgi.com>; Sat, 22 May 2010 08:52:19 -0500
Received: from mail-wy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B786E366332
	for <xfs@oss.sgi.com>; Sat, 22 May 2010 06:54:39 -0700 (PDT)
Received: from mail-wy0-f181.google.com (mail-wy0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id 51KzgJFnmcQxpqGR
	for <xfs@oss.sgi.com>; Sat, 22 May 2010 06:54:39 -0700 (PDT)
Received: by wyf19 with SMTP id 19so1331340wyf.26
	for <xfs@oss.sgi.com>; Sat, 22 May 2010 06:54:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BF7DA7D.5070405@sandeen.net>
References: <AANLkTilJD2Jfr4W97BiAlyc_7C9jLEhEzuEWSDyVKXYP@mail.gmail.com>
	<4BF7DA7D.5070405@sandeen.net>
Date: Sat, 22 May 2010 14:54:38 +0100
Message-ID: <AANLkTil7ti8LCCiZ8KZzaBL80Qy06pyhL_oZuGZXm_qQ@mail.gmail.com>
Subject: Re: Tuning XFS for real time audio on a laptop with encrypted LVM
From: Pedro Ribeiro <pedrib@gmail.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 22 May 2010 14:22, Eric Sandeen <sandeen@sandeen.net> wrote:
> Pedro Ribeiro wrote:
>> Hi all,
>>
>> I was wondering what is the best scheduler for my use case given my
>> current hardware.
>>
>> I have a laptop with a fast Core 2 duo at 2.26 and a nice amount of
>> ram (4GB) which I use primarily for real time audio (though without a
>> -rt kernel). All my partitions are XFS under LVM which itself is
>> contained on a LUKS partition (encrypted with AES 128).
>>
>> CFQ currently does not perform very well and causes a lot of thrashing
>> and high latencies when I/O usage is high. Changing it to the noop
>> scheduler solves some of the problems and makes it more responsive.
>> Still performance is a bit of a let down: it takes 1m30s to unpack the
>> linux-2.6.34 tarball and a massive 2m30s to rm -r.
>> I have lazy-count=1, noatime, logbufs=8, logbsize=256k and a 128m log.
>
> Are you optimizing for kernel untars, or "real time audio?"
>
> I would expect that even suboptimal tuning would keep up just fine with
> audio demands.
>
> -Eric
>

"real-time audio" is very different from normal audio. In particular,
it requires <10ms response time for jitter free operation. Up to and
including kernel 2.6.33 this was not possible to do reliably without
the -rt patch, no matter how tuned it was.
The big difference came with 2.6.34-rcX and now the stable 2.6.34. It
is now possible to make it work reliable without any audio drops.

But then again, this probably has nothing to do with XFS. My point was
just that while my primary goal is optimum real-time audio, I still
want top reliability (which I could not get with the -rt patch) and
good filesystem performance. Of course the fact that I am using
encryption does not help, but that is another story.

Bottom line, I'm quite happy with XFS and do not plan to change it in
the near future. The only complaint I have is the slow deletion of
large directories like the kernel tree. But I'll trade the reliability
of XFS for that.

Regards,
Pedro

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
