Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB5GZs3U029389 for <xfs@oss.sgi.com>; Fri, 5 Dec 2008 10:35:55 -0600
Received: from lxorguk.ukuu.org.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE23816BDBC2
	for <xfs@oss.sgi.com>; Fri,  5 Dec 2008 08:35:51 -0800 (PST)
Received: from lxorguk.ukuu.org.uk (earthlight.etchedpixels.co.uk
	[81.2.110.250]) by cuda.sgi.com with ESMTP id KcYFdvsCXhbykIXQ
	for <xfs@oss.sgi.com>; Fri, 05 Dec 2008 08:35:51 -0800 (PST)
Date: Fri, 5 Dec 2008 11:52:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Device loses barrier support (was: Fixed patch for simple
	barriers.)
Message-ID: <20081205115225.13c277ee@lxorguk.ukuu.org.uk>
In-Reply-To: <20081205013739.GZ6703@one.firstfloor.org>
References: <20081204142015.GQ6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812040913510.6118@hs20-bc2-1.build.redhat.com>
	<20081204145810.GR6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812041139200.2434@hs20-bc2-1.build.redhat.com>
	<20081204174838.GS6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812041401210.23079@hs20-bc2-1.build.redhat.com>
	<20081204221551.GV6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812041756550.29638@hs20-bc2-1.build.redhat.com>
	<20081205004849.GX6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812041948400.14114@hs20-bc2-1.build.redhat.com>
	<20081205013739.GZ6703@one.firstfloor.org>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <andi-suse@firstfloor.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>

On Fri, 5 Dec 2008 02:37:39 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> > * barrier support in md-raid1 deviates from the specification at 
> > Documentation/block/barrier.txt. The specification says that requests 
> > submitted after the barrier request hit the media after the barrier 
> > request hits the media. The reality is that the barrier request can be 
> > randomly aborted and the requests submitted after it hit the media before 
> > the barrier request.
> 
> Yes the spec should be probably updated.
> 
> But also see Linus' rant from yesterday about code vs documentation.
> When in doubt the code wins.

Not when the fundamental design of the code is broken and trashes
performance. The documented behaviour is strongly desirable.

Alan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
