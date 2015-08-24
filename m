Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B44167F37
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 12:11:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 458EEAC004
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 10:11:49 -0700 (PDT)
Received: from mail-qk0-f181.google.com (mail-qk0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	o2XKwoJaN0dDgECY (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Aug 2015 10:11:47 -0700 (PDT)
Received: by qkda128 with SMTP id a128so27402055qkd.3
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 10:11:47 -0700 (PDT)
Date: Mon, 24 Aug 2015 13:11:44 -0400
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150824171144.GB27262@mtj.duckdns.org>
References: <20150818195439.GB15739@mtj.duckdns.org>
	<20150818215611.GD3902@dastard>
	<20150821102053.GL17933@dhcp-13-216.nay.redhat.com>
	<20150822003025.GS3902@dastard>
	<20150822044609.GM17933@dhcp-13-216.nay.redhat.com>
	<20150824011123.GA714@dastard>
	<20150824031816.GO17933@dhcp-13-216.nay.redhat.com>
	<20150824062425.GU3902@dastard>
	<20150824091959.GA2936@quack.suse.cz>
	<20150824145150.GA10029@mtj.duckdns.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150824145150.GA10029@mtj.duckdns.org>
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
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, Eryu Guan <eguan@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, axboe@fb.com, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, kernel-team@fb.com

Hello,

On Mon, Aug 24, 2015 at 10:51:50AM -0400, Tejun Heo wrote:
> > Bah, I see the problem and indeed it was introduced by commit e79729123f639
> > "writeback: don't issue wb_writeback_work if clean". The problem is that
> > we bail out of sync_inodes_sb() if there is no dirty IO. Which is wrong
> > because we have to wait for any outstanding IO (i.e. call wait_sb_inodes())
> > regardless of dirty state! And that also explains why Tejun's patch fixes
> > the problem because it backs out the change to the exit condition in
> > sync_inodes_sb().
> 
> Dang, I'm an idiot sandwich.

A question tho, so this means that an inode may contain dirty or
writeback pages w/o the inode being on one of the dirty lists.
Looking at the generic filesystem and writeback code, this doesn't
seem true in general.  Is this something xfs specific?

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
