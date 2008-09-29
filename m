Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Sep 2008 07:34:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8TEYTOl025795
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 07:34:30 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9932E1B4C306
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 07:36:06 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id DUoqhWz0IIG6Weh9 for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 07:36:06 -0700 (PDT)
Message-ID: <48E0E7D4.1090409@sandeen.net>
Date: Mon, 29 Sep 2008 09:36:04 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] Add timeout feature
References: <20080908205337t-sato@mail.jp.nec.com> <20080908171119.GB22521@infradead.org> <48DBFD42.6030307@redhat.com> <D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp> <20080929141326.GA31781@infradead.org>
In-Reply-To: <20080929141326.GA31781@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Takashi Sato <t-sato@yk.jp.nec.com>, Ric Wheeler <rwheeler@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, axboe@kernel.dk, mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Fri, Sep 26, 2008 at 05:52:35PM +0900, Takashi Sato wrote:
>> I think that your concern is that the freezer cannot recognize the occurrence
>> of a timeout and it continues the backup process and the backup data is
>> corrupted finally.
> 
> What timeout should happen?  the freeze ioctl must not return until the
> filesystem is a clean state and all writes are blocked.

The suggestion was that *UN*freeze would return ETIMEDOUT if the
filesystem had already unfrozen itself, I think.  That way you know that
the snapshot you just took is worthless, at least.

I'm still not really sold on the timeout, but I think the above was the
intent.

-Eric
