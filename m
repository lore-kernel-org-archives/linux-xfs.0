Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B78C4C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 04:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbiD0Edz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Apr 2022 00:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357716AbiD0Edx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Apr 2022 00:33:53 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 635E11AF0D
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 21:30:42 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-62-197.pa.nsw.optusnet.com.au [49.195.62.197])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9CABD5362F6;
        Wed, 27 Apr 2022 14:30:41 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njZK4-0051KQ-Gp; Wed, 27 Apr 2022 14:30:40 +1000
Date:   Wed, 27 Apr 2022 14:30:40 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: reduce transaction reservations with reflink
Message-ID: <20220427043040.GJ1098723@dread.disaster.area>
References: <165102071223.3922658.5241787533081256670.stgit@magnolia>
 <165102075178.3922658.11792444708694506676.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165102075178.3922658.11792444708694506676.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6268c6f1
        a=KhGSFSjofVlN3/cgq4AT7A==:117 a=KhGSFSjofVlN3/cgq4AT7A==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=W-YlsfQvEv7QFxXbQ0MA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 26, 2022 at 05:52:31PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Before to the introduction of deferred refcount operations, reflink
> would try to cram refcount btree updates into the same transaction as an
> allocation or a free event.  Mainline XFS has never actually done that,
> but we never refactored the transaction reservations to reflect that we
> now do all refcount updates in separate transactions.  Fix this to
> reduce the transaction reservation size even farther, so that between
> this patch and the previous one, we reduce the tr_write and tr_itruncate
> sizes by 66%.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Much easier to understand than the previous version! Thanks for
reworking this :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
