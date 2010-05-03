Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o43Bo5h4151871 for <xfs@oss.sgi.com>; Mon, 3 May 2010 06:50:05 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 69EC81DE3387
	for <xfs@oss.sgi.com>; Mon,  3 May 2010 04:52:10 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	BDbJ2ZjC64XKKSHK for <xfs@oss.sgi.com>;
	Mon, 03 May 2010 04:52:10 -0700 (PDT)
Date: Mon, 3 May 2010 21:52:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: read slower than write on "mv"?
Message-ID: <20100503115207.GE2591@dastard>
References: <201005031054.38817@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201005031054.38817@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Mon, May 03, 2010 at 10:54:28AM +0200, Michael Monnerie wrote:
> This is not XFS specific, I see it on every filesys. I do a 
> "mv . /newlocation" and see this with iostat:
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-
> sz avgqu-sz   await  svctm  %util
> xvdb              608,60    2,60 25967,20   102,40    85,31     5,37    
> 8,77   1,58  96,72
> xvdg              0,00  608,60     0,00 26532,10    87,19     7,55   
> 12,41   0,12   7,44
> 
> Reading takes 97% I/O time, writing 7%. This is on the same raidset, but 
> I see the same when copying between two different single disks also. Or 
> is it just an effect of write caching that writes look faster than 
> reads?

Yes, just an effect of write caching hiding IO latency.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
