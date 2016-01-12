Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4D6577F37
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 16:03:04 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DE638AC004
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 14:03:00 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	sYU08B1OBpdESfK2 for <xfs@oss.sgi.com>;
	Tue, 12 Jan 2016 14:02:57 -0800 (PST)
Date: Wed, 13 Jan 2016 09:02:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] Move from __uint*_t types to uint*_t and likewise
	for __int*_t
Message-ID: <20160112220240.GO10456@dastard>
References: <cover.1452627740.git.felix.janda@posteo.de>
	<20160112195935.GB568@nyan> <20160112212405.GL10456@dastard>
	<20160112214634.GC10558@nyan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160112214634.GC10558@nyan>
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
To: Felix Janda <felix.janda@posteo.de>
Cc: xfs@oss.sgi.com

On Tue, Jan 12, 2016 at 10:46:34PM +0100, Felix Janda wrote:
> Dave Chinner wrote:
> > On Tue, Jan 12, 2016 at 08:59:35PM +0100, Felix Janda wrote:
> > > The uint*_t and int*_t are defined by C99 and should be prefered
> > > over the less portable __uint*_t and __int*_t variants. The
> > > necessary <stdint.h> include is in platformdefs.h, which gets
> > > included in most places via libxfs.h. In the public headers
> > > <stdint.h> is included in <xfs/xfs_types.h>.
> > > 
> > > Signed-off-by: Felix Janda <felix.janda@posteo.de>
> > 
> > I can't apply this straight off. Most of the libxfs code that is
> > changed is shared with the kernel code, and so the definitions of
> > the variables need to be the same as the kernel code. There are
> > reasons for the kernel code using __[u]int*_t type variants (e.g.  I
> > think the endian conversion static checker requires the __ variants
> > for host order variables), and so before making sweeping changes
> > like this we need to ensure that we can make the equivalent changes
> > to the kernel code as well...
> 
> Thanks for the review!
> 
> Sorry, I was not aware about this difference between the types.
> 
> The simplest fix for musl would be to add defines or something similar
> to linux.h.
> 
> On the other hand, on the long run it would be preferable to use
> the stdint types (consistently).

Right, that's definitely the better solution. We can't just jump
there in one go. :/

FWIW, changing everything outside libxfs/ and include/ should be ok
to do straight away; it's just the libxfs stuff that we have other
constraints on.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
