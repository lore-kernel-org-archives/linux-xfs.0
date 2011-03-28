Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2SEtlEN171345
	for <linux-xfs@oss.sgi.com>; Mon, 28 Mar 2011 09:55:48 -0500
Received: from mx5.twosigma.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF2E71131976
	for <linux-xfs@oss.sgi.com>; Mon, 28 Mar 2011 07:58:56 -0700 (PDT)
Received: from mx5.twosigma.com (mx5.twosigma.com [208.77.212.35]) by
	cuda.sgi.com with ESMTP id bEFM3kZIhx2rvwf2 for
	<linux-xfs@oss.sgi.com>; Mon, 28 Mar 2011 07:58:56 -0700 (PDT)
From: Sean Noonan <Sean.Noonan@twosigma.com>
Date: Mon, 28 Mar 2011 10:58:53 -0400
Subject: RE: XFS memory allocation deadlock in 2.6.38
Message-ID: <081DDE43F61F3D43929A181B477DCA95639B5349@MSXAOA6.twosigma.com>
References: <081DDE43F61F3D43929A181B477DCA95639B52FD@MSXAOA6.twosigma.com>
	<081DDE43F61F3D43929A181B477DCA95639B5327@MSXAOA6.twosigma.com>
	<20110324174311.GA31576@infradead.org>
	<AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
In-Reply-To: <AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
Content-Language: en-US
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
To: 'Michel Lespinasse' <walken@google.com>, Christoph Hellwig <hch@infradead.org>
Cc: Trammell Hudson <Trammell.Hudson@twosigma.com>, Christos Zoulas <Christos.Zoulas@twosigma.com>, Bligh <Martin.Bligh@twosigma.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stephen Degler <Stephen.Degler@twosigma.com>, "linux-xfs@oss.sgi.com" <linux-xfs@oss.sgi.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Martin@oss.sgi.com

> Regarding the deadlock: I am curious to see if it could be made to
> happen before 5ecfda041e4b4bd858d25bbf5a16c2a6c06d7272. Could you test
> what happens if you remove the MAP_POPULATE flag from your mmap call,
> and instead read all pages from userspace right after the mmap ? I
> expect you would then be able to trigger the deadlock before
> 5ecfda041e4b4bd858d25bbf5a16c2a6c06d7272.

I still see the deadlock without MAP_POPULATE

Sean

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
