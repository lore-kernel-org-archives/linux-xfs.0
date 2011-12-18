Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBIKQv1g243538 for <xfs@oss.sgi.com>; Sun, 18 Dec 2011 14:26:57 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	HFfaOYoKsxC7qVYH for <xfs@oss.sgi.com>;
	Sun, 18 Dec 2011 12:26:56 -0800 (PST)
Date: Sun, 18 Dec 2011 15:26:51 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs-trace-ilock-more
Message-ID: <20111218202651.GA20799@infradead.org>
References: <20111214024040.GA17780@infradead.org>
	<20111214182750.GH11114@wotan.suse.de> <4EE8F7F0.7070207@suse.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4EE8F7F0.7070207@suse.com>
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
To: Jeff Mahoney <jeffm@suse.com>
Cc: Mark Fasheh <mfasheh@suse.de>, Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Dec 14, 2011 at 02:24:32PM -0500, Jeff Mahoney wrote:
> That's pretty much the explanation. With heavy reader load, buffered
> writes were stalling for 80 ms and sometimes longer. I suspected it
> was contention on the ilock and the tracing with that patch
> demonstrated a delay there. Since we were chasing a similar issue at
> another site, it seemed worthwhile to just keep it around. We're still
> tracking down the cause. I'm not sure if more recent kernels have the
> same issue as there's been quite a lot of churn.

Ok.  I was a bit surprised that it was one out of only two XFS updates
that went into a recent SLES security errata, and I never heard about it
before.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
