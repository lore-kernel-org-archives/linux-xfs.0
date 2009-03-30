Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2UJ02mW210018 for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 14:00:12 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0F2558F80C3
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 11:59:38 -0700 (PDT)
Message-Id: <62A5B706-A608-4E51-8837-7F9EDCE69634@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090330185624.GA21753@infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] xfstests: fix async io error handling in fsx
Date: Mon, 30 Mar 2009 13:59:38 -0500
References: <1238391050-14211-1-git-send-email-felixb@sgi.com>
	<20090330175451.GA1041@infradead.org>
	<2466E954-2122-4FEB-B3DA-8F06AA22BAB7@sgi.com>
	<20090330185624.GA21753@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


On Mar 30, 2009, at 1:56 PM, Christoph Hellwig wrote:

> On Mon, Mar 30, 2009 at 01:53:21PM -0500, Felix Blyakher wrote:
>>>> +		/*
>>>> +		 * The b0rked libaio defines event.res as signed.
>>>> +		 * However the kernel strucuture has it unsigned,
>>>> +		 * and it's used to pass negated error value.
>>>> +		 * Till the library is fixed use the temp var.
>>>> +		 */
>>>
>>> This comment seems backwards to the patch description and the actual
>>> code.
>>
>> Hmm, not really.
>> If the libaio library would be correct (do you know whom to talk
>> to and where to send a patch), the code would look like this:
>
> Yeah, but shouldn't the comment read:
>
> 	/*
> 	 * The b0rked libaio defines event.res as *unsigned*.
> 	 * However the kernel strucuture has it *signed*,

Ohh, I was blind twice.
Sure, you're right. Thanks for pointing it out.

Felix

>
> 	 * and it's used to pass negated error value.
> 	 * Till the library is fixed use the temp var.
> 	 */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
