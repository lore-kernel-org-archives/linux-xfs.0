Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Sep 2007 01:57:03 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8P8uuQ3006842
	for <xfs@oss.sgi.com>; Tue, 25 Sep 2007 01:56:59 -0700
Date: Tue, 25 Sep 2007 09:28:56 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] lose xfs_hex_dump in favor of print_hex_dump
Message-ID: <20070925082856.GA9786@infradead.org>
References: <46F85240.1060206@sandeen.net> <20070925003232.GA26663@puku.stupidest.org> <46F86501.7070605@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F86501.7070605@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Chris Wedgwood <cw@f00f.org>, xfs-oss <xfs@oss.sgi.com>

On Mon, Sep 24, 2007 at 08:31:45PM -0500, Eric Sandeen wrote:
> >> +void
> >> +xfs_hex_dump(void *p, int length)
> >> +{
> >> +	print_hex_dump(KERN_ALERT, "", DUMP_PREFIX_OFFSET, 16, 1, p, length, 1);
> >> +}
> > 
> > Is this symbol exported/needed?  If not then why not make it a #define
> > or an inline in the header where you have the prototype?
> 
> Yeah, I suppose that might be better....  I just followed the lead of
> xfs_cmn_err etc.
> 
> The only reason I left a wrapper was for cattelan's BSD exploits 
> (er, adventures)  ;-)  I could imagine it getting called from other places, 
> but for now it only has one caller, xfs_corruption_error (so really, even 
> the length argument is never anything other than 16...)

No point in making anything in an absolute slowpath inline or a macro.
I think the patch is fine as-is.
