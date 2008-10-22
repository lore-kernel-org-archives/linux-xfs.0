Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Oct 2008 01:19:40 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9M8JcG4013569
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 01:19:38 -0700
Received: from yw-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1E3561215B43
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 01:21:23 -0700 (PDT)
Received: from yw-out-1718.google.com (yw-out-1718.google.com [74.125.46.155]) by cuda.sgi.com with ESMTP id l70wlgnipXCShC3h for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 01:21:23 -0700 (PDT)
Received: by yw-out-1718.google.com with SMTP id 5so524697ywm.32
        for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 01:21:23 -0700 (PDT)
Message-ID: <a4423d670810220121k27ab3d1dp1921ea282786eebc@mail.gmail.com>
Date: Wed, 22 Oct 2008 12:21:23 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
Subject: Re: BUG: sleeping function called from invalid context at kernel/rwsem.c:131 XFS? (was: Re: linux-next: Tree for October 17)
In-Reply-To: <20081022075838.GK18495@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670810170954h7ca130aaw8895380a4c6b125@mail.gmail.com>
	 <a4423d670810171013g5bc19c1cm3f7d9c014ee70349@mail.gmail.com>
	 <20081017203710.GA27187@infradead.org>
	 <20081017135510.7127c4e7@infradead.org>
	 <a4423d670810200758m3cea3841h40988afc8eaf81@mail.gmail.com>
	 <20081020163327.GA15651@infradead.org>
	 <a4423d670810201013w6448cb38w402771799cefb5f5@mail.gmail.com>
	 <20081020223549.GA21152@disturbed>
	 <a4423d670810210442y51b62fc2naf6cb649e6b26942@mail.gmail.com>
	 <20081022075838.GK18495@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, lachlan@sgi.com, Christoph Hellwig <hch@infradead.org>, Arjan van de Ven <arjan@infradead.org>, xfs@oss.sgi.com, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

> Ah, OK, I see the problem, though I don't understand why I'm not
> seeing the might_sleep() triggering all the time given that I always
> build with:
>
> $ grep SLEEP .config
> CONFIG_DEBUG_SPINLOCK_SLEEP=y
>
> Basically the above commit moved xfs_ilock() inside
> radix_tree_preload()/radix_tree_preload_end(), which means we are
> taking a rwsem() while we have an elevated preempt count. I'll
> get a patch out to fix it.
Could it cause the I/O dead lock or should I continue trying to reproduce it?
