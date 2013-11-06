Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 656DA29E30
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 13:58:44 -0600 (CST)
Message-ID: <527A9F67.6000208@sgi.com>
Date: Wed, 06 Nov 2013 13:58:31 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: xfstest failures
References: <20131106105451.GA31283@infradead.org>
	<20131106194417.GF6188@dastard>
In-Reply-To: <20131106194417.GF6188@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On 11/06/13 13:44, Dave Chinner wrote:
> On Wed, Nov 06, 2013 at 02:54:51AM -0800, Christoph Hellwig wrote:
>> Unfortunately it seems our number of test failures is still through the
>> roof, mostly due to the lack of updates in xfstests for other changes.
>>
>> To start with the quick group in xfs I see:

...

>> xfs/206
>>
>> 	Does not expect the ftype flag.  Didn't we change a generic
>> 	filter to take care of this?
>
> xfs/206 has it's own mkfs filter:
>
> http://oss.sgi.com/archives/xfs/2013-10/msg00777.html
>
> I asked that the generic mkfs filters also be modified to support
> ftype, and there hasn't been any followup since then.
>

and I said that _filter_mkfs() does not need to be changed for field 
type. The standard output is correct already.

http://oss.sgi.com/archives/xfs/2013-10/msg00781.html

You also said the standard output is correct, and asked that new 
features add environment variables in _filter_mkfs():

http://oss.sgi.com/archives/xfs/2013-10/msg00823.html

Don't see any feature including crcs doing that yet.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
