Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 May 2007 11:05:52 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4TI5jWt021267
	for <xfs@oss.sgi.com>; Tue, 29 May 2007 11:05:48 -0700
Date: Tue, 29 May 2007 14:05:44 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: xfs_fsr 2.2.38 bug/kernel 2.6.21.3 cannot defrag volume
Message-ID: <Pine.LNX.4.64.0705291404430.2944@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: apiszcz@solarrain.com

# uname -a
Linux boxname 2.6.21.3 #2 SMP Sun May 27 11:34:21 EDT 2007 i686 GNU/Linux
# xfs_fsr -V
xfs_fsr version 2.2.38
# xfs_db -V
xfs_db version 2.8.18
# xfs_db -c frag -f /dev/md1
actual 449, ideal 403, fragmentation factor 10.24%
# xfs_fsr /dev/md1
/d2 start inode=0
# xfs_db -c frag -f /dev/md1
actual 449, ideal 403, fragmentation factor 10.24%
#
