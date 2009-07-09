Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n69ErgCH035115 for <xfs@oss.sgi.com>; Thu, 9 Jul 2009 09:53:43 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DE906A14B33
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2009 08:01:21 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 3pravGHEnPOENKEa for
	<xfs@oss.sgi.com>; Thu, 09 Jul 2009 08:01:21 -0700 (PDT)
Message-ID: <4A560497.7@sandeen.net>
Date: Thu, 09 Jul 2009 09:54:15 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair stops on "traversing filesystem..."
References: <4A55FAF7.5040908@gmail.com>
In-Reply-To: <4A55FAF7.5040908@gmail.com>
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
To: Tomek Kruszona <bloodyscarion@gmail.com>
Cc: xfs@oss.sgi.com

Tomek Kruszona wrote:
> Hello!
> 
> I have a little problem with XFS filesystem that I have on one of my
> machines. I try to make xfs_repair that was not making any problems
> before, but xfs_repair stops on:
> 
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
> 
> CPU usage grows up to 100%. I left it in the night hoping it will finish
> job till morning, but the situation hasn't changed...

...

> Any ideas how to make xfs_repair working again?

You might try running with -P, though I doubt that's the issue.

If that doesn't help, you could provide an xfs_metadump image (in public
or to me in private) and I'll take a look to see what's going on.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
