Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D39D77F37
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 16:09:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B485E8F8033
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 14:09:34 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id bD4GXBcBG7uVXWqe (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Aug 2015 14:09:33 -0700 (PDT)
Date: Mon, 24 Aug 2015 23:09:27 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150824210927.GA8823@quack.suse.cz>
References: <20150822003025.GS3902@dastard>
	<20150822044609.GM17933@dhcp-13-216.nay.redhat.com>
	<20150824011123.GA714@dastard>
	<20150824031816.GO17933@dhcp-13-216.nay.redhat.com>
	<20150824062425.GU3902@dastard>
	<20150824091959.GA2936@quack.suse.cz>
	<20150824145150.GA10029@mtj.duckdns.org>
	<20150824171144.GB27262@mtj.duckdns.org>
	<20150824190847.GA4234@quack.suse.cz>
	<20150824193242.GE28944@mtj.duckdns.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150824193242.GE28944@mtj.duckdns.org>
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
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, axboe@fb.com, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, kernel-team@fb.com

On Mon 24-08-15 15:32:42, Tejun Heo wrote:
> Hello, Jan.
> 
> On Mon, Aug 24, 2015 at 09:08:47PM +0200, Jan Kara wrote:
> > Inode may contain writeback pages (but not dirty pages) without being on
> > any of the dirty lists. That is correct. Josef Bacik had patches to create
> 
> Hmmm... Can you please expand on how / why that happens?  It's kinda
> weird to require writeback to walk all inodes regardless of their
> dirty states.

It is inefficient, yes. But note that 'writeback' and 'dirty' states are
completely independent. Page can be in any of the !dirty & !writeback,
dirty & !writeback, !dirty & writeback, dirty & writeback states. So mixing
tracking of writeback and dirty state of an inode just makes the code even
messier.

> > a list to track inodes with pages under writeback but they clashed with
> > your patch series and they didn't get rebased yet AFAIR.
> 
> Wouldn't it make more sense to simply put them on one of the existing
> b_* lists?

Logically it just doesn't make sense because as I wrote above dirty and
writeback states are completely independent. Also you'd have to detect &
skip inodes that don't really have any dirty pages to write and all the
detection of "is there any data to write" would get more complicated. A
separate list for inodes under writeback as Josef did is IMO the cleanest
solution.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
