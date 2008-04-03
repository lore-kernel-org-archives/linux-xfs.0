Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Apr 2008 14:36:24 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m33LaEIS017625
	for <xfs@oss.sgi.com>; Thu, 3 Apr 2008 14:36:16 -0700
Date: Thu, 3 Apr 2008 14:57:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/7] XFS: Unicode case-insensitive lookup implementation
Message-ID: <20080403185717.GB6045@infradead.org>
References: <20080402062508.017738664@chook.melbourne.sgi.com> <20080402062709.011126702@chook.melbourne.sgi.com> <20080403171450.GB22385@infradead.org> <20080403172400.GC22812@samba1> <20080403184333.GA30595@infradead.org> <20080403184739.GB6100@samba1> <20080403185526.GA6045@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080403185526.GA6045@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeremy Allison <jra@samba.org>
Cc: Christoph Hellwig <hch@infradead.org>, Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Thu, Apr 03, 2008 at 02:55:26PM -0400, Christoph Hellwig wrote:
> On Thu, Apr 03, 2008 at 11:47:39AM -0700, Jeremy Allison wrote:
> > > CI filenames can work perfectly fine without adding validation of file
> > > names by treating non-conformant bytestreams as not having lower/upper
> > > case variants.
> > 
> > Sorry, then I'm not understanding your objection to this patch (and I
> > don't think I understood that sentence :-).
> 
> I objected to the part of the patch I've quoted (and the bitsrelated to
> it), not all of it.  That how we do reviews in kernel land, not sure
> how samba handles it if you have a binary object/don't object policy..

oops, look like the quote actually got deleted accidentally.  sorry
I'ltake that comment back.

The part I object to are the various calls to xfs_unicode_validate
in the namespace operations.
