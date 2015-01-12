Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (unknown [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6C4F27F3F
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 17:38:17 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 807D7AC006
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 15:38:01 -0800 (PST)
Received: from mail-qa0-f53.google.com (mail-qa0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id EXkO1dA57hDS3X3X
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 12 Jan 2015 15:37:58 -0800 (PST)
Received: by mail-qa0-f53.google.com with SMTP id n4so10027347qaq.12
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 15:37:57 -0800 (PST)
Date: Mon, 12 Jan 2015 18:37:55 -0500
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] xfs: mark the xfs-alloc workqueue as high priority
Message-ID: <20150112233755.GD22156@htj.dyndns.org>
References: <54B01927.2010506@redhat.com> <54B019F4.8030009@sandeen.net>
	<20150109182310.GA2785@htj.dyndns.org>
	<54B03BCC.7040207@sandeen.net>
	<20150110192852.GD25319@htj.dyndns.org>
	<54B429EB.9050807@sandeen.net>
	<20150112225314.GC22156@htj.dyndns.org>
	<54B454E2.70707@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54B454E2.70707@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Hello, Eric.

On Mon, Jan 12, 2015 at 05:12:34PM -0600, Eric Sandeen wrote:
> The only tasks in RU state are the one I mentioned, and swapper/X.
> 
> crash> ps -m | grep RU
> [0 00:00:00.159] [RU]  PID: 17056  TASK: c000000111cc0000  CPU: 8   COMMAND: "kworker/u112:1"
> [4 19:11:44.360] [RU]  PID: 0      TASK: c0000000010416f0  CPU: 0   COMMAND: "swapper/0"
> [4 19:11:44.192] [RU]  PID: 0      TASK: c000000633280000  CPU: 1   COMMAND: "swapper/1"
> [4 19:11:44.192] [RU]  PID: 0      TASK: c0000006332c0000  CPU: 2   COMMAND: "swapper/2"
> ...
> 
> and I don't see anything interesting in those. :)

Heh, I don't get it.  Can you please print out worker_pool->nr_running
of the pool that the hung work item is queued on?

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
