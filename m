Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8T6CrgV026143 for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 01:12:55 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BAE4018846D7
	for <xfs@oss.sgi.com>; Tue, 28 Sep 2010 23:13:52 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id guC63vE8p9rEL9Ol for
	<xfs@oss.sgi.com>; Tue, 28 Sep 2010 23:13:52 -0700 (PDT)
Date: Wed, 29 Sep 2010 02:13:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: reduce lock traffic on incore sb lock
Message-ID: <20100929061351.GA20921@infradead.org>
References: <1285721500-5671-1-git-send-email-david@fromorbit.com>
	<20100929040425.GA29691@infradead.org>
	<20100929055748.GK5665@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100929055748.GK5665@dastard>
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
Cc: xfs@oss.sgi.com

On Wed, Sep 29, 2010 at 03:57:48PM +1000, Dave Chinner wrote:
> FWIW, I've got a prototype that converts the per-cpu counters to the
> generic per-cpu counter infrastructure. It chops out almost all the
> xfs_icsb_* stuff (including xfs_icsb_modify_counters()) and has a
> diffstat of:

Sounds good - I always throught of the balanced per-cpu counters as
infrastructure that really shouldn't sit inside XFS.

> It needs a significant cleanup of xfs_mod_incore_sb() before/after
> the conversion which I haven't done yet because I haven't quite got
> my new percpu_counter_test_and_add_delta() function working
> correctly yet. I spotted this locking problem when testing the
> patch...
> 
> That said, there's no reason why my percpu counter code needs to run
> through xfs_mod_incore_sb() at all. If we have a separate path for
> per-cpu counters then I can rework my code on top of that....

We'll always need a low-level function to to the actual superblock
updates and a high-level one modifying the per-cpu counters.  I don't
think the exact naming matters too much.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
