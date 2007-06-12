Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 12 Jun 2007 16:28:33 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5CNSOWt029708
	for <xfs@oss.sgi.com>; Tue, 12 Jun 2007 16:28:27 -0700
Date: Wed, 13 Jun 2007 09:28:17 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: sunit not working
Message-ID: <20070612232817.GZ86004887@sgi.com>
References: <1181608444.3758.73.camel@edge.yarra.acx> <902286657-1181653953-cardhu_decombobulator_blackberry.rim.net-1527539029-@bxe120.bisx.prod.on.blackberry>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <902286657-1181653953-cardhu_decombobulator_blackberry.rim.net-1527539029-@bxe120.bisx.prod.on.blackberry>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: salmr0@bp.com
Cc: nscott@aconex.com, "Salmon, Rene" <Rene.Salmon@bp.com>, xfs@oss.sgi.com

On Tue, Jun 12, 2007 at 01:12:15PM +0000, salmr0@bp.com wrote:
> 
> Thanks that helps.  Now that I know I have the right sunit and swidth I have
> a performace related question.
> 
> If I do a dd on the raw device or to the lun directy I get speeds of around
> 190-200 MBytes/sec.
> 
> As soon as I add xfs on top of the lun my speeds go to around 150
> MBytes/sec. This is for a single stream write using various block sizes on a
> 2 Gbit/sec fiber channel card.

That's for buffered I/O, right? That sounds about right - if you do two
writes, it should increase a little further. Also, direct I/O should be able
to get you to >90% of the raw device capability....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
