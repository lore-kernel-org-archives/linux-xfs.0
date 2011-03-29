Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2TJ3jBx243949
	for <linux-xfs@oss.sgi.com>; Tue, 29 Mar 2011 14:03:45 -0500
Received: from mx5.twosigma.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id AD61E1445549
	for <linux-xfs@oss.sgi.com>; Tue, 29 Mar 2011 12:06:55 -0700 (PDT)
Received: from mx5.twosigma.com (mx5.twosigma.com [208.77.212.35]) by
	cuda.sgi.com with SMTP id VNN1ir3AlhS0uhOf for
	<linux-xfs@oss.sgi.com>; Tue, 29 Mar 2011 12:06:55 -0700 (PDT)
From: Sean Noonan <Sean.Noonan@twosigma.com>
Date: Tue, 29 Mar 2011 15:05:28 -0400
Subject: RE: XFS memory allocation deadlock in 2.6.38
Message-ID: <081DDE43F61F3D43929A181B477DCA95639B5359@MSXAOA6.twosigma.com>
References: <081DDE43F61F3D43929A181B477DCA95639B52FD@MSXAOA6.twosigma.com>
	<081DDE43F61F3D43929A181B477DCA95639B5327@MSXAOA6.twosigma.com>
	<20110324174311.GA31576@infradead.org>
	<AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
	<081DDE43F61F3D43929A181B477DCA95639B5349@MSXAOA6.twosigma.com>
	<BANLkTin0jJevStg5P2hqsLbqMzo3o30sYg@mail.gmail.com>
	<081DDE43F61F3D43929A181B477DCA95639B534E@MSXAOA6.twosigma.com>
In-Reply-To: <081DDE43F61F3D43929A181B477DCA95639B534E@MSXAOA6.twosigma.com>
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
To: Sean Noonan <Sean.Noonan@twosigma.com>, 'Michel Lespinasse' <walken@google.com>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>, Christos Zoulas <Christos.Zoulas@twosigma.com>, Trammell Hudson <Trammell.Hudson@twosigma.com>, Martin Bligh <Martin.Bligh@twosigma.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, Stephen Degler <Stephen.Degler@twosigma.com>, 'Christoph Hellwig' <hch@infradead.org>, "'linux-mm@kvack.org'" <linux-mm@kvack.org>

>> Could you test if you see the deadlock before
>> 5ecfda041e4b4bd858d25bbf5a16c2a6c06d7272 without MAP_POPULATE ?

> Built and tested 72ddc8f72270758951ccefb7d190f364d20215ab.
> Confirmed that the original bug does not present in this version.
> Confirmed that removing MAP_POPULATE does cause the deadlock to occur.

git bisect leads to this:

bdfb04301fa5fdd95f219539a9a5b9663b1e5fc2 is the first bad commit
commit bdfb04301fa5fdd95f219539a9a5b9663b1e5fc2
Author: Christoph Hellwig <hch@infradead.org>
Date:   Wed Jan 20 21:55:30 2010 +0000

    xfs: replace KM_LARGE with explicit vmalloc use
    
    We use the KM_LARGE flag to make kmem_alloc and friends use vmalloc
    if necessary.  As we only need this for a few boot/mount time
    allocations just switch to explicit vmalloc calls there.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Alex Elder <aelder@sgi.com>

:040000 040000 1eed68ced17d8794fa842396c01c3b9677c6e709 d462932a318f8c823fa2a73156e980a688968cb2 M	fs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
