Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 09 Oct 2007 19:27:56 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9A2RmKN024806
	for <xfs@oss.sgi.com>; Tue, 9 Oct 2007 19:27:51 -0700
Date: Wed, 10 Oct 2007 12:27:57 +1000
Subject: Re: RFC: Case-insensitive support for XFS
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.ty6361ut3jf8g2@pc-bnaujok.melbourne.sgi.com> <op.tzpbqspl3jf8g2@pc-bnaujok.melbourne.sgi.com> <20071005154442.GA6432@infradead.org> <1191610338.2695.8.camel@entropy> <op.tzu4jagf3jf8g2@pc-bnaujok.melbourne.sgi.com> <1191822288.2694.10.camel@entropy>
Content-Transfer-Encoding: 8bit
Message-ID: <op.tzymgvj03jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <1191822288.2694.10.camel@entropy>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nicholas Miell <nmiell@comcast.net>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, linux-fsdevel@vger.kernel.org, urban@svenskatest.se

On Mon, 08 Oct 2007 15:44:48 +1000, Nicholas Miell <nmiell@comcast.net>  
wrote:

> On Mon, 2007-10-08 at 15:07 +1000, Barry Naujok wrote:
>> On Sat, 06 Oct 2007 04:52:18 +1000, Nicholas Miell <nmiell@comcast.net>
>> wrote:
>>
>> > On Fri, 2007-10-05 at 16:44 +0100, Christoph Hellwig wrote:
>> >> [Adding -fsdevel because some of the things touched here might be of
>> >>  broader interest and Urban because his name is on nls_utf8.c]
>> >>
>> >> On Fri, Oct 05, 2007 at 11:57:54AM +1000, Barry Naujok wrote:
>> >> >
>> >> > On it's own, linux only provides case conversion for old-style
>> >> > character sets - 8 bit sequences only. A lot of distos are
>> >> > now defaulting to UTF-8 and Linux NLS stuff does not support
>> >> > case conversion for any unicode sets.
>> >>
>> >> The lack of case tables in nls_utf8.c defintively seems odd to me.
>> >> Urban, is there a reason for that?  The only thing that comes to
>> >> mind is that these tables might be quite large.
>> >>
>> >
>> > Case conversion in Unicode is locale dependent. The legacy 8-bit
>> > character encodings don't code for enough characters to run into the
>> > ambiguities, so they can get away with fixed case conversion tables.
>> > Unicode can't.
>>
>> Based on http://www.unicode.org/reports/tr21/tr21-5.html and
>> http://www.unicode.org/Public/UNIDATA/CaseFolding.txt
>>
>> Doing case comparison using that table should cater for most
>> circumstances except a few exeptions. It should be enough
>> to satisfy a locale independant case-insensitive filesystem
>> (ie. the C + F case folding option).
>>
>> Is normalization required after case-folding? What I read
>> implies it is not necessary for this purpose (and would
>> slow things down and bloat the code more).
>>
>> Now I suppose, it's just a question of a fixed table in the
>> kernel driver (HFS+ style), or data stored in a special
>> inode on-disk (NTFS style, shared refcounted in memory
>> when the same). With the on-disk, the table can be generated
>>  from mkfs.xfs.
>
> You also have to decide whether to screw over people who speak Turkic
> languages and expect an 'I' to 'ı' mapping or everybody else who expect
> an 'I' to 'i' mapping.

I have had a thought about this. If the case table is stored on-disk like
NTFS, then mkfs.xfs can specify whether to use Turkic I's or not.

That guarantees consistent case folding for the filesystem. mkfs.xfs can
default to a Turkic case table if the user's locale is tr/az and the
"default case table" if not. mkfs.xfs will have to highlight this setting
if the user specifies the generic case-insensitive option. mkfs.xfs
should also allow the user to specify which of the case tables to use.

Barry.
