Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 10 Jan 2007 14:09:53 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0AM9iqw010560
	for <linux-xfs@oss.sgi.com>; Wed, 10 Jan 2007 14:09:46 -0800
Date: Thu, 11 Jan 2007 09:08:43 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS and 2.6.18 -> 2.6.20-rc3
Message-ID: <20070110220843.GA44411608@melbourne.sgi.com>
References: <45A27BC7.2020709@exegy.com> <20070109012212.GG44411608@melbourne.sgi.com> <20070109072535.GH44411608@melbourne.sgi.com> <45A4EA2B.5050505@exegy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45A4EA2B.5050505@exegy.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Mr. Berkley Shands" <bshands@exegy.com>
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, Dave Lloyd <dlloyd@exegy.com>, linux-xfs@oss.sgi.com

On Wed, Jan 10, 2007 at 07:29:15AM -0600, Mr. Berkley Shands wrote:
> With a fresh install of the O/S on a non-broken motherboard, the change to
> 
> /proc/sys/vm/dirty_ratio
> 
> restores most of the lost performance from 2.6.18,
> as of 2.6.20-rc4. The difference is 10% to 15% without the dirty_ratio
> change (40 is the default, 10 gives the old performance).

....

> So whatever needs to be tweaked in the VM system seems to be the key.
> 
> Thanks to all for getting this regression repaired.

Well, it's not repaired as such - you've got a WAR for the problem.
I'll report the problem to lkml so that the VM gurus can try to
really fix the problem....

Thanks for confirming that the dirty_ratio tweak also worked
for you.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
