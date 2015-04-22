Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9DBFB7F37
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2015 17:06:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8C3B88F804B
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2015 15:06:17 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id wClOJUiL8BHct782 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 Apr 2015 15:06:14 -0700 (PDT)
Date: Wed, 22 Apr 2015 15:06:11 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: don't trigger fsync log force based on inode pin
	count
Message-ID: <20150422220611.GA8881@infradead.org>
References: <1429713466-22137-1-git-send-email-bfoster@redhat.com>
	<20150422161509.GA27237@infradead.org>
	<20150422171322.GB6688@bfoster.bfoster>
	<20150422211845.GP21261@dastard>
	<20150422220244.GA48944@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150422220244.GA48944@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Apr 22, 2015 at 06:02:44PM -0400, Brian Foster wrote:
> That was what I thought at first but I bumped the extent count a couple
> times and still couldn't reproduce. I was curious enough to track it
> down and it is actually the time update again. For whatever reason, I
> think the crc mechanism is throwing the timing off and just hiding the
> problem again. E.g., no-op xfs_vn_time_update() and the problem
> reproduces on v5 as well.

Actually, its the changecount again.  If MS_I_VERSION is set
the VFS will always call into ->xfs_vn_time_update.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
