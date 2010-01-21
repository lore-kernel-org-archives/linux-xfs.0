Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0L8tvhr062428 for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 02:55:59 -0600
Date: Thu, 21 Jan 2010 03:56:55 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Circular locking dependency warning involing xfs on 2.6.27
Message-ID: <20100121085655.GA687@infradead.org>
References: <4B57ADB4.70002@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B57ADB4.70002@kernel.org>
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
To: Tejun Heo <tj@kernel.org>
Cc: xfs@oss.sgi.com, lkml <linux-kernel@vger.kernel.org>, Carsten Aulbert <carsten.aulbert@aei.mpg.de>, Alex Elder <aelder@sgi.com>

On Thu, Jan 21, 2010 at 10:28:20AM +0900, Tejun Heo wrote:
> Hello,
> 
> This is on a pretty old kernel but Carsten reports that it happens
> occassionally in a pretty large setup involving 1500+ machines (please
> feel free to fill in).  This happens pretty sporadically so reporting
> it just in case this is a yet unknown problem.  As I understand it,
> testing with newer kernel isn't out of question but it being a
> production environment, not a very easy thing.

I think the one below is gone.  We still have a very similar one that
can only happen during unmount, and we're trying to sort that one at the
VFS level (see the current thread on -fsdevel)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
