Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1E18C7CA2
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 19:22:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E6AF4304053
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 17:22:21 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Gcafrkq9eMtKG128 for <xfs@oss.sgi.com>;
	Tue, 29 Mar 2016 17:22:19 -0700 (PDT)
Date: Wed, 30 Mar 2016 11:16:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: disallow rw remount on fs with unknown ro-compat
	features
Message-ID: <20160330001608.GG30721@dastard>
References: <56FAD75C.80502@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56FAD75C.80502@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Mar 29, 2016 at 02:28:28PM -0500, Eric Sandeen wrote:
> Today, a kernel which refuses to mount a filesystem read-write
> due to unknown ro-compat features can still transition to read-write
> via the remount path.  The old kernel is most likely none the wiser,
> because it's unaware of the new feature, and isn't using it.  However,
> writing to the filesystem may well corrupt metadata related to that
> new feature, and moving to a newer kernel which understand the feature
> will have problems.
> 
> Right now the only ro-compat feature we have is the free inode btree,
> which showed up in v3.16.  It would be good to push this back to
> all the active stable kernels, I think, so that if anyone is using
> newer mkfs (which enables the finobt feature) with older kernel
> releases, they'll be protected.

Ok, so the bug was introduced with the original extended feature
masks in commit e721f50 ("xfs: implement extended feature masks"),
which was introduced in 3.10. So it will need to go back to stable
kernels all the way back to 3.10, right?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
