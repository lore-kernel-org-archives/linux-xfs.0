Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 594F17F4E
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 11:05:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DAFF0AC002
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 09:05:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id pZCHyQJlpj1sakTV for <xfs@oss.sgi.com>;
	Tue, 25 Mar 2014 09:05:06 -0700 (PDT)
Message-ID: <5331A930.9030402@sandeen.net>
Date: Tue, 25 Mar 2014 09:05:04 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix buffer use after free on IO error
References: <532CFA12.4040104@redhat.com>	<20140325125754.GA18691@bfoster.bfoster>
	<20140325131705.GB25392@infradead.org>
In-Reply-To: <20140325131705.GB25392@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 3/25/14, 6:17 AM, Christoph Hellwig wrote:
>> On Fri, Mar 21, 2014 at 09:48:50PM -0500, Eric Sandeen wrote:
>>> +	/*
>>> +	 * If _xfs_buf_ioapply failed, we'll get back here with
>>> +	 * only the reference we took above.  _xfs_buf_ioend will
>>> +	 * drop it to zero, so we'd better not queue it for later,
>>> +	 * or we'll free it before it's done.
>>> +	 */
>>> +	_xfs_buf_ioend(bp, bp->b_error ? 0 : 1);
>>>  
>>
>> Out of curiosity, is there any major reason we don't use 0 here
>> unconditionally? Are we worried about I/O completing before we have a
>> chance to decrement the reference?
> 
> I think this should unconditionally avoid the schedule, and while we're
> at it we should kill _xfs_buf_ioend and opencode it here and at the
> other callsite.

And then remove the flag from xfs_buf_ioend which is always 0 at that
point ...

> Also atomic_dec_and_test really just returns true/false - there should
> ne no need for the explicit == 1 in the conditional.

Yeah I have a patch to do that as well; I wanted to separate the
bugfix from the more invasive cleanup, though - and I wanted to
get the fix out for review sooner.

But yeah, I was unsure about whether or not to schedule at all here.
We come here from a lot of callsites and I'm honestly not sure what
the implications are yet.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
