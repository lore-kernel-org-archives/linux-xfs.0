Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAPLZqnW010120 for <xfs@oss.sgi.com>; Wed, 25 Nov 2009 15:35:53 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8054918E5349
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2009 13:36:18 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kYTqZgZTcakKHjXn for
	<xfs@oss.sgi.com>; Wed, 25 Nov 2009 13:36:18 -0800 (PST)
Message-ID: <4B0DA34A.1030400@redhat.com>
Date: Wed, 25 Nov 2009 15:36:10 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 213: Add enospc case to fallocate test
References: <4B0D66F7.5080704@redhat.com>
	<20091125210731.GB12150@infradead.org>
In-Reply-To: <20091125210731.GB12150@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs mailing list <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Wed, Nov 25, 2009 at 11:18:47AM -0600, Eric Sandeen wrote:
>> Add a test for ENOSPC when fallocating.
>>
>> Also, add an expected output, not sure how that went missing!
> 
> Oops.  Easily to do because xfstests doesn't complain but rather just
> skips tests without golden output..
> 
> I guess the ENOSPC test is to catch the inverted error returns just
> detected?

yep

> Anyway, looks good,

thanks!

-eric

> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
