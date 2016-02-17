Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AC0A97CA2
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 04:10:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9C110304053
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 02:10:17 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id YIKTv2Aak5EFBZ7C (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 17 Feb 2016 02:10:14 -0800 (PST)
Date: Wed, 17 Feb 2016 02:10:12 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] generic/304: fix high offset
Message-ID: <20160217101012.GA15314@infradead.org>
References: <20160215204608.7977.2802.stgit@birch.djwong.org>
	<20160215204614.7977.2848.stgit@birch.djwong.org>
	<20160217095646.GA21482@infradead.org>
	<CAL3q7H5NRUXvo=mEtGr4-S4yPT7k_yw6LsMAq_V8bPD1T=7r0g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAL3q7H5NRUXvo=mEtGr4-S4yPT7k_yw6LsMAq_V8bPD1T=7r0g@mail.gmail.com>
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
To: Filipe Manana <fdmanana@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, fstests@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>

On Wed, Feb 17, 2016 at 10:04:23AM +0000, Filipe Manana wrote:
> > What does btrfs return here?
> 
> -EINVAL, so this makes the test pass on btrfs.

Ok, looks fine to me then:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
