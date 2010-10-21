Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9LCmNHO256506 for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 07:48:23 -0500
Subject: Re: [PATCH 2/4] xfstests: add _require_attrs
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101021050202.GA1752@infradead.org>
References: <20101015222820.GA3655@infradead.org>
	<20101015222902.GB3781@infradead.org> <1287597791.2284.99.camel@doink>
	<20101021050202.GA1752@infradead.org>
Date: Thu, 21 Oct 2010 07:49:34 -0500
Message-ID: <1287665374.1887.1.camel@doink>
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
Cc: xfs@oss.sgi.com

On Thu, 2010-10-21 at 01:02 -0400, Christoph Hellwig wrote:
> On Wed, Oct 20, 2010 at 01:03:11PM -0500, Alex Elder wrote:
> > On Fri, 2010-10-15 at 18:29 -0400, Christoph Hellwig wrote:
> > > Add a new helper to check if extended attributes are supported.  It
> > > errors out if any of the attr tools are not found, or if a filesystem
> > > does not support setting attributes.
> > > 
> > > Remove the opencoded checks for the attr tools from various tests
> > > now that we do them in common code.
> > 
> > Generally this looks good.
> > 
> > I was going to just make a few suggestions and ask you
> > to fix them before committing, but  I think there are
> > enough that I think it would be good to re-submit this.
> 
> I'd rather commit the patch as-is and fix up the attr/getfattr
> references separately.  I'll submit a patch to do ASAP.
> 

Sounds good to me.  Probably better that way anyway.	-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
