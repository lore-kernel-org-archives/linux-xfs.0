Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1F1847F50
	for <xfs@oss.sgi.com>; Sun,  3 Feb 2013 10:42:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AC602AC001
	for <xfs@oss.sgi.com>; Sun,  3 Feb 2013 08:42:26 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id pi2Cp26c1F2UoPi5
	for <xfs@oss.sgi.com>; Sun, 03 Feb 2013 08:42:25 -0800 (PST)
Message-ID: <510E9372.60808@hardwarefreak.com>
Date: Sun, 03 Feb 2013 10:42:26 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs deadlock on buffer semaphore while reading directory
References: <20130202192007.GS30577@one.firstfloor.org>
	<510D6EDE.1080409@sgi.com> <510E054B.2070500@tlinx.org>
In-Reply-To: <510E054B.2070500@tlinx.org>
Reply-To: stan@hardwarefreak.com
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs@oss.sgi.com

On 2/3/2013 12:35 AM, Linda Walsh wrote:

> Odd thing about my current probs -- my current system has been
> up 12 days...but before that it had been up 43 days...

Linux greer 3.2.6 #1 SMP Mon Feb 20 17:05:10 CST 2012 i686 GNU/Linux
 10:13:13 up 339 days, 22:42,  1 user,  load average: 0.06, 0.06, 0.05

This is a hand rolled 'minimalist' kernel with the old SLAB allocator,
no modules, Debian 6 atop.  Just over 11 months of flawless operation,
though load is probably much lighter than on your system.

> I can't get the buffers to 'free' no matter what
> echo 3> /proc/sys/vm/drop_caches does nothing.

That's interesting.

> so I may be rebooting soon...

Did you roll this 3.7.1 yourself?  I'm wondering if you did something
wonky in your config that's causing or contributing to your problems.

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
