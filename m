Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 997517F4C
	for <xfs@oss.sgi.com>; Fri,  8 Mar 2013 14:31:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7A3DD304039
	for <xfs@oss.sgi.com>; Fri,  8 Mar 2013 12:31:54 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id mc37FCRojDVGSZes for <xfs@oss.sgi.com>;
	Fri, 08 Mar 2013 12:31:53 -0800 (PST)
Message-ID: <513A4AB7.2040908@sandeen.net>
Date: Fri, 08 Mar 2013 14:31:51 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfs_repair: skip freelist scan of corrupt agf in
	no-modify mode
References: <51313DE8.5080104@sandeen.net> <51326DC0.8030403@sandeen.net>
	<513A4A9B.3050802@sgi.com>
In-Reply-To: <513A4A9B.3050802@sgi.com>
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
Cc: Ole Tange <tange@binf.ku.dk>, xfs-oss <xfs@oss.sgi.com>

On 3/8/13 2:31 PM, Rich Johnston wrote:
> This version looks good. ;)
> 
> Reviewed-by: Rich Johnston <rjohnston@sgi.com>
> 
> This has been committed.

Thanks; from what Dave said there are probably other spots that need love as well.

-Eric

> commit 7e8e3cce00f38ee1533df0e7bda6bcb584b03e96
> Author: Eric Sandeen <sandeen@sandeen.net>
> Date:   Sat Mar 2 21:23:12 2013 +0000
> 
>     xfsprogs: xfs_repair skip freelist scan of corrupt agf in no-modify mode
> 
>     In xfs_repair's no-modify mode (-n), verify_set_agf doesn't fix up
>     bad freelist blocks that it finds.  When we get to scan_freelist,
>     this can wreak havoc if, for example, first > last and the loop
>     never exits; we index agfl->agfl_bno[i] off into the weeds.
> 
>     To fix this, re-check the values in no-modify mode, and if
>     they're off, warn about it and skip the scan.
> 
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
