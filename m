Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 08 Oct 2008 13:57:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m98KvL11024595
	for <xfs@oss.sgi.com>; Wed, 8 Oct 2008 13:57:21 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 975C513C233B
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2008 13:59:00 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id ugcZKYASAY0EY3WC for <xfs@oss.sgi.com>; Wed, 08 Oct 2008 13:59:00 -0700 (PDT)
Date: Thu, 9 Oct 2008 07:58:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsaild centisecs /proc wakeup control?
Message-ID: <20081008205856.GE7342@disturbed>
References: <48ED0DA9.7070002@tlinx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48ED0DA9.7070002@tlinx.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Linda A. Walsh" <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Oct 08, 2008 at 12:44:41PM -0700, Linda A. Walsh wrote:
> I was looking at powertop again recently, and noticed xfsbufd and
> xfsaild at the top of the wakeup list. xfsbufd can be tuned with
> /proc/sys/fs/xfs/xfsbufd_centisecs along with 3 other time-related
> tunables.  However, I don't see one for xfsaild.  Is that an
> oversight?

No. The xfsaild is currently operating with watchdog functionality
to catch AIL push stalls due to a know problem that this new patch:

http://oss.sgi.com/archives/xfs/2008-10/msg00119.html

fixes.

After this has been included for a while (say a release), I
plan to remove the watchdog feature of the xfsaild so the
once-per-second-per-XFS-filesystem wakeup will go away then.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
