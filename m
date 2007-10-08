Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 07 Oct 2007 22:57:40 -0700 (PDT)
Received: from sccrmhc14.comcast.net (sccrmhc14.comcast.net [63.240.77.84])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l985vYqb015807
	for <xfs@oss.sgi.com>; Sun, 7 Oct 2007 22:57:37 -0700
Subject: Re: RFC: Case-insensitive support for XFS
From: Nicholas Miell <nmiell@comcast.net>
In-Reply-To: <op.tzu4jagf3jf8g2@pc-bnaujok.melbourne.sgi.com>
References: <op.ty6361ut3jf8g2@pc-bnaujok.melbourne.sgi.com>
	 <op.tzpbqspl3jf8g2@pc-bnaujok.melbourne.sgi.com>
	 <20071005154442.GA6432@infradead.org> <1191610338.2695.8.camel@entropy>
	 <op.tzu4jagf3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 07 Oct 2007 22:44:48 -0700
Message-Id: <1191822288.2694.10.camel@entropy>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, linux-fsdevel@vger.kernel.org, urban@svenskatest.se

On Mon, 2007-10-08 at 15:07 +1000, Barry Naujok wrote:
> On Sat, 06 Oct 2007 04:52:18 +1000, Nicholas Miell <nmiell@comcast.net>  
> wrote:
> 
> > On Fri, 2007-10-05 at 16:44 +0100, Christoph Hellwig wrote:
> >> [Adding -fsdevel because some of the things touched here might be of
> >>  broader interest and Urban because his name is on nls_utf8.c]
> >>
> >> On Fri, Oct 05, 2007 at 11:57:54AM +1000, Barry Naujok wrote:
> >> >
> >> > On it's own, linux only provides case conversion for old-style
> >> > character sets - 8 bit sequences only. A lot of distos are
> >> > now defaulting to UTF-8 and Linux NLS stuff does not support
> >> > case conversion for any unicode sets.
> >>
> >> The lack of case tables in nls_utf8.c defintively seems odd to me.
> >> Urban, is there a reason for that?  The only thing that comes to
> >> mind is that these tables might be quite large.
> >>
> >
> > Case conversion in Unicode is locale dependent. The legacy 8-bit
> > character encodings don't code for enough characters to run into the
> > ambiguities, so they can get away with fixed case conversion tables.
> > Unicode can't.
> 
> Based on http://www.unicode.org/reports/tr21/tr21-5.html and
> http://www.unicode.org/Public/UNIDATA/CaseFolding.txt
> 
> Doing case comparison using that table should cater for most
> circumstances except a few exeptions. It should be enough
> to satisfy a locale independant case-insensitive filesystem
> (ie. the C + F case folding option).
> 
> Is normalization required after case-folding? What I read
> implies it is not necessary for this purpose (and would
> slow things down and bloat the code more).
> 
> Now I suppose, it's just a question of a fixed table in the
> kernel driver (HFS+ style), or data stored in a special
> inode on-disk (NTFS style, shared refcounted in memory
> when the same). With the on-disk, the table can be generated
>  from mkfs.xfs.

You also have to decide whether to screw over people who speak Turkic
languages and expect an 'I' to 'ı' mapping or everybody else who expect
an 'I' to 'i' mapping.

Although, if you're content in ignoring the kernel's native NLS case
mapping tables (which expect a locale-independent 1-to-1 mapping), you
could just uppercase everything and map both 'i' and 'ı' to 'I'.

Then you have to decide whether things like 'ê' map to 'E' or 'Ê', which
is also locale dependent.

-- 
Nicholas Miell <nmiell@comcast.net>
