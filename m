Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n39EMSnk249030 for <xfs@oss.sgi.com>; Thu, 9 Apr 2009 09:22:38 -0500
Received: from mail-fx0-f177.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 62EB11CAB14B
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2009 07:21:48 -0700 (PDT)
Received: from mail-fx0-f177.google.com (mail-fx0-f177.google.com
	[209.85.220.177]) by cuda.sgi.com with ESMTP id
	tIqhOLCw3rQ37Lcd for <xfs@oss.sgi.com>;
	Thu, 09 Apr 2009 07:21:48 -0700 (PDT)
Received: by fxm25 with SMTP id 25so635314fxm.20
	for <xfs@oss.sgi.com>; Thu, 09 Apr 2009 07:21:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19f34abd0904090707v7eb8b677gbda42595aa04a090@mail.gmail.com>
References: <200903301936.08477.cova@ferrara.linux.it>
	<19f34abd0904090707v7eb8b677gbda42595aa04a090@mail.gmail.com>
Date: Thu, 9 Apr 2009 16:21:47 +0200
Message-ID: <19f34abd0904090721i1e2976dbka7780cb09319c531@mail.gmail.com>
Subject: Re: [BUG] spinlock lockup on CPU#0
From: Vegard Nossum <vegard.nossum@gmail.com>
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
To: Fabio Coatti <cova@ferrara.linux.it>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

2009/4/9 Vegard Nossum <vegard.nossum@gmail.com>:
> 2009/3/30 Fabio Coatti <cova@ferrara.linux.it>:
>> Hi all, I've got the following BUG: report on one of our servers running
>> 2.6.28.8; some background:
>> we are seeing several lockups in db (mysql) servers that shows up as a sudden
>> load increase and then, very quickly, the server freezes. It happens in a
>> random way, sometimes after weeks, sometimes very quickly after a system
>> reboot. Trying to discover the problem we installed latest (at the time of
>> test) 2.6.28.X kernel and loaded it with some high disk I/O operations (find,
>> dd, rsync and so on).

[...]

>> Could someone give us some hints about this issue, or at least some
>> suggestions on how to dig it? Of course we can do any sort of testing and
>> tries.
>
> You _could_ also try something like the attached patch. It's
> completely untested, and could lead to data loss (depending on whether
> the callers of this function expects/handles the error condition
> gracefully). I really have no idea. If you try, be sure to back up
> your data first. Good luck :-)

Actually, I think you can forget about this patch. At least that's not
the point of problem in the stack-trace you posted. (My suggestion of
trying a different filesystem still holds, though.)

:-/


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
