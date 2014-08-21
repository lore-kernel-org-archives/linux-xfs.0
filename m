Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DD94F7F51
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 12:45:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C9D898F8037
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 10:45:28 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id vpPgmfHIiPnE2Psr for <xfs@oss.sgi.com>;
	Thu, 21 Aug 2014 10:45:28 -0700 (PDT)
Message-ID: <53F6303D.7060407@sandeen.net>
Date: Thu, 21 Aug 2014 12:45:33 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: use abort() not ASSERT(0) for impossible switch
	case
References: <53F62D12.8010505@sandeen.net>
	<20140821174414.GA28860@infradead.org>
In-Reply-To: <20140821174414.GA28860@infradead.org>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On 8/21/14, 12:44 PM, Christoph Hellwig wrote:
> On Thu, Aug 21, 2014 at 12:32:02PM -0500, Eric Sandeen wrote:
>> The original reason for the expletive below has been lost
>> in the mists of time, but at any rate, ASSERT() goes away in
>> libxfs, and this leads static analysis checkers to believe that
>> XFS_BTNUM_MAX is possible, and that we might overflow an array
>> later when using it as an index.
>>
>> We can shut this up and mark it as truly impossible with abort().
> 
> This won't work in kernel space, and we'd like to keep this file in sync.

Ah, right, sorry - spaced out that it was shared.

I'll add ASSERT_ALWAYS() to userspace then, perhaps.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
