Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8C0E77F5A
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 11:19:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 288D9AC009
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 09:19:05 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 3hKIwO8gzybMKypQ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 01 Dec 2014 09:19:03 -0800 (PST)
Date: Mon, 1 Dec 2014 18:18:54 +0100
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH-v4 1/7] vfs: split update_time() into update_time() and
	write_time()
Message-ID: <20141201171854.GH12140@twin.jikos.cz>
References: <1416997437-26092-1-git-send-email-tytso@mit.edu>
	<1416997437-26092-2-git-send-email-tytso@mit.edu>
	<20141126192328.GA20436@infradead.org>
	<20141127144116.GA14091@thunk.org>
	<20141127153315.GC14091@thunk.org>
	<20141127164952.GA1622@infradead.org>
	<20141127202731.GG14091@thunk.org>
	<20141201092810.GA5538@infradead.org>
	<20141201150450.GA3337@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141201150450.GA3337@thunk.org>
Reply-To: dsterba@suse.cz
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>

On Mon, Dec 01, 2014 at 10:04:50AM -0500, Theodore Ts'o wrote:
> On Mon, Dec 01, 2014 at 01:28:10AM -0800, Christoph Hellwig wrote:
> > 
> > The ->is_readonly method seems like a clear winner to me, I'm all for
> > adding it, and thus suggested moving it first in the series.
> 
> It's a real winner for me as well, but the reason why I dropped it is
> because if btrfs() has to keep its ->update_time function, we wouldn't
> actually have a user for is_readonly().  I suppose we could have
> update_time() call ->is_readonly() and then ->update_time() if they
> exist, but it only seemed to add an extra call and a bit of extra
> overhead without really simplifying things for btrfs.

We would use is_readonly in order to remove some extra checks from btrfs
(setxattr, removexattr, possibly setsize).

> If there were other users of ->is_readonly, then it would make sense,
> but it seemed better to move into a separate code refactoring series.

Yeah it would be better addressed separately as it's not the point of
lazytime patchset and only turned out to be a good idea during the
iterations.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
