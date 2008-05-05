Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 May 2008 11:43:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m45IheVn015874
	for <xfs@oss.sgi.com>; Mon, 5 May 2008 11:43:41 -0700
Date: Mon, 5 May 2008 14:44:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Don't use d_alloc_anon for open_by_handle
Message-ID: <20080505184424.GA25933@infradead.org>
References: <20080501070244.GH108924158@sgi.com> <1209693339-4861-1-git-send-email-xaiki@sgi.com> <20080502060654.GA23912@infradead.org> <ncczlr5b6pt.fsf@sgi.com> <20080505095316.GA23934@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505095316.GA23934@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com, gnb@sgi.com

On Mon, May 05, 2008 at 05:53:16AM -0400, Christoph Hellwig wrote:
> It shouldn't be slow.  You'd do the equivalent no_subtree check export
> without parent fh, so what we do is call the fh_to_dentry method
> and then call find_acceptable_alias to check if there's already an
> dentry around and if yes use that one.  That latter part is what should
> fix your problem.  If you want to be lazy you could just copy
> find_acceptable_alias into the xfs code and call it directly and let me
> clean up the mess later..

Sorry, this was written before my cup of tea in the morning.
find_acceptable_alias is of course a no-op in the no_subtree_check case,
and thus it's identical to what we're currently doing in the handle
code.  So any problem you see here will also be seen in an nfs
environment with no_subtree_check, which is the sensible choise and
I think even the default these days.  So we'd better fix the lacking
expiry in the core code.  Cc'ing Greg as he's been fighting this code
quite a bit in the past.
