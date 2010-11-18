Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAI5Z8Fi126885 for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 23:35:08 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72E7D18C8A8
	for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 21:36:41 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	VhKA7qqpuQWOVV1M for <xfs@oss.sgi.com>;
	Wed, 17 Nov 2010 21:36:41 -0800 (PST)
Date: Thu, 18 Nov 2010 16:36:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests 246: Test for race between direct I/O and mmap
Message-ID: <20101118053623.GU13830@dastard>
References: <4CDDC193.9030208@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CDDC193.9030208@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Lachlan McIlroy <lmcilroy@redhat.com>, xfs mailing list <xfs@oss.sgi.com>

On Fri, Nov 12, 2010 at 04:37:07PM -0600, Eric Sandeen wrote:
> 
> 
> From: Lachlan McIlroy <lmcilory@redhat.com>
> 
> A customer reported a problem:
> 
> If a process is using mmap to write to a file on an 
> ext4 filesystem while another process is using direct 
> I/O to write to the same file the first thread may 
> receive a SIGBUS during a page fault.
> 
> A SIGBUS occurs if the page fault tries to access a 
> page that is entirely beyond the end of the file but 
> in this test case that should not be happening.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

looks fine to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
