Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9NCPADc044860 for <xfs@oss.sgi.com>; Tue, 23 Oct 2012 07:25:10 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	75wrZagKuTcgCCwi (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Oct 2012 05:26:53 -0700 (PDT)
Date: Tue, 23 Oct 2012 08:26:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsdump:fill in bs_forkoff
Message-ID: <20121023122652.GE7341@infradead.org>
References: <5080D0BD.3000304@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5080D0BD.3000304@redhat.com>
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

On Thu, Oct 18, 2012 at 11:02:05PM -0500, Eric Sandeen wrote:
> Upstream, the structure containing bs_forkoff is actually zeroed
> prior to these functions, but when pulling the patch back to an
> older xfsdump, we got checksum errors due to an uninitialized
> bs_forkoff not matching in dump vs. restore.
> 
> So even though forkoff won't be explicitly restored from
> a dump, do explicitly set it in these routines to keep checksums
> happy.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
