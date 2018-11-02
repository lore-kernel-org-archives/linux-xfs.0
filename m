Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:22956 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725986AbeKBKln (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Nov 2018 06:41:43 -0400
Date: Fri, 2 Nov 2018 12:36:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2] xfsdump whitespace changes
Message-ID: <20181102013618.GD19305@dastard>
References: <20181101110130.19489-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181101110130.19489-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Nov 01, 2018 at 12:01:28PM +0100, Jan Tulak wrote:
> (I'm splitting the previous set into smaller ones, so changes doesn't
>  have to wait.)
> 
> This set is dealing with whitespaces only, no functional change, code
> shuffling, etc. should be present. The first patch clears out trailing
> whitespaces, the second one sorts out the crazy mishmash of tabs and
> spaces.

patch 2 Didn't come through - it'll be too large for the list.

However, it's is the same change as what you originally posted to a
git tree, then it needs revision. basically, most of the change was
converting vertically aligned function call parameters to use tabs,
and that broke the vertical alignment.

I'd suggest that this is the least of the whitespace sins of
xfsdump. yes, it's easy to script, but I don't think it's the right
thing to do. The biggest problems I think we need to start with are:

- reformat all the function definitions according to common XFS style
- get rid of all the "( foo )" style white space aroudn parenthesis
- convert all the code with 4 space indents to tabs, leaving
  vertically aligned function call parameters alone.

This will be a much smaller set of cleanups than a blanket
space-to-tab script does...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
