Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 030027F4C
	for <xfs@oss.sgi.com>; Sun, 27 Jan 2013 20:38:26 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E5A508F8039
	for <xfs@oss.sgi.com>; Sun, 27 Jan 2013 18:38:22 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ef4ASvDbrPKM5vFy for <xfs@oss.sgi.com>;
	Sun, 27 Jan 2013 18:38:21 -0800 (PST)
Date: Mon, 28 Jan 2013 11:35:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/8] libxfs: initialize xfs_alloc_arg structures
Message-ID: <20130128003542.GB16727@disturbed.disaster>
References: <1359240032-11576-1-git-send-email-sandeen@redhat.com>
	<1359240032-11576-3-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1359240032-11576-3-git-send-email-sandeen@redhat.com>
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
Cc: xfs@oss.sgi.com

On Sat, Jan 26, 2013 at 04:40:26PM -0600, Eric Sandeen wrote:
> This is a merge-to-userspace of kernel commit a0041684
> xfs: zero allocation_args on the kernel stack
> 
> When calling xfs_alloc_vextent args.userdata was uninitialized,
> and if we had args.type==XFS_ALLOCTYPE_START_BNO, this uninit
> structure member got tested, leading to some random allocator
> behavior.

Got that as part of the kernel-user sync I sent out a couple of
weeks back.

BTW, perhaps we want to get that sync sorted out before shovelling
a bunch of stuff into xfsprogs that will require fixing conflicts in
that sync up?

Chers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
