Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E329229E04
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 07:46:41 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B3630304043
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 05:46:41 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id vjXVSPE6FzURB0V1 for <xfs@oss.sgi.com>;
	Thu, 07 Nov 2013 05:46:40 -0800 (PST)
Message-ID: <527B99C3.6090903@sandeen.net>
Date: Thu, 07 Nov 2013 07:46:43 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfstest failures
References: <20131106105451.GA31283@infradead.org>
	<20131106161825.GU1935@sgi.com> <527A887F.2030807@sandeen.net>
	<20131107081710.GC25157@infradead.org>
	<527B948C.9060905@sandeen.net>
	<20131107132739.GA16608@infradead.org>
In-Reply-To: <20131107132739.GA16608@infradead.org>
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
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On 11/7/13, 7:27 AM, Christoph Hellwig wrote:
> On Thu, Nov 07, 2013 at 07:24:28AM -0600, Eric Sandeen wrote:
>> On 11/7/13, 2:17 AM, Christoph Hellwig wrote:
>>> On Wed, Nov 06, 2013 at 12:20:47PM -0600, Eric Sandeen wrote:
>>>> that's right, it's a known bug w/ a testcase but no fix yet.
>>>>
>>>> I looked a bit, but ugh, xfsdump.
>>>
>>> Maybe it's time you come up with an xfail mechanism at least?
>>
>> What's the proposal there, a "fail" group for things known to still
>> fail everywhere?
>>
>> so i.e. ./check -x fail ?  I can easily send a patch for that if
>> that's what folks want.
> 
> A mechnism to annotate a test as xfail, so that check would output them
> at the end ala:
> 
> Expected failures:  common/263
> Unexpected successes: reiser4/001
> 

The thing that's tricky about that is that what's expected depends
so heavily on what kernel is running.

Would an expected failure be only for tests which are known to be
not-fixed anywhere?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
