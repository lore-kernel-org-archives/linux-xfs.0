Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 40C397CA2
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2016 16:35:26 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 21A35304048
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2016 14:35:26 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	2xYrCDmASqFJqB3p for <xfs@oss.sgi.com>;
	Fri, 05 Feb 2016 14:35:23 -0800 (PST)
Date: Sat, 6 Feb 2016 09:35:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] xfs: fix realtime device assert failures
Message-ID: <20160205223519.GM459@dastard>
References: <1454373550-3102-1-git-send-email-david@fromorbit.com>
	<CAOxpaSVs=DmbjsBH68wwQVZeP4dm4PkfA3=jQF3LhR_kgp2tFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOxpaSVs=DmbjsBH68wwQVZeP4dm4PkfA3=jQF3LhR_kgp2tFQ@mail.gmail.com>
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
To: Ross Zwisler <zwisler@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Feb 04, 2016 at 02:22:17PM -0700, Ross Zwisler wrote:
> This series solves the assert and the follow-up XFS warning for me.
> 
> Tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> 
> The lockdep splat is still there, but I assume you know that.

Mostly I don't care about lockdep splats because experience tells me
they are wild goose chases that end with us jumping through ever
more complex flaming hoops to annotate the special corner case
lockdep has falsely triggered on.

I also don't have time to care about lockdep right now, so I'm
ignoring it until it manifests itself as a real deadlock.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
