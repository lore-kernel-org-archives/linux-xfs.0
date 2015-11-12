Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 38C3C7F62
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 06:51:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2873C304039
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 04:51:25 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id CDnPn14F8A2SALEp (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 12 Nov 2015 04:51:22 -0800 (PST)
Date: Thu, 12 Nov 2015 04:51:15 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFCv3.1 00/11] xfstests: test the nfs/cifs/btrfs/xfs
	reflink/dedupe ioctls
Message-ID: <20151112125115.GA28822@infradead.org>
References: <20151111192628.15056.6451.stgit@birch.djwong.org>
	<20151112090756.GA25685@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151112090756.GA25685@infradead.org>
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
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, tao.peng@primarydata.com, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org

On Thu, Nov 12, 2015 at 01:07:56AM -0800, Christoph Hellwig wrote:
> Looks fine:
> 
> Acked-by: Christoph Hellwig <hch@lst.de>

Actually I take this back.  I had though this was the existing series
with my fixes, but this one still incorrectly assumes that if reflink
works dedup works as well, leading to lots of false failures on nfs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
