Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4VFGXHL054140 for <xfs@oss.sgi.com>; Tue, 31 May 2011 10:16:33 -0500
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7E922516844
	for <xfs@oss.sgi.com>; Tue, 31 May 2011 08:16:31 -0700 (PDT)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id dNKfoEQzLGAI4wti
	for <xfs@oss.sgi.com>; Tue, 31 May 2011 08:16:31 -0700 (PDT)
Received: from dermichi-2-pt.tunnel.tserv23.zrh1.ipv6.he.net
	([2001:470:25:4f4::2])
	by firestarter.dermichi.com with esmtpsa (TLSv1:CAMELLIA256-SHA:256)
	(Exim 4.76) (envelope-from <mw@dermichi.com>) id 1QRQgJ-0000EY-5g
	for xfs@oss.sgi.com; Tue, 31 May 2011 17:16:31 +0200
Message-ID: <4DE5064D.1010203@dermichi.com>
Date: Tue, 31 May 2011 17:16:29 +0200
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: xfssyncd and disk spin down
References: <20101223165532.GA23813@peter.simplex.ro>	<20101227021904.GA24828@dastard>	<20101227061629.GA2275@pandora.simplex.ro>	<20101227140750.GB24828@dastard>	<20101227171939.GA7759@pandora.simplex.ro>	<20101231001323.GD15179@dastard>	<20110120100143.GA2007@peter.simplex.ro>	<20110120234310.GV16267@dastard>	<20110210204254.GA10451@peter.simplex.ro>	<20110210221851.GG2559@dastard>	<loom.20110214T185310-606@post.gmane.org>
	<loom.20110531T163459-953@post.gmane.org>
In-Reply-To: <loom.20110531T163459-953@post.gmane.org>
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
To: xfs@oss.sgi.com

Brian wrote:
> 
> Can anyone please comment if this bug was ever fixed?
> 
> I have searched and see no further talk about this.
> 
> echo 720000 > /proc/sys/fs/xfs/xfssyncd_centisecs allows a drive to sleep more
> often, but still is impacted by this. 
> 
> Thanks!
> 
AFAICT nothing has changed in this regard. I sill see the same behavior
with kernel 2.6.39. Thanks to this thread i found out about the problems
related to accumulating head unloads which i was able to mitigate by
setting xfssyncd_centisecs to a higher value.

cheers,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
