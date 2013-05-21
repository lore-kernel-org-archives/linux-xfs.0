Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D91E97F37
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 19:45:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 743EBAC003
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 17:45:57 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	5KHUsj97rhNUunGM for <xfs@oss.sgi.com>;
	Mon, 20 May 2013 17:45:55 -0700 (PDT)
Date: Tue, 21 May 2013 10:45:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests comma separated group names
Message-ID: <20130521004553.GL24543@dastard>
References: <CANW9uytRpGXcd9x=HWMEoFvd3_9G98CN_Tv3YacTtd1h+Gq=4g@mail.gmail.com>
	<20130520113045.GB24543@dastard>
	<CANW9uytQDPaBr_VAGMuwSqhStCfyMCGmV_A3ccNzOExi-KeZfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANW9uytQDPaBr_VAGMuwSqhStCfyMCGmV_A3ccNzOExi-KeZfQ@mail.gmail.com>
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
To: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, May 20, 2013 at 08:42:35PM +0900, Itaru Kitayama wrote:
> Yes, we can do that, but I just thought as you originally proposed last year
> 
> -g rw,attr reads better.

Agreed, it does read better and is easily to type.

That's what you need to put in the commit message - why it is better
than what we currently have, and whether it is badwards compatible
or not (doesn't break any existing scripts). i.e. the commit
message is for telling people -why- the change should be made as we
can look at the code to determine -what- the change is.  ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
