Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Sep 2008 10:10:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m88HA5Rp003960
	for <xfs@oss.sgi.com>; Mon, 8 Sep 2008 10:10:05 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7476741B0EE
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2008 10:11:34 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id TitALW1ZDaGr7030 for <xfs@oss.sgi.com>; Mon, 08 Sep 2008 10:11:34 -0700 (PDT)
Date: Mon, 8 Sep 2008 13:11:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080908171119.GB22521@infradead.org>
References: <20080908205337t-sato@mail.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080908205337t-sato@mail.jp.nec.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Mon, Sep 08, 2008 at 08:53:37PM +0900, Takashi Sato wrote:
> The timeout feature is added to "freeze ioctl" to solve a deadlock
> when the freezer accesses a frozen filesystem. And new ioctl
> to reset the timeout period is added to extend the timeout period.
> For example, the freezer resets the timeout period to 10 seconds every 5
> seconds.  In this approach, even if the freezer causes a deadlock by
> accessing the frozen filesystem, it will be solved by the timeout
> in 10 seconds and the freezer will be able to recognize that
> at the next reset of timeout period.

And as with all previous posting I still fundamentally disagree about
the need of this functionality.  We don't need a timeout for freezing.
