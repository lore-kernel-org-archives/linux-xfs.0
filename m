Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3D1Intu177985 for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 20:18:49 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 161D51269E25
	for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 18:20:42 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	1Vuh36wSvVfHtoqD for <xfs@oss.sgi.com>;
	Mon, 12 Apr 2010 18:20:42 -0700 (PDT)
Date: Mon, 12 Apr 2010 17:11:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCHv2 9/10] xfs: a few more minor xfs_log_recover.c cleanups
Message-ID: <20100412071131.GK2493@dastard>
References: <1270852266.7840.159.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1270852266.7840.159.camel@doink>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Apr 09, 2010 at 05:31:06PM -0500, Alex Elder wrote:
> Minor things that didn't seem to warrant their own individual
> patches:
> - In xlog_bread_noalign(), reorder assertions so the buffer pointer
>   is known to be non-null before attempting to dereference it.

That's OK, but if you are debugging then it'll be obvious what
happend by it being a null ptr dereference rather than an assert
failure. Hence if anything I'd just kill the ASSERT(bp)....

> - Add a more descriptive header comment for xlog_find_verify_cycle().

It just describes what the code does - I don't think it make the
code any clearer and makes it more likely that if we ever change the
code the comment will then be wrong...

> - Make a few additions to the comments in xlog_find_head().  Also
>   rearrange some expressions in a few spots to produce the same
>   result, but in a way that seems more clear what's being computed.

I'd say this is probably the only bits of the patch that add value.
Can you split this one out by itself?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
