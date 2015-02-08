Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 889307F63
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2015 15:36:25 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 67D57304032
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2015 13:36:22 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	DBDupq8Mj3NtBqAl for <xfs@oss.sgi.com>;
	Sun, 08 Feb 2015 13:36:19 -0800 (PST)
Date: Mon, 9 Feb 2015 08:35:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2] xfs: pass mp to XFS_WANT_CORRUPTED_*
Message-ID: <20150208213502.GA4251@dastard>
References: <54D53E8C.8070207@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54D53E8C.8070207@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Feb 06, 2015 at 04:22:04PM -0600, Eric Sandeen wrote:
> These 2 patches provide information about which filesystem
> hit the error...

If we are going to touch every one of these macros, then can we
rename them to something a little shorter like XFS_CORRUPT_GOTO()
and XFS_CORRUPT_RETURN() at the same time? That will make the code a
little less eye-bleedy where there are lots of these statements,
and make formatting of complex checks a bit easier, too...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
