Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA5JFaCI218001 for <xfs@oss.sgi.com>; Fri, 5 Nov 2010 14:15:36 -0500
Subject: Re: Linux and DMAPI
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101003061854.GA24293@infradead.org>
References: <AANLkTim5FExj9GFQf9v1rzRmxqtNrdw_UR5VPUs4bPMq@mail.gmail.com>
	<20101003061854.GA24293@infradead.org>
Date: Fri, 05 Nov 2010 14:16:57 -0500
Message-ID: <1288984617.2295.35.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Diego Woitasen <diego@woitasen.com.ar>, xfs@oss.sgi.com

On Sun, 2010-10-03 at 02:18 -0400, Christoph Hellwig wrote:
> On Sat, Sep 18, 2010 at 09:08:16PM -0300, Diego Woitasen wrote:
> > Hi,
> >  I'm looking for software that supports DMAPI on Linux. I haven't
> > found anything on the web. I need to implement HSM for a mail server,
> > to store old messages in a secondary storage.
> > 
> >  Are there something implemented? Open source or propietary one? I
> > prefer open source obviously...
> 
> The XFS on disk format supports the required metadata for DMAPI, but the
> implementation for it never made it into the mainline Linux kernel.  For
> years SGI provided a tree to add the support, but for the last few years
> the support bitrotted heavily.  Alex promised to publush a tree with
> updated DMAPI support in the near future.

(Catching up on old mail, sorry I didn't respond earlier.)
I will keep my promise...  I have it ported to the
2.6.32-stable and 2.6.33-stable branches at this point.
I was going to try to get up-to-date with the newest
kernels first, but am now setting my sights on getting
just what I have so far published.  I will send an
announcement when it's available.
 
> You'll still need additional userspace support the to actually driver
> the migration.  The xfstests suite has a minimal implementation for QA
> purposes as free software, but I don't think that's what your looking
> for.  The main user of the XFS DMAPI support is SGI's DMF product,
> and at least a few years ago IBM's Tivoli Storage Manager also supported
> DMAPI.

As Christoph said, SGI offers DMF (Data Migration Facility),
but it is a proprietary product.

					-Alex


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
