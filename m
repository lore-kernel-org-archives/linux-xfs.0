Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AB7567F37
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 19:25:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8E0CD304043
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 17:24:59 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	w23NCX1HrR8XEvM7 for <xfs@oss.sgi.com>;
	Thu, 25 Jul 2013 17:24:58 -0700 (PDT)
Date: Fri, 26 Jul 2013 10:24:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 14/49] xfs: introduce xfs_inode_buf.c for inode buffer
	operations
Message-ID: <20130726002450.GJ13468@dastard>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-15-git-send-email-david@fromorbit.com>
	<51F179BE.4040506@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51F179BE.4040506@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 25, 2013 at 02:17:18PM -0500, Mark Tinguely wrote:
> On 07/19/13 01:24, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >The only thing remaining in xfs_inode.[ch] are the operations that
> >read, write or verify physical inodes in their underlying buffers.
> >Move all this code to xfs_inode_buf.[ch] and so we can stop sharing
> >xfs_inode.[ch] with userspace.
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >---
> 
> Bug patches committed in the last couple days make this patch no
> longer current.

Right, which is why I've had to rebase it (yet again). The changes
are minor, though, and shouldn't prevent review of this version of
the patch.

I haven't reposted the new series yet, because I'm waiting on
reviews for the current series to be done and I don't want to have
to continually rebase and repost the series. There is a risk that
every time I do a rebase that I screw something up, so I want to
minimise the number of rebases I have to do.

This is yet another reason why I'd like to see this code reviewed
quickly and committed because I've already rebased it several times
and it's not fun. Repeated rebasing simply because review of slow is
a waste of everyone's time...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
