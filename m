Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Sep 2008 07:12:12 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8TEC4J9022493
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 07:12:06 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B47949240C
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 07:13:40 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id PlOQ6lxdqAOYyAZ1 for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 07:13:40 -0700 (PDT)
Date: Mon, 29 Sep 2008 10:13:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080929141326.GA31781@infradead.org>
References: <20080908205337t-sato@mail.jp.nec.com> <20080908171119.GB22521@infradead.org> <48DBFD42.6030307@redhat.com> <D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, axboe@kernel.dk, mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 05:52:35PM +0900, Takashi Sato wrote:
> I think that your concern is that the freezer cannot recognize the occurrence
> of a timeout and it continues the backup process and the backup data is
> corrupted finally.

What timeout should happen?  the freeze ioctl must not return until the
filesystem is a clean state and all writes are blocked.
