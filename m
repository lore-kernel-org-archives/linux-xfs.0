Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n07M9o6p007589 for <xfs@oss.sgi.com>; Wed, 7 Jan 2009 16:09:50 -0600
Received: from zaphod.dth.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 113C417B8D1C
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2009 14:09:49 -0800 (PST)
Received: from zaphod.dth.net (zaphod.dth.net [85.159.112.68]) by cuda.sgi.com
	with ESMTP id SinIzqenyt5R6Gb6 for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2009 14:09:49 -0800 (PST)
Date: Wed, 7 Jan 2009 23:09:10 +0100
From: Danny ter Haar <dth@dth.net>
Subject: Re: problems showing up as XFS problems on kernels after 2.6.28-git2
Message-ID: <20090107220910.GA12726@dth.net>
References: <20090107165218.GA11132@dth.net>
	<20090107180246.GA15218@infradead.org>
	<20090107182415.GA12039@dth.net>
	<20090107183115.GA6261@infradead.org>
	<20090107184420.GA15653@dth.net>
	<20090107185226.GA19010@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090107185226.GA19010@infradead.org>
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
> Please only with CONFIG_DEBUG_INFO in that case.  CONFIG_XFS_DEBUG would
> be useful if you could reproduce it, but it does change the addresses,
> so it's harmful for the case of getting back to the source line.

Hmm, one bug is never alone...

During compile my laptop started smelling because of heat buildup and switched itself
off. I re-compiled the kernel on a debian lenny32 box i have access to.
I only added the "CONFIG_DEBUG_INFO" option.

Rebooted the nas, and so far the machine is running without a problem :-(
Am now gonna compile a kernel on the machine itself, to force a lot
of disk activity.

Will keep you posted.



-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
