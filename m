Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n07IVjT3021454 for <xfs@oss.sgi.com>; Wed, 7 Jan 2009 12:31:45 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E10006C069
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2009 10:31:45 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id oaVgf5ue5VEyFLh1 for
	<xfs@oss.sgi.com>; Wed, 07 Jan 2009 10:31:45 -0800 (PST)
Date: Wed, 7 Jan 2009 13:31:15 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: problems showing up as XFS problems on kernels after 2.6.28-git2
Message-ID: <20090107183115.GA6261@infradead.org>
References: <20090107165218.GA11132@dth.net>
	<20090107180246.GA15218@infradead.org>
	<20090107182415.GA12039@dth.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090107182415.GA12039@dth.net>
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
To: Danny ter Haar <dth@dth.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Jan 07, 2009 at 07:24:15PM +0100, Danny ter Haar wrote:
> Since compiling a kernel on the native hardware takes "forever"
> i compile them at my laptop (ubuntu 32bits) and move the kernel
> to the NAS.
> This morning i compiled tried git9 (still an error)

And error when compiling the kernel or you got the same error again?
In case you can actually reproduce this error, I would be very
interested in a metadump of the filesystem that causes this error.

> I have copied the config & system.map file to the same dir on
> my server ( http://www.dth.net/kernel/c3/ )
> 
> 
> I'm not familiar with the debugging, do you have pointer where
> i could find how to do this ?
> In the mean time i'll try and google some info on how...
> 
> I could copy the whole source tree over to the machine and give you 
> (root) access to the machine so you can take a look yourself (if needed).

The dbuegging should be really easy as long you actually have a tree /
config with which the oops happened so that the oops has the same
addresses.  Compared to your config we would need CONFIG_DEBUG_INFO,
but that's something we could turn on after the fact as it shouldn't
change the reported address.  After that we can just do a trivial
command in gdb to find the source lines for the addresses reported
(this can easily be done on the system where you compile the kernel,
doesn't have to be on the NAS box).

Btw, turning on CONFIG_XFS_DEBUG would be useful to see more output
in case you can reproduce this issue.  Just make sure to turn it
off again when you want to use the box for a real workload..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
