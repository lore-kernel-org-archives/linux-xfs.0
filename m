Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB5CIpXq013384 for <xfs@oss.sgi.com>; Fri, 5 Dec 2008 06:18:53 -0600
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 197AC16B5797
	for <xfs@oss.sgi.com>; Fri,  5 Dec 2008 04:18:50 -0800 (PST)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id M3ZaQJtaQTeGgYRn for
	<xfs@oss.sgi.com>; Fri, 05 Dec 2008 04:18:50 -0800 (PST)
Date: Fri, 5 Dec 2008 13:29:30 +0100
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Device loses barrier support (was: Fixed patch for simple
	barriers.)
Message-ID: <20081205122930.GB6703@one.firstfloor.org>
References: <20081204145810.GR6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812041139200.2434@hs20-bc2-1.build.redhat.com>
	<20081204174838.GS6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812041401210.23079@hs20-bc2-1.build.redhat.com>
	<20081204221551.GV6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812041756550.29638@hs20-bc2-1.build.redhat.com>
	<20081205004849.GX6703@one.firstfloor.org>
	<Pine.LNX.4.64.0812041948400.14114@hs20-bc2-1.build.redhat.com>
	<20081205013739.GZ6703@one.firstfloor.org>
	<20081205115225.13c277ee@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081205115225.13c277ee@lxorguk.ukuu.org.uk>
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
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi-suse@firstfloor.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Andi Kleen <andi@firstfloor.org>, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>

> Not when the fundamental design of the code is broken and trashes
> performance. 

Sorry but that's just not correct. There's nothing in late failing
barriers that "trashes performance". The file system writers have
to be careful to handle it, but at least the current ones all do.
And also if someone writes a hypothetical fully asynchronously driven 
barrier based IO transaction system it would be still possible to handle 
the late failing barrier without too many complications.

Also late failing barriers is pretty much the only sane way to implement
barriers in software remapping schemes like DM and MD.

-Andi

-- 
ak@linux.intel.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
