Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9B8777F4E
	for <xfs@oss.sgi.com>; Tue, 24 Sep 2013 09:04:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5F3738F8050
	for <xfs@oss.sgi.com>; Tue, 24 Sep 2013 07:04:39 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id vU4kENamFM42HCEN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Sep 2013 07:04:38 -0700 (PDT)
Message-ID: <52419C20.8040105@oracle.com>
Date: Tue, 24 Sep 2013 22:05:20 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: improve xfs_iext_destroy() by freeing extent
	indirection array directly
References: <523C5E92.8000406@oracle.com> <20130923003617.GM12541@dastard>
	<523FCA18.1000204@oracle.com> <20130923235017.GX9901@dastard>
In-Reply-To: <20130923235017.GX9901@dastard>
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 09/24/2013 07:50 AM, Dave Chinner wrote:

> On Mon, Sep 23, 2013 at 12:56:56PM +0800, Jeff Liu wrote:
>> On 09/23/2013 08:36 AM, Dave Chinner wrote:
>>
>>> On Fri, Sep 20, 2013 at 10:41:22PM +0800, Jeff Liu wrote:
>>>> From: Jie Liu <jeff.liu@oracle.com>
>>>>
>>>> To free the incore file extents stores at the indirection array, we
>>>> call the common routine xfs_iext_irec_remove() to remove a record
>>>> from the array one at a time in reverse order, which will resize an
>>>> extent indirection array repeatedly according to the array size.
>>>>
>>>> This is not often the case to make a file with thousands extent records
>>>> stores at an indirection array, but above operation is inefficient and
>>>> could result in memory fragments.
>>>
>>> Yes, it may be inefficient, but I don't see that it's a contributor
>>> to memory fragmentation as the reallocated buffer is freed shortly
>>> after it has been allocated as the array shrinks. Do you have any
>>> evidence to suggest that such behaviour is actually fragmenting
>>> memory? If so, is the any test case that reproduces this problem?
>>
>> Ah, yes, it should not cause memory fragmentation.
>>
>> The benefits is that this change could save alloc/free buffers depending
>> on the number of extents records are stored at indirection array.
> 
> OK, can you send a new version with an updated commit message?

Sure, will post it soon.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
