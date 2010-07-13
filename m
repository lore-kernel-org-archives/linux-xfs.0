Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6DGbakL098381 for <xfs@oss.sgi.com>; Tue, 13 Jul 2010 11:37:36 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 817B91E2802B
	for <xfs@oss.sgi.com>; Tue, 13 Jul 2010 09:40:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EMzdHc3Y8UF7WHWC for
	<xfs@oss.sgi.com>; Tue, 13 Jul 2010 09:40:31 -0700 (PDT)
Message-ID: <4C3C96EF.3050103@redhat.com>
Date: Tue, 13 Jul 2010 11:40:15 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH xfstests] _qmount: mount w/o selinux xattrs
References: <4C2CF34F.7070008@redhat.com>
	<20100702071006.GB30776@infradead.org>
	<4C2E2687.3080700@redhat.com>
	<20100709161232.GA26302@infradead.org>
	<4C3B6D0A.2010708@redhat.com> <20100712221346.GI25335@dastard>
In-Reply-To: <20100712221346.GI25335@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs mailing list <xfs@oss.sgi.com>

On 07/12/2010 05:13 PM, Dave Chinner wrote:
> On Mon, Jul 12, 2010 at 02:29:14PM -0500, Eric Sandeen wrote:
>> On 07/09/2010 11:12 AM, Christoph Hellwig wrote
>>> On Fri, Jul 02, 2010 at 12:48:55PM -0500, Eric Sandeen wrote:
>>>>> What about just disabling selinux for all filesystems instead of just
>>>>> XFS for the general case.
>>>>
>>>> Well it seems like if we -can- test with it on, that's good.
>>>> Certain distros ship with it on by default, so exercising lots
>>>> of scenarios with it on seems beneficial...
>>>
>>> It seems, but I'd rather do it consistently for all filesystems.
>>>
>>
>> except we can't, because xfs actually has such low-level format checking
>> that selinux -will- break it badly.
>>
>> I guess we could flag which tests can't run w/ extra xattrs,
>> and only mount w/ the context for those?
> 
> Maybe use a group to define all the tests that can't run with
> selinux enabled and check it before running each test? i.e. use
> notrun to prevent such tests from running. The attr group isprobably
> a good start for the tests that will break w/ selinux enabled....

Something like that ... but there are more tests than just the attr
group, I'm afraid.

I'd have to re-run to see which break, guess I'll put that on the list.

-Eric

> Cheers.
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
