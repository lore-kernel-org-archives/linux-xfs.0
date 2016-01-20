Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 70FDF7F37
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2016 18:47:20 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4E34B304059
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2016 16:47:17 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	xQCW9ooHn6ZBW51P for <xfs@oss.sgi.com>;
	Tue, 19 Jan 2016 16:47:11 -0800 (PST)
Date: Wed, 20 Jan 2016 11:46:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] Move from __uint*_t types to uint*_t and likewise
	for __int*_t
Message-ID: <20160120004639.GT6033@dastard>
References: <cover.1452627740.git.felix.janda@posteo.de>
	<20160112195935.GB568@nyan> <20160112212405.GL10456@dastard>
	<20160113074859.GB21939@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160113074859.GB21939@infradead.org>
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
Cc: Felix Janda <felix.janda@posteo.de>, xfs@oss.sgi.com

On Tue, Jan 12, 2016 at 11:48:59PM -0800, Christoph Hellwig wrote:
> On Wed, Jan 13, 2016 at 08:24:06AM +1100, Dave Chinner wrote:
> > I can't apply this straight off. Most of the libxfs code that is
> > changed is shared with the kernel code, and so the definitions of
> > the variables need to be the same as the kernel code. There are
> > reasons for the kernel code using __[u]int*_t type variants (e.g.  I
> > think the endian conversion static checker requires the __ variants
> > for host order variables), and so before making sweeping changes
> > like this we need to ensure that we can make the equivalent changes
> > to the kernel code as well...
> 
> There is no functional requirement for these types.  I'm not sure if
> they are an IRIXism, or something that was added during the early
> Linux port, but they certainly aren't nessecary.
> 
> I'd love to kill them in favour or either the kernel __u/s types or the
> C99 types which are like the urrent ones just without the __ prefix.
> 
> Maybe we should get an agreement which ones we want and ask Felix for
> a patch to the kernel tree?

Either way is fine by me, but it's not a small patch - there's ~600
variables declared in fs/xfs with the __[u]int*_t types.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
