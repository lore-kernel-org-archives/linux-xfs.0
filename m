Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9C6857F3F
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 17:51:57 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8A766304053
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 15:51:54 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	vZFJGBPn0jFVuz7L for <xfs@oss.sgi.com>;
	Wed, 04 Mar 2015 15:51:52 -0800 (PST)
Date: Thu, 5 Mar 2015 10:51:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [regression v4.0-rc1] mm: IPIs from TLB flushes causing
	significant performance degradation.
Message-ID: <20150304235126.GB18360@dastard>
References: <CA+55aFw+7V9DfxBA2_DhMNrEQOkvdwjFFga5Y67-a6yVeAz+NQ@mail.gmail.com>
	<CA+55aFw+fb=Fh4M2wA4dVskgqN7PhZRGZS6JTMx4Rb1Qn++oaA@mail.gmail.com>
	<20150303052004.GM18360@dastard>
	<CA+55aFyczb5asoTwhzaJr1JdRi1epg1A6cFJgnzMMZj6U0gFWA@mail.gmail.com>
	<20150303113437.GR4251@dastard> <20150303134346.GO3087@suse.de>
	<20150303213353.GS4251@dastard> <20150304200046.GP3087@suse.de>
	<20150304230045.GZ18360@dastard> <20150304233544.GA24733@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150304233544.GA24733@gmail.com>
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
To: Ingo Molnar <mingo@kernel.org>
Cc: Matt B <jackdachef@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-mm <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>

On Thu, Mar 05, 2015 at 12:35:45AM +0100, Ingo Molnar wrote:
> 
> * Dave Chinner <david@fromorbit.com> wrote:
> 
> > > After going through the series again, I did not spot why there is 
> > > a difference. It's functionally similar and I would hate the 
> > > theory that this is somehow hardware related due to the use of 
> > > bits it takes action on.
> > 
> > I doubt it's hardware related - I'm testing inside a VM, [...]
> 
> That might be significant, I doubt Mel considered KVM's interpretation 
> of pte details?

I did actaully mention that before:

| I am running a fake-numa=4 config on this test VM so it's got 4
| nodes of 4p/4GB RAM each.

but I think it got snipped before Mel was cc'd.

Perhaps size of the nodes is relevant, too, because the steady state
phase 3 memory usage is 5-6GB when this problem first shows up, and
then continues into phase 4 where memory usage grows again and peaks
at ~10GB....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
