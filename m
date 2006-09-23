Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 23 Sep 2006 09:35:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8NGZDaG015916
	for <xfs@oss.sgi.com>; Sat, 23 Sep 2006 09:35:16 -0700
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6B835D10E74F
	for <xfs@oss.sgi.com>; Sat, 23 Sep 2006 09:34:35 -0700 (PDT)
Message-ID: <4515620F.5010607@sandeen.net>
Date: Sat, 23 Sep 2006 11:34:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: largeio mount and performance impact
References: <55EF1E5D5804A542A6CA37E446DDC206655888@mapibe17.exchange.xchg>
In-Reply-To: <55EF1E5D5804A542A6CA37E446DDC206655888@mapibe17.exchange.xchg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sebastian Brings <sebas@silexmedia.com>
Cc: xfs@oss.sgi.com

Sebastian Brings wrote:
> In a different thread I read about the largeio mount option for XFS. Now
> I wonder if the problems I recently ran in have been caused by this.
> 
> After a system uprgade from sles9 sp2 to sp3 one app started
> misbehaving. Before the upgrade it used 15% CPU, after the upgrade it
> was 90+% and the performance dropped by about 50%. The app is writing a
> wave audio file, and for every 3840 bytes of audio samples it appends,
> it updates the RIFF header of the file. All of this was done using the
> buffered fopen/fwrite/... C library functions. 
> An strace showed that seeking to the beginning of the file also
> triggered a 12MiB read(2) call, and seeking to the end, for example to
> 13MiB, translated to a seek(2) to offset 1mib and a read(2) of 12 MiB.
> 
> Initiall I assumed something very strange had happened to the C lib
> defaults. Otoh 12MiB is the swidth of the filesystem, so I assume that
> the C lib got the 12 MiB optimal IO size from XFS and therefore behaved
> as described above. Could that be?

Unless you specify the largeio mount option, I don't -think- any of this is exposed.

What does stat -c %o <file> say?

Did this strace behavior change from sp2 to sp3?

-Eric
