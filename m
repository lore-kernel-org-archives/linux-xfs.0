Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9685E7F5D
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 18:12:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 84E1F304071
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 16:12:21 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 48T2LgL5lJHIZ4SV for <xfs@oss.sgi.com>;
	Mon, 21 Oct 2013 16:12:20 -0700 (PDT)
Message-ID: <5265B4D2.3000907@sandeen.net>
Date: Mon, 21 Oct 2013 18:12:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix possible NULL dereference
References: <1382380366-26540-1-git-send-email-geyslan@gmail.com>
	<5265956F.4010700@sandeen.net> <20131021224459.GE16161@dastard>
In-Reply-To: <20131021224459.GE16161@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Alex Elder <elder@kernel.org>, open list <linux-kernel@vger.kernel.org>, XFS FILESYSTEM <xfs@oss.sgi.com>, Ben Myers <bpm@sgi.com>, "Geyslan G. Bem" <geyslan@gmail.com>, kernel-br@googlegroups.com

On 10/21/13 5:44 PM, Dave Chinner wrote:
> On Mon, Oct 21, 2013 at 03:58:23PM -0500, Eric Sandeen wrote:
>> On 10/21/13 1:32 PM, Geyslan G. Bem wrote:
>>> This patch puts a 'break' in the true branch, avoiding the 'icptr->ic_next'
>>> dereferencing.
>>
>> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> Actually, NACK.

I felt that one coming ;)

>> Hm, yeah - cmn_err(CE_PANIC, " " ); used to BUG_ON, but the newer
>> xfs_emerg() doesn't.
>>
>> Dave, was that intentional?
> 
> Of course it was. ;) xfs_emerg() is only called from the debug code
> in xlog_verify_iclog(), xlog_verify_tail_lsn and assfail().
> 
> In the case of assfail(), it has it's own BUG() call, so it does
> everything just fine.
> 
> In the case of xlog_verify_iclog() when icptr is NULL, it will
> panic immediately after the message is printed, just like the old
> code. i.e. this patch isn't fixing anything we need fixed. 

A BUG() is probably warranted, then.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
