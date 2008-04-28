Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Apr 2008 06:03:35 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3SD3LjZ018288
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 06:03:23 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E3281215C51
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 06:04:00 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id YAPpfPZzaEYj9mG3 for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 06:04:00 -0700 (PDT)
Date: Mon, 28 Apr 2008 09:03:58 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 1/3] Implement generic freeze feature
Message-ID: <20080428130358.GB2798@infradead.org>
References: <20080428193123t-sato@mail.jp.nec.com> <20080428103719.GA16030@infradead.org> <2E042A67F72447F6AAA0CC0605DBFA84@nsl.ad.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2E042A67F72447F6AAA0CC0605DBFA84@nsl.ad.nec.co.jp>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 09:59:55PM +0900, Takashi Sato wrote:
>> I think the protection against double freezes would be better done by
>> using a trylock on bd_mount_sem.
>
> bd_mount_sem can protect against only freezes and cannot protect against
> unfreezes.  If multiple unfreezes run in parallel,  the multiple up() for
> bd_mount_sem might occur incorrectly.

Indeed.  The bit flag would fix that because unfreeze could then check
for the bit beeing set first.  So that's probably the easiest way to go.
