Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ED3A67FE2
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 17:48:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 66F5CAC002
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 15:48:36 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	f2CyDbcdnoqkA81c for <xfs@oss.sgi.com>;
	Wed, 03 Jun 2015 15:48:16 -0700 (PDT)
Date: Thu, 4 Jun 2015 08:44:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [RFC v2] xfs: byte range buffer dirty region tracking
Message-ID: <20150603224449.GQ24666@dastard>
References: <1432865777-14616-1-git-send-email-david@fromorbit.com>
	<556F0CE0.8080402@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <556F0CE0.8080402@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 03, 2015 at 09:19:12AM -0500, Mark Tinguely wrote:
> On 05/28/15 21:16, Dave Chinner wrote:
> >Discussion:
> >
> >I think that we will eventually need to track multiple regions - 3
> >is probably sufficient - because the nature of directory operations
> >are that just about every operation modifies a header in the buffer,
> >a tail section in the buffer and then some number of bytes/regions
> >in the middle of the buffer.
> 
> Nod to the idea.
> 
> What made you change from your original idea of using 4 regions to 3
> regions?

3 or 4 regions make little difference. header, body and tail is most
common for random directory modifications, so whether we have 1 or 2
body regions won't make much difference once more than a couple of
modifications are made to the same directory block. Indeed, I'm not
sure that we even need multiple regions - the log bandwidth and log
item memcpy overhead hasn't changed very much even on large
directory buffers with a single region...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
