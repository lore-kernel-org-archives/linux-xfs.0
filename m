Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BC8CC29DF8
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 22:21:11 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9D59F304059
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 20:21:08 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	4PJuRrfPruIJ8fdV for <xfs@oss.sgi.com>;
	Wed, 26 Feb 2014 20:21:07 -0800 (PST)
Date: Thu, 27 Feb 2014 15:20:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/9 V2] xfs: add xfs_verifier_error()
Message-ID: <20140227042053.GH29907@dastard>
References: <1392767549-25574-1-git-send-email-sandeen@redhat.com>
	<1392767549-25574-8-git-send-email-sandeen@redhat.com>
	<53056F43.7070005@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53056F43.7070005@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On Wed, Feb 19, 2014 at 08:58:11PM -0600, Eric Sandeen wrote:
> We want to distinguish between corruption, CRC errors,
> etc.  In addition, the full stack trace on verifier errors
> seems less than helpful; it looks more like an oops than
> corruption.
> 
> Create a new function to specifically alert the user to
> verifier errors, which can differentiate between
> EFSCORRUPTED and CRC mismatches.  It doesn't dump stack
> unless the xfs error level is turned up high.
> 
> Define a new error message (EFSBADCRC) to clearly identify
> CRC errors.  (Defined to EILSEQ, bad byte sequence)

I've updated this to be EBADMSG, to match the code.

Otherwise, looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
