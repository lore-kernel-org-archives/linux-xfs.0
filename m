Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Jul 2008 06:37:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m68DbMDl003746
	for <xfs@oss.sgi.com>; Tue, 8 Jul 2008 06:37:22 -0700
Received: from spitz.ucw.cz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 001A02C8987
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2008 06:38:16 -0700 (PDT)
Received: from spitz.ucw.cz (gprs189-60.eurotel.cz [160.218.189.60]) by cuda.sgi.com with ESMTP id vyHGEJIEo7eq4HgI for <xfs@oss.sgi.com>; Tue, 08 Jul 2008 06:38:16 -0700 (PDT)
Date: Mon, 7 Jul 2008 13:07:31 +0200
From: Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080707110730.GG5643@ucw.cz>
References: <20080630212450t-sato@mail.jp.nec.com> <20080701081026.GB16691@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701081026.GB16691@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Takashi Sato <t-sato@yk.jp.nec.com>, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, axboe@kernel.dk, mtk.manpages@googlemail.com

Hi!

> I still disagree with this whole patch.  There is not reason to let
> the freeze request timeout - an auto-unfreezing will only confuse the
> hell out of the caller.  The only reason where the current XFS freeze
> call can hang and this would be theoretically useful is when the

What happens when someone dirties so much data that vm swaps out
whatever process that frozen the filesystem?

I though that was why the timeout was there...
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
