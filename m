Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3942F7F58
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 14:54:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C6587AC00F
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 12:54:43 -0700 (PDT)
Received: from mail-pa0-f49.google.com (mail-pa0-f49.google.com
	[209.85.220.49]) by cuda.sgi.com with ESMTP id RDDHpUoqdAZAFhPk
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 18 Aug 2015 12:54:42 -0700 (PDT)
Received: by pacgr6 with SMTP id gr6so139442135pac.2
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 12:54:41 -0700 (PDT)
Date: Tue, 18 Aug 2015 12:54:39 -0700
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block/for-linus] writeback: fix syncing of I_DIRTY_TIME
	inodes
Message-ID: <20150818195439.GB15739@mtj.duckdns.org>
References: <20150812101204.GE17933@dhcp-13-216.nay.redhat.com>
	<20150813004435.GN3902@dastard>
	<20150813224415.GG4496@mtj.duckdns.org>
	<20150814111408.GB8710@quack.suse.cz>
	<20150817200254.GG21075@mtj.duckdns.org>
	<20150818091603.GA12317@quack.suse.cz>
	<20150818174718.GA15739@mtj.duckdns.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150818174718.GA15739@mtj.duckdns.org>
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

On Tue, Aug 18, 2015 at 10:47:18AM -0700, Tejun Heo wrote:
> Hmm... the only possibility I can think of is tot_write_bandwidth
> being zero when it shouldn't be.  I've been staring at the code for a
> while now but nothing rings a bell.  Time for another debug patch, I
> guess.

So, I can now reproduce the bug (it takes a lot of trials but lowering
the number of tested files helps quite a bit) and instrumented all the
early exit paths w/o the fix patch.  bdi_has_dirty_io() and
wb_has_dirty_io() are never out of sync with the actual dirty / io
lists even when the test 048 fails, so the bug at least is not caused
by writeback skipping due to buggy bdi/wb_has_dirty_io() result.
Whenever it skips, all the lists are actually empty (verified while
holding list_lock).

One suspicion I have is that this could be a subtle timing issue which
is being exposed by the new short-cut path.  Anything which adds delay
seems to make the issue go away.  Dave, does anything ring a bell?

As for the proposed I_DIRTY_TIME fix, I think it'd be a good idea to
merge it.  It fixes a clear brekage regardless of this xfs issue.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
