Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4J2DT2V092284 for <xfs@oss.sgi.com>; Tue, 18 May 2010 21:13:29 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9FB6812998E3
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 19:16:51 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id J8rwsjvpNlmkCNa8 for
	<xfs@oss.sgi.com>; Tue, 18 May 2010 19:16:51 -0700 (PDT)
Message-ID: <4BF349D1.6050408@sandeen.net>
Date: Tue, 18 May 2010 21:15:45 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair memory usage and stopping on "Traversing filesystem..."
References: <00FB97ED-C684-4B81-B623-AB7EBD7B7091@blackducksoftware.com>
	<20100519001911.GJ2150@dastard>
In-Reply-To: <20100519001911.GJ2150@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Colin Wilson <cwilson@blackducksoftware.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Dave Chinner wrote:

 
> Hence I'd start by upgrading to 3.1.2 and running with the default
> options first to see whether it is faster and whether it hangs or
> not before going any further.

If it still hangs, collecting an xfs_metadump of the fs would be 
useful for investigating the problem.

But, I think I fixed that (the options you mentioned were workarounds
for the bug I eventually fixed, IIRC)

Thanks,
-Eric

> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
