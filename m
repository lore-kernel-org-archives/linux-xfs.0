Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBRM0PZ8209124 for <xfs@oss.sgi.com>; Sun, 27 Dec 2009 16:00:25 -0600
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B440912A6B2
	for <xfs@oss.sgi.com>; Sun, 27 Dec 2009 14:01:11 -0800 (PST)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.10])
	by cuda.sgi.com with ESMTP id F1Llu5CjxGoKWJcU for
	<xfs@oss.sgi.com>; Sun, 27 Dec 2009 14:01:11 -0800 (PST)
Date: Sun, 27 Dec 2009 14:01:07 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: lockdep: inconsistent lock state
In-Reply-To: <20091227212700.GA7613@discord.disaster>
Message-ID: <alpine.DEB.2.01.0912271355550.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.0912261255380.3483@bogon.housecafe.de>
	<20091227212700.GA7613@discord.disaster>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Mon, 28 Dec 2009 at 08:27, Dave Chinner wrote:
> from kswapd inverts lock ordering and so we get this report. This
> case has never been a deadlock case because an inode in reclaim
> cannot be referenced by any other path, so once again it is a
> false positive....

OK, thanks for confirming this. I've only seen this during
bonnie++ tests so far, and it's always reproducible there, but
I've not seen it during "normal use". It's still scary though. Just 
checked, opensuse and fedora have CONFIG_LOCKDEP_SUPPORT=y but no 
related DEBUG options set, so it probably won't ever show up for
the general public.

Christian.
-- 
BOFH excuse #278:

The Dilithium Crystals need to be rotated.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
