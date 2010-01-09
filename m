Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o09GW6c0173818 for <xfs@oss.sgi.com>; Sat, 9 Jan 2010 10:32:07 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE:  Re: [PATCH v2] xfs: Don't flush stale inodes
Date: Sat, 9 Jan 2010 10:22:14 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A693B@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20100109000927.GE8654@discord.disaster>
From: "Alex Elder" <aelder@sgi.com>
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
Cc: xfs@oss.sgi.com

Dave Chinner wrote:
> On Fri, Jan 08, 2010 at 05:14:25PM -0600, Alex Elder wrote:
>> Dave Chinner wrote:
>>> Because inodes remain in cache much longer than inode buffers do
>>> under memory pressure, we can get the situation where we have stale,
>>> dirty inodes being reclaimed but the backing storage has been freed.
>>> Hence we should never, ever flush XFS_ISTALE inodes to disk as
>>> there is no guarantee that the backing buffer is in cache and
>>> still marked stale when the flush occurs.
>>> 
>>> Signed-off-by: Dave Chinner <david@fromorbit.com>
>> 
>> Dave, I'm putting this patch in before your perag radix tree
>> patch series, so I had to port it.  I am submitting here on
>> your behalf, but would like you to review it if possible.
>> It builds fine, and I've run it through a quick test.
>> I will retain all of your original commentary, etc.  I did
>> *not* implement Christoph's recommendation that you change
>> the "for" loop in xfs_alloc_search_busy() to a more typical form.
>> 
>> For reference, the original patch is here:
>>     http://patchwork.xfs.org/patch/382/
>> 
>> Signed-off-by: Alex Elder <aelder@sgi.com>
> 
> Ah, which patch are you talking about? The title says stale inodes,
> the patch is searching busy extents.

Oops.  I blame my Left-handed mouse clicking skills, which are
improving but are still unreliable.  I'm working mostly without
my Right hand this week because of an injury...

> Assuming you meant the busy extent search fix, you've ported the
> wrong version of the busy extent search fix. I posted an updated
> version after Christoph reviewed that one (in my response to
> Christoph's review).

Yes, I see that now.  I had marked your older one "Reviewed" and
didn't look further.  I will re-do the port and will re-submit.
BTW I also plan to port the perag radix tree patch(es) over this
for you after I get this one published.

> Because it was a new patch, patchwork doesn't add the email to the
> original thread - it starts a new one. It's a real PITA, IMO, but
> that is the way patchwork does stuff. The patch that should be
> checked in is this one:
> 
> http://patchwork.xfs.org/patch/387/

Yes, I agree.  I find it helpful when updates are flagged with
something like "[PATCH v2]" because it somehow catches my eye
better *and* makes it explicit that the message contains a patch
that obsoletes a previous one.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
