Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4C12D7F51
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 17:45:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 177828F8039
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 15:45:03 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	9QwACxqP16mIyNKl for <xfs@oss.sgi.com>;
	Mon, 21 Oct 2013 15:45:01 -0700 (PDT)
Date: Tue, 22 Oct 2013 09:44:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix possible NULL dereference
Message-ID: <20131021224459.GE16161@dastard>
References: <1382380366-26540-1-git-send-email-geyslan@gmail.com>
	<5265956F.4010700@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5265956F.4010700@sandeen.net>
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
Cc: Alex Elder <elder@kernel.org>, open list <linux-kernel@vger.kernel.org>, XFS FILESYSTEM <xfs@oss.sgi.com>, Ben Myers <bpm@sgi.com>, "Geyslan G. Bem" <geyslan@gmail.com>, kernel-br@googlegroups.com

On Mon, Oct 21, 2013 at 03:58:23PM -0500, Eric Sandeen wrote:
> On 10/21/13 1:32 PM, Geyslan G. Bem wrote:
> > This patch puts a 'break' in the true branch, avoiding the 'icptr->ic_next'
> > dereferencing.
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Actually, NACK.

> Hm, yeah - cmn_err(CE_PANIC, " " ); used to BUG_ON, but the newer
> xfs_emerg() doesn't.
> 
> Dave, was that intentional?

Of course it was. ;) xfs_emerg() is only called from the debug code
in xlog_verify_iclog(), xlog_verify_tail_lsn and assfail().

In the case of assfail(), it has it's own BUG() call, so it does
everything just fine.

In the case of xlog_verify_iclog() when icptr is NULL, it will
panic immediately after the message is printed, just like the old
code. i.e. this patch isn't fixing anything we need fixed. 

> I wonder if there are more spots after xfs_emerg()'s which aren't
> defensive, because the code used to just panic there.

As for the rest of the calls in xlog_verify_iclog, they are checking
things that aren't immediately fatal, but indication that iclog
corruption has already occurred. It's debug code, so we could add
"panic immediately" code, but personally I'd prefer to see the error
message being printed and then have it continue like a production
system would so that we can see the types of crashes normal kernels
will see as a result of iclog memory corruption....

As for xlog_verify_tail_lsn(), that's an important informational
message indicating we might be leaking log space. It's not
immediately fatal, but if we see it and then have a log space
hang...

So, really, none of the callers really need xfs_emerg to panic like
CE_PANIC used to. The one case where it might be useful (i.e this
patch) we panic immediately anyway....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
