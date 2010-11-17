Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAHFU9LT037603 for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 09:30:09 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 506D68F808E
	for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 07:31:40 -0800 (PST)
Message-ID: <4CE3F55C.9080902@sgi.com>
Date: Wed, 17 Nov 2010 09:31:40 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3 9/9] xfsrestore: check for compatible xfsrestore
References: <20101116150502.179825893@sgi.com>
	<20101116150705.423217632@sgi.com>
	<20101117093842.GI17317@infradead.org>
In-Reply-To: <20101117093842.GI17317@infradead.org>
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

On 11/17/2010 03:38 AM, Christoph Hellwig wrote:
> On Tue, Nov 16, 2010 at 09:05:11AM -0600, wkendall@sgi.com wrote:
>> When resuming a restore or doing a cumulative restore, xfsrestore
>> reads state information left around by the previous invocation.
>> This patch adds logic to determine whether or not restore is
>> able to make sense of the sense information.
>>
>> The xfsrestore man page has also been updated to make the user
>> aware of the requirement to use a compatible restore and
>> system when resuming restores.
>
> Shouldn't you use the opportunity to switch everything in the on-disk
> layout to explicitly sized types?  Seeing things like the bool types
> in the persistant structures really scares me.

Just to be clear, the state information is used only for the life of
a series of restores. You restore your level 0 dump, then run restore
again on your level 1, and so on. After that the state information is not
used and would be deleted.

Given how unlikely it is for someone to start a restore on one system
and continue it on another (incompatible) system, and since your suggested
change would ripple out into all the code that touches any of the on-disk
structures, I'd prefer to simply detect a change in the size of types. I
would think that recording/checking the size of a pointer would be
sufficient, assuming your main concern is type size differences between
32-bit and 64-bit systems.

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
