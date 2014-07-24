Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 52A487F58
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 18:35:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3C3B58F8040
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 16:35:37 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	6UWYkNgtflXzBSEO for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 16:35:35 -0700 (PDT)
Date: Fri, 25 Jul 2014 09:34:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 18/18] xfs: enable sparse inode chunks for v5 superblocks
Message-ID: <20140724233445.GX20518@dastard>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
	<1406211788-63206-19-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1406211788-63206-19-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 24, 2014 at 10:23:08AM -0400, Brian Foster wrote:
> Enable the use and processing of sparse inode chunks.  Fix the
> xfs_sb_version_hassparseinodes() helper to allow the allocation of
> sparse chunks on v5 format superblocks. Add the incompat. feature bit to
> the *_ALL mask such that fs' with sparse chunks can be mounted.

Interesting way of allowing XFS_SB_FEAT_INCOMPAT_SPINODES to be
optional. :)

I didn't expect it to be used this way, hence my earlier comments
about chicken and egg feature bits. I still think I'd like this to
be explicit rather than just added when the format first changes...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
