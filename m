Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:47824 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfF0Nwc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jun 2019 09:52:32 -0400
Date: Thu, 27 Jun 2019 06:52:25 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: KASAN: use-after-free Read in xlog_alloc_log
Message-ID: <20190627135225.GA22423@infradead.org>
References: <000000000000783d99058c489257@google.com>
 <20190627110654.GA13946@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627110654.GA13946@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: syzbot <syzbot+b75afdbe271a0d7ac4f6@syzkaller.appspotmail.com>
Cc: darrick.wong@oracle.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com

On Thu, Jun 27, 2019 at 04:06:54AM -0700, Christoph Hellwig wrote:
> It seems like this is the xlog_alloc_log error path.  We didn't
> really change anything in the circular ioclogs queue handling, so
> maybe thish has been there before, but xfs_buf wasn't wired up to
> kasan to catch it?
> 
> Either way I suspect the right thing to do is to replace the list
> with an array based lookup.  I'll look into that, maybe a reproducer
> appears until then.

Actually, the iclog allocations are obviously too small.  A patch will
be on its way soon.
