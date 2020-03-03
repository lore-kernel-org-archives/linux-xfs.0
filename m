Return-Path: <SRS0=TABv=4U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26E35C3F2C6
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 23:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F382C20828
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 23:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbgCCXph (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 18:45:37 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:53937 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727604AbgCCXph (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 18:45:37 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 354ED3A26F8;
        Wed,  4 Mar 2020 10:45:34 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9HED-0004rN-Bn; Wed, 04 Mar 2020 10:45:33 +1100
Date:   Wed, 4 Mar 2020 10:45:33 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: fix buffer state when we reject a corrupt dir
 free block
Message-ID: <20200303234533.GY10776@dread.disaster.area>
References: <158294091582.1729975.287494493433729349.stgit@magnolia>
 <158294092192.1729975.12710230360219661807.stgit@magnolia>
 <e38b8334-6b64-71ed-62d6-527f0fe57f09@sandeen.net>
 <20200303163853.GA8045@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303163853.GA8045@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=4pnkVB2WtlmvbiU2uoAA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 03, 2020 at 08:38:53AM -0800, Darrick J. Wong wrote:
> On Mon, Mar 02, 2020 at 05:54:07PM -0600, Eric Sandeen wrote:
> > On 2/28/20 5:48 PM, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Fix two problems in the dir3 free block read routine when we want to
> > > reject a corrupt free block.  First, buffers should never have DONE set
> > > at the same time that b_error is EFSCORRUPTED.  Second, don't leak a
> > > pointer back to the caller.
> > 
> > For both of these things I'm left wondering; why does this particular
> > location need to have XBF_DONE cleared after the verifier error?  Most
> > other locations that mark errors don't do this.
> 
> Read verifier functions don't need to clear XBF_DONE because
> xfs_buf_reverify will notice b_error being set, and clear XBF_DONE for
> us.
> 
> __xfs_dir3_free_read calls _read_buf.  If the buffer read succeeds,
> _free_read then has xfs_dir3_free_header_check do some more checking on
> the buffer that we can't do in read verifiers.  This is *outside* the
> regular read verifier (because we can't pass the owner into _read_buf)
> so if we're going to use xfs_verifier_error() to set b_error then we
> also have to clear XBF_DONE so that when we release the buffer a few
> lines later the buffer will be in a state that the buffer code expects.

Actually, if the data in the buffer is bad after it has been
successfully read and we want to make sure it never gets used, the
buffer should be marked stale.

That will prevent the buffer from being placed on the LRU when it is
released, and if a lookup finds it in cache it will clear /all/ the
flags on it

xfs_da_read_buf() has read the buffer successfully, and set up it's
state so that it is cached via insertion into the LRU on release. We
want to make sure that nothing uses this buffer again without a
complete re-initialisation, and that's effectively what
xfs_buf_stale() does.

> This isn't theoretical, if the _header_check fails then we start
> tripping the b_error assert the next time someone calls
> xfs_buf_reverify.

We shouldn't be trying to re-use a corrupt buffer - it should cycle
out of memory immediately. Clearing the XBF_DONE flag doesn't
accomplish that; it works for buffer read verifier failures because
that results in the buffer being released before they are configured
to be cached on the LRU by the caller...

Indeed, xfs_buf_read_map() already stales the buffer on read and
reverify failure....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
