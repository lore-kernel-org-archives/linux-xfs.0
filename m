Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Jul 2008 06:18:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6EDHw7E001776
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 06:17:58 -0700
Received: from g4t0015.houston.hp.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 14F142EB6CF
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 06:19:05 -0700 (PDT)
Received: from g4t0015.houston.hp.com (g4t0015.houston.hp.com [15.201.24.18]) by cuda.sgi.com with ESMTP id EE2xupV6dw1Z64VC for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 06:19:05 -0700 (PDT)
Message-ID: <487B51DD.2080206@hp.com>
Date: Mon, 14 Jul 2008 09:17:17 -0400
From: jim owens <jowens@hp.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] Add timeout feature
References: <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org> <E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu> <20080708235502.1c52a586@infradead.org> <20080709071346.GS11558@disturbed> <20080709110900.GI9957@mit.edu> <20080709114958.GV11558@disturbed> <4874C3E8.20804@hp.com> <20080713120602.GC7517@elf.ucw.cz> <487A383F.50600@hp.com> <20080714063617.GF31949@elf.ucw.cz>
In-Reply-To: <20080714063617.GF31949@elf.ucw.cz>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Pavel Machek <pavel@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org, t-sato@yk.jp.nec.com, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, axboe@kernel.dk, mtk.manpages@googlemail.com

Pavel Machek wrote:

> If you also freeze data writes, at least snapshot is not worse than
> _unexpected_ shutdown.

True.  But the key point is also that stopping file writes is
__no better__ than an unexpected shutdown for applications.

Once kernel people accept that it is identical to an unknown
shutdown state, they realize that as you said...

> And apps should already be ready for unexpected shutdowns (using fsync
> etc).

The people writing the code outside the kernel are the ones
responsible for the logic of handling "we don't know what
application writes made it to disk".

Remember that immediately after fsync(), the next write
can make the file inconsistent.  For example, look at this
simple sales processing database type sequence:

    write(sale_last_name_file, "Mackek"
    write(sale_first_name_file, "Pavel")
    fsync(sale_last_name_file)
    fsync(sale_first_name_file)
       ...
    write(sale_last_name_file, "Owens")
    write(sale_first_name_file, "Jim")
    fsync(sale_last_name_file)

FREEZEFS [defined to NOT allow file data writes]

So if we restart from that snapshot, the sales order
thinks the customer is "Pavel Owens"... unless there
is some mechanism such as seqence numbers that tie
the files together.  And if they have such a mechanism
then it doesn't matter if we allow even more writes
such as:

    write(sale_first_name_file, "Ted")

There just is no way inside the kernel to know a
freeze was triggered at a stable application point
such that data before the freeze must be on disk
and data after the freez must not go to disk.

This issue is not unique to freeze, it is also
present with filesystems that have snapshots and
cow/versioning built in.

jim
