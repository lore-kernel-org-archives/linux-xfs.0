Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 14 Jul 2007 16:33:42 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6ENXdbm018264
	for <xfs@oss.sgi.com>; Sat, 14 Jul 2007 16:33:40 -0700
Received: from localhost (localhost [127.0.0.1])
	by lucidpixels.com (Postfix) with ESMTP id A2A0A40195B9
	for <xfs@oss.sgi.com>; Sat, 14 Jul 2007 19:33:41 -0400 (EDT)
Date: Sat, 14 Jul 2007 19:33:41 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: xfs_fsr speed?
Message-ID: <Pine.LNX.4.64.0707141923530.20845@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Is there some sort of cap on the speed during the defragmentation process 
of xfs_fsr?

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
  3  0    128  48344     12 6954488    0    0 131072 129620 4536 8160  0 13 68 18
  0  1    128  48152     12 6954744    0    0 131072 116080 4687 8561  0 13 68 19
  2  0    128  47744     12 6955112    0    0 131072 145816 5308 8192  0 15 68 17
  1  0    128  47444     12 6955368    0    0 131072 116264 4761 7095  0 13 68 19
  0  1    128  47176     12 6955624    0    0 131072 147420 4855 8174  0 15 68 17
  2  1    128  46996     12 6955880    0    0 131072 131040 4425 9094  0 14 68 18
  0  1    128  48680     12 6954232    0    0 131072 131040 4399 7874  0 13 69 18
  1  0    128  48224     12 6954488    0    0 131072 114660 4558 5614  0 13 68 19
  1  1    128  48072     12 6954744    0    0 131072 147420 4872 9617  0 15 67 18
  0  1    128  47648     12 6955080    0    0 131072 114660 4348 7113  0 13 68 19
  0  1    128  47516     12 6955368    0    0 131072 131040 4586 8688  0 14 68 18
  1  0    128  47208     12 6955624    0    0 131072 131040 4524 6861  0 14 68 18
  1  0    128  47072     12 6955880    0    0 131072 145764 4631 10596 0 14 68 18
  1  1    128  46652     12 6956136    0    0 131072 116316 4293 5592  0 14 69 19
  1  0    128  48272     12 6954568    0    0 131072 131040 4772 8290  0 14 68 18

Justin.
