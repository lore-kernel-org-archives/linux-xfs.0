Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n83GfJAA115065 for <xfs@oss.sgi.com>; Thu, 3 Sep 2009 11:41:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AE6F615C65BE
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2009 09:42:16 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id dEKeAjXvAKBQ1GPU for
	<xfs@oss.sgi.com>; Thu, 03 Sep 2009 09:42:16 -0700 (PDT)
Date: Thu, 3 Sep 2009 12:42:09 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: ext4 writepages is making tiny bios?
Message-ID: <20090903164209.GA28384@infradead.org>
References: <20090901184450.GB7885@think> <20090901205744.GE6996@mit.edu>
	<20090901212740.GA9930@infradead.org>
	<20090903055201.GA7146@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090903055201.GA7146@discord.disaster>
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
Cc: Theodore Tso <tytso@mit.edu>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Chris Mason <chris.mason@oracle.com>

On Thu, Sep 03, 2009 at 03:52:01PM +1000, Dave Chinner wrote:
> > XFS did the mistake of trusting the VM, while everyone more or less
> > overrode it.  Removing all those checks and writing out much larger
> > data fixes it with a relatively small patch:
> > 
> > 	http://verein.lst.de/~hch/xfs/xfs-writeback-scaling
> 
> Careful:
> 
> -	tloff = min(tlast, startpage->index + 64);
> +	tloff = min(tlast, startpage->index + 8192);
> 
> That will cause 64k page machines to try to write back 512MB at a
> time. This will re-introduce similar to the behaviour in sles9 where
> writeback would only terminate at the end of an extent (because the
> mapping end wasn't capped like above).

Pretty good point, any applies to all the different things we discussed
recently.  Ted, should be maybe introduce a max_writeback_mb instead of
the max_writeback_pages in the VM, too?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
