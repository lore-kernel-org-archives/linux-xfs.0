Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 26 Sep 2008 14:26:12 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8QLQ36u009319
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 14:26:04 -0700
Received: from e36.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E43F11AFD5E6
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 14:27:37 -0700 (PDT)
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154]) by cuda.sgi.com with ESMTP id xrZn6Ll7daO2peM0 for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 14:27:37 -0700 (PDT)
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m8QLRKsI013145
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 17:27:20 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8QLRJP0210108
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 15:27:19 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m8QLRIlN001730
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 15:27:18 -0600
Subject: Re: [PATCH 0/10] freeze feature ver 1.13
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
In-Reply-To: <30536.1222426096@turing-police.cc.vt.edu>
References: <20080926175652t-sato@mail.jp.nec.com>
	 <30536.1222426096@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Fri, 26 Sep 2008 16:26:58 -0500
Message-Id: <1222464418.27833.7.camel@norville.austin.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Valdis.Kletnieks@vt.edu
Cc: Takashi Sato <t-sato@yk.jp.nec.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Fri, 2008-09-26 at 06:48 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 26 Sep 2008 17:56:52 +0900, Takashi Sato said:

> Would it be a good idea to merge patch 10 into patch 8?   Otherwise, there's
> two issues I can see:
> 
> 1) A mostly theoretical problem if a bisect lands exactly on patch 9 it can
> hit the deadlock.

Really, there's no deadlock until someone uses the new function, so
that's not really an issue, is it?  However, this patchset breaks
bisection anyway.

A bisect anywhere between patch 1 and 7 will cause some number of
filesystems to fail to compile.  Patches 1-7 either need to be combined
into one, or patch 1 needs to add freeze_fs and unfreeze_fs while
leaving write_super_lockfs and unlockfs, then a patch between 7 and 8
could remove write_super_lockfs and unlockfs.

> 2) The API at patch 8 and patch 10 differs, that's going to make testing through
> a bisection of this patch series a pain.

There's no need to test the new interface during a bisection.  Bisection
is important in testing regressions, but not new function.
-- 
David Kleikamp
IBM Linux Technology Center
