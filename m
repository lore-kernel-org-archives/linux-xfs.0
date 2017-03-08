Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:35590 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753717AbdCHXDa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2017 18:03:30 -0500
Received: by mail-qk0-f175.google.com with SMTP id v125so91595300qkh.2
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2017 15:03:30 -0800 (PST)
Date: Wed, 8 Mar 2017 18:03:27 -0500
From: Tejun Heo <tj@kernel.org>
Subject: Re: How to favor memory allocations for WQ_MEM_RECLAIM threads?
Message-ID: <20170308230327.GE21117@htj.duckdns.org>
References: <201703031948.CHJ81278.VOHSFFFOOLJQMt@I-love.SAKURA.ne.jp>
 <20170303133950.GD31582@dhcp22.suse.cz>
 <20170303232512.GI17542@dastard>
 <20170307121503.GJ28642@dhcp22.suse.cz>
 <20170307193659.GD31179@htj.duckdns.org>
 <20170307212132.GQ17542@dastard>
 <20170307214842.GA7500@htj.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170307214842.GA7500@htj.duckdns.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Michal Hocko <mhocko@kernel.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, linux-xfs@vger.kernel.org, linux-mm@kvack.org

Hello,

On Tue, Mar 07, 2017 at 04:48:42PM -0500, Tejun Heo wrote:
> > > It's implementable for sure.  I'm just not sure how it'd help
> > > anything.  It's not a relevant information on anything.
> > 
> > Except to enable us to get closer to the "rescuer must make forwards
> > progress" guarantee. In this context, the rescuer is the only
> > context we should allow to dip into memory reserves. I'm happy if we
> > have to explicitly check for that and set PF_MEMALLOC ourselves 
> > (we do that for XFS kernel threads involved in memory reclaim),
> > but it's not something we should set automatically on every
> > IO completion work item we run....
> 
> Ah, okay, that does make sense to me.  Yeah, providing that test
> shouldn't be difficult at all.  Lemme cook up a patch.

Turns out we already have this.  Writeback path already has a special
case handling for the rescuer.  You can just use
current_is_workqueue_rescuer().  The function can be called safely
from any task context.

Thanks.

-- 
tejun
