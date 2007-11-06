Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 Nov 2007 11:18:33 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA6JIQBR032278
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2007 11:18:27 -0800
Subject: Re: writeout stalls in current -git
From: Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20071106042527.GT995458@sgi.com>
References: <393903856.06449@ustc.edu.cn>
	 <64bb37e0711011120i63cdfe3ci18995d57b6649a8@mail.gmail.com>
	 <64bb37e0711011200n228e708eg255640388f83da22@mail.gmail.com>
	 <E1InmAI-0003ME-2i@localhost> <1193998532.27652.343.camel@twins>
	 <64bb37e0711021222q7d12c825mc62d433c4fe19e8@mail.gmail.com>
	 <20071102204258.GR995458@sgi.com>
	 <64bb37e0711040319l5de285c3xea64474540a51b6e@mail.gmail.com>
	 <20071105014510.GU66820511@sgi.com>
	 <64bb37e0711051027v49869699s9593ea54713b15ff@mail.gmail.com>
	 <20071106042527.GT995458@sgi.com>
Content-Type: text/plain
Date: Tue, 06 Nov 2007 20:01:22 +0100
Message-Id: <1194375682.6289.88.camel@twins>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>, Fengguang Wu <wfg@mail.ustc.edu.cn>, Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Tue, 2007-11-06 at 15:25 +1100, David Chinner wrote:

> I'm struggling to understand what possible changed in XFS or writeback that
> would lead to stalls like this, esp. as you appear to be removing files when
> the stalls occur. 

Just a crazy idea,..

Could there be a set_page_dirty() that doesn't have
balance_dirty_pages() call near? For example modifying meta data in
unlink?

Such a situation could lead to an excess of dirty pages and the next
call to balance_dirty_pages() would appear to stall, as it would
desperately try to get below the limit again.
