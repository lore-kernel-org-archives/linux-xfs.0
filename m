Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Jul 2008 01:09:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6189R8q005956
	for <xfs@oss.sgi.com>; Tue, 1 Jul 2008 01:09:27 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A5431D7ED8E
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2008 01:10:30 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 4qIVDGZTKMniZ4Vf for <xfs@oss.sgi.com>; Tue, 01 Jul 2008 01:10:30 -0700 (PDT)
Date: Tue, 1 Jul 2008 04:10:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080701081026.GB16691@infradead.org>
References: <20080630212450t-sato@mail.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630212450t-sato@mail.jp.nec.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, axboe@kernel.dk, mtk.manpages@googlemail.com

I still disagree with this whole patch.  There is not reason to let
the freeze request timeout - an auto-unfreezing will only confuse the
hell out of the caller.  The only reason where the current XFS freeze
call can hang and this would be theoretically useful is when the
filesystem is already frozen by someone else, but this should be fixed
by refusing to do the second freeze, as suggested in my comment to patch
1.
