Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 081BE7F3F
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 11:59:01 -0600 (CST)
Message-ID: <52B090E1.2020805@sgi.com>
Date: Tue, 17 Dec 2013 11:58:57 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 5/6] xfs: xlog_recover_process_data leaks like a sieve
References: <1386826478-13846-1-git-send-email-david@fromorbit.com>
	<1386826478-13846-6-git-send-email-david@fromorbit.com>
	<20131213123205.GA17935@infradead.org>
	<20131213221102.GX10988@dastard>
	<20131216152339.GC12360@infradead.org>
In-Reply-To: <20131216152339.GC12360@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 12/16/13 09:23, Christoph Hellwig wrote:
> On Sat, Dec 14, 2013 at 09:11:02AM +1100, Dave Chinner wrote:
>> >  I'll rework it, but hte main issue is that it has to be freed
>> >  regardless of the error value in commit record processing, so it's
>> >  not as simple as just freeing it on error....
> Indeed, but think that's another reason to move the freeing to
> xlog_recover_process_data.  Right now or with the proposed patch
> xlog_recover_commit_trans frees trans, but there's nothing that
> breaks out of the loop in xlog_recover_process_data after that case.
>
> By moving the freeing there for all cases we can add a corruption
> check for that case, and we have a single function that controls
> the lifetime of the xlog_recover structure.

I like that idea of doing the frees in xlog_recover_process_data().
Each loop allocates a new trans, so each loop is self contained.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
