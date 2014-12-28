Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D6CD17F47
	for <xfs@oss.sgi.com>; Sun, 28 Dec 2014 05:51:35 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 82FBAAC04C
	for <xfs@oss.sgi.com>; Sun, 28 Dec 2014 03:51:32 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	LHJmozd1X0vWozs2 for <xfs@oss.sgi.com>;
	Sun, 28 Dec 2014 03:51:30 -0800 (PST)
Date: Sun, 28 Dec 2014 22:51:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS crashing system with general protection fault
Message-ID: <20141228115127.GN24183@dastard>
References: <20141224111403.54d7226b@neptune.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141224111403.54d7226b@neptune.home>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: xfs@oss.sgi.com

On Wed, Dec 24, 2014 at 11:14:03AM +0100, Bruno Pr=E9mont wrote:
> Hi,
> =

> On a server I've got the following traces, the first on Monday, the second
> one today. On Monday kernel was 3.14.17 and 3.14.27 for today (both captu=
red
> via netconsole).
> =

> Is that fixed in a newer kernel?
> =

> I've xfs_repaired one of the two XFS partitions on the server though it
> found nothing to complain about. The other partition, containing /, has
> not been explicitly checked yet.
> =

> If there is some information I should gather before xfs_repairing, please
> tell as soon as possible!
> =

> =

> Thanks,
> Bruno
> =

> [6149136.014757] general protection fault: 0000 [#1] SMP =

> [6149136.022825] Modules linked in: netconsole configfs
> [6149136.028996] CPU: 4 PID: 151 Comm: kworker/4:1H Not tainted 3.14.18-x=
86_64 #1
> [6149136.040750] Hardware name: HP ProLiant DL360 G6, BIOS P64 07/02/2013
> [6149136.048936] Workqueue: xfslogd xfs_buf_iodone_work
> [6149136.056836] task: ffff880212c67500 ti: ffff8800def3c000 task.ti: fff=
f8800def3c000
> [6149136.067023] RIP: 0010:[<ffffffff81255b67>]  [<ffffffff81255b67>] xfs=
_trans_ail_delete_bulk+0x87/0x1a0
> [6149136.080940] RSP: 0018:ffff8800def3dce8  EFLAGS: 00010202
> [6149136.088889] RAX: dead000000100100 RBX: ffff88000211bd10 RCX: ffff880=
10e23fbb1
> [6149136.098962] RDX: 6b6b6b6b6b6b6b6b RSI: 6b6b6b6b6b6b6b6b RDI: ffff880=
00211bd10
> [6149136.110787] RBP: ffff8800def3dd38 R08: 6b6b6b6b6b6b6b6b R09: 2900000=
000000000

You have memory poisoning turned on?

#define POISON_FREE      0x6b    /* for use-after-free poisoning */

Did this occur at unmount? Can you reproduce it on a 3.18 kernel?

Cheers,

Dave.

-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
