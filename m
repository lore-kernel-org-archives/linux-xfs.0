Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8E11D7CA3
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 04:26:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2C9938F8035
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 02:26:39 -0700 (PDT)
Received: from smtp2.cc.ic.ac.uk (smtp2.cc.ic.ac.uk [146.179.32.42]) by
	cuda.sgi.com with ESMTP id tZk8BX52yhhFGflr (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Aug 2016 02:26:37 -0700 (PDT)
Date: Thu, 11 Aug 2016 10:26:04 +0100
From: Wei Lin <lin.wei15@imperial.ac.uk>
Subject: Re: Question on migrating data between PVs in xfs
Message-ID: <20160811092604.GA4615@ic>
References: <20160809145046.GB5583@ic> <20160809223503.GJ19025@dastard>
	<20160810092313.GA16193@ic> <20160810105639.GR16044@dastard>
	<20160810183132.0b9ae8e4@harpe.intellique.com>
	<20160810215149.GM19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160810215149.GM19025@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, Wei Lin <lin.wei15@imperial.ac.uk>

On 16-08-11 07:51:49, Dave Chinner wrote:
> On Wed, Aug 10, 2016 at 06:31:32PM +0200, Emmanuel Florac wrote:
> > Le Wed, 10 Aug 2016 20:56:39 +1000
> > Dave Chinner <david@fromorbit.com> =E9crivait:
> > =

> > > Have you lookd at using dm-cache instead of modifying the
> > > filesystem?
> > > =

> > =

> > Or bcache, fcache, or EnhanceIO. So far from my own testing bcache is
> > significantly faster and dm-cache by far the slowest of the bunch, but
> > bcache needs some more loving (his main developer is busy writing
> > some new tiered, caching filesystem instead).
> =

> Yeah, the problem with bcache is that it is effectively an orphaned
> driver. If there are obvious and reproducable performance
> differentials between bcache and dm-cache, you should bring them to
> the attention of the dm developers to see if they can fix them...
> =

> Cheers,
> =

> Dave.
> -- =

> Dave Chinner
> david@fromorbit.com

Software like dm-cache and bcache seem to use SSDs merely as caches
instead of aggregating the capacity of all devices. However I just found
aufs and overlayfs, which conceptually suit the purpose better.

Cheers,
-- =

Wei Lin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
