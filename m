Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1O5YfjZ126326 for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 23:34:42 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F0E1144B12
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 21:34:10 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id ds4Ik43OFTuIT5rH for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2009 21:34:10 -0800 (PST)
Message-ID: <49A38420.5030700@sandeen.net>
Date: Mon, 23 Feb 2009 23:22:40 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
References: <200902240010.25434.vapier@gentoo.org>
In-Reply-To: <200902240010.25434.vapier@gentoo.org>
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
To: Mike Frysinger <vapier@gentoo.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Mike Frysinger wrote:
> i noticed that xfsprogs-3.0.0 sometimes fails to build in parallel with an 
> error about fsr not being able to find libhandle.  looking at the top level 
> Makefile shows the obvious missing depend (fsr: libhandle).  playing around a 
> bit found a few more not so obvious missing depends on the include subdir, so 
> i fixed that too.
> -mike

Oh, can you resend with a formal Signed-off-by: line?  Being a little
nitpicky here but we follow the same process as kernel patches.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
