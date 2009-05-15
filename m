Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4FGon5S046784 for <xfs@oss.sgi.com>; Fri, 15 May 2009 11:50:55 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C7BF219D04AB
	for <xfs@oss.sgi.com>; Fri, 15 May 2009 09:50:57 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id XirB4ZG1EE25AQRw for
	<xfs@oss.sgi.com>; Fri, 15 May 2009 09:50:57 -0700 (PDT)
Date: Fri, 15 May 2009 12:50:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: mmap vs mtime in 2.6.26 and up
Message-ID: <20090515165054.GA11439@infradead.org>
References: <874ovws94s.fsf@tac.ki.iif.hu> <87ljp2v6vt.fsf@tac.ki.iif.hu>
	<2c0942db0905120837g702b457bm52a412293925021a@mail.gmail.com>
	<20090512155301.GA23160@infradead.org>
	<87ws8i720y.fsf@tac.ki.iif.hu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87ws8i720y.fsf@tac.ki.iif.hu>
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
Cc: Ray Lee <ray-lk@madrabbit.org>, linux-kernel@vger.kernel.org, Anton Salikhmetov <salikhmetov@gmail.com>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com

On Fri, May 15, 2009 at 06:40:29PM +0200, Ferenc Wagner wrote:
> Thanks for the analysis.  Unfortunately I don't nearly know enough to
> work on this issue, but would like to track it as it affects our
> backup system.  So, shouldn't #2645 be reopened again?

Yes, definitively as the current "fix" is incorrected.  I'll try to cook
up a correct version once I get some time.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
