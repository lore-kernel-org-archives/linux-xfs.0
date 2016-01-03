Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CE1CA7F37
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 06:17:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 544E2AC003
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 04:17:31 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id PMltMAXhjqORWQKd (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 03 Jan 2016 04:17:29 -0800 (PST)
Date: Sun, 3 Jan 2016 04:17:28 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 34/76] xfs: implement XFS_IOC_SWAPEXT when rmap btree is
	enabled
Message-ID: <20160103121728.GC28429@infradead.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
	<20151219090008.12713.25755.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151219090008.12713.25755.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

On Sat, Dec 19, 2015 at 01:00:08AM -0800, Darrick J. Wong wrote:
> Implement extent swapping when reverse-mapping is enabled.

Can you just fold this into the previous patch?  There seem to be a lot
of patches in the series that would benefit from merging, but this
is the one that really screams for it :)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
