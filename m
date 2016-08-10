Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 34D067CA3
	for <xfs@oss.sgi.com>; Wed, 10 Aug 2016 16:51:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 07989304039
	for <xfs@oss.sgi.com>; Wed, 10 Aug 2016 14:51:54 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	EqDlgAbE02kXsBFz for <xfs@oss.sgi.com>;
	Wed, 10 Aug 2016 14:51:51 -0700 (PDT)
Date: Thu, 11 Aug 2016 07:51:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Question on migrating data between PVs in xfs
Message-ID: <20160810215149.GM19025@dastard>
References: <20160809145046.GB5583@ic> <20160809223503.GJ19025@dastard>
	<20160810092313.GA16193@ic> <20160810105639.GR16044@dastard>
	<20160810183132.0b9ae8e4@harpe.intellique.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160810183132.0b9ae8e4@harpe.intellique.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com, Wei Lin <lin.wei15@imperial.ac.uk>

On Wed, Aug 10, 2016 at 06:31:32PM +0200, Emmanuel Florac wrote:
> Le Wed, 10 Aug 2016 20:56:39 +1000
> Dave Chinner <david@fromorbit.com> =E9crivait:
> =

> > Have you lookd at using dm-cache instead of modifying the
> > filesystem?
> > =

> =

> Or bcache, fcache, or EnhanceIO. So far from my own testing bcache is
> significantly faster and dm-cache by far the slowest of the bunch, but
> bcache needs some more loving (his main developer is busy writing
> some new tiered, caching filesystem instead).

Yeah, the problem with bcache is that it is effectively an orphaned
driver. If there are obvious and reproducable performance
differentials between bcache and dm-cache, you should bring them to
the attention of the dm developers to see if they can fix them...

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
