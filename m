Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (unknown [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 913CD7F3F
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 17:13:05 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C568BAC006
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 15:12:54 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id XgjL4yJcARoFyOGT for <xfs@oss.sgi.com>;
	Mon, 12 Jan 2015 15:12:39 -0800 (PST)
Message-ID: <54B454E2.70707@sandeen.net>
Date: Mon, 12 Jan 2015 17:12:34 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfs: mark the xfs-alloc workqueue as high priority
References: <54B01927.2010506@redhat.com> <54B019F4.8030009@sandeen.net>
	<20150109182310.GA2785@htj.dyndns.org>
	<54B03BCC.7040207@sandeen.net>
	<20150110192852.GD25319@htj.dyndns.org>
	<54B429EB.9050807@sandeen.net>
	<20150112225314.GC22156@htj.dyndns.org>
In-Reply-To: <20150112225314.GC22156@htj.dyndns.org>
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
To: Tejun Heo <tj@kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 1/12/15 4:53 PM, Tejun Heo wrote:
> Hello, Eric.

Hi Tejun :)

> This doesn't look like the direct cause.  It could just be reclaim
> path going berserk as the filesystem can't writeout pages.  Can you
> dump all runnable tasks?  Was this the only runnable kworker?
> 
> Thanks.

The only tasks in RU state are the one I mentioned, and swapper/X.

crash> ps -m | grep RU
[0 00:00:00.159] [RU]  PID: 17056  TASK: c000000111cc0000  CPU: 8   COMMAND: "kworker/u112:1"
[4 19:11:44.360] [RU]  PID: 0      TASK: c0000000010416f0  CPU: 0   COMMAND: "swapper/0"
[4 19:11:44.192] [RU]  PID: 0      TASK: c000000633280000  CPU: 1   COMMAND: "swapper/1"
[4 19:11:44.192] [RU]  PID: 0      TASK: c0000006332c0000  CPU: 2   COMMAND: "swapper/2"
...

and I don't see anything interesting in those. :)

-Eric


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
