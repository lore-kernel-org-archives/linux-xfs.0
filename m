Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4O49nq3154225 for <xfs@oss.sgi.com>; Sun, 23 May 2010 23:09:49 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A59AE368510
	for <xfs@oss.sgi.com>; Sun, 23 May 2010 21:12:09 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id d3p1QZYYnBljvpXF
	for <xfs@oss.sgi.com>; Sun, 23 May 2010 21:12:09 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id BA7C66C2B0
	for <xfs@oss.sgi.com>; Sun, 23 May 2010 23:12:08 -0500 (CDT)
Message-ID: <4BF9FCA8.8090906@hardwarefreak.com>
Date: Sun, 23 May 2010 23:12:24 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: WARNING in xfs_lwr.c, xfs_write()
References: <20100523002023.41f5a5c8@aaa.pulp.binarylife.net>	<20100523101856.GL2150@dastard>
	<20100523092344.0fcaab42@aaa.pulp.binarylife.net>
In-Reply-To: <20100523092344.0fcaab42@aaa.pulp.binarylife.net>
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

Roman Kononov put forth on 5/23/2010 9:23 AM:
> On 2010-05-23, 20:18:56 +1000, Dave Chinner <david@fromorbit.com> wrote:
>> You've got some workload that is mixing direct IO writes with some
>> form of buffered or mmap IO on the same file and they are racing.
>> Mixing different types of IO on the one inode is also known as A
>> Really Bad Idea because there is no guarantee of coherency between
>> them....
>>
>> Can you find out what the application is triggering this?
> 
> This is severely modified Postgresql, which does mix direct IO with
> buffered one.

"The whole notion of "direct IO" is totally braindamaged. Just say no.

	This is your brain: O
	This is your brain on O_DIRECT: .

	Any questions?"


		Linus

From:  http://lkml.org/lkml/2007/1/10/235


-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
