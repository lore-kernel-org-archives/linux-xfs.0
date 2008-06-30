Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 29 Jun 2008 17:00:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5U00uLQ007989
	for <xfs@oss.sgi.com>; Sun, 29 Jun 2008 17:00:56 -0700
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 422EC29B2A7
	for <xfs@oss.sgi.com>; Sun, 29 Jun 2008 17:01:57 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org [140.211.169.13]) by cuda.sgi.com with ESMTP id aPlNd2TlN0DqbAaK for <xfs@oss.sgi.com>; Sun, 29 Jun 2008 17:01:57 -0700 (PDT)
Date: Sun, 29 Jun 2008 17:01:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] Add timeout feature
Message-Id: <20080629170152.aa769918.akpm@linux-foundation.org>
In-Reply-To: <C2E97AF9310E467696FA7F4C62C88AC5@nsl.ad.nec.co.jp>
References: <20080624160056t-sato@mail.jp.nec.com>
	<20080624150925.765155f0.akpm@linux-foundation.org>
	<7B349EFCD35842D4ADAEB402D2BDCA4E@nsl.ad.nec.co.jp>
	<20080627115727.149dcb2e.akpm@linux-foundation.org>
	<C2E97AF9310E467696FA7F4C62C88AC5@nsl.ad.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, mtk.manpages@googlemail.com

On Mon, 30 Jun 2008 08:13:07 +0900 "Takashi Sato" <t-sato@yk.jp.nec.com> wrote:

> > It's much better to use NULL here rather than literal zero because the
> > reader of this code can then say "ah-hah, we're passing in a pointer". 
> > Whereas plain old "0" could be a pointer or a scalar.
> 
> The second argument's type of freeze_bdev() is "long", not pointer as below.
> struct super_block *freeze_bdev(struct block_device *, long timeout_msec);

oh, ok, I goofed, sorry.

> So "0" is reasonable, isn't it?

yup.
