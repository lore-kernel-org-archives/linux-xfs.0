Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 144927F98
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 10:42:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 973C5AC001
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 08:42:46 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id B3nEulSAVOQo2XXm for <xfs@oss.sgi.com>;
	Mon, 09 Feb 2015 08:42:44 -0800 (PST)
Message-ID: <54D8E383.4020906@sandeen.net>
Date: Mon, 09 Feb 2015 10:42:43 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] xfs: pass mp to XFS_WANT_CORRUPTED_*
References: <54D53E8C.8070207@redhat.com> <20150208213502.GA4251@dastard>
	<20150209130926.GA18336@laptop.bfoster>
In-Reply-To: <20150209130926.GA18336@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 2/9/15 7:09 AM, Brian Foster wrote:
> On Mon, Feb 09, 2015 at 08:35:02AM +1100, Dave Chinner wrote:
>> On Fri, Feb 06, 2015 at 04:22:04PM -0600, Eric Sandeen wrote:
>>> These 2 patches provide information about which filesystem
>>> hit the error...
>>
>> If we are going to touch every one of these macros, then can we
>> rename them to something a little shorter like XFS_CORRUPT_GOTO()
>> and XFS_CORRUPT_RETURN() at the same time? That will make the code a
>> little less eye-bleedy where there are lots of these statements,
>> and make formatting of complex checks a bit easier, too...
>>
> 
> XFS_CORRUPT_DOSOMETHING() jumps out to me as indicate corruption if the
> logic statement evaluates as true rather than false. The latter (e.g.,
> assert-like logic) is how they work today, so that could be a bit
> confusing to somebody who isn't already familiar with how these macros
> work.
> 
> Unfortunately, nothing shorter than the current naming immediately comes
> to mind... :/ We could kill the XFS_ prefix I suppose or even invert the
> logic of the calls, but that's certainly a more significant change.
> Thoughts?

Right, so today it's XFS_WANT_CORRUPTED_RETURN(thing_that_should_be_true)
and I agree, that's always felt a bit odd.

Dave suggests XFS_CORRUPT_RETURN(thing_that_should_be_true)

I guess the "WANT" was supposed to imply that the argument is the
test that we "want" to be true? :)

I'm not super excited about inverting every test, but we could ...

XFS_CORRUPT_RETURN_IF_NOT(test) would be explicit, at least.
Or XFS_CORRUPT_RETURN_UNLESS(test).

I can't think of a nice short name that conveys more meaning, either,
but I'm not really sure that it's critical to change it at this point.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
