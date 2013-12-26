Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5CD3B7F50
	for <xfs@oss.sgi.com>; Thu, 26 Dec 2013 04:45:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 076F7AC004
	for <xfs@oss.sgi.com>; Thu, 26 Dec 2013 02:45:02 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 47mYWYb23evYQF0B (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Dec 2013 02:45:01 -0800 (PST)
Message-ID: <52BC0888.3060702@oracle.com>
Date: Thu, 26 Dec 2013 18:44:24 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/4] xfs: rename mem_to_page to xfs_bufmem_to_page
References: <52B982AF.2060607@oracle.com>
	<20131226100825.GB11950@infradead.org>
In-Reply-To: <20131226100825.GB11950@infradead.org>
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 12/26 2013 18:08 PM, Christoph Hellwig wrote:
> On Tue, Dec 24, 2013 at 08:48:47PM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> Rename mem_to_page() to xfs_bufmem_to_page() for XFS convention.
> 
> There's nothing inherently buffere related in the function, it doesn't
> even take an argument related to buffers.
Well, I originally want to rename to xfs_buf_mem_to_page() by following
up other functions in this file with "xfs_buf_" prefix, something like
a typo...

Looks this routine can not be folded into xfs_buf_associate_memory()
without introducing another variable to hold the temporary type convert
value of pageaddr, so I'm fine if we remains the same.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
