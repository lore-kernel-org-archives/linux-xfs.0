Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 Mar 2007 15:01:57 -0700 (PDT)
Received: from smtp106.sbc.mail.mud.yahoo.com (smtp106.sbc.mail.mud.yahoo.com [68.142.198.205])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2LM1m6p023250
	for <xfs@oss.sgi.com>; Wed, 21 Mar 2007 15:01:49 -0700
Date: Wed, 21 Mar 2007 14:35:02 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: [RFC][PATCH] sys_fallocate() system call
Message-ID: <20070321213501.GA1208@tuatara.stupidest.org>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com> <20070317111036.GC29931@parisc-linux.org> <20070321120425.GA27273@amitarora.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321120425.GA27273@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com, cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com

I hate to comment at this late stage, especially on something that I
think is really a great idea (I did similar more complex, sys_blkalloc
with even more arguments time ago --- I'm glad given how complex this
thread has become I didn't post them now).

In the past there wasn't that much incentive to get this functionality
exposed because of various other issues (mmap + page dirty didn't
flush reliably) which are close to being resolve, so I think the
timing of this is really great....


On Wed, Mar 21, 2007 at 05:34:25PM +0530, Amit K. Arora wrote:

> As suggested by you and Russel, I have made this change to the
> patch.  Here is how it looks like now. Please let me know if anyone
> has concerns about passing arguments this way (breaking each
> "loff_t" into two "u32"s).

I really dislike breaking 64-bit args up unless it's necessary.  I
guess it doesn't really hurt, but it feels needlessly ugly.

> +	.long sys_fallocate		/* 320 */

> +/*
> + * fallocate() modes
> + */
> +#define FA_ALLOCATE	0x1
> +#define FA_DEALLOCATE	0x2
> +

given there are the only TWO modes right now, why not leave the
arguments as 64-bit sane and simply have two syscalls, one for each?
