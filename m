Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 May 2008 02:52:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m459qXYo013998
	for <xfs@oss.sgi.com>; Mon, 5 May 2008 02:52:34 -0700
Date: Mon, 5 May 2008 05:53:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Don't use d_alloc_anon for open_by_handle
Message-ID: <20080505095316.GA23934@infradead.org>
References: <20080501070244.GH108924158@sgi.com> <1209693339-4861-1-git-send-email-xaiki@sgi.com> <20080502060654.GA23912@infradead.org> <ncczlr5b6pt.fsf@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ncczlr5b6pt.fsf@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-dev@sgi.com, xfs@oss.sgi.com

On Mon, May 05, 2008 at 04:33:34PM +1000, Niv Sardi wrote:
> >
> > No, this is even more buggy than using d_alloc_anon.
> 
> I must be missing a point here, can you please further explain why is it
> buggy ? We are indeed abusing the normal dentry life, but that's what we
> want libhandle to be. i.e. We really don't need it connected, we don't
> need to know anything about that file, we just want to access it.
> 
> > What really needs to be done in the handle code is to do the full
> > reconnect logic nfsd would be doing. 
> 
> That would be slow, and we don't really need it. What is wrong with
> having a temp hanging dentry if it gets thorn appart properly ? The
> dentry we're using never makes it to any kind of cache. We don't even
> have security concerns as the 2 pieces of code can only be triggered by
> root.

It shouldn't be slow.  You'd do the equivalent no_subtree check export
without parent fh, so what we do is call the fh_to_dentry method
and then call find_acceptable_alias to check if there's already an
dentry around and if yes use that one.  That latter part is what should
fix your problem.  If you want to be lazy you could just copy
find_acceptable_alias into the xfs code and call it directly and let me
clean up the mess later..
