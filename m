Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 Nov 2007 12:26:18 -0800 (PST)
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.180])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA6KQ1jx011466
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2007 12:26:10 -0800
Received: by py-out-1112.google.com with SMTP id u77so4148314pyb
        for <xfs@oss.sgi.com>; Tue, 06 Nov 2007 12:26:06 -0800 (PST)
Message-ID: <64bb37e0711061226l48dce395ub2f9539efc66ecc0@mail.gmail.com>
Date: Tue, 6 Nov 2007 21:26:05 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Subject: Re: writeout stalls in current -git
In-Reply-To: <1194375682.6289.88.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <393903856.06449@ustc.edu.cn> <E1InmAI-0003ME-2i@localhost>
	 <1193998532.27652.343.camel@twins>
	 <64bb37e0711021222q7d12c825mc62d433c4fe19e8@mail.gmail.com>
	 <20071102204258.GR995458@sgi.com>
	 <64bb37e0711040319l5de285c3xea64474540a51b6e@mail.gmail.com>
	 <20071105014510.GU66820511@sgi.com>
	 <64bb37e0711051027v49869699s9593ea54713b15ff@mail.gmail.com>
	 <20071106042527.GT995458@sgi.com> <1194375682.6289.88.camel@twins>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Chinner <dgc@sgi.com>, Fengguang Wu <wfg@mail.ustc.edu.cn>, Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On 11/6/07, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2007-11-06 at 15:25 +1100, David Chinner wrote:
>
> > I'm struggling to understand what possible changed in XFS or writeback that
> > would lead to stalls like this, esp. as you appear to be removing files when
> > the stalls occur.
>
> Just a crazy idea,..
>
> Could there be a set_page_dirty() that doesn't have
> balance_dirty_pages() call near? For example modifying meta data in
> unlink?
>
> Such a situation could lead to an excess of dirty pages and the next
> call to balance_dirty_pages() would appear to stall, as it would
> desperately try to get below the limit again.

Only if accounting of the dirty pages is also broken.
In the unmerge testcase I see most of the time only <200kb of dirty
data in /proc/meminfo.

The system has 4Gb of RAM so I'm not sure if it should ever be valid
to stall even the emerge/install testcase.

Torsten

Now building a kernel with the skipped-pages-accounting-patch reverted...
