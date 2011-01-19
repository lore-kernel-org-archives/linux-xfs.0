Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0JBaHkm208637 for <xfs@oss.sgi.com>; Wed, 19 Jan 2011 05:36:17 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A6FCE16224A0
	for <xfs@oss.sgi.com>; Wed, 19 Jan 2011 03:38:34 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ak6qqbftHQzufWA2 for
	<xfs@oss.sgi.com>; Wed, 19 Jan 2011 03:38:34 -0800 (PST)
Date: Wed, 19 Jan 2011 06:38:22 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: add fpunch command for hole punching via
	fallocate
Message-ID: <20110119113822.GA12941@infradead.org>
References: <1295009545-17839-1-git-send-email-josef@redhat.com>
	<20110118125112.GB21440@infradead.org>
	<20110118130603.GA23491@dhcp231-156.rdu.redhat.com>
	<20110118131203.GA4349@infradead.org>
	<20110118212303.GV28803@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110118212303.GV28803@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Josef Bacik <josef@redhat.com>, xfs@oss.sgi.com

On Wed, Jan 19, 2011 at 08:23:03AM +1100, Dave Chinner wrote:
> 	a) it is consistent with other xfs_io allocation manipulation
> 	   command structures such as resvsp/unresvsp

These are all different ioctls.

> 	b) "punch" is less to type than "fallocate -p"
> 	c) self documenting in scripts e.g. -c "punch 4k 4k" is much
> 	   more obvious than -c "fallocate -p 4k 4k" and saves a man
> 	   page lookup when reading the script.
> 	d) punch as a top level command will show up in the "xfs_io
> 	   -c help", not require you to know it is a suboption of the
> 	   "falloc" command to find out how to use it.
> 	e) the xfs_io command does not have to have the same name
> 	   and structure as the underlying API that implements the
> 	   functionality the commands execute.

I still don't like this as a reason to duplicate the code, and not
having the different arguments for fallocate exposed similar to the
syscall level.

What do you think about introducing a concept of aliases in xfs_io
so that we can have a toplevel punch command that just gets aliased
to fallocate -p without having to reimplement it?

I'd take Josef's older falocate -p implementation and will add the alias
support myself.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
