Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 19DEA29DF8
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 15:00:28 -0500 (CDT)
Date: Tue, 4 Jun 2013 15:00:24 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: garbage block(s) after powercycle/reboot + sparse writes
Message-ID: <20130604200024.GK20932@sgi.com>
References: <alpine.DEB.2.00.1306041210070.15156@cobra.newdream.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1306041210070.15156@cobra.newdream.net>
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
To: Sage Weil <sage@inktank.com>
Cc: xfs@oss.sgi.com

Hi Sage,

On Tue, Jun 04, 2013 at 12:24:00PM -0700, Sage Weil wrote:
> I'm observing an interesting data corruption pattern:
> 
> - write a bunch of files
> - power cycle the box
> - remount
> - immediately (within 1-2 seconds) write create a file and
>  - write to a lower offset, say offset 430423 len 527614
>  - write to a higher offset, say offset 1360810 len 269613
>  (there is other random io going to other files too)
> 
> - about 5 seconds later, read the whole file and verify content
> 
> And what I see:
> 
> - the first region is correct, and intact
> - the bytes that follow, up until the block boundary, are 0
> - the next few blocks are *not* zero! (i've observed 1 and 6 4k blocks)
> - then lots of zeros, up until the second region, which appears intact.
> 
> I'm pretty reliably hitting this, and have reproduced it twice now and 
> found the above consistent pattern (but different filenames, different 
> offsets).  What I haven't yet confirmed is whether the file was written at 
> all prior to the powercycle, since that tends to blow away the last 
> bit of the ceph logs, too.  I'm adding some additional checks to see 
> whether the file is in fact new when the first extent is written.
> 
> The other possibly interesting thing is the offsets.  The garbage regions 
> I saw were
> 
>  0xea000 - 0xf0000
>  0xff000 - 0x100000
> 
> Does this failure pattern look familiar to anyone? I'm pretty sure it is 
> new in 3.9, which we switched over to right around the time when this 
> started happening.  I'm confirming that as well, but just wanted to see if 
> this is ringing any bells...

Consider

commit 49b137cbbcc836ef231866c137d24f42c42bb483
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon May 20 09:51:08 2013 +1000

    xfs: fix sub-page blocksize data integrity writes

I think that this is the only candidate we have recently.  Maybe you are seeing
stale data from disk, after the allocation was completed, but before the pages
were written it crashed.  IIRC we have a zeroing problem in that area.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
