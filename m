Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7E2B77F58
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 18:18:50 -0500 (CDT)
Date: Mon, 21 Oct 2013 18:18:49 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: fix possible NULL dereference
Message-ID: <20131021231849.GL10553@sgi.com>
References: <1382380366-26540-1-git-send-email-geyslan@gmail.com>
	<5265956F.4010700@sandeen.net> <20131021224459.GE16161@dastard>
	<5265B4D2.3000907@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5265B4D2.3000907@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>
Cc: kernel-br@googlegroups.com, Alex Elder <elder@kernel.org>, open list <linux-kernel@vger.kernel.org>, "Geyslan G. Bem" <geyslan@gmail.com>, XFS FILESYSTEM <xfs@oss.sgi.com>

Hey,

On Mon, Oct 21, 2013 at 06:12:18PM -0500, Eric Sandeen wrote:
> On 10/21/13 5:44 PM, Dave Chinner wrote:
> > On Mon, Oct 21, 2013 at 03:58:23PM -0500, Eric Sandeen wrote:
> >> On 10/21/13 1:32 PM, Geyslan G. Bem wrote:
> >>> This patch puts a 'break' in the true branch, avoiding the 'icptr->ic_next'
> >>> dereferencing.
> >>
> >> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> > 
> > Actually, NACK.
> 
> I felt that one coming ;)
> 
> >> Hm, yeah - cmn_err(CE_PANIC, " " ); used to BUG_ON, but the newer
> >> xfs_emerg() doesn't.
> >>
> >> Dave, was that intentional?
> > 
> > Of course it was. ;) xfs_emerg() is only called from the debug code
> > in xlog_verify_iclog(), xlog_verify_tail_lsn and assfail().
> > 
> > In the case of assfail(), it has it's own BUG() call, so it does
> > everything just fine.
> > 
> > In the case of xlog_verify_iclog() when icptr is NULL, it will
> > panic immediately after the message is printed, just like the old
> > code. i.e. this patch isn't fixing anything we need fixed. 
> 
> A BUG() is probably warranted, then.

I tend to agree with Eric on this point.  If we want to crash, I'd rather our
intent be very clear, rather than just see a null ptr deref.  ;)

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
