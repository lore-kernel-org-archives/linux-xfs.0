Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0A2067F96
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2013 13:34:32 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DB7EE304043
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2013 11:34:28 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	zVs9NFB861sTEbtU for <xfs@oss.sgi.com>;
	Thu, 28 Feb 2013 11:34:27 -0800 (PST)
Date: Fri, 1 Mar 2013 06:34:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't verify buffers after IO errors
Message-ID: <20130228193412.GP5551@dastard>
References: <1361931954-11105-1-git-send-email-david@fromorbit.com>
	<512F79CE.4030502@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <512F79CE.4030502@sgi.com>
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

On Thu, Feb 28, 2013 at 09:37:50AM -0600, Mark Tinguely wrote:
> On 02/26/13 20:25, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >When we read a buffer, we might get an error from the underlying
> >block device and not the real data. Hence if we get an IO error, we
> >shouldn't run the verifier but instead just pass the IO error
> >straight through.
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >---
> 
> Looks good. needs to go into Linux 3.7/8 stable?

It's not a critical fix - it just makes logs noisy and changes the
error from, say, EIO to EFSCORRUPTED. The end result will be the
same, though....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
