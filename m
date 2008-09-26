Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 26 Sep 2008 02:39:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q9cTeo008058
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 02:38:30 -0700
Received: from fogou.chygwyn.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 41EBD1211555
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 02:40:04 -0700 (PDT)
Received: from fogou.chygwyn.com ([195.171.2.24]) by cuda.sgi.com with ESMTP id J6ZQ58iP1Qxk4FiO for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 02:40:04 -0700 (PDT)
Date: Fri, 26 Sep 2008 10:37:30 +0100
From: steve@chygwyn.com
Subject: Re: [PATCH 5/10] gfs2: Fix error handling in
	write_super_lockfs/unlockfs
Message-ID: <20080926093730.GA5346@fogou.chygwyn.com>
References: <20080926175821t-sato@mail.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080926175821t-sato@mail.jp.nec.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi,

On Fri, Sep 26, 2008 at 05:58:21PM +0900, Takashi Sato wrote:
> Changed write_super_lockfs so that it returns an error in case of an failure.
> unlockfs always returns 0.

Looks good now. Thanks,

Steve.
