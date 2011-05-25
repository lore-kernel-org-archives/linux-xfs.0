Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4PMaJ5v168409 for <xfs@oss.sgi.com>; Wed, 25 May 2011 17:36:19 -0500
Received: from homer.ka9q.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2EA5D4790A8
	for <xfs@oss.sgi.com>; Wed, 25 May 2011 15:36:17 -0700 (PDT)
Received: from homer.ka9q.net (homer.ka9q.net [75.60.237.89]) by cuda.sgi.com
	with ESMTP id mXhZVvoFXMbvgcFh for <xfs@oss.sgi.com>;
	Wed, 25 May 2011 15:36:17 -0700 (PDT)
Message-ID: <4DDD845E.9090709@ka9q.net>
Date: Wed, 25 May 2011 15:36:14 -0700
From: Phil Karn <karn@ka9q.net>
MIME-Version: 1.0
Subject: Re: automatically running fstrim
References: <4DDBE293.8030203@philkarn.net>
	<alpine.LFD.2.00.1105251155120.4667@dhcp-27-109.brq.redhat.com>
	<BANLkTi=8CX_rjWHFEjt5JO5oScdKoZopww@mail.gmail.com>
	<alpine.LFD.2.00.1105251335280.4667@dhcp-27-109.brq.redhat.com>
In-Reply-To: <alpine.LFD.2.00.1105251335280.4667@dhcp-27-109.brq.redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: xfs@oss.sgi.com

On 5/25/11 4:47 AM, Lukas Czerner wrote:


> unlinked often). Unfortunately xfs does not have this support yet, but
> other filesystems do (ext4,btrfs,...) so if you like you might try one
> of those and mount it with -o discard mount option. What it does is,
> that it will send a TRIM for every range of freed filesystem blocks.
> 
> Generally, in its current state it comes with quite big performance
> loss (that's why we have fstrim), but in you case it might be actually
> more convenient than running fstrim all the time. Also it is handled
> automatically and the only think needed is to pass the "-i discard"
> mount option.

I have thought of using ext4 with the discard option on that device for
just this reason. But this OCZ Revo SSD seems to execute TRIM rather
slowly. I just timed it at 7 minutes 38 seconds to trim 46 GB of free
space on a 90 GB SSD. I wouldn't want that to occur in the foreground
while I'm running a program that's generating a lot of garbage blocks.

Intel drives, at least, seem to execute TRIM much faster; I think they
can take more blocks in each operation, and I conjecture that the drive
controller simply adds them to a "to do" list for later erasure in the
background. So there should probably be an option for "real-time" TRIM
on those SSDs that can do it without a performance penalty.

It would be nice if the fitrim ioctl were to issue TRIM commands only
for newly created garbage blocks that haven't already been trimmed. But
I guess that would require some major changes to the file system data
structures. At the least, it would require some special record-keeping
to keep track of this information. The Intel drive shows it's possible
to implement a very speedy TRIM, so maybe it won't be such a bad thing
to just trim the whole free list every time.

Phil

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
