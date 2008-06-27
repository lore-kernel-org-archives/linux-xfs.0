Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Jun 2008 00:27:53 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5R7Rnu6013355
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 00:27:49 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C73C6183A224
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 00:28:49 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id 2DYkcWVE13jeIZPv for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 00:28:49 -0700 (PDT)
Date: Fri, 27 Jun 2008 17:28:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: is the flush-on-close-after-truncate still needed?
Message-ID: <20080627072800.GA29319@disturbed>
References: <4859415B.3000009@sandeen.net> <200806181049.07812.dchinner@agami.com> <20080626210904.GA15920@bob.dscon.sk> <486407EB.70703@sandeen.net> <20080627071312.GB15920@bob.dscon.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627071312.GB15920@bob.dscon.sk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: DS <xfs@bob.dscon.sk>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Fri, Jun 27, 2008 at 09:13:12AM +0200, DS wrote:
> Thanx for interest.
> 
> There is no chance to change all scripts (too many customers and
> thousands and thousands perl/php skripts).
> 
> I think it isn't right way compiling own perl/php libs with needed changes on
> open/fopen function.

Overwriting files by truncating then first and then not fsync'ing
the file is a sure way to lose data if the system crashes.  That's
an application bug, not a filesystem bug, because the filesystem is
only doing what it is told to do. XFS is ensuring that lazy
application writers are unlikely to lose data when they carelessly
overwriting data.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
