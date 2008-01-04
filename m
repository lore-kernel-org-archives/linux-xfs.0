Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 Jan 2008 14:04:25 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m04M4KZY011011
	for <xfs@oss.sgi.com>; Fri, 4 Jan 2008 14:04:20 -0800
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 25522BF95DC
	for <xfs@oss.sgi.com>; Fri,  4 Jan 2008 14:04:30 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id X47CJ8ui2OBOo4kT for <xfs@oss.sgi.com>; Fri, 04 Jan 2008 14:04:30 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by lucidpixels.com (Postfix) with ESMTP id D49891C000EF7
	for <xfs@oss.sgi.com>; Fri,  4 Jan 2008 17:04:29 -0500 (EST)
Received: from lucidpixels.com ([127.0.0.1])
	by localhost (p34.internal.lan [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id iL9EkKQm31JJ for <xfs@oss.sgi.com>;
	Fri,  4 Jan 2008 17:04:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
	by lucidpixels.com (Postfix) with ESMTP id 7CE79408F24E
	for <xfs@oss.sgi.com>; Fri,  4 Jan 2008 17:04:27 -0500 (EST)
Date: Fri, 4 Jan 2008 17:04:27 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: external log doubles performance?
Message-ID: <Pine.LNX.4.64.0801041704030.22541@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

from a linux-admin page/post:

Mon Jul  3 14:22:45 PDT 2006
10 clients started
.......................+......+.......+++++....+*********
Throughput 182.083 MB/sec (NB=227.604 MB/sec  1820.83 MBit/sec) 10 procs
Mon Jul  3 14:22:52 PDT 2006

When the logbufs and logbsize options are added, throughput increases from
92.7404 MB/sec to 96.4556 MB/sec. When the log is moved to an external
device the throughput nearly doubles to 182.083 MB/sec. Clearly, the
external log increases file system performance under dbench, a program 
that
has a large amount of metadata activity.

Tuning the I/O Scheduler

--

has anyone done any recent testing?
