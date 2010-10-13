Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9DM8Df2147747 for <xfs@oss.sgi.com>; Wed, 13 Oct 2010 17:08:13 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 58838EC978
	for <xfs@oss.sgi.com>; Wed, 13 Oct 2010 15:09:21 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Hr3hn2nesnaU1B4O for
	<xfs@oss.sgi.com>; Wed, 13 Oct 2010 15:09:21 -0700 (PDT)
Message-ID: <4CB62DBC.9060808@sandeen.net>
Date: Wed, 13 Oct 2010 17:07:56 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: kernel crash 2.6.31.14-0.1-xen from openSUSE 11.2
References: <201010092355.17240@zmi.at> <20101010015628.GL4681@dastard>
In-Reply-To: <20101010015628.GL4681@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

On 10/09/2010 08:56 PM, Dave Chinner wrote:
> On Sat, Oct 09, 2010 at 11:55:16PM +0200, Michael Monnerie wrote:
>> I just had a bug in one VM, and don't know if this is XFS related, but it seems so.
>>
>> [1172140.926859] BUG: unable to handle kernel paging request at 00000003d03dd178
>> [1172140.926877] IP: [<ffffffff80034872>] dequeue_task+0x72/0x110
>> [1172140.926897] PGD 1b54b067 PUD 0 
>> [1172140.926897] Thread overran stack, or stack corrupted
>                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Awesome, that's the 2nd time in like 4 years I've seen that stack canary
I put in actually be useful ;)

-Eric

> The stack trace shows pdflush doing writeback, and way down the
> stack doing a memory allocation that triggered direct reclaim, which
> caused writeback to occur, which blew the stack.....
> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
