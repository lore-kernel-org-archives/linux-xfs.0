Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 00:01:49 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O71jD5022515
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 00:01:45 -0700
Message-ID: <48D9E631.3080103@sgi.com>
Date: Wed, 24 Sep 2008 17:03:13 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: RFC: adding a crc field to xfs_buf_log_format_t
References: <20080923172800.GA22047@infradead.org> <20080924010553.GC13705@disturbed>
In-Reply-To: <20080924010553.GC13705@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Dave Chinner wrote:
> On Tue, Sep 23, 2008 at 01:28:00PM -0400, Christoph Hellwig wrote:
>> With adding CRC to xfs metadata structures we face an interesting
>> problem.  As we want all the CRCs logged we always have to log the CRC.
> 
> What version of the CRC are you wanting to log? The one that is
> currently in the buffer (i.e. the one we last wrote to disk), or a
> new CRC that covers the changes we just made to the buffer?
> 
> In the first case, I can't see how having that CRC in the
> transaction helps in recovery at all. Algorithmically, if all
> buffers have a crc32c in them, then the buffers should CRC to zero
> when you include the CRC value in the calculation. Hence during log
> recovery when we read a buffer in for the first time, we simply need
> to check that the buffer CRC is zero. Hence we can verify that we've
> read an uncorrupted buffer regardless of it's type or location of
> the crc value in the buffer.
> 
> In the second case, that means every transaction commit has to
> recalculate the CRC for every buffer modified to insert them into
> the transaction. That means we need to peak into the buffer type
> during transaction commit to determine where the CRC is and
> extract that. There's a *lot* of CPU overhead there, especially
> for heavily re-logged buffers, and once again I don't think it
> buys us anything because we still need to verify the CRC is
> correct before we write the buffer to disk at the end of log
> replay...
> 
> I note that from your previous patch set you make these comments:
> 
>>> Note that we currently do not log the crc of the block, but
>>> re-created it during log recovery.  With the pending patch to
>>> also checksum the log this should be safe against filesystem
>>> corruption but doesn't really follow the end to end argument.
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
> 
Thanks for the clarification.
I haven't looked at the CRC of the transactions yet - need to find
that patch.
But it seems to make sense to just apply CRC's to metadata or log data
that is going to disk and keep things simple - as we are targetting
corruption of on-disk meta data by outside things.

--Tim
