Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Jun 2007 07:44:19 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5QEi9tL006163
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 07:44:12 -0700
Date: Tue, 26 Jun 2007 10:44:10 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Does anyone have a benchmark of chunk sizes with SW RAID5?
Message-ID: <Pine.LNX.4.64.0706261042490.3561@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: xfs@oss.sgi.com

I am running one with 64,128,256,512,1024,2048,4096,8192,16384,32768,65536 
it it accepts up that high..  With XFS and _ALL_ default mount and 
filesystem settings to target this specific tunable.

p34:~# /usr/bin/time ./benchraid.sh
Tue Jun 26 10:25:21 EDT 2007: Creating RAID5 array with 64 chunk size...
Tue Jun 26 10:25:21 EDT 2007: Increasing RAID rebuild speed...
Tue Jun 26 10:25:21 EDT 2007: RAID is still building...
Tue Jun 26 10:35:21 EDT 2007: RAID is still building...
