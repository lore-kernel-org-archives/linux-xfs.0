Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EFF6C29E04
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 08:23:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E162F8F8070
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 06:23:35 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id oFEjA2lCQw5P5Fdo for
	<xfs@oss.sgi.com>; Fri, 13 Dec 2013 06:23:35 -0800 (PST)
Message-ID: <52AB1863.9070404@redhat.com>
Date: Fri, 13 Dec 2013 09:23:31 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/5] libxfs: buffer cache hashing is suboptimal
References: <1386832945-19763-1-git-send-email-david@fromorbit.com>
	<1386832945-19763-5-git-send-email-david@fromorbit.com>
	<52AA078E.90800@redhat.com> <20131212205657.GA10988@dastard>
In-Reply-To: <20131212205657.GA10988@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 12/12/2013 03:56 PM, Dave Chinner wrote:
> On Thu, Dec 12, 2013 at 01:59:26PM -0500, Brian Foster wrote:
>> On 12/12/2013 02:22 AM, Dave Chinner wrote:
>>> From: Dave Chinner <dchinner@redhat.com>
>>>
>>> The hashkey calculation is very simplistic,and throws away an amount
>>> of entropy that should be folded into the hash. The result is
>>> sub-optimal distribution across the hash tables. For example, with a
>>> default 512 entry table, phase 2 results in this:
>>>
>> ...
>>> Modify the hash to be something more workable - steal the linux
>>> kernel inode hash calculation and try that:
>>>
>> ...
>>>
>>> Kinda says it all, really...
>>>
>>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>>> ---
>>
>> Results look nice and the algorithm seems to match the kernel variant,
>> but what about the 32-bit alternate prime/cache line values? Safe to
>> leave out..?
> 
> The buffer cache uses a 64 bit key, regardless of the platform.
> Therefore the 64 bit variant is always needed. The kernel inode hash
> uses a 32 bit key on 32 bit systems, which is why there are two
> variants for it.
> 

Ah.. xfs_bufkey->blkno is an xfs_daddr_t, which is an __int64_t. Thanks.

Reviewed-by: Brian Foster <bfoster@redhat.com>

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
