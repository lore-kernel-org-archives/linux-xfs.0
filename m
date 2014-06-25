Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 43ABC7F56
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 18:22:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2D6D730404E
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 16:22:42 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	8gaJeiM3GMX1GtYL for <xfs@oss.sgi.com>;
	Wed, 25 Jun 2014 16:22:36 -0700 (PDT)
Date: Thu, 26 Jun 2014 09:22:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Metadata CRC error upon unclean unmount
Message-ID: <20140625232222.GS4453@dastard>
References: <CA+o=1OW0OXhzU+b9ACMZzg0dq=B7BSj+yPXD2Vrr9F6mWK8ruQ@mail.gmail.com>
	<20140624201946.GJ9508@dastard>
	<CA+o=1OVnORG0Ah3Zx8dkGzs7vtT7odRH=v12KqtLW0MP_3oHjQ@mail.gmail.com>
	<20140625012144.GK9508@dastard>
	<CA+o=1OXY8Ay8CSgsdiAOTacBa9800FiMKGbr0DdkE_YVpewqBw@mail.gmail.com>
	<20140625220336.GN9508@dastard>
	<CA+o=1OWptqFq87E0ncmYH2T6yEzeGheefE-o_VAm7-E_0Z+NJA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+o=1OWptqFq87E0ncmYH2T6yEzeGheefE-o_VAm7-E_0Z+NJA@mail.gmail.com>
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
To: Fanael Linithien <fanael4@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 26, 2014 at 12:33:06AM +0200, Fanael Linithien wrote:
> 2014-06-26 0:03 GMT+02:00 Dave Chinner <david@fromorbit.com>:
> > Can you try to reproduce the AGI or AGF/freespace corruption issue
> > and post the results?
> 
> Sure, looks like the bug heard you and decided to manifest itself right now.
> 
> dmesg: https://clbin.com/g52eu (the second mount error is because I
> typo'd and tried to mount wrong partition)
> Metadata before an attempt to mount: https://clbin.com/YDZBV

Curious. Completely clean log. head/tail at 2/16292. Yet the AGF
head and a couple of btree blocks are have bad CRCs. They were on
disk *before* the system crashed.

> Metadata after an attempt to mount: https://clbin.com/2jayF

Dirty log. tail at 2/16292, head at 2/16332.

The before-mount image shows the CRC error, so it didn't come from
log recovery. It may have come from recovery in the previous
iteration, - do you still have the pre-mount images from the prior
iteration before the crash error was detected?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
