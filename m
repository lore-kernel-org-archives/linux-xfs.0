Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Jan 2007 02:27:41 -0800 (PST)
Received: from smtp102.mail.mud.yahoo.com (smtp102.mail.mud.yahoo.com [209.191.85.212])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0PARWqw032728
	for <xfs@oss.sgi.com>; Thu, 25 Jan 2007 02:27:33 -0800
Message-ID: <45B885CE.4030206@yahoo.com.au>
Date: Thu, 25 Jan 2007 21:26:22 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2]: Fix BUG in cancel_dirty_pages on XFS
References: <1169640835.6189.14.camel@twins> <45B7627B.8050202@yahoo.com.au> <20070124224654.GN33919298@melbourne.sgi.com> <45B7F5F9.2070308@yahoo.com.au> <20070125003536.GS33919298@melbourne.sgi.com> <45B7FE1C.3070807@yahoo.com.au> <20070125015204.GV33919298@melbourne.sgi.com> <45B80F65.6010206@yahoo.com.au> <20070125034227.GX33919298@melbourne.sgi.com> <45B83139.1040007@yahoo.com.au> <20070125074018.GB33919298@melbourne.sgi.com>
In-Reply-To: <20070125074018.GB33919298@melbourne.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@osdl.org

David Chinner wrote:

> Only if we leave the page in the page cache. If we toss the page,
> the time it takes to do the I/O for the page fault is enough for
> the direct I/o to complete. Sure it's not an absolute guarantee,
> but if you want an absolute guarantee:

So I guess you *could* relax it in theory... Anyway, don't take
my pestering as advocacy for wanting XFS to do something more
clever in such a corner case. I think you're quite right to be
conservative and share codepaths between direct IO read and
write.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
