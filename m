Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ECEAD7F37
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 22:50:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CD7638F8052
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 20:50:52 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	uCsY4n5C01J7601f for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 20:50:50 -0700 (PDT)
Date: Fri, 7 Jun 2013 13:50:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Adding Quotas - Skip Quota check on first mount/boot
Message-ID: <20130607035046.GJ29338@dastard>
References: <CAO9TOLffaO62ZtvchpKnnORuNd0GJMsqKDeAhmdSQ1mnFn1EpA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAO9TOLffaO62ZtvchpKnnORuNd0GJMsqKDeAhmdSQ1mnFn1EpA@mail.gmail.com>
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
To: Adam Brenner <aebrenne@uci.edu>
Cc: xfs@oss.sgi.com

On Thu, Jun 06, 2013 at 07:59:34PM -0700, Adam Brenner wrote:
> Howdy XFS Devs,
> 
> We run a 14TB XFS fileserver on our cluster and want to add quota
> support. This is running 3.9.2-1.el6.elrepo.x86_64 kernel under CentOS
> 6.3 (Final).

How many files in the filesystem?

> The issue is when we unmount the XFS RAID, and re-mount it adding
> quota support, the mount command hangs.

It won't have hung, it will just be busy doing a quotacheck.

> Sever IS responsive and the
> XFS mount point is not accessible. Reverting our changes in /etc/fstab
> to remove the quota options does not have mount hang.

Because it doesn't do a quotacheck.

> I suspect that upon re-mount, XFS is running a quota check on the 14TB
> RAID. My question is: how do I disable the initial quota check so it
> can mount it properly and have quota check run in the background?

You can't. quotacheck relies on exclusive access to the filesystem,
and so the mount cannot process until it completes. Quotas need to
be consistent before you can start using the filesystem....

Now, there's the possibility that we could parallelise quotacheck
because it uses bulkstat for iteration, but somebody would have to
find the time to do that and it won't solve your immediate problem.

Hence I suggest just waiting for it to complete - if you have
millions of inodes it could hours to complete, so just let it go
overnight...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
