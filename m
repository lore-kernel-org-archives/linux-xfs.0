Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Jul 2008 03:52:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m61Aq0QT016501
	for <xfs@oss.sgi.com>; Tue, 1 Jul 2008 03:52:00 -0700
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 84451123A92A
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2008 03:53:00 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com with ESMTP id ntehcwwXRHrqHbHK for <xfs@oss.sgi.com>; Tue, 01 Jul 2008 03:53:00 -0700 (PDT)
Date: Tue, 1 Jul 2008 11:52:51 +0100
From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080701105251.GC22522@agk.fab.redhat.com>
References: <20080630212450t-sato@mail.jp.nec.com> <20080701081026.GB16691@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701081026.GB16691@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, mtk.manpages@googlemail.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, viro@ZenIV.linux.org.uk, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, akpm@linux-foundation.org, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

On Tue, Jul 01, 2008 at 04:10:26AM -0400, Christoph Hellwig wrote:
> I still disagree with this whole patch.  

Same here - if you want a timeout, what stops you from implementing it in a
userspace process?  If your concern is that the process might die without
thawing the filesystem, take a look at the userspace LVM/multipath code for
ideas - lock into memory, disable OOM killer, run from ramdisk etc.
In practice, those techniques seem to be good enough.

> call can hang and this would be theoretically useful is when the
> filesystem is already frozen by someone else, but this should be fixed
> by refusing to do the second freeze, as suggested in my comment to patch
> 1.

Similarly if a device-mapper device is involved, how should the following
sequence behave - A, B or C?

1. dmsetup suspend (freezes)
2. FIFREEZE
3. FITHAW
4. dmsetup resume (thaws)

A:
  1 succeeds, freezes
  2 succeeds, remains frozen
  3 succeeds, remains frozen
  4 succeeds, thaws

B:
  1 succeeds, freezes
  2 fails, remains frozen
  3 shouldn't be called because 2 failed but if it is: succeeds, thaws
  4 succeeds (already thawed, but still does the device-mapper parts)

C:
  1 succeeds, freezes
  2 fails, remains frozen
  3 fails (because device-mapper owns the freeze/thaw), remains frozen 
  4 succeeds, thaws

Alasdair
-- 
agk@redhat.com
