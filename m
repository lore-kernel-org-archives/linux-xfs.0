Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0FLiCge132999 for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 15:44:22 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A220F1C54C3F
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 13:44:36 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bUvFQ55x3RpqhwL9 for
	<xfs@oss.sgi.com>; Fri, 15 Jan 2010 13:44:36 -0800 (PST)
Message-ID: <4B50E14E.5050204@gmail.com>
Date: Fri, 15 Jan 2010 22:42:38 +0100
From: Edward Shishkin <edward.shishkin@gmail.com>
MIME-Version: 1.0
Subject: Re: [Jfs-discussion] benchmark results
References: <20091224212756.GM21594@thunk.org>
	<alpine.DEB.2.01.0912241739160.3483@bogon.housecafe.de>
	<20091225161453.GD32757@thunk.org>
	<20091225162238.GB19303@bitmover.com>
	<alpine.DEB.2.01.0912251042540.3483@bogon.housecafe.de>
	<4B36333B.3030600@hp.com> <4B365EBE.5050804@nerdbynature.de>
	<4B37BA76.7050403@hp.com>
	<alpine.DEB.2.01.0912271346240.3483@bogon.housecafe.de>
	<20091227223307.GA4429@thunk.org>
	<20091228140855.GD10982@bitmover.com>
In-Reply-To: <20091228140855.GD10982@bitmover.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Larry McVoy <lm@bitmover.com>, tytso@mit.edu, Christian Kujau <lists@nerdbynature.de>, jim owens <jowens@hp.com>, jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org, Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>, ext-users <ext3-users@redhat.com>, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org


> When things didn't match up that was a clue that either
>
>     - the benchmark was broken
>     - the code was broken
>   
[...]

I would carry out an object-oriented dualism here.


[1] methods (kernel module) ---- [2] objects (formatted partition)

 |                                |
 |                                |

[3] benchmarks ----------------- [4] user-space utilities (fsck)


User-space utilities investigate "object corruptions",
whereas benchmarks investigate "software corruptions"
(including bugs in source code, broken design, etc, etc..)

It is clear that "software" can be "corrupted" by a larger
number of ways than "objects". Indeed, it is known that
dual space V* (of all linear functions over V) is a much
more complex object than V.

So benchmark is a process which takes a set of methods
(we consider only "software" benchmarks) and puts numerical
values populated with a special (the worst) value CRASH.

Three main categories of benchmarks using:

1) Internal testing

An engineer makes optimizations in a file system (e.g. for a
customer) via choosing functions or plugins as winners in
a set of internal (local) "nominations".

2) Business plans

A system administrator chooses a "winner" in some (global)
"nomination" of file systems in accordance with internal
business-plans.

3) Flame and politics

Someone presents a "nomination" (usually with the "winner"
among restricted number of nominated members) to the public
while nobody asked him to do it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
