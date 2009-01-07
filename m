Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n07ION1g020794 for <xfs@oss.sgi.com>; Wed, 7 Jan 2009 12:24:25 -0600
Received: from zaphod.dth.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72C5C6C1D0
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2009 10:24:23 -0800 (PST)
Received: from zaphod.dth.net (zaphod.dth.net [85.159.112.68]) by cuda.sgi.com
	with ESMTP id OXPWkENYbmRpU9xs for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2009 10:24:23 -0800 (PST)
Date: Wed, 7 Jan 2009 19:24:15 +0100
From: Danny ter Haar <dth@dth.net>
Subject: Re: problems showing up as XFS problems on kernels after 2.6.28-git2
Message-ID: <20090107182415.GA12039@dth.net>
References: <20090107165218.GA11132@dth.net>
	<20090107180246.GA15218@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090107180246.GA15218@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Quoting Christoph Hellwig (hch@infradead.org):
> > Any kernel i try to boot after 2.6.28-git2 (i tried git4-9) 
> > sooner or later gives me an XFS error:

> The recover_uiunlinks code changed recently.  Do you still have the
> exactly kernel tree version config around so you take a look using
> gdb what exact line of code the oops is?

Since compiling a kernel on the native hardware takes "forever"
i compile them at my laptop (ubuntu 32bits) and move the kernel
to the NAS.
This morning i compiled tried git9 (still an error)
I have copied the config & system.map file to the same dir on
my server ( http://www.dth.net/kernel/c3/ )


I'm not familiar with the debugging, do you have pointer where
i could find how to do this ?
In the mean time i'll try and google some info on how...

I could copy the whole source tree over to the machine and give you 
(root) access to the machine so you can take a look yourself (if needed).

Danny

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
