Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5HC8evV117418 for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 07:08:40 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9AB4951DB08
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 05:08:39 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	B69PvejBEFfJE9WJ for <xfs@oss.sgi.com>;
	Fri, 17 Jun 2011 05:08:39 -0700 (PDT)
Date: Fri, 17 Jun 2011 08:08:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3 v5] XFS TESTS: Add ENOSPC Hole Punch Test
Message-ID: <20110617120838.GA20714@infradead.org>
References: <4DED6405.7020104@vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DED6405.7020104@vnet.ibm.com>
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
To: Allison Henderson <achender@vnet.ibm.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

This one fails for me because my test system doesn't have sudo
installed.  I can't see any reason why a simple su wouldn't be enough.

We already have a helper to make su usable on both IRIX and Linux in
test 123, and it might be a good idea to add this to the common routines
and use it.

I'd also suggest to split this test off 252 into a new test case, as
unlike the other tests it actually requires a scratch devices, and in
general is pretty different from the simple xfs_io exercises in 252.

I'd also move the newly added helpers directly into the new testcase
as they really aren't common.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
