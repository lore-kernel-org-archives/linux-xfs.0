Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8D1977F58
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 09:02:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 24F09AC004
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 07:02:04 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id uXDB4PDj1aODuA0Z (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Jun 2014 07:02:02 -0700 (PDT)
Date: Tue, 17 Jun 2014 07:01:59 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [RFC] xfs: wire up aio_fsync method
Message-ID: <20140617140159.GA1709@infradead.org>
References: <1402562047-31276-1-git-send-email-david@fromorbit.com>
	<20140612141329.GA11676@infradead.org>
	<20140612234441.GT9508@dastard>
	<20140613162352.GB23394@infradead.org> <539F5C6F.4060402@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <539F5C6F.4060402@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-man@vger.kernel.org, xfs@oss.sgi.com

On Mon, Jun 16, 2014 at 11:06:55PM +0200, Michael Kerrisk (man-pages) wrote:
> > Talking about documentation:  The kernel aio manpages (io_*.2) seems
> > to not really be very useful, mostly because they don't explain how
> > to set up the iocbs.  Michael, any idea how to get started to improve
> > this?
> 
> Well, it just needs someone knowledgeable to fill the gaps, and
> perhaps add an example program. I don't have that knowledge 
> offhand myself...

Dave pointed out that there actually are man pages for the ops, they
just come with libaio instead of the man-pages project.  I'll send you
a patch to refer to them.

The libaio man pages could also use some work, I'll see if I can find
time for that as well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
