Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q55FLb12096467 for <xfs@oss.sgi.com>; Tue, 5 Jun 2012 10:21:37 -0500
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id 7AQKaE9LGlIy4A5j (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 Jun 2012 08:21:35 -0700 (PDT)
Received: from telerig.nabble.com ([192.168.236.162])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>) id 1SbvZe-0007Gy-Ah
	for xfs@oss.sgi.com; Tue, 05 Jun 2012 08:21:34 -0700
Message-ID: <33964752.post@talk.nabble.com>
Date: Tue, 5 Jun 2012 08:21:34 -0700 (PDT)
From: Chris J Arges <chris.j.arges@canonical.com>
Subject: Re: Still seeing hangs in xlog_grant_log_space
In-Reply-To: <CAH4wwdGWHSZoveLJMxu5pjr22NEEeW7oG8TS+snoM8RY=ZeRmg@mail.gmail.com>
MIME-Version: 1.0
References: <CADLDEKsP4DsXf_G07ub+a-ODbrJbsiprRJUX1fJdaQ41TB7+Xg@mail.gmail.com>
	<CAH4wwdGWHSZoveLJMxu5pjr22NEEeW7oG8TS+snoM8RY=ZeRmg@mail.gmail.com>
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



Peter Watkins-3 wrote:
> 
> Does your kernel have the effect of
> 
> 0bf6a5bd4b55b466964ead6fa566d8f346a828ee xfs: convert the xfsaild
> thread to a workqueue
> 

This patch is present in the Ubuntu Precise 3.2 kernel, and I have been able
to reproduce the failure with this patch applied.


Peter Watkins-3 wrote:
> 
> c7eead1e118fb7e34ee8f5063c3c090c054c3820 xfs: revert to using a
> kthread for AIL pushing
> 

I see this patch is 0030807c66f058230bcb20d2573bcaf28852e804 upstream, and
this patch is also present in the 3.2 Precise kernel that was tested and
exhibited the failure.


Peter Watkins-3 wrote:
> 
> In particular, is this code in xfs_trans_ail_push:
> 
>        smp_wmb();
>        xfs_trans_ail_copy_lsn(ailp, &ailp->xa_target, &threshold_lsn);
>        smp_wmb();
> 

In fs/xfs/xfs_trans_ail.c:xfs_ail_push():

        /*
         * Ensure that the new target is noticed in push code before it
clears
         * the XFS_AIL_PUSHING_BIT.
         */
        smp_wmb();
        xfs_trans_ail_copy_lsn(ailp, &ailp->xa_target, &threshold_lsn);
        smp_wmb();


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs


-- 
View this message in context: http://old.nabble.com/Still-seeing-hangs-in-xlog_grant_log_space-tp33732886p33964752.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
