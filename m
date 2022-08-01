Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3282AC00144
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Aug 2022 20:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbiHAUtM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Aug 2022 16:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233896AbiHAUtI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Aug 2022 16:49:08 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B8D7A2A277;
        Mon,  1 Aug 2022 13:49:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-20-138.pa.nsw.optusnet.com.au [49.195.20.138])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 3268362CD71;
        Tue,  2 Aug 2022 06:49:04 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oIcLW-0081My-9Q; Tue, 02 Aug 2022 06:49:02 +1000
Date:   Tue, 2 Aug 2022 06:49:02 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Sherry Yang <sherry.yang@oracle.com>
Cc:     djwong@kernel.org, dchinner@redhat.com,
        allison.henderson@oracle.com, chandanrlinux@gmail.com,
        bfoster@redhat.com, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] xfs: initialize error in xfs_defer_finish_one
Message-ID: <20220801204902.GA3600936@dread.disaster.area>
References: <20220801190311.65703-1-sherry.yang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801190311.65703-1-sherry.yang@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62e83c41
        a=cxZHBGNDieHvTKNp/pucQQ==:117 a=cxZHBGNDieHvTKNp/pucQQ==:17
        a=kj9zAlcOel0A:10 a=biHskzXt2R4A:10 a=7-415B0cAAAA:8
        a=uhNI-8COEOrwEqbXutoA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 01, 2022 at 12:03:11PM -0700, Sherry Yang wrote:
> Path through non-void function 'xfs_defer_finish_one' may return error
> uninitialized if no iteration of 'list_for_each_safe' occurs. Fix this
> by initializing error.

I didn't think this situation was possible - how do we get deferred
work queued with no work items on it?

If we can return an uninitialised error from xfs_defer_finish_one()
because of an empty queued work, then something else has gone wrong
earlier in the work deferral process. If this can actually happen,
then we need to fix whatever is creating the empty work rather than
paper over it by initialising the error being returned for empty
works...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
