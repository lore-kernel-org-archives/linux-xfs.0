Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6LIqYou092975 for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 13:52:34 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3539EBF8B4F
	for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 12:02:22 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.187]) by cuda.sgi.com with ESMTP id
	6dn6S4Bek0PDClZI for <xfs@oss.sgi.com>;
	Wed, 21 Jul 2010 12:02:22 -0700 (PDT)
Date: Wed, 21 Jul 2010 11:55:26 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: xfsprogs: only absolute run-paths are allowed
In-Reply-To: <1279737202.1816.16.camel@doink>
Message-ID: <alpine.DEB.2.01.1007211149320.3964@bogon.housecafe.de>
References: <alpine.DEB.2.01.1007210408390.3964@bogon.housecafe.de>
	<20100721171319.GA17772@infradead.org>
	<1279737202.1816.16.camel@doink>
MIME-Version: 1.0
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, 21 Jul 2010 at 13:33, Alex Elder wrote:
> > The patch below should fix this issue.  Note that you need to do a
> > 
> > 	make realclean
> > 	make configure
> > 
> > to regenerate the configure script first.
> 
> This looks OK to me.  Once you get confirmation
> it works for Christian you can re-format your
> description and commit it.  (I didn't see the
> problem in my environment for some reason.)

Yes, the patch works for me, thanks Christoph!

 Tested-by: Christian Kujau <lists@nerdbynature.de>

Btw, I noticed quite a few warnings[0] during compilation:

   warning: pointer targets in assignment differ in signedness
   warning: pointer targets in passing argument 1 of '...' differ in signedness

I hope they're nothing to worry about?

Thanks again,
Christian.

[0] http://nerdbynature.de/bits/xfsprogs/prefix/make_v3.1.2.log.gz
-- 
BOFH excuse #260:

We're upgrading /dev/null

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
