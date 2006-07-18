Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Jul 2006 19:07:29 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6I27CDW021471
	for <xfs@oss.sgi.com>; Mon, 17 Jul 2006 19:07:12 -0700
From: Neil Brown <neilb@suse.de>
Date: Tue, 18 Jul 2006 10:48:07 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17596.12231.468729.199881@cse.unsw.edu.au>
Subject: Re: Raid5 Reshape Status + xfs_growfs = Success! (2.6.17.3)
In-Reply-To: message from Justin Piszcz on Tuesday July 11
References: <Pine.LNX.4.64.0607111159470.12230@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com

On Tuesday July 11, jpiszcz@lucidpixels.com wrote:
> Neil,
> 
> It worked, echo'ing the 600 > to the stripe width in /sys, however, how 
> come /dev/md3 says it is 0 MB when I type fdisk -l?
> 
> Is this normal?

Yes.  The 'cylinders' number is limited to 16bits.  For you 2.2TB
array, the number of 'cylinders' (given 2 heads and 4 sectors) would
be about 500,000 which doesn't fit into 16 bits.
> 
> Furthermore, the xfs_growfs worked beautifully!
> 

Excellent!

NeilBrown
