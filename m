Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 220407F37
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 16:45:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E7646304032
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 14:45:39 -0700 (PDT)
Received: from mail-yk0-f169.google.com (mail-yk0-f169.google.com
	[209.85.160.169]) by cuda.sgi.com with ESMTP id
	RclsvnP5PTQI1qNr (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Aug 2015 14:45:38 -0700 (PDT)
Received: by ykfw73 with SMTP id w73so136618146ykf.3
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 14:45:37 -0700 (PDT)
Date: Mon, 24 Aug 2015 17:45:35 -0400
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150824214535.GM28944@mtj.duckdns.org>
References: <20150822044609.GM17933@dhcp-13-216.nay.redhat.com>
	<20150824011123.GA714@dastard>
	<20150824031816.GO17933@dhcp-13-216.nay.redhat.com>
	<20150824062425.GU3902@dastard>
	<20150824091959.GA2936@quack.suse.cz>
	<20150824145150.GA10029@mtj.duckdns.org>
	<20150824171144.GB27262@mtj.duckdns.org>
	<20150824190847.GA4234@quack.suse.cz>
	<20150824193242.GE28944@mtj.duckdns.org>
	<20150824210927.GA8823@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150824210927.GA8823@quack.suse.cz>
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

On Mon, Aug 24, 2015 at 11:09:27PM +0200, Jan Kara wrote:
> It is inefficient, yes. But note that 'writeback' and 'dirty' states are
> completely independent. Page can be in any of the !dirty & !writeback,

That isn't true for pages being dirtied through set_page_dirty().
It's guaranteed that a dirty inode remains on one of the b_* lists
till there's no dirty page and writeback is complete.

> dirty & !writeback, !dirty & writeback, dirty & writeback states. So mixing
> tracking of writeback and dirty state of an inode just makes the code even
> messier.

I'm curious where and why they would deviate.  Can you give me some
examples?  AFAICS, anything which uses the usual set_page_dirty() path
shouldn't do that.

> > > a list to track inodes with pages under writeback but they clashed with
> > > your patch series and they didn't get rebased yet AFAIR.
> > 
> > Wouldn't it make more sense to simply put them on one of the existing
> > b_* lists?
> 
> Logically it just doesn't make sense because as I wrote above dirty and
> writeback states are completely independent. Also you'd have to detect &
> skip inodes that don't really have any dirty pages to write and all the
> detection of "is there any data to write" would get more complicated. A
> separate list for inodes under writeback as Josef did is IMO the cleanest
> solution.

Given that the usual code path tracks dirty and writeback together, I
don't think it's nonsensical; however, I'm more curious how common
writeback w/o dirtying case is.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
