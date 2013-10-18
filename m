Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 06E467F50
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 17:40:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E5AC18F8039
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 15:40:45 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	OpvR691h2UgAoOdU for <xfs@oss.sgi.com>;
	Fri, 18 Oct 2013 15:40:44 -0700 (PDT)
Date: Sat, 19 Oct 2013 09:40:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/32] xfs: create a shared header file for
	format-related information
Message-ID: <20131018224041.GW4446@dastard>
References: <1380510944-8571-1-git-send-email-david@fromorbit.com>
	<1380510944-8571-9-git-send-email-david@fromorbit.com>
	<526168EB.1080403@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <526168EB.1080403@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 18, 2013 at 11:59:23AM -0500, Rich Johnston wrote:
> This has been committed.
> 
> Thanks
> --Rich
> 
> commit dd297fd6d366f62ca2f579e510e6287699d0bd5d
> Author: Dave Chinner <david@fromorbit.com>
> Date:   Mon Sep 30 03:15:20 2013 +0000
> 
>     xfs: create a shared header file for format-related information

Rich, none of the kernel patches for this rework have been committed
yet. I appreciate you catching up on outstanding patches, but lets
not jump the gun completely by commit stuff to userspace that isn't
yet in the kernel tree.

As it is, the last version of the kernel patch for this change was
slightly modified due to review comments, which is why we should be
waiting for the kernel commits to shared files before finalising
and committing the userspace patches...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
