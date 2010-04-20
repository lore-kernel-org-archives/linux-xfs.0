Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3KNU3Ic072931 for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 18:30:04 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4715D2DF8B9
	for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 16:32:01 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	jAEcGhSOccciD0p5 for <xfs@oss.sgi.com>;
	Tue, 20 Apr 2010 16:32:01 -0700 (PDT)
Date: Wed, 21 Apr 2010 09:31:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/4] writeback: limit write_cache_pages integrity
	scanning to current EOF
Message-ID: <20100420233159.GB23541@dastard>
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
	<20100420034005.GA15130@dastard>
	<20100420232819.GR11723@shareable.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100420232819.GR11723@shareable.org>
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
To: Jamie Lokier <jamie@shareable.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Apr 21, 2010 at 12:28:19AM +0100, Jamie Lokier wrote:
> Dave Chinner wrote:
> > sync can currently take a really long time if a concurrent writer is
> > extending a file. The problem is that the dirty pages on the address
> > space grow in the same direction as write_cache_pages scans, so if
> > the writer keeps ahead of writeback, the writeback will not
> > terminate until the writer stops adding dirty pages.
> > 
> > For a data integrity sync, we only need to write the pages dirty at
> > the time we start the writeback, so we can stop scanning once we get
> > to the page that was at the end of the file at the time the scan
> > started.
> > 
> > This will prevent operations like copying a large file preventing
> > sync from completing as it will not write back pages that were
> > dirtied after the sync was started. This does not impact the
> > existing integrity guarantees, as any dirty page (old or new)
> > within the EOF range at the start of the scan will still be
> > captured.
> 
> I guess it can still get stuck if someone does ftruncate() first, then
> writes to the hole?

Yes, it would. It only deals with extending files because fixing the
problem w.r.t.  writes into holes requires something much more
invasive like Jan's radix tree mark-and-sweep algorithm....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
