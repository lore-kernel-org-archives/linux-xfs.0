Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 408BE7CB1
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2016 01:07:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9BFD8AC005
	for <xfs@oss.sgi.com>; Wed,  7 Sep 2016 23:07:03 -0700 (PDT)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com
	[74.125.82.68]) by cuda.sgi.com with ESMTP id GWwJEZXY2vMrYhUl
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 07 Sep 2016 23:07:00 -0700 (PDT)
Received: by mail-wm0-f68.google.com with SMTP id w12so6208414wmf.1
	for <xfs@oss.sgi.com>; Wed, 07 Sep 2016 23:07:00 -0700 (PDT)
Date: Thu, 8 Sep 2016 08:06:55 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH, RFC] xfs: remove i_iolock and use i_rwsem in the VFS
	inode instead
Message-ID: <20160908060655.GA17296@gmail.com>
References: <1470935423-12329-1-git-send-email-hch@lst.de>
	<20160811215444.GY30192@twins.programming.kicks-ass.net>
	<20160818173707.GA1240@lst.de>
	<20160819132736.GH10121@twins.programming.kicks-ass.net>
	<20160820063723.GA7013@lst.de>
	<20160822083455.GH10153@twins.programming.kicks-ass.net>
	<20160905151244.GA16726@lst.de>
	<20160907074312.GQ10153@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160907074312.GQ10153@twins.programming.kicks-ass.net>
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
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, Sep 05, 2016 at 05:12:44PM +0200, Christoph Hellwig wrote:
> > Peter, this is the fixed up patch.  Can you write a proper changelog
> > and add your signoff?
> 
> Yes, sorry for the delay.
> 
> Did you get the workqueue thing sorted, where you rely on another task
> holding the lock for you?
> 
> I simplified the implementation a little, since I noticed pushing the
> @read argument all the way down to match_held_lock() didn't really make
> all that much sense and caused a lot of churn.
> 
> I also added CONFIG_LOCKDEP=n stubs for the new lockdep_assert_held*()
> macros (which you don't use :-).
> 
> Feel free to push this through the XFS tree where you add its first use.

I can also create a separate one-commit tree for it which you can pull into the 
XFS tree. This way there won't be conflicts between the XFS tree and the locking 
tree.

Thanks,

	Ingo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
