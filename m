Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7CA397F37
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 04:42:24 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0F069AC002
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 02:42:20 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id ri65ZcTXc4ZvNazn (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 05 Jan 2016 02:42:19 -0800 (PST)
Date: Tue, 5 Jan 2016 02:42:14 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfs: cancel COW in xfs_cancel_ioend
Message-ID: <20160105104214.GA16310@infradead.org>
References: <1451822873-12969-1-git-send-email-hch@lst.de>
	<1451822873-12969-4-git-send-email-hch@lst.de>
	<20160105014310.GK28330@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160105014310.GK28330@birch.djwong.org>
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
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, Jan 04, 2016 at 05:43:10PM -0800, Darrick J. Wong wrote:
> Hmm.  This might be the cause of the occasional complaints I've been seeing
> where allocated blocks remain in the COW fork when the inode is being cleared
> out.  That said, the xfs_reflink_end_cow_failed() is apparently missing a
> xfs_bunmapi_cow() to actually clean out the COW fork.

I can still reproduce xfs_reflink_cancel_pending_cow tripping over
allocated blocks in the COW fork over NFS.  generic/154 reproduces
it 100% over NFS, although when adding a delay before the cleanup
it disappears.  I'm currently trying to figure out why.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
