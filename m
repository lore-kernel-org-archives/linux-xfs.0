Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4IBhQV3242119 for <xfs@oss.sgi.com>; Mon, 18 May 2009 06:43:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9CD61FC4B1E
	for <xfs@oss.sgi.com>; Mon, 18 May 2009 04:48:41 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id gD5sogxSj85RR5Xq for
	<xfs@oss.sgi.com>; Mon, 18 May 2009 04:48:41 -0700 (PDT)
Date: Mon, 18 May 2009 07:43:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: mmap vs mtime in 2.6.26 and up
Message-ID: <20090518114305.GA6303@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090515165054.GA11439@infradead.org>
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
To: Ferenc Wagner <wferi@niif.hu>
Cc: Peter Staubach <staubach@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Ray Lee <ray-lk@madrabbit.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>

On Fri, May 15, 2009 at 12:50:54PM -0400, Christoph Hellwig wrote:
> On Fri, May 15, 2009 at 06:40:29PM +0200, Ferenc Wagner wrote:
> > Thanks for the analysis.  Unfortunately I don't nearly know enough to
> > work on this issue, but would like to track it as it affects our
> > backup system.  So, shouldn't #2645 be reopened again?
> 
> Yes, definitively as the current "fix" is incorrected.  I'll try to cook
> up a correct version once I get some time.

Doing this correctly in the framework of the current codee is
unfortunately not so easy, as calling ->setattr requires taking i_mutex
which we can't in the pagefaul path.

To fix this properly we need to actually update the timestamps during
msync and co as done by the patches from Miklos:

	http://lkml.org/lkml/2007/2/28/166

and Peter:

	http://lkml.org/lkml/2006/5/31/176

----- End forwarded message -----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
