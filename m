Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p93EOAXP246534 for <xfs@oss.sgi.com>; Mon, 3 Oct 2011 09:24:10 -0500
Date: Mon, 3 Oct 2011 10:23:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/6] xfsprogs: tolerate mount or project errors
Message-ID: <20111003142343.GA19985@infradead.org>
References: <1317646160-5437-1-git-send-email-aelder@sgi.com>
	<20111003133127.GA7875@infradead.org>
	<1317651685.1972.5.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1317651685.1972.5.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Oct 03, 2011 at 09:21:25AM -0500, Alex Elder wrote:
> > I'd really like to do some sort of QA for this.  Given that xfs_quota
> > already has an (uncodumented) -t flag to use a replacement for
> > /proc/mounts and /etc/mtab this seems fairly easy to do.
> 
> Yes I agree, and that's exactly what I intend to do (and how I
> was thinking of doing it).  I also owe a quota test for the
> doubling of what gets reported from a month ago or so.  I
> thought I could address both issues in the same test (unless
> someone feels it's important to have each test have a more
> specific focus).

I think these should be separate tests as they test very different
things.  What could be rolled into the first one would be a test
for RT quota reporting - despite the comment in your commit those
should work just fine.

> > If you're motivated for even more cleanups it would be good if all
> > xfs_quota options are actully documented, and making sure the
> > /proc/mounts, /etc/mtab and co handling in xfsprogs doesn't differ
> > for different tools.  Currently libxcmd, libxfs and xfs_fsr all
> > have their own variants.
> 
> To be honest I kind of went further with this than I intended
> to and I had to sort of put a stop to it...  I have three or
> four other cleanup patches started but I just have to move on
> and so posted what I have working and am content with.
> 
> I think what you suggest are all good but for now I'm not
> planning to work on them.

It's not that important, but maybe we should keep a todo list
for these kinds of tidyups.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
