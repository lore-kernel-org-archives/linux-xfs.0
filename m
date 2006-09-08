Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Sep 2006 12:20:37 -0700 (PDT)
Received: from smtp105.sbc.mail.mud.yahoo.com (smtp105.sbc.mail.mud.yahoo.com [68.142.198.204])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k88JKKDW015784
	for <xfs@oss.sgi.com>; Fri, 8 Sep 2006 12:20:24 -0700
Date: Fri, 8 Sep 2006 12:19:40 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: XFS questions
Message-ID: <20060908191940.GC30358@tuatara.stupidest.org>
References: <200609081923.08215.microchip@chello.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200609081923.08215.microchip@chello.be>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Grozdan Nikolov <microchip@chello.be>
Cc: xfs@oss.sgi.com

On Fri, Sep 08, 2006 at 07:23:07PM +0200, Grozdan Nikolov wrote:

> I'm also worried about the 'zeroing' thing in XFS.

Most of what people claim is a bit vague and often incorrect.

> 1) How reliable is XFS at data-integrity?

Fine, if your applications are sane.  MTAs like postfix for example
*never* had any problems with XFS.

> 2) Will the 'zeroing' thing be removed/fixed in the near future?

What usually happens if that if you truncate over a file, and write
data *then* loose power some of the data might not have been written
to disk yet so when you read it back the XFS returns zeroes.

This is normal/expected for journalling filesystems.  Now, by default
ext3 doesn't have this 'problem' so I think have a misconception as to
how it should work (or how they would like it to).

In recent kernels when XFS truncated over a file the data is flushed
after close() so the chances of loosing data are much less.

Why have people seen this?  Because a lot of applications do something
like:

   open file ~/.bookmarks
   read
   close

   [...]

   open file ~/.bookmarks, truncating the existing file
   write
   close

The open + truncate is journalled, so that will survive a power
failure, but the 'write' isn't --- so you might end up with a file
that looks like it has zeroes.

I'll claim this in general is a bad practise and I'm also going to
claim applications that do this ideally should be fixed to open/creat
tmp, write, fsync, close, rename tmp to original.  Not only does that
make things more reliable for XFS, but also pretty much every other fs
out there on any unix-like OS.  It also is more reliable again
something like a crash/powerfailure in the application during write
out (which I've seen).
