Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8S9uw7P209715 for <xfs@oss.sgi.com>; Fri, 28 Sep 2012 04:56:58 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	aqiSoUJIbC6j89b6 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 28 Sep 2012 02:58:16 -0700 (PDT)
Date: Fri, 28 Sep 2012 05:58:15 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests 068: Add mmap load
Message-ID: <20120928095815.GA14240@infradead.org>
References: <50651A99.1070307@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50651A99.1070307@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Sep 27, 2012 at 10:33:45PM -0500, Eric Sandeen wrote:
> Test 068 is the go-to test for freeze deadlock coverage;
> unfortunately it only uses fsstress, which doesn't do any mmap
> IO.
> 
> Using the existing fstest binary gets us a cheap mmap exerciser
> as well.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
