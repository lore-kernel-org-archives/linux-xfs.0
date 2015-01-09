Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9EAB37F3F
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 12:23:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2C8E6AC006
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2015 10:23:16 -0800 (PST)
Received: from mail-qa0-f46.google.com (mail-qa0-f46.google.com
	[209.85.216.46]) by cuda.sgi.com with ESMTP id 6BRY366FzWkpSu7D
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 09 Jan 2015 10:23:14 -0800 (PST)
Received: by mail-qa0-f46.google.com with SMTP id j7so428376qaq.5
	for <xfs@oss.sgi.com>; Fri, 09 Jan 2015 10:23:14 -0800 (PST)
Date: Fri, 9 Jan 2015 13:23:10 -0500
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] xfs: mark the xfs-alloc workqueue as high priority
Message-ID: <20150109182310.GA2785@htj.dyndns.org>
References: <54B01927.2010506@redhat.com>
 <54B019F4.8030009@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54B019F4.8030009@sandeen.net>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Hello, Eric.

On Fri, Jan 09, 2015 at 12:12:04PM -0600, Eric Sandeen wrote:
> I had a case reported where a system under high stress
> got deadlocked.  A btree split was handed off to the xfs
> allocation workqueue, and it is holding the xfs_ilock
> exclusively.  However, other xfs_end_io workers are
> not running, because they are waiting for that lock.
> As a result, the xfs allocation workqueue never gets
> run, and everything grinds to a halt.

I'm having a difficult time following the exact deadlock.  Can you
please elaborate in more detail?

> To be honest, it's not clear to me how the workqueue
> subsystem manages this sort of thing.  But in testing,
> making the allocation workqueue high priority so that
> it gets added to the front of the pending work list,
> resolves the problem.  We did similar things for
> the xfs-log workqueues, for similar reasons.

Ummm, this feel pretty voodoo.  In practice, it'd change the order of
things being executed and may make certain deadlocks unlikely enough,
but I don't think this can be a proper fix.

> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index e5bdca9..9c549e1 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -874,7 +874,7 @@ xfs_init_mount_workqueues(
>  		goto out_destroy_log;
>  
>  	mp->m_alloc_workqueue = alloc_workqueue("xfs-alloc/%s",
> -			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
> +		       WQ_MEM_RECLAIM|WQ_FREEZABLE|WQ_HIGHPRI, 0, mp->m_fsname);

And this at least deserves way more explanation.

>  	if (!mp->m_alloc_workqueue)
>  		goto out_destroy_eofblocks;
>  
> 

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
