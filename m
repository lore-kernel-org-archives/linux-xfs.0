Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3B9C47CA0
	for <xfs@oss.sgi.com>; Fri, 19 Aug 2016 05:29:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BDB90AC002
	for <xfs@oss.sgi.com>; Fri, 19 Aug 2016 03:29:03 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	uDPorchSSWs6g8dM for <xfs@oss.sgi.com>;
	Fri, 19 Aug 2016 03:29:01 -0700 (PDT)
Date: Fri, 19 Aug 2016 20:28:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] PING...  mkfs.xfs: fix static-lib build
Message-ID: <20160819102858.GK19025@dastard>
References: <1470907976-2362-1-git-send-email-dmonakhov@openvz.org>
	<87bn0p6ql4.fsf@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87bn0p6ql4.fsf@openvz.org>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-xfs@vger.kernel.org, billodo@redhat.com, xfs@oss.sgi.com

On Fri, Aug 19, 2016 at 12:44:07PM +0300, Dmitry Monakhov wrote:
> 
> I'm just want to double check that this list is still alive, and
> not yet moved some where XXX-xfs@kernel.org  :)

linux-xfs@vger.kernel.org is active and we'll be moving there soon -
stay tuned. For the moment, I'll see any email you send there, at
least ;P

> > diff --git a/mkfs/Makefile b/mkfs/Makefile
> > index 170e3c1..c13b903 100644
> > --- a/mkfs/Makefile
> > +++ b/mkfs/Makefile
> > @@ -10,7 +10,7 @@ LTCOMMAND = mkfs.xfs
> >  HFILES =
> >  CFILES = maxtrres.c proto.c xfs_mkfs.c
> >  
> > -LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBUUID) $(LIBRT) $(LIBPTHREAD) $(LIBBLKID)
> > +LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBRT) $(LIBPTHREAD) $(LIBBLKID) $(LIBUUID)
> >  LTDEPENDENCIES += $(LIBXFS) $(LIBXCMD)
> >  LLDFLAGS = -static-libtool-libs

I've already got a patch from Darrick to fix that in my queue.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
