Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6BDC07F37
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 17:06:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3CBE78F8039
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 15:06:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jgwyWqsY0BDos9wp for
	<xfs@oss.sgi.com>; Mon, 14 Apr 2014 15:06:40 -0700 (PDT)
Date: Mon, 14 Apr 2014 18:06:16 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs readdir hang on for-next (3.15.0-rc1)
Message-ID: <20140414220616.GA57010@bfoster.bfoster>
References: <20140414164313.GA62307@bfoster.bfoster>
	<20140414190834.GB62307@bfoster.bfoster>
	<20140414205737.GI26782@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140414205737.GI26782@laptop.programming.kicks-ass.net>
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
To: Peter Zijlstra <peterz@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Apr 14, 2014 at 10:57:37PM +0200, Peter Zijlstra wrote:
> On Mon, Apr 14, 2014 at 03:08:36PM -0400, Brian Foster wrote:
> > On Mon, Apr 14, 2014 at 12:43:14PM -0400, Brian Foster wrote:
> > > Hi all,
> > > 
> > > This is a heads up that I'm seeing a blatant readdir hang on the current
> > > for-next with selinux enabled. To reproduce, I format a clean fs, mount
> > > and attempt an ls.
> > > 
> > > The problem does not occur with selinux disabled, if I back out the
> > > following commit:
> > > 
> > > 40194ecc6d78 xfs: reinstate the ilock in xfs_readdir
> > > 
> > > ... or if I remove the locking around xfs_attr_get(), so I suspect this
> > > is another instance of a recursive deadlock. I'm getting no output
> > > whatsoever in order to confirm this and it also leads to a complete
> > > system lockup. It's also interesting that this hasn't been observed
> > > until now, given the above commit was introduced in 3.14. So the above
> > > commit doesn't appear to be the most recent change that triggers this.
> > > 
> > > I reproduced on the latest linus tree and do not reproduce on 3.14, so
> > > I'm trying to do a bisect to find out what else might have changed to
> > > trigger this.
> > > 
> > 
> > This bisected down to:
> > 
> > commit 6f008e72cd111a119b5d8de8c5438d892aae99eb
> > Author: Peter Zijlstra <peterz@infradead.org>
> > Date:   Wed Mar 12 13:24:42 2014 +0100
> > 
> >     locking/mutex: Fix debug checks
> > ...
> > 
> > ... which suggests something down in the mutex debug code. Indeed, the
> > problem no longer occurs if I disable kernel debug in my .config. What
> > is also interesting is that it didn't return when I reenable
> > DEBUG_KERNEL and DEBUG_MUTEXES alone. It does return when I start to
> > enable some of the other lock debugging options. FWIW, I also cleared
> > out my tree and rebuilt from scratch just to be sure that I didn't have
> > anything stale/broken lying around.
> > 
> > Peter,
> > 
> > Any insight on this? 
> 
> http://lkml.kernel.org/r/tip-a227960fe0cafcc229a8d6bb8b454a3a0b33719d@git.kernel.org
> 
> That will make the kernel continue after the lockdep splat. I too see it
> on some of my XFS using machines.
> 
> 

That fixes the problem for me. Thanks!

Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
