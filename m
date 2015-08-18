Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3AA787F56
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 12:47:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BBC3DAC00F
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 10:47:26 -0700 (PDT)
Received: from mail-pd0-f173.google.com (mail-pd0-f173.google.com
	[209.85.192.173]) by cuda.sgi.com with ESMTP id
	Cw8arkV9JRu88Meh (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 18 Aug 2015 10:47:22 -0700 (PDT)
Received: by pdob1 with SMTP id b1so15068616pdo.2
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 10:47:21 -0700 (PDT)
Date: Tue, 18 Aug 2015 10:47:18 -0700
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150818174718.GA15739@mtj.duckdns.org>
References: <20150812101204.GE17933@dhcp-13-216.nay.redhat.com>
	<20150813004435.GN3902@dastard>
	<20150813224415.GG4496@mtj.duckdns.org>
	<20150814111408.GB8710@quack.suse.cz>
	<20150817200254.GG21075@mtj.duckdns.org>
	<20150818091603.GA12317@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150818091603.GA12317@quack.suse.cz>
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

On Tue, Aug 18, 2015 at 11:16:03AM +0200, Jan Kara wrote:
> On Mon 17-08-15 16:02:54, Tejun Heo wrote:
> > Hello, Jan.
> > 
> > On Fri, Aug 14, 2015 at 01:14:09PM +0200, Jan Kara wrote:
> > > So the patch looks good to me. But the fact that is fixes Eryu's problem
> > > means there is something fishy going on. Either inodes get wrongly attached
> > 
> > Seriously, it shouldn't affect size syncing or xfs but then again my
> > understanding of xfs is severely limited.
> 
> Well, i_size == 0 in XFS usually means that writeback didn't get to
> flushing delay allocated pages - inode size on disk gets increased only
> after the pages are written out in ->end_io callback. So at least this part
> makes some sense to me.

Hmm... the only possibility I can think of is tot_write_bandwidth
being zero when it shouldn't be.  I've been staring at the code for a
while now but nothing rings a bell.  Time for another debug patch, I
guess.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
