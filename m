Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCBF5C47083
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 00:57:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB525613E6
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 00:57:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhFCA7C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 20:59:02 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43177 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229541AbhFCA7C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Jun 2021 20:59:02 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 848A786182C;
        Thu,  3 Jun 2021 10:57:01 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lobfQ-008IZB-HZ; Thu, 03 Jun 2021 10:57:00 +1000
Date:   Thu, 3 Jun 2021 10:57:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 39/39] xfs: expanding delayed logging design with
 background material
Message-ID: <20210603005700.GC664593@dread.disaster.area>
References: <20210519121317.585244-1-david@fromorbit.com>
 <20210519121317.585244-40-david@fromorbit.com>
 <20210527203844.GP2402049@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527203844.GP2402049@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=dR5lHU3L-_iKhazkLugA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 27, 2021 at 01:38:44PM -0700, Darrick J. Wong wrote:
> On Wed, May 19, 2021 at 10:13:17PM +1000, Dave Chinner wrote:
> > +As a result, permanent transactions only "regrant" reservation space during
> > +xfs_trans_commit() calls, while the physical log space reservation - tracked by
> > +the write head - is then reserved separately by a call to xfs_log_reserve()
> > +after the commit completes. Once the commit completes, we can sleep waiting for
> > +physical log space to be reserved from the write grant head, but only if one
> > +critical rule has been observed::
> > +
> > +	Code using permanent reservations must always log the items they hold
> > +	locked across each transaction they roll in the chain.
> > +
> > +"Re-logging" the locked items on every transaction roll ensures that the items
> > +the transaction chain is rolling are always relocated to the physical head of
> 
> This reads (to me) a little awkwardly.  One could ask if the transaction
> chain itself is rolling the items?  Which is not really what's
> happening.  How about:
> 
> "...ensures that the items attached to the transaction chain being
> rolled are always relocated..."

Fixed.

> > -This relogging is also used to implement long-running, multiple-commit
> > -transactions.  These transaction are known as rolling transactions, and require
> > -a special log reservation known as a permanent transaction reservation. A
> > -typical example of a rolling transaction is the removal of extents from an
> > +A typical example of a rolling transaction is the removal of extents from an
> >  inode which can only be done at a rate of two extents per transaction because
> 
> Ignoring rt files, do we even have /that/ limit anymore?  Especially
> considering the other patchset you just sent... :)

Well.... Remind me to make this update in that patch set if I
forget to do it. :P

> With that one odd sentence up there reworked,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thx!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
