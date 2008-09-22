Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Sep 2008 03:58:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8MAwgXI017178
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 03:58:44 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B6AFA1BD1850
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 04:00:16 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id FwGZ3HFYaHKGxR5C for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 04:00:16 -0700 (PDT)
Date: Mon, 22 Sep 2008 06:59:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/10] VFS: Fix error handling of
	write_super_lockfs/unlockfs
Message-ID: <20080922105956.GA16069@infradead.org>
References: <20080922195526t-sato@mail.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922195526t-sato@mail.jp.nec.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Mon, Sep 22, 2008 at 07:55:26PM +0900, Takashi Sato wrote:
> I've changed the type of write_super_lockfs and unlockfs from "void" to
> "int" so that they can return an error. 

Returning an error from the freeze operation makes sense, but for the
unfreeze I don't see the point.  You must however change all existing
instances to actually return a value (even if it's always 0 for now)
to avoid breaking git bisect.

If you touch all instances anyway, it would be nice to rename them
to freeze / unfreze as the current names are more confusing.
