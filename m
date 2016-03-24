Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AD2447CA0
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 04:43:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 693F68F8037
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 02:43:04 -0700 (PDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com
	[74.125.82.48]) by cuda.sgi.com with ESMTP id jkMOjQh4EWhenlW4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Mar 2016 02:43:02 -0700 (PDT)
Received: by mail-wm0-f48.google.com with SMTP id l68so266473026wml.0
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 02:43:02 -0700 (PDT)
Subject: Re: Failing XFS memory allocation
References: <56F26CCE.6010502@kyup.com> <20160324093345.GA13569@infradead.org>
From: Nikolay Borisov <kernel@kyup.com>
Message-ID: <56F3B6A1.4020400@kyup.com>
Date: Thu, 24 Mar 2016 11:42:57 +0200
MIME-Version: 1.0
In-Reply-To: <20160324093345.GA13569@infradead.org>
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



On 03/24/2016 11:33 AM, Christoph Hellwig wrote:
> Hi Nikolay,
> 
> can you give the patch below a spin?  While it doesn't solve the root
> cause it makes many typical uses of kmem_realloc behave less badly,
> so it should help with at least some of the less dramatic cases of very
> fragmented files:
> 

Sure, however I just checked some other servers with analogical setup
and there are files which even larger extents (the largest I saw was 2
millions) so I guess in this particular case the memory was fragmented
and compaction as invoked from the page allocator couldn't satisfy it.
So I don't know if it will help in my particular case but in any case I
will give it a go.

Thanks

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
