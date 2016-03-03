Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D4D987CA1
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2016 08:06:02 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5FED0AC004
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2016 06:05:59 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id GPw3WS89wIdBG8cu (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 03 Mar 2016 06:05:57 -0800 (PST)
Date: Thu, 3 Mar 2016 06:05:56 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: block allocations for the refcount btree
Message-ID: <20160303140556.GA26825@infradead.org>
References: <20160210190738.GA13051@infradead.org>
	<20160210214058.GN14668@dastard>
	<20160212191046.GA28421@infradead.org>
	<20160301181809.GC27973@birch.djwong.org>
	<20160301204013.GA23128@infradead.org>
	<20160302052411.GB1902@birch.djwong.org>
	<20160302095932.GA9141@infradead.org>
	<20160302164102.GA20109@birch.djwong.org>
	<20160302165704.GA31438@infradead.org>
	<20160302212101.GF27973@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160302212101.GF27973@birch.djwong.org>
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

On Wed, Mar 02, 2016 at 01:21:01PM -0800, Darrick J. Wong wrote:
> Ok.  I think the problem is that making changes to the refcount btree eats
> up our entire reservation in certain cases.  Can you try the following bandaid?
> This should give us enough room to handle splitting the btree at both ends
> of a range that we're refcount-changing.

This seems to work in general.  I ran into one log related hang when
running -g auto on nfs, but it's not been reproducible so far.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
