Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8A4usBx132307 for <xfs@oss.sgi.com>; Thu, 9 Sep 2010 23:56:54 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E03D1D8F60D
	for <xfs@oss.sgi.com>; Thu,  9 Sep 2010 22:09:00 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 1d8I5IyYQsEB1hD8
	for <xfs@oss.sgi.com>; Thu, 09 Sep 2010 22:09:00 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id EAB426C011
	for <xfs@oss.sgi.com>; Thu,  9 Sep 2010 23:57:36 -0500 (CDT)
Message-ID: <4C89BAC0.4000607@hardwarefreak.com>
Date: Thu, 09 Sep 2010 23:57:36 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: fragmentation question
References: <C8AEA6E3.6E2E%bchang@greenplum.com>
	<4C89A4AE.2070904@hardwarefreak.com>
In-Reply-To: <4C89A4AE.2070904@hardwarefreak.com>
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
To: xfs@oss.sgi.com

Stan Hoeppner put forth on 9/9/2010 10:23 PM:
> Brady Chang put forth on 9/9/2010 4:59 PM:
>> thanks guys for the feedback.
>> iostat shows balanced io between two filesystems.
> 
> Can we please see the "iostat -x" output for the duration of the TPC-H
> run _only_?

What db engine are you using?  Oracle, DB2, MySQL, or PostgreSQL?

Exactly how are you instructing it to split files between /data1 and /data2?

Are you instructing your db engine to split your transaction logs and db
files equally across both filesystems?

On which filesystem are you locating your database engine scratch space
if any?

Can you run xfs_bmap on the files on each filesystem to determine which
are the most fragmented?  Doing this may/should produce the smoking gun.

At this point, I'm guessing you have transaction logs and db scratch
space allocated to /data2 which is causing the heavy fragmentation.

It would be instructive if you dropped /data2 out of the picture
entirely and ran the TPC-H benchy using only /data1.  I'm sure you'll
see the fragmentation on /data1 in this case.

It seems clear your fragmentation issue is a database management issue,
not an XFS issue.  Your answers to my questions should tell us which.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
