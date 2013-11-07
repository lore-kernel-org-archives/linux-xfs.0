Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2F2667FF0
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 07:58:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B5940AC005
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 05:58:24 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id FgfP1NyGQpo6HzRz for <xfs@oss.sgi.com>;
	Thu, 07 Nov 2013 05:58:23 -0800 (PST)
Message-ID: <527B9C80.4060304@sandeen.net>
Date: Thu, 07 Nov 2013 07:58:24 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfstest failures
References: <20131106105451.GA31283@infradead.org>	<20131106194417.GF6188@dastard>
	<527A9F67.6000208@sgi.com>	<20131107081634.GB25157@infradead.org>
	<527B94A5.20004@sgi.com>
In-Reply-To: <527B94A5.20004@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>, Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 11/7/13, 7:24 AM, Mark Tinguely wrote:
> On 11/07/13 02:16, Christoph Hellwig wrote:
>> On Wed, Nov 06, 2013 at 01:58:31PM -0600, Mark Tinguely wrote:
>>>
>>>>> xfs/206
>>>>>
>>>>>     Does not expect the ftype flag.  Didn't we change a generic
>>>>>     filter to take care of this?
>>>>
>>>> xfs/206 has it's own mkfs filter:
>>>>
>>>> http://oss.sgi.com/archives/xfs/2013-10/msg00777.html
>>
>> And why is this patch not merged?
>>
> 
> It was never reviewed.

Nor was xfstests: filter projid32bit info out of growfs & info output
which I sent originally, before the ftype stuff went in.

Nor was xfstests: New _require_* tests for CRC enabled filesystems which
Dave sent back in June, which Dave alluded to as fixing this as well.
I circled back to it in October w/ a suggestion but haven't seen a
repost.

This lag is clearly causing headaches for all of us; let's just take
a deep breath & get these taken care of.

We had a really high rate of change there for a while, and keeping up on
all fronts was tough.

There's been a bit of defensiveness in the replies here; let's get past
that & take Christoph's list of failures and just get them taken care of.

I'll try to go through the failures and either pick up existing patches,
or get new ones written, and get a new series on the list to get this all
cleaned up.

-Eric


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
