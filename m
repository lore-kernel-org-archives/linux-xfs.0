Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6V2Xjtc124136 for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 21:33:45 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	7R9t20DA0jblntcL (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 30 Jul 2012 19:33:39 -0700 (PDT)
Date: Mon, 30 Jul 2012 22:33:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: Change fstrim behaviour to be consistent with
	upstream version
Message-ID: <20120731023335.GA31494@infradead.org>
References: <1343649963-14079-1-git-send-email-tracek@redhat.com>
	<20120730220413.GI2877@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120730220413.GI2877@dastard>
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
Cc: lczerner@redhat.com, Tomas Racek <tracek@redhat.com>, xfs@oss.sgi.com

On Tue, Jul 31, 2012 at 08:04:13AM +1000, Dave Chinner wrote:
> If we have duplicate code (i.e. a copy of the upstream utility) or
> the local tool can be completely replaced by the upstream tool,
> then we should use upstream and remove the local copy completely.
> Distros have been shipping fstrim for long enough now that most
> people running testing on upstream kernels will have it installed...
> 
> Adding a _require_fstrim() function that checks for the upstream
> version of fstrim to be installed for each test that requires it
> would go along with this.

I would also vote for just using the upstream util-linux fstrim.  Not
quite sure what the history was here, but it might have been that the
xfstests one actually was the earlier version.  Lukas, any opinions?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
