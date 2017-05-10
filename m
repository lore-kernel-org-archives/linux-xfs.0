Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:16518 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752330AbdEJKoy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 May 2017 06:44:54 -0400
Date: Wed, 10 May 2017 20:44:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: make fatal assert failures conditional in debug
 mode
Message-ID: <20170510104450.GJ17542@dastard>
References: <1493991086-18817-1-git-send-email-bfoster@redhat.com>
 <20170505230943.GG17542@dastard>
 <20170508125530.GA29840@bfoster.bfoster>
 <20170508231448.GH17542@dastard>
 <fb356789-56ab-757c-7c5f-b90d9ffbb1ea@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb356789-56ab-757c-7c5f-b90d9ffbb1ea@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Mon, May 08, 2017 at 10:02:16PM -0500, Eric Sandeen wrote:
> On 5/8/17 6:14 PM, Dave Chinner wrote:
> >> So for me, the ability to live switch between BUG() or warn in debug
> >> mode doesn't add value. In fact, it is less ideal than just being able
> >> to (re)compile a kernel module and load it with expected behavior. That
> 
> > Who uses kernel modules for testing?
> 
> I do, all the time.

And I don't - haven't for years - but that misses the point of the
question.  It was a rhetorical question attempting to make people
think about more than just their own workflow-specific details...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
