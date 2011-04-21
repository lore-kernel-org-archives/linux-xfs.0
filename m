Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3LKf8p7175670 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 15:41:08 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8A7B31E12556
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 13:44:36 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id ZosoXGaXJNBDndjO for <xfs@oss.sgi.com>;
	Thu, 21 Apr 2011 13:44:36 -0700 (PDT)
Date: Thu, 21 Apr 2011 22:44:34 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: buffered writeback torture program
Message-ID: <20110421204434.GF4476@quack.suse.cz>
References: <1303322378-sup-1722@think> <20110420220626.GL29872@redhat.com>
	<1303383609-sup-2330@think> <1303399343-sup-9292@think>
	<20110421165529.GE4476@quack.suse.cz> <1303404971-sup-7825@think>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1303404971-sup-7825@think>
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
To: Chris Mason <chris.mason@oracle.com>
Cc: axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, xfs <xfs@oss.sgi.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

On Thu 21-04-11 12:57:17, Chris Mason wrote:
> Excerpts from Jan Kara's message of 2011-04-21 12:55:29 -0400:
> > On Thu 21-04-11 11:25:41, Chris Mason wrote:
> > > Excerpts from Chris Mason's message of 2011-04-21 07:09:11 -0400:
> > > > Excerpts from Vivek Goyal's message of 2011-04-20 18:06:26 -0400:
> > > > > > 
> > > > > > In this case the 128s spent in write was on a single 4K overwrite on a
> > > > > > 4K file.
> > > > > 
> > > > > Chris, You seem to be doing 1MB (32768*32) writes on fsync file instead of 4K.
> > > > > I changed the size to 4K still not much difference though.
> > > > 
> > > > Whoops, I had that change made locally but didn't get it copied out.
> > > > 
> > > > > 
> > > > > Once the program has exited because of high write time, i restarted it and
> > > > > this time I don't see high write times.
> > > > 
> > > > I see this for some of my runs as well.
> > > > 
> > > > > 
> > > > > First run
> > > > > ---------
> > > > > # ./a.out 
> > > > > setting up random write file
> > > > > done setting up random write file
> > > > > starting fsync run
> > > > > starting random io!
> > > > > write time: 0.0006s fsync time: 0.3400s
> > > > > write time: 63.3270s fsync time: 0.3760s
> > > > > run done 2 fsyncs total, killing random writer
> > > > > 
> > > > > Second run
> > > > > ----------
> > > > > # ./a.out 
> > > > > starting fsync run
> > > > > starting random io!
> > > > > write time: 0.0006s fsync time: 0.5359s
> > > > > write time: 0.0007s fsync time: 0.3559s
> > > > > write time: 0.0009s fsync time: 0.3113s
> > > > > write time: 0.0008s fsync time: 0.4336s
> > > > > write time: 0.0009s fsync time: 0.3780s
> > > > > write time: 0.0008s fsync time: 0.3114s
> > > > > write time: 0.0009s fsync time: 0.3225s
> > > > > write time: 0.0009s fsync time: 0.3891s
> > > > > write time: 0.0009s fsync time: 0.4336s
> > > > > write time: 0.0009s fsync time: 0.4225s
> > > > > write time: 0.0009s fsync time: 0.4114s
> > > > > write time: 0.0007s fsync time: 0.4004s
> > > > > 
> > > > > Not sure why would that happen.
> > > > > 
> > > > > I am wondering why pwrite/fsync process was throttled. It did not have any
> > > > > pages in page cache and it shouldn't have hit the task dirty limits. Does that
> > > > > mean per task dirty limit logic does not work or I am completely missing
> > > > > the root cause of the problem.
> > > > 
> > > > I haven't traced it to see.  This test box only has 1GB of ram, so the
> > > > dirty ratios can be very tight.
> > > 
> > > Oh, I see now.  The test program first creates the file with a big
> > > streaming write.  So the task doing the streaming writes gets nailed
> > > with the per-task dirty accounting because it is making a ton of dirty
> > > data.
> > > 
> > > Then the task forks the random writer to do all the random IO.
> > > 
> > > Then the original pid goes back to do the fsyncs on the new file.
> > > 
> > > So, in the original run, we get stuffed into balance_dirty_pages because
> > > the per-task limits show we've done a lot of dirties.
> > > 
> > > In all later runs, the file already exists, so our fsyncing process
> > > hasn't done much dirtying at all.  Looks like the VM is doing something
> > > sane, we just get nailed with big random IO.
> >   Ok, so there isn't a problem with fsync() as such if I understand it
> > right. We just block tasks in balance_dirty_pages() for a *long* time
> > because it takes long time to write out that dirty IO and we make it even
> > worse by trying to writeout more on behalf of the throttled task. Am I
> > right? The IO-less throttling will solve this regardless of patchset we
> > choose so I wouldn't be too worried about the problem now.
> 
> You're right.  With one small exception, we probably do want to rotor
> out of the random buffered writes in hopes of finding some sequential IO
> even with the IO-less dirty throttling.
  Flusher thread should do this - it writes at most 1024 pages (as much as
->writepages call does) from the big file and then put inode to b_more_io
queue and go on with the next dirty inode. So if there is some sequential
IO as well, we should get to it...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
