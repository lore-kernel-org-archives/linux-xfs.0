Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1ODFxe0143847 for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 07:16:00 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D93D14881F
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 05:15:29 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id mDir208QzW6DbfBc for
	<xfs@oss.sgi.com>; Tue, 24 Feb 2009 05:15:29 -0800 (PST)
Date: Tue, 24 Feb 2009 08:15:23 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
Message-ID: <20090224131523.GA1579@infradead.org>
References: <200902240010.25434.vapier@gentoo.org>
	<49A38420.5030700@sandeen.net>
	<200902240221.44184.vapier@gentoo.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200902240221.44184.vapier@gentoo.org>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Tue, Feb 24, 2009 at 02:21:43AM -0500, Mike Frysinger wrote:
> On Tuesday 24 February 2009 00:22:40 Eric Sandeen wrote:
> > Mike Frysinger wrote:
> > > i noticed that xfsprogs-3.0.0 sometimes fails to build in parallel with
> > > an error about fsr not being able to find libhandle.  looking at the top
> > > level Makefile shows the obvious missing depend (fsr: libhandle). 
> > > playing around a bit found a few more not so obvious missing depends on
> > > the include subdir, so i fixed that too.
> >
> > Oh, can you resend with a formal Signed-off-by: line?  Being a little
> > nitpicky here but we follow the same process as kernel patches.
> 
> where is the git tree now ?  i tried git://oss.sgi.com/xfs-cmds but that seems 
> to be dead now.

http://git.kernel.org/?p=fs/xfs/xfsprogs-dev.git;a=tree for the bleeding
edge development tree.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
