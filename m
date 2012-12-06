Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB6HP0FT139118 for <xfs@oss.sgi.com>; Thu, 6 Dec 2012 11:25:00 -0600
Message-ID: <50C0D57A.9000704@sgi.com>
Date: Thu, 06 Dec 2012 11:27:22 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [3.0-stable PATCH 00/36] Proposed 3.0-stable bug patches
References: <20121203144208.143464631@sgi.com> <20121205214505.GG29399@dastard>
In-Reply-To: <20121205214505.GG29399@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: stable@vger.kernel.org, xfs@oss.sgi.com

On 12/05/12 15:45, Dave Chinner wrote:
> On Mon, Dec 03, 2012 at 05:42:08PM -0600, Mark Tinguely wrote:
>> Here a collection of bug fixes for 3.0-stable. Many of these patches
>> were also selected by Dave Chinner as possible 3.0-stable patches:
>> 	http://oss.sgi.com/archives/xfs/2012-08/msg00255.html
>>
>> I chose only bug fixes and kept the changes to a minimum.
>>
>> Patch 21/22 are required for the bug fix in patch 23 but they are
>> important changes in their own right.
>
> So I'll ask the same question that Christoph asked me: If nobody is
> reporting problems on 3.0.x, why do this and risk regression and
> fallout that requires fixing?
>
> FWIW, what testing have you done?
>
> Cheers,
>
> Dave.


Do you mean?

	http://oss.sgi.com/archives/xfs/2012-09/msg00002.html

I read that message as a concern that your original Linux 3.0-stable
patch series contained some items that did not meet the -stable
criteria.

As for adding patches to 3.0-stable. I believed then and now that
proactively suggesting bug fixes into 3.0-stable is a good thing
because it is the long term stable branch.

A few days after Christoph's email, I put my "Reviewed-by:" on your
series.

	http://oss.sgi.com/archives/xfs/2012-09/msg00167.html

As for testing, the whole series is spun on xfstests loops for days on
x86_32 and x86_64 boxes, just like we test a top of tree patch series.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
