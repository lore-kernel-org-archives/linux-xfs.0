Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9C2DF7F3F
	for <xfs@oss.sgi.com>; Mon, 16 Dec 2013 09:23:40 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 21103AC003
	for <xfs@oss.sgi.com>; Mon, 16 Dec 2013 07:23:39 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id O3HVaAybwTSZXIcT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 16 Dec 2013 07:23:39 -0800 (PST)
Date: Mon, 16 Dec 2013 07:23:39 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] xfs: xlog_recover_process_data leaks like a sieve
Message-ID: <20131216152339.GC12360@infradead.org>
References: <1386826478-13846-1-git-send-email-david@fromorbit.com>
	<1386826478-13846-6-git-send-email-david@fromorbit.com>
	<20131213123205.GA17935@infradead.org>
	<20131213221102.GX10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131213221102.GX10988@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sat, Dec 14, 2013 at 09:11:02AM +1100, Dave Chinner wrote:
> I'll rework it, but hte main issue is that it has to be freed
> regardless of the error value in commit record processing, so it's
> not as simple as just freeing it on error....

Indeed, but think that's another reason to move the freeing to
xlog_recover_process_data.  Right now or with the proposed patch
xlog_recover_commit_trans frees trans, but there's nothing that
breaks out of the loop in xlog_recover_process_data after that case.

By moving the freeing there for all cases we can add a corruption
check for that case, and we have a single function that controls
the lifetime of the xlog_recover structure.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
