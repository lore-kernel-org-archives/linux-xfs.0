Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B58477F52
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 05:05:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A32D48F804C
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 03:05:31 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	PtZauNoUqN0ZqlJV for <xfs@oss.sgi.com>;
	Mon, 02 Sep 2013 03:05:29 -0700 (PDT)
Date: Mon, 2 Sep 2013 20:05:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: set remote symlink buffer type for recovery
Message-ID: <20130902100525.GC12779@dastard>
References: <1378081921-18570-1-git-send-email-david@fromorbit.com>
	<1378081921-18570-2-git-send-email-david@fromorbit.com>
	<20130902081625.GA11210@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130902081625.GA11210@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Sep 02, 2013 at 01:16:25AM -0700, Christoph Hellwig wrote:
> On Mon, Sep 02, 2013 at 10:32:00AM +1000, Dave Chinner wrote:
> > errors, and subsequent reads of the symlink failing CRC
> > verification. Found via fsstress + godown.
> 
> Can you make sure xfstests triggers this case, please?

Yeah, I've got a script that reproduced it, so i shoul dbe able to
turn it into an xfstest easily enough...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
