Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C10017CA2
	for <xfs@oss.sgi.com>; Sat, 20 Aug 2016 18:23:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 93B358F8037
	for <xfs@oss.sgi.com>; Sat, 20 Aug 2016 16:23:43 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	LZF1JZroRMd9WHy1 for <xfs@oss.sgi.com>;
	Sat, 20 Aug 2016 16:23:41 -0700 (PDT)
Date: Sun, 21 Aug 2016 09:23:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: IRQ Lock Inversion dependency detected?
Message-ID: <20160820232338.GL19025@dastard>
References: <6b41c73b-9894-3076-670a-18c7247752b8@shaw.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6b41c73b-9894-3076-670a-18c7247752b8@shaw.ca>
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
To: Andrew Ryder <tireman@shaw.ca>
Cc: xfs@oss.sgi.com

On Sat, Aug 20, 2016 at 12:09:24AM -0400, Andrew Ryder wrote:
> Had this pop up sometime in the last 24 hours but it didn't seem to
> cause me any problems? Thought I'd pass it along if its of use or
> ignore them in the future? I've attached the full dmesg output also.

False positive.  See commit dbad7c9 ("xfs: stop holding ILOCK over
filldir callbacks") for explanation and the change that was made to
stop lockdep triggering on this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
