Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E28FDC433ED
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 00:30:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B07C561396
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 00:30:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240216AbhEMAbt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 20:31:49 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:48092 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240538AbhEMAbB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 May 2021 20:31:01 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id F3465104415E;
        Thu, 13 May 2021 10:29:39 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lgzEN-000Jot-8U; Thu, 13 May 2021 10:29:35 +1000
Date:   Thu, 13 May 2021 10:29:35 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/22] xfs: push perags through the ag reservation
 callouts
Message-ID: <20210513002935.GB2893@dread.disaster.area>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-10-david@fromorbit.com>
 <YJp4wmJaA1GeEbW0@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJp4wmJaA1GeEbW0@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=hmHCrhEuNgNoaa-vS7sA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 11, 2021 at 08:29:54AM -0400, Brian Foster wrote:
> On Thu, May 06, 2021 at 05:20:41PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We currently pass an agno from the AG reservation functions to the
> > individual feature accounting functions, which then may have to do
> > perag lookups to access per-AG state. Plumb the perag through from
> > the highest AG reservation layer to the feature callouts so they
> > don't have to look it up again.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> The changes look fine, but the commit log implies we're relieving some
> lower level functions of the need to re-look up perag structs. I don't
> see one perag get/put cycle being removed here, so I suppose either that
> comes later or the commit log is a bit misleading..? Either way, with a
> minor reword of the commit log to clarify that, this otherwise looks
> fine to me.

Future patches use the the perag that is passed down through these
functions. e.g. the next series of patches that pass a perag to the
btree cursor init functions rather than the plain AG. Passing the
pag down the stack ehre means that the lower layers modified in this
patch don't need to look up the perag again.

i.e. read this "don't have to add lookups in future", not as "will
remove existing lookups right now".

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
