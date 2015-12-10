Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 876547F50
	for <xfs@oss.sgi.com>; Wed,  9 Dec 2015 20:14:10 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6BB8B304032
	for <xfs@oss.sgi.com>; Wed,  9 Dec 2015 18:14:07 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	CVmjrKwVn1VOL0h0 for <xfs@oss.sgi.com>;
	Wed, 09 Dec 2015 18:14:03 -0800 (PST)
Date: Thu, 10 Dec 2015 13:13:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: handling device or resource busy errors.
Message-ID: <20151210021343.GI19802@dastard>
References: <CACQ+YcuwWv8g5zHk2sMfN_uRPGnW8Xb8WT6NGOLGigN2+0Toag@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACQ+YcuwWv8g5zHk2sMfN_uRPGnW8Xb8WT6NGOLGigN2+0Toag@mail.gmail.com>
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
To: Ed Peschko <horos22@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Dec 09, 2015 at 04:25:06PM -0800, Ed Peschko wrote:
> All,
> 
> we are 'getting device or resource busy' errors which we *know* are
> spurious (lsof shows nothing, no multipath daemon, the partition that we
> are trying to access was just created).

Please show your working - it saves us having to guess at how you
came to that conclusion.

> So the working theory is that the futex in question is spurious, that
> something didn't clean up after itself and we are stuck waiting for an
> non-existent process to fix it.

Sorry, what futex has anything to do with whether a block device can
be opened or not?

> And the force option doesn't work for some reason. So a couple of questions.
> 
>     1. Why doesn't force work in this case? With parted and partx it does -
> in the case of mkfs.xfs it is a fatal error.

Because mkfs.xfs uses O_EXCL in it's open() call. If there are other
active references to the block device, then we sure aren't going to
overwrite anything on it.

>     2. could an 'extra force' option - one which ignored the futex - be
> added in cases of backwards compatibility?

What futex?

>     3. is there any way to list out what holds mutexes in the linux kernel
> so we could try to root out the ultimate cause of the issue? lsof is
> useless, as is dmesg and /var/log/messages.

sysrq-l

Does waiting a few seconds make the problem go away, what about
running 'udevadm settle' before mkfs?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
