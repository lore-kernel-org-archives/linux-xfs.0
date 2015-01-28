Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5C46C7F7B
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2015 15:00:18 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CEA83AC004
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2015 13:00:14 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	qWJACul62yR48bJU for <xfs@oss.sgi.com>;
	Wed, 28 Jan 2015 13:00:12 -0800 (PST)
Date: Thu, 29 Jan 2015 07:59:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs_spaceman: Accounting for AGFL blocks
Message-ID: <20150128205956.GA6282@dastard>
References: <54c1c12e.230a460a.4729.11fc@mx.google.com>
	<20150128015757.GT16552@dastard>
	<CALJmpHP=vjz_ZY9sFpW8k2Y7TL+sz-WyjPeMoy4sM6XDTt8MTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALJmpHP=vjz_ZY9sFpW8k2Y7TL+sz-WyjPeMoy4sM6XDTt8MTQ@mail.gmail.com>
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
To: ADRS PICT <adrscube@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Jan 28, 2015 at 06:35:22PM +0530, ADRS PICT wrote:
> On Wed, Jan 28, 2015 at 7:27 AM, Dave Chinner <david@fromorbit.com> wrote:
> > Hmmm - I think something is still missing - what are the sagbno and
> > eagbno parameters supposed to do?
> 
> Actually the parameters sagbno and eagbno are not needed in this
> function and can be excluded.

Why? Don't we still have to check the blocks found on the AGFL fll
within the range requested by the user, like we do for every extent
found in the btree?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
