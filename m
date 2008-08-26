Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Aug 2008 12:12:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7QJCLoZ032345
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2008 12:12:21 -0700
Date: Tue, 26 Aug 2008 15:13:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: REVIEW: Fix xfs_check SEGV when encountering an unreadable
	block
Message-ID: <20080826191344.GA30481@infradead.org>
References: <op.udjgr6qc3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.udjgr6qc3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Jun 30, 2008 at 11:51:32AM +1000, Barry Naujok wrote:
> xfs_check (xfs_db "check" command) internally uses a stack for I/Os
> it reads/writes. In the check command, there are a few places where
> the I/O stack is pushed, a read is issued and the read fails but
> does not pop the stack location back.
>
> In nested uses of this stack, the caller then accesses this un-popped
> block which the data pointer is "NULL" causing a SEGV.
>
> I've checked all calls to push_cur()/set_cur() to make sure all
> failures call pop_cur().

Looks good to me.
