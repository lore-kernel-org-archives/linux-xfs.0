Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n847JO1r183045 for <xfs@oss.sgi.com>; Fri, 4 Sep 2009 02:19:35 -0500
Received: from kernel.dk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C72A427849
	for <xfs@oss.sgi.com>; Fri,  4 Sep 2009 00:20:16 -0700 (PDT)
Received: from kernel.dk (brick.kernel.dk [93.163.65.50]) by cuda.sgi.com with
	ESMTP id Nx0WC8pNEZFjnNh0 for <xfs@oss.sgi.com>;
	Fri, 04 Sep 2009 00:20:16 -0700 (PDT)
Date: Fri, 4 Sep 2009 09:20:13 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: ext4 writepages is making tiny bios?
Message-ID: <20090904072013.GR18599@kernel.dk>
References: <20090901184450.GB7885@think> <20090901205744.GE6996@mit.edu>
	<20090901212740.GA9930@infradead.org>
	<20090903055201.GA7146@discord.disaster>
	<20090903164209.GA28384@infradead.org>
	<20090904001545.GA30759@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090904001545.GA30759@mit.edu>
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
To: Theodore Tso <tytso@mit.edu>
Cc: xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Chris Mason <chris.mason@oracle.com>

On Thu, Sep 03 2009, Theodore Tso wrote:
> On Thu, Sep 03, 2009 at 12:42:09PM -0400, Christoph Hellwig wrote:
> > > Careful:
> > > 
> > > -	tloff = min(tlast, startpage->index + 64);
> > > +	tloff = min(tlast, startpage->index + 8192);
> > > 
> > > That will cause 64k page machines to try to write back 512MB at a
> > > time. This will re-introduce similar to the behaviour in sles9 where
> > > writeback would only terminate at the end of an extent (because the
> > > mapping end wasn't capped like above).
> > 
> > Pretty good point, any applies to all the different things we discussed
> > recently.  Ted, should be maybe introduce a max_writeback_mb instead of
> > the max_writeback_pages in the VM, too?
> 
> Good point.
> 
> Jens, maybe we should replace my patch with this one, which makes the
> tunable in terms of megabytes instead of pages?

That is probably a better metric than 'pages', lets update it.

-- 
Jens Axboe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
