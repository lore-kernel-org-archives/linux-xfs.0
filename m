Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 55BBF7F37
	for <xfs@oss.sgi.com>; Tue,  7 Jul 2015 18:37:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E8340AC005
	for <xfs@oss.sgi.com>; Tue,  7 Jul 2015 16:37:46 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	xL4wFAT5JnBMp7lV for <xfs@oss.sgi.com>;
	Tue, 07 Jul 2015 16:37:44 -0700 (PDT)
Date: Wed, 8 Jul 2015 09:37:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Possible memory allocation deadlock in kmem_alloc and hung task
	in xfs_log_commit_cil and xlog_cil_push
Message-ID: <20150707233743.GZ7943@dastard>
References: <CA+eFSM30A1V7j4CYJOyLSN7V7REHt0hrxteU1dVRw4HQZLmuxw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+eFSM30A1V7j4CYJOyLSN7V7REHt0hrxteU1dVRw4HQZLmuxw@mail.gmail.com>
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
To: Gavin Guo <gavin.guo@canonical.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Tue, Jul 07, 2015 at 05:29:43PM +0800, Gavin Guo wrote:
> Hi all,
> 
> Recently, we observed that there is the error message in
> Ubuntu-3.13.0-48.80:
> 
> "XFS: possible memory allocation deadlock in kmem_alloc (mode:0x8250)"
> 
> repeatedly shows in the dmesg. Temporarily, our workaround is to tune the
> parameters, such as, vfs_cache_pressure, min_free_kbytes, and dirty_ratio.
> 
> And we also found that there are different error messages regarding the
> hung tasks which happened in xfs_log_commit_cil and xlog_cil_push.
> 
> The log is available at: http://paste.ubuntu.com/11835007/
> 
> The following link seems the same problem we suffered:
> 
> XFS hangs with XFS: possible memory allocation deadlock in kmem_alloc
> http://oss.sgi.com/archives/xfs/2015-03/msg00172.html
> 
> I read the mail and found that there might be some modification regarding
> to move the memory allocation outside the ctx lock. And I also read the
> latest patch from February of 2015 to see if there is any new change
> about that. Unfortunately, I didn't find anything regarding the change (may
> be I'm not familiar with the XFS, so didn't find the commit). If it's
> possible for someone who is familiar with the code to point out the commits
> related to the bug if already exist or any status about the plan.

No commits - the approach I thought we might be able to take to
avoid the problem didn't work out. I have another idea of how we
might solve the problem, but I haven't ad a chance to prototype it
yet.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
