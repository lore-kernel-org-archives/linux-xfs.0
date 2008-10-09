Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 03:16:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m99AGrah032054
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 03:16:54 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 201EA1B582FD
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2008 03:18:33 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id Bg9FqggnNXgc8FCB for <xfs@oss.sgi.com>; Thu, 09 Oct 2008 03:18:33 -0700 (PDT)
Date: Thu, 9 Oct 2008 06:18:09 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20081009101809.GA1319@infradead.org>
References: <20080908205337t-sato@mail.jp.nec.com> <20080908171119.GB22521@infradead.org> <48DBFD42.6030307@redhat.com> <D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp> <20080929141326.GA31781@infradead.org> <48E0E7D4.1090409@sandeen.net> <20080929143749.GA13286@infradead.org> <48E0EA0B.7000701@sandeen.net> <0AD458D29A8E4938BB3914BB5C562C39@nsl.ad.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0AD458D29A8E4938BB3914BB5C562C39@nsl.ad.nec.co.jp>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@infradead.org>, Ric Wheeler <rwheeler@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, axboe@kernel.dk, mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org

On Thu, Oct 09, 2008 at 07:12:17PM +0900, Takashi Sato wrote:
> I think we need the timeout for the case someone dirties so much data
> with mmap, hence the freeze process is swapped out and cannot unfreeze.

That is not supposed to happen.  That's why write blocks early on a
frozen filesystem (the shared mmap write path is currently missing the
check, but that's a rather small patch)
