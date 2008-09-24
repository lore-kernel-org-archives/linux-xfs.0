Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Sep 2008 18:04:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O14P7l021717
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 18:04:25 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 166A5474F1F
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 18:05:59 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id nCkXPRIDp7HVcaUU for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 18:05:59 -0700 (PDT)
Date: Wed, 24 Sep 2008 11:05:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: RFC: adding a crc field to xfs_buf_log_format_t
Message-ID: <20080924010553.GC13705@disturbed>
References: <20080923172800.GA22047@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923172800.GA22047@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Sep 23, 2008 at 01:28:00PM -0400, Christoph Hellwig wrote:
> With adding CRC to xfs metadata structures we face an interesting
> problem.  As we want all the CRCs logged we always have to log the CRC.

What version of the CRC are you wanting to log? The one that is
currently in the buffer (i.e. the one we last wrote to disk), or a
new CRC that covers the changes we just made to the buffer?

In the first case, I can't see how having that CRC in the
transaction helps in recovery at all. Algorithmically, if all
buffers have a crc32c in them, then the buffers should CRC to zero
when you include the CRC value in the calculation. Hence during log
recovery when we read a buffer in for the first time, we simply need
to check that the buffer CRC is zero. Hence we can verify that we've
read an uncorrupted buffer regardless of it's type or location of
the crc value in the buffer.

In the second case, that means every transaction commit has to
recalculate the CRC for every buffer modified to insert them into
the transaction. That means we need to peak into the buffer type
during transaction commit to determine where the CRC is and
extract that. There's a *lot* of CPU overhead there, especially
for heavily re-logged buffers, and once again I don't think it
buys us anything because we still need to verify the CRC is
correct before we write the buffer to disk at the end of log
replay...

I note that from your previous patch set you make these comments:

>> Note that we currently do not log the crc of the block, but
>> re-created it during log recovery.  With the pending patch to
>> also checksum the log this should be safe against filesystem
>> corruption but doesn't really follow the end to end argument.

The CRC is protecting what is on disk, not what is being changed in
memory. The model for protection is "write-IO to read-IO", not
"in-memory change to in-memory change".  That is, the CRC is not
protecting every single change that is made - it is simply there to
validate what is on disk is *what we wrote*, and with the current
re-logging model of the transaction subsystem that means each update
of the CRC is an "aggregate change" of the object.

Hence I think that CRC'd log transactions are more than sufficient
to protect against corruption of the delta changes that get applied
to CRC protected objects.....

>> Also poking into the buffer to find out whether this is a btree
>> buffer during log recovery is not a very clean way to implement
>> this.

Add the type of buffer to the buffer format structure, that way we
can poke the buffer to _verify_ it's type rather than having to rely
on what came off disk. Recording that type will also enable us to
easily set up the buffer correctly for calculating the CRC at
writeback at the end of log replay....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
