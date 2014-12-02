Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2ADAB7F56
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 16:05:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0A86E8F8033
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 14:05:40 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	kBMNbtxPtwGtP5py for <xfs@oss.sgi.com>;
	Tue, 02 Dec 2014 14:05:36 -0800 (PST)
Date: Wed, 3 Dec 2014 09:05:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix set-but-unused warnings
Message-ID: <20141202220503.GE18131@dastard>
References: <1417489741-11223-1-git-send-email-david@fromorbit.com>
	<20141202092310.GA25767@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141202092310.GA25767@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Dec 02, 2014 at 01:23:10AM -0800, Christoph Hellwig wrote:
> On Tue, Dec 02, 2014 at 02:09:01PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The kernel compile doesn't turn on these checks by default, so it's
> > only when I do a kernel-user sync that I find that there are lots of
> > compiler warnings waiting to be fixed. Fix up these set-but-unused
> > warnings.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Looks good.  Maybe we should enable those warnings for fs/xfs?

I now have a local patch (-Werror -Wunused-but-set-variable) that
catches these during my for-next integration testing workflow, so
I should catch them (and other errors) during review....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
