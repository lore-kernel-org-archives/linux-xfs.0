Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Nov 2008 18:31:46 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mAD2FUJK008723
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 18:15:30 -0800
Received: from femx.pixar.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B2C441B1FD8C
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 18:15:29 -0800 (PST)
Received: from femx.pixar.com (femx.pixar.com [199.108.77.27]) by cuda.sgi.com with ESMTP id 1Z67zM5cx67LhOZZ for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 18:15:29 -0800 (PST)
Date: Wed, 12 Nov 2008 17:55:04 -0800
From: Lars Damerow <lars@pixar.com>
Subject: Re: last xfs_repair time?
Message-ID: <20081113015503.GN18990@pixar.com>
References: <20081112224109.GC18990@pixar.com> <491B6F4C.6030506@sgi.com> <491B7EB9.1050207@sandeen.net> <20081113012045.GL18990@pixar.com> <491B83E5.4030002@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491B83E5.4030002@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

>From Eric Sandeen <sandeen@sandeen.net>, Wed, Nov 12, 2008 at 07:33:25PM -0600:
> So, for what it's worth, power loss should not necessarily require a
> repair; as long as you have barriers enabled and/or you're not losing
> log writes to a volatile write cache, power loss should never corrupt
> the filesystem metadata; that is what the log is for, after all...

Our disks are partitioned with LVM, so we don't have write barriers. We
just recently disabled write caching, though, so our future should be
brighter than it's been. :)

-lars

--
lars r. damerow :: button pusher :: pixar animation studios
<lars@pixar.com>
