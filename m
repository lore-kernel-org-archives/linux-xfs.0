Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBN3u1x5087032 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 21:56:01 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 32D0CAC009
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 19:57:57 -0800 (PST)
Subject: [PATCH 0/5] percpu_counter: modifications to
	__percpu_counter_add_unless_lt()
From: Alex Elder <aelder@sgi.com>
Date: Wed, 22 Dec 2010 21:56:07 -0600
Message-ID: <1293076567.2408.424.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

This series is based on (i.e., applies on top of)
the third patch in Dave Chinner's scalability series
(lib: percpu counter add unless less than functionality).
I had some questions while reviewing that patch, and
after closer inspection I think I found what I think
are some problems, and in order to work through them
I came up with this patch series to lay out what I
think the problems are and my attempt at addressing
them.

The series has been rearranged a bit since I put it
together.  Patch 3 includes some background and
terminology that might be more useful at the
beginning, but I'm leaving it as-is for now.

The more I look at the end result of the series the
more confident I am that it's correct.  However I
still need some convincing--either to point out
where I've got something wrong, or to affirm that
what I have is right.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
