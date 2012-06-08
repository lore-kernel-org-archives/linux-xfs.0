Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q58319ZJ161741 for <xfs@oss.sgi.com>; Thu, 7 Jun 2012 22:01:09 -0500
Received: from trent.utfs.org (trent.utfs.org [94.185.90.103]) by cuda.sgi.com
	with ESMTP id vVsNUz9YdsbZ2DzM for <xfs@oss.sgi.com>;
	Thu, 07 Jun 2012 20:01:08 -0700 (PDT)
Date: Thu, 7 Jun 2012 20:01:06 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: attr vs. getfattr
In-Reply-To: <4FD16983.5090901@sandeen.net>
Message-ID: <alpine.DEB.2.01.1206071959230.5568@trent.utfs.org>
References: <alpine.DEB.2.01.1206070508580.5568@trent.utfs.org>
	<4FD16983.5090901@sandeen.net>
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, 7 Jun 2012 at 21:54, Eric Sandeen wrote:
> > I.e. "nothing" is printed. I understand there's "attr" specifically for 
> > XFS filesystems and at least it displays that there *is* an attribute 
> > stored, but it cannot get its value:
> 
> By default it's looking at the user namespace.  You want to look at security (or all) with -m:

Aaargh! Namespaces...yes, of course. Thanks for reminding me and sorry for 
the noise.

> A lot of manpage reading and intuition-following and namespace-remembering.  ;)

Will do!

C.
-- 
BOFH excuse #79:

Look, buddy:  Windows 3.1 IS A General Protection Fault.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
