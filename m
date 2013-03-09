Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5C1BF7F37
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 09:00:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3C7AB8F8049
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 07:00:58 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 93p7rk4ftzmxP0Hg for <xfs@oss.sgi.com>;
	Sat, 09 Mar 2013 07:00:57 -0800 (PST)
Message-ID: <513B4EA7.4060908@sandeen.net>
Date: Sat, 09 Mar 2013 09:00:55 -0600
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
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, Ole Tange <tange@binf.ku.dk>

On 3/8/13 2:31 PM, Rich Johnston wrote:
> This version looks good. ;)

Actually it's not quite:

scan.c: In function =91scan_freelist=92:
scan.c:1074: warning: =91i=92 may be used uninitialized in this function

I don't know what's wrong with my brain these days.  :/

I will send a patch to fix that along w/ the other scan_freelists shortly.

Sorry :/

-Eric

> Reviewed-by: Rich Johnston <rjohnston@sgi.com>
> =

> This has been committed.
> =

> commit 7e8e3cce00f38ee1533df0e7bda6bcb584b03e96
> Author: Eric Sandeen <sandeen@sandeen.net>
> Date:   Sat Mar 2 21:23:12 2013 +0000
> =

>     xfsprogs: xfs_repair skip freelist scan of corrupt agf in no-modify m=
ode
> =

>     In xfs_repair's no-modify mode (-n), verify_set_agf doesn't fix up
>     bad freelist blocks that it finds.  When we get to scan_freelist,
>     this can wreak havoc if, for example, first > last and the loop
>     never exits; we index agfl->agfl_bno[i] off into the weeds.
> =

>     To fix this, re-check the values in no-modify mode, and if
>     they're off, warn about it and skip the scan.
> =

> =

> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
