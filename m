Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 33E917F37
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 02:37:37 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 14C768F8040
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 00:37:33 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id QvjKaGUGNBm8iPhu (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Jan 2016 00:37:31 -0800 (PST)
Date: Wed, 13 Jan 2016 09:37:29 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] Revert "xfs: clear PF_NOFREEZE for xfsaild kthread"
In-Reply-To: <1452661968-11482-1-git-send-email-david@fromorbit.com>
Message-ID: <alpine.LNX.2.00.1601130931050.3402@cbobk.fhfr.pm>
References: <1452661968-11482-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, 13 Jan 2016, Dave Chinner wrote:

> This reverts commit 24ba16bb3d499c49974669cd8429c3e4138ab102 as it
> prevents machines from suspending. This regression occurs when the
> xfsaild is idle on entry to suspend, and so there s no activity to
> wake it from it's idle sleep and hence see that it is supposed to
> freeze. Hence the freezer times out waiting for it and suspend is
> cancelled.
> 
> There is no obvious fix for this short of freezing the filesystem
> properly, so revert this change for now.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>

I hope I'll find time in the future and make some progress on making the 
fs freezing happen during suspend properly. Unfortunately, before that 
happens

	Acked-by: Jiri Kosina <jkosina@suse.cz>

Thanks,

-- 
Jiri Kosina
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
