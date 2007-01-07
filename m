Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 07 Jan 2007 14:49:14 -0800 (PST)
Received: from smtp.osdl.org (smtp.osdl.org [65.172.181.24])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l07Mn7qw012412
	for <xfs@oss.sgi.com>; Sun, 7 Jan 2007 14:49:08 -0800
Date: Sun, 7 Jan 2007 14:48:12 -0800
From: Andrew Morton <akpm@osdl.org>
Subject: Re: BUG: warning at mm/truncate.c:60/cancel_dirty_page()
Message-Id: <20070107144812.96357ff9.akpm@osdl.org>
In-Reply-To: <20070107222341.GT33919298@melbourne.sgi.com>
References: <20070106023907.GA7766@m.safari.iki.fi>
	<Pine.LNX.4.64.0701062051570.24997@blonde.wat.veritas.com>
	<20070107222341.GT33919298@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, Sami Farin <7atbggg02@sneakemail.com>, Nathan Scott <nathans@sgi.com>, xfs@oss.sgi.com, Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org

On Mon, 8 Jan 2007 09:23:41 +1100
David Chinner <dgc@sgi.com> wrote:

> How are you supposed to invalidate a range of pages in a mapping for
> this case, then? invalidate_mapping_pages() would appear to be the
> candidate (the generic code uses this), but it _skips_ pages that
> are already mapped.

unmap_mapping_range()?

> So, am I correct in assuming we should be calling invalidate_inode_pages2_range()
> instead of truncate_inode_pages()?

That would be conventional.
