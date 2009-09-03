Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n83FitGk111768 for <xfs@oss.sgi.com>; Thu, 3 Sep 2009 10:45:10 -0500
Date: Thu, 3 Sep 2009 11:45:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] xfs: make sure xfs_sync_fsdata covers the log
Message-ID: <20090903154551.GA16715@infradead.org>
References: <20090827231558.057467775@bombadil.infradead.org>
	<1AB9A794DBDDF54A8A81BE2296F7BDFE83ABF3@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ABF3@cf--amer001e--3.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com


FYI: I found some nasty deadlock in this on a large machine, please
hold back until I've sorted it out.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
