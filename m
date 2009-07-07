Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n67J69ea162999
	for <linux-xfs@oss.sgi.com>; Tue, 7 Jul 2009 14:06:11 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B96529F9735
	for <linux-xfs@oss.sgi.com>; Tue,  7 Jul 2009 12:13:38 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Suh1dJIsFapL8cbM for
	<linux-xfs@oss.sgi.com>; Tue, 07 Jul 2009 12:13:38 -0700 (PDT)
Date: Tue, 7 Jul 2009 15:06:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [2.6.27.25] assfail in xfs_attr_quiesce() during umount
Message-ID: <20090707190643.GA32467@infradead.org>
References: <MAIL10OSN4RHlLx5ERz0002f238@mail1.netezza.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <MAIL10OSN4RHlLx5ERz0002f238@mail1.netezza.com>
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
To: Paul Smith <paul@mad-scientist.net>
Cc: Linux XFS <linux-xfs@oss.sgi.com>, david chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, christoph hellwig <hch@ifradead.org>

On Tue, Jul 07, 2009 at 02:42:16PM -0400, Paul Smith wrote:
> According to the thread for the former, it was intended to be resolved
> by "proper per-vfsmount write count in 2.6.25 as part of the per-mount
> r/o patches" (C.Hellwig)
> 
> Did those fixes indeed go into 2.6.25 (or 2.6.27 or below)?  Was there
> something else that needed to be done for XFS to be able take advantage
> of that enhancement?

We haven't fixed the VFS issues yet.  In some later kernel we just
changed the assert to a warn on for now until the issue is sorted out.

> And, is the patch posted by DavidC here:
> http://marc.info/?l=linux-kernel&m=120106649923499&w=2

It looks somehwat dangerous for me.  For now I would just comment
out the assert or change it to a WARN_ON as in the newer kernels.

I've recently started looking at that area in the VFS again and I'll
hopefully make progress on a solution that sets MS_RDONLY at the
correct time.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
