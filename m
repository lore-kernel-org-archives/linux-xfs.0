Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5G3Xrjj140899
	for <linux-xfs@oss.sgi.com>; Mon, 15 Jun 2009 22:33:54 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F08EC2FAF01
	for <linux-xfs@oss.sgi.com>; Mon, 15 Jun 2009 20:34:17 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id WKpgibstN293WtuE for
	<linux-xfs@oss.sgi.com>; Mon, 15 Jun 2009 20:34:17 -0700 (PDT)
Message-ID: <4A3712BF.7030101@sandeen.net>
Date: Mon, 15 Jun 2009 22:34:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS Preallocate using ALLOCSP
References: <24042506.post@talk.nabble.com>
In-Reply-To: <24042506.post@talk.nabble.com>
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
To: Smit Shah <getsmit@gmail.com>
Cc: linux-xfs@oss.sgi.com

Smit Shah wrote:
> Hi, 
> 
> I wanted to preallocate the file using the ALLOCSP so that the preallocated
> space is zeroed out. Hence i used the xfsctl but the problem is that i
> cannot execute  it as a non-root user.  So i tried using fallocate but when
> i saw the xfs implementation of kernel it uses the RESVP cmd and  since the
> unwritten flag is set i am assuming that the performance of writing to the
> preallocated space will suffer because of the metadata updates. So is there
> a way to preallocate using ALLOCSP as a non-root user or else i would be
> required to modify the kernel ??
> 
> TIA, 
> Smit 

ALLOCSP simply writes 0s to a file.... you may as well do it using posix
calls, as a normal user, I think.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
