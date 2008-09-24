Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 10:27:50 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8OHRk8E025366
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 10:27:46 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 33575478A68
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 10:29:20 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id CwHIsYCFS5wi8MR2 for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 10:29:20 -0700 (PDT)
Date: Wed, 24 Sep 2008 13:29:20 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: RFC: adding a crc field to xfs_buf_log_format_t
Message-ID: <20080924172920.GB31993@infradead.org>
References: <20080923172800.GA22047@infradead.org> <20080924010553.GC13705@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080924010553.GC13705@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Sep 24, 2008 at 11:05:53AM +1000, Dave Chinner wrote:
> On Tue, Sep 23, 2008 at 01:28:00PM -0400, Christoph Hellwig wrote:
> > With adding CRC to xfs metadata structures we face an interesting
> > problem.  As we want all the CRCs logged we always have to log the CRC.
> 
> What version of the CRC are you wanting to log? The one that is
> currently in the buffer (i.e. the one we last wrote to disk), or a
> new CRC that covers the changes we just made to the buffer?

The CRC of the block after the just applied changes.

> >> Note that we currently do not log the crc of the block, but
> >> re-created it during log recovery.  With the pending patch to
> >> also checksum the log this should be safe against filesystem
> >> corruption but doesn't really follow the end to end argument.
> 
> The CRC is protecting what is on disk, not what is being changed in
> memory. The model for protection is "write-IO to read-IO", not
> "in-memory change to in-memory change".  That is, the CRC is not
> protecting every single change that is made - it is simply there to
> validate what is on disk is *what we wrote*, and with the current
> re-logging model of the transaction subsystem that means each update
> of the CRC is an "aggregate change" of the object.
> 
> Hence I think that CRC'd log transactions are more than sufficient
> to protect against corruption of the delta changes that get applied
> to CRC protected objects.....

Still feeling a little un-easy about it, but I guess you're right.
Having one proper checksum for the log buffer should be enough, and
we should not worry about the end-to-end argument.  Certainly makes the
implementation a lot simpler, and the operations faster.

> >> Also poking into the buffer to find out whether this is a btree
> >> buffer during log recovery is not a very clean way to implement
> >> this.
> 
> Add the type of buffer to the buffer format structure, that way we
> can poke the buffer to _verify_ it's type rather than having to rely
> on what came off disk. Recording that type will also enable us to
> easily set up the buffer correctly for calculating the CRC at
> writeback at the end of log replay....

We can easily use blf_type for the type of buffer, that's what I had
changed the btree patch to after posting it.
