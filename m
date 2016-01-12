Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0CA3D7F3F
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 15:49:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E5C2C8F8049
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 13:49:26 -0800 (PST)
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65]) by
	cuda.sgi.com with ESMTP id GdnwhXZkJHx7JVTb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2016 13:49:24 -0800 (PST)
Received: from dovecot03.posteo.de (dovecot03.posteo.de [172.16.0.13])
	by mout01.posteo.de (Postfix) with ESMTPS id D6CBD20AAC
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 22:49:23 +0100 (CET)
Date: Tue, 12 Jan 2016 22:46:34 +0100
From: Felix Janda <felix.janda@posteo.de>
Subject: Re: [PATCH 1/6] Move from __uint*_t types to uint*_t and likewise
	for __int*_t
Message-ID: <20160112214634.GC10558@nyan>
References: <cover.1452627740.git.felix.janda@posteo.de>
	<20160112195935.GB568@nyan> <20160112212405.GL10456@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160112212405.GL10456@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner wrote:
> On Tue, Jan 12, 2016 at 08:59:35PM +0100, Felix Janda wrote:
> > The uint*_t and int*_t are defined by C99 and should be prefered
> > over the less portable __uint*_t and __int*_t variants. The
> > necessary <stdint.h> include is in platformdefs.h, which gets
> > included in most places via libxfs.h. In the public headers
> > <stdint.h> is included in <xfs/xfs_types.h>.
> > 
> > Signed-off-by: Felix Janda <felix.janda@posteo.de>
> 
> I can't apply this straight off. Most of the libxfs code that is
> changed is shared with the kernel code, and so the definitions of
> the variables need to be the same as the kernel code. There are
> reasons for the kernel code using __[u]int*_t type variants (e.g.  I
> think the endian conversion static checker requires the __ variants
> for host order variables), and so before making sweeping changes
> like this we need to ensure that we can make the equivalent changes
> to the kernel code as well...

Thanks for the review!

Sorry, I was not aware about this difference between the types.

The simplest fix for musl would be to add defines or something similar
to linux.h.

On the other hand, on the long run it would be preferable to use
the stdint types (consistently).

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
