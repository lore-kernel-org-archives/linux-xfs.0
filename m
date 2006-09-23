Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 23 Sep 2006 07:41:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8NEesaG030199
	for <xfs@oss.sgi.com>; Sat, 23 Sep 2006 07:40:55 -0700
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.126.190])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E4392D111DF6
	for <xfs@oss.sgi.com>; Sat, 23 Sep 2006 06:28:15 -0700 (PDT)
Received: from [212.227.126.203] (helo=mrvnet.kundenserver.de)
	by moutng.kundenserver.de with esmtp (Exim 3.35 #1)
	id 1GR7Xx-0001do-00
	for xfs@oss.sgi.com; Sat, 23 Sep 2006 15:27:57 +0200
Received: from [172.23.1.26] (helo=xchgsmtp.exchange.xchg)
	by mrvnet.kundenserver.de with smtp (Exim 3.35 #1)
	id 1GR7Xx-0001Rn-00
	for xfs@oss.sgi.com; Sat, 23 Sep 2006 15:27:57 +0200
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: largeio mount and performance impact
Date: Sat, 23 Sep 2006 15:27:45 +0200
Message-ID: <55EF1E5D5804A542A6CA37E446DDC206655888@mapibe17.exchange.xchg>
From: "Sebastian Brings" <sebas@silexmedia.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

In a different thread I read about the largeio mount option for XFS. Now
I wonder if the problems I recently ran in have been caused by this.

After a system uprgade from sles9 sp2 to sp3 one app started
misbehaving. Before the upgrade it used 15% CPU, after the upgrade it
was 90+% and the performance dropped by about 50%. The app is writing a
wave audio file, and for every 3840 bytes of audio samples it appends,
it updates the RIFF header of the file. All of this was done using the
buffered fopen/fwrite/... C library functions. 
An strace showed that seeking to the beginning of the file also
triggered a 12MiB read(2) call, and seeking to the end, for example to
13MiB, translated to a seek(2) to offset 1mib and a read(2) of 12 MiB.

Initiall I assumed something very strange had happened to the C lib
defaults. Otoh 12MiB is the swidth of the filesystem, so I assume that
the C lib got the 12 MiB optimal IO size from XFS and therefore behaved
as described above. Could that be?

Regards

Sebastian 
