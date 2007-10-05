Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 05 Oct 2007 12:02:52 -0700 (PDT)
Received: from alnrmhc14.comcast.net (alnrmhc14.comcast.net [206.18.177.54])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l95J2jAA027623
	for <xfs@oss.sgi.com>; Fri, 5 Oct 2007 12:02:47 -0700
Subject: Re: RFC: Case-insensitive support for XFS
From: Nicholas Miell <nmiell@comcast.net>
In-Reply-To: <20071005154442.GA6432@infradead.org>
References: <op.ty6361ut3jf8g2@pc-bnaujok.melbourne.sgi.com>
	 <op.tzpbqspl3jf8g2@pc-bnaujok.melbourne.sgi.com>
	 <20071005154442.GA6432@infradead.org>
Content-Type: text/plain
Date: Fri, 05 Oct 2007 11:52:18 -0700
Message-Id: <1191610338.2695.8.camel@entropy>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, linux-fsdevel@vger.kernel.org, urban@svenskatest.se

On Fri, 2007-10-05 at 16:44 +0100, Christoph Hellwig wrote:
> [Adding -fsdevel because some of the things touched here might be of
>  broader interest and Urban because his name is on nls_utf8.c]
> 
> On Fri, Oct 05, 2007 at 11:57:54AM +1000, Barry Naujok wrote:
> > 
> > On it's own, linux only provides case conversion for old-style
> > character sets - 8 bit sequences only. A lot of distos are
> > now defaulting to UTF-8 and Linux NLS stuff does not support
> > case conversion for any unicode sets.
> 
> The lack of case tables in nls_utf8.c defintively seems odd to me.
> Urban, is there a reason for that?  The only thing that comes to
> mind is that these tables might be quite large.
> 

Case conversion in Unicode is locale dependent. The legacy 8-bit
character encodings don't code for enough characters to run into the
ambiguities, so they can get away with fixed case conversion tables.
Unicode can't.

I'd point you to the Unicode technical report which explains how to do
it, but unicode.org seems to be offline right now.

> > NTFS in Linux also implements it's own dcache and NTFS also
> 
> 					^^^^^^^ dentry operations?
> 
> > stores its unicode case table on disk. This allows the filesystem
> > to migrate to newer forms of Unicode at the time of formatting
> > the filesystem. Eg. Windows Vista now supports Unicode 5.0
> > while older version would support an earlier version of
> > Unicode. Linux's version of NTFS case table is implemented
> > in fs/ntfs/upcase.c defined as default_upcase.
> 
> Because ntfs uses 16bit wide chars it prefers to use it's own tables.
> I'm not sure it's a that good idea.  

Well, Windows uses those on-disk tables, so the Linux driver has to
also. I don't see how that's a bad idea or any way to not do it and
remain compatible.

-- 
Nicholas Miell <nmiell@comcast.net>
