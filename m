Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D433B7F51
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2015 10:34:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B24BB30404E
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2015 08:34:53 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 9O34LbqvXNDhZoHa (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 10 Dec 2015 08:34:52 -0800 (PST)
Date: Thu, 10 Dec 2015 08:34:49 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] reflink: more tests
Message-ID: <20151210163449.GA15774@infradead.org>
References: <20151208062844.21871.23644.stgit@birch.djwong.org>
	<20151208062904.21871.30589.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151208062904.21871.30589.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, tao.peng@primarydata.com, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org

The new 849 fails reliably on btrfs, which makes me wonder if either
the test is doing something wrong, or the btrfs whole file clone
behavior is broken, which wouldn't be very reasuring.  I didn't have
time to look into why it's failing yet.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
