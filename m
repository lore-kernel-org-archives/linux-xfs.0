Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Oct 2007 00:00:45 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l986xtPx029058
	for <xfs@oss.sgi.com>; Sun, 7 Oct 2007 23:59:59 -0700
Date: Mon, 08 Oct 2007 17:00:58 +1000
Subject: Re: RFC: Case-insensitive support for XFS
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.ty6361ut3jf8g2@pc-bnaujok.melbourne.sgi.com> <op.tzpbqspl3jf8g2@pc-bnaujok.melbourne.sgi.com> <20071005154442.GA6432@infradead.org> <1191610338.2695.8.camel@entropy> <op.tzu4jagf3jf8g2@pc-bnaujok.melbourne.sgi.com> <1191822288.2694.10.camel@entropy>
Content-Transfer-Encoding: 8bit
Message-ID: <op.tzu9rwld3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <1191822288.2694.10.camel@entropy>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nicholas Miell <nmiell@comcast.net>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, linux-fsdevel@vger.kernel.org, urban@svenskatest.se

On Mon, 08 Oct 2007 15:44:48 +1000, Nicholas Miell <nmiell@comcast.net>  
wrote:

> You also have to decide whether to screw over people who speak Turkic
> languages and expect an 'I' to 'ı' mapping or everybody else who expect
> an 'I' to 'i' mapping.

I suspect they would be used to the false case-insensitive match. I
tested it on Windows XP with NTFS: İ (U+0130) did not match I or i
or ı (U+0131). I also tested it with the Turkish language/keyboard set.

Once it's set in a filesystem, the handling of it can't really be
swapped back and forth either, otherwise, you may lose access to
that file.

There is no practical way that I can see of supporting this
fully, even with using the NLS tables. The on-disk hashes have
to remain consistent regardless of what language is specified.

Barry.
