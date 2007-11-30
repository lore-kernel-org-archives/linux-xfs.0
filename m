Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 30 Nov 2007 15:04:34 -0800 (PST)
Received: from smtp116.sbc.mail.sp1.yahoo.com (smtp116.sbc.mail.sp1.yahoo.com [69.147.64.89])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAUN4SUX032208
	for <linux-xfs@oss.sgi.com>; Fri, 30 Nov 2007 15:04:30 -0800
Date: Fri, 30 Nov 2007 15:04:35 -0800
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: [PATCH] xfs: revert to double-buffering readdir
Message-ID: <20071130230435.GA12626@puku.stupidest.org>
References: <20071114070400.GA25708@puku.stupidest.org> <20071125163014.GA17922@infradead.org> <474FBA21.4070201@sgi.com> <165B249C-FE97-4B27-927B-B39DE316CB23@xfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165B249C-FE97-4B27-927B-B39DE316CB23@xfs.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephen Lord <lord@xfs.org>
Cc: Timothy Shimmin <tes@sgi.com>, Christoph Hellwig <hch@infradead.org>, linux-xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>

On Fri, Nov 30, 2007 at 04:36:25PM -0600, Stephen Lord wrote:

> Looks like the readdir is in the bowels of the btree code when
> filldir gets called here, there are probably locks on several
> buffers in the btree at this point. This will only show up for large
> directories I bet.

I see it for fairly small directories.  Larger than what you can stuff
into an inode but less than a block (I'm not checking but fairly sure
that's the case).

> Just rambling, not a single line of code was consulted in writing
> this message.

Can you explain why the offset is capped and treated in an 'odd way'
at all?

+       curr_offset = filp->f_pos;
+       if (curr_offset == 0x7fffffff)
+               offset = 0xffffffff;
+       else
+               offset = filp->f_pos;

and later the offset to filldir is masked.  Is that some restriction
in filldir?
