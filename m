Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p11Fw8CU216766 for <xfs@oss.sgi.com>; Tue, 1 Feb 2011 09:58:08 -0600
Received: from ironport2-out.pppoe.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D5471EA99DB
	for <xfs@oss.sgi.com>; Tue,  1 Feb 2011 08:00:35 -0800 (PST)
Received: from ironport2-out.pppoe.ca (ironport2-out.teksavvy.com
	[206.248.154.183]) by cuda.sgi.com with ESMTP id
	PyLrvKJgVbd8byd0 for <xfs@oss.sgi.com>;
	Tue, 01 Feb 2011 08:00:35 -0800 (PST)
Message-ID: <4D482E21.5040803@teksavvy.com>
Date: Tue, 01 Feb 2011 11:00:33 -0500
From: Mark Lord <kernel@teksavvy.com>
MIME-Version: 1.0
Subject: Re: [GIT PULL] XFS update for 2.6.38-rc3
References: <201101311642.p0VGgXTS018851@stout.americas.sgi.com>
In-Reply-To: <201101311642.p0VGgXTS018851@stout.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On 11-01-31 11:42 AM, Alex Elder wrote:
> Linus, please accept the following updates for XFS, for 2.6.38-rc3
> (if it's not too late) or 2.6.38-rc4.
> 
> They are all fixes for bugs that have some pretty undesirable
> consequences.  They address:
> - One spot in which a hang can occur due to neglecting to drop a
>   lock
> - A bug which in some cases a bogus block number can be recorded in
>   a block map btree, resulting in a subsequent BUG_ON().
> - Two memory leaks
> - Three places in which extent sizes are allowed to exceed various
>   size limits
> - One place where code depends on behavior that is not well-defined
>   by the C standard
> - One problem in handling transaction commit errors


Are these bugs all new in 2.6.38, or should some of these fixes
also go out to -stable for earlier revisions?


> Dave Chinner (8):
>       xfs: fix log ticket leak on forced shutdown.
>       xfs: fix efi item leak on forced shutdown
>       xfs: speculative delayed allocation uses rounddown_power_of_2 badly
>       xfs: limit extent length for allocation to AG size
>       xfs: prevent extsize alignment from exceeding maximum extent size
>       xfs: limit extsize to size of AGs and/or MAXEXTLEN
>       xfs: handle CIl transaction commit failures correctly
>       xfs: fix dquot shaker deadlock
> 
> bpm@sgi.com (1):
>       xfs: xfs_bmap_add_extent_delay_real should init br_startblock

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
