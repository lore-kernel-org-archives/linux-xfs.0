Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Aug 2007 09:56:02 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7UGtw4p027948
	for <xfs@oss.sgi.com>; Thu, 30 Aug 2007 09:55:59 -0700
Date: Thu, 30 Aug 2007 17:55:56 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: About errors in XFS header  files and xfsprogs
Message-ID: <20070830165556.GA13308@infradead.org>
References: <46D6F066.5000009@op.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D6F066.5000009@op.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bogdan <bogdandr@op.pl>
Cc: xfs@oss.sgi.com

On Thu, Aug 30, 2007 at 06:29:26PM +0200, Bogdan wrote:
>                                The header files should not only be
> ISO-C-compatible, but even ANSI-C-compatible. This will allow anyone
> to use them.

Sais who?  The GNU C extensions are very useful for programming, and
there is no reason to move to an inferior dialect.

>  Please, make useful public functions available in header files.
> Especially platform_check_ismounted() and platform_check_iswritable()
> and other "platform" functions.
> 
>  Also, anything that is a part of the public interface, should be in
> the "xfs namespace", i.e. start with "xfs_". At least one issue of
> this type is known: the list_head structure, declared in other files
> from other libraries. Things like these are very important to fix,
> because they are making other header files useless.

There is no such thing as a public inteface.  There's a good reason
libxfs is not a shared libary - it's really nothing more but a collection
of useful routines for the xfs utilities.

If you think a proper shared library with a defined interface is a good
thing you're probably right, and people would welcome you to work on one.
