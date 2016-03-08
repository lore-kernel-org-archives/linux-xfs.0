Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8F3D929E05
	for <xfs@oss.sgi.com>; Tue,  8 Mar 2016 01:01:58 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0DF5AAC001
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 23:01:54 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id rnagbEPznKnvMa44 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 07 Mar 2016 23:01:51 -0800 (PST)
Date: Mon, 7 Mar 2016 23:01:49 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] xfs: ioends require logically contiguous file offsets
Message-ID: <20160308070149.GA30440@infradead.org>
References: <1457300990-18300-1-git-send-email-david@fromorbit.com>
	<1457300990-18300-3-git-send-email-david@fromorbit.com>
	<20160307162644.GB19784@infradead.org>
	<20160308023311.GB27689@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160308023311.GB27689@birch.djwong.org>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Thanks Darrick,

the explanation looks fine to me.  I suspect it's still only really
needed for COW, but together with my earlier direct I/O changes
it makes the ioend rules sensible in general, so I'm all for it!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
