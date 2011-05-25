Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4PA6cno132444 for <xfs@oss.sgi.com>; Wed, 25 May 2011 05:06:38 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C4B7014D9F2F
	for <xfs@oss.sgi.com>; Wed, 25 May 2011 03:06:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id r7z6a2MAEqCRzjva for
	<xfs@oss.sgi.com>; Wed, 25 May 2011 03:06:36 -0700 (PDT)
Date: Wed, 25 May 2011 12:06:32 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: automatically running fstrim
In-Reply-To: <4DDBE293.8030203@philkarn.net>
Message-ID: <alpine.LFD.2.00.1105251155120.4667@dhcp-27-109.brq.redhat.com>
References: <4DDBE293.8030203@philkarn.net>
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
To: Phil Karn <karn@philkarn.net>
Cc: xfs@oss.sgi.com

On Tue, 24 May 2011, Phil Karn wrote:

> Now that the Linux 2.6.39 kernel is out, is there any reason I shouldn't
> run fstrim out of my crontab? It doesn't seem to slow down my system
> significantly while it runs.
> 
> As I understand fstrim, it walks through the file system free list
> issuing TRIMs for each entry, and except for whatever load the TRIM
> commands themselves generate (which is drive dependent) it shouldn't
> interfere that much with system operation. Correct? Is there any
> mechanism to issue these commands at a lower priority than regular disk I/O?

No, not that I know of. But why not to run fstrim from cron lets say every
day ? Note that you do not necessarily need to run it "all the time",
because if the drive firmware has a lot of space for doing
wear-leveling, there is no point of sending TRIM.

Also keep in mind that lot of newer SSD's has some "hidden" space just
for wear-leveling, so to get to the point where firmware will have hard
time doing it and the drive actually get slower takes even more writes
than just filling your drive up to max.

So doing fstrim once or twice a day (it really depends on your work
load) is more than enough.

Also, since we have all this in place we might talk to distributions to
add the infrastructure to actually recognise "discard enabled" devices
and add fstrim into cron job automatically. Or, since the filesystem
should know the best when is the "right" time to do this, we might try
to figure out some kernel logic to trigger it. However it might be a
little bit tricky, since every drive behaves differently...

Thanks!
-Lukas

> 
> Thanks for all the work you guys do on XFS. It is much appreciated.
> 
> Phil
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
