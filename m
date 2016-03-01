Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3B1FB7CB3
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 07:11:11 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B3308AC001
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 05:11:10 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cCgvZ63MAZ9XZDpJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Mar 2016 05:11:05 -0800 (PST)
Date: Tue, 1 Mar 2016 08:11:03 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/3] xfs: borrow indirect blocks from freed extent when
	available
Message-ID: <20160301131103.GB22465@bfoster.bfoster>
References: <1456756170-51248-1-git-send-email-bfoster@redhat.com>
	<1456756170-51248-4-git-send-email-bfoster@redhat.com>
	<20160301130018.GA28675@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160301130018.GA28675@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Mar 01, 2016 at 05:00:18AM -0800, Christoph Hellwig wrote:
> I've been wrapping my head around this since yersterday..
> 
> It looks reasonable, but I'd be much more comfortable if you could
> split this into two patches:
> 
>  - one to just factor out a helper to update the temp and temp2
>    values (great variable names while we're at it..  not your fault,
>    though)
>  - one to actually change the algorithm used.

Sure, will do.

Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
