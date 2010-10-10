Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9A1tR8d199368 for <xfs@oss.sgi.com>; Sat, 9 Oct 2010 20:55:29 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C5B1318E95BB
	for <xfs@oss.sgi.com>; Sat,  9 Oct 2010 18:56:32 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	OPsJa5NW2NNZr7qt for <xfs@oss.sgi.com>;
	Sat, 09 Oct 2010 18:56:32 -0700 (PDT)
Date: Sun, 10 Oct 2010 12:56:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: kernel crash 2.6.31.14-0.1-xen from openSUSE 11.2
Message-ID: <20101010015628.GL4681@dastard>
References: <201010092355.17240@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201010092355.17240@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Sat, Oct 09, 2010 at 11:55:16PM +0200, Michael Monnerie wrote:
> I just had a bug in one VM, and don't know if this is XFS related, but it seems so.
> 
> [1172140.926859] BUG: unable to handle kernel paging request at 00000003d03dd178
> [1172140.926877] IP: [<ffffffff80034872>] dequeue_task+0x72/0x110
> [1172140.926897] PGD 1b54b067 PUD 0 
> [1172140.926897] Thread overran stack, or stack corrupted
                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The stack trace shows pdflush doing writeback, and way down the
stack doing a memory allocation that triggered direct reclaim, which
caused writeback to occur, which blew the stack.....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
