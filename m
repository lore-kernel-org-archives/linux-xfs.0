Return-Path: <SRS0=88Vy=XH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB48C49ED6
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Sep 2019 01:08:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B97D720863
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Sep 2019 01:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfILBIn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Sep 2019 21:08:43 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:55440 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727256AbfILBIn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Sep 2019 21:08:43 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8AEDD43D5AA;
        Thu, 12 Sep 2019 11:08:39 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1i8DbC-0007qy-Bx; Thu, 12 Sep 2019 11:08:38 +1000
Date:   Thu, 12 Sep 2019 11:08:38 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, zlang@redhat.com
Subject: Re: [PATCH] [RFC] xfs: fix inode fork extent count overflow
Message-ID: <20190912010838.GO16973@dread.disaster.area>
References: <20190911012107.26553-1-david@fromorbit.com>
 <20190911105550.GA23676@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911105550.GA23676@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=7-415B0cAAAA:8 a=Ao7XzL8_WaSlczhuA6wA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 11, 2019 at 03:55:51AM -0700, Christoph Hellwig wrote:
> ... and there went my hopes to eventually squeeze xfs_ifork into
> a single 64-byte cacheline.  But the analys looks sensible.

Not sure what the issue is here:

struct xfs_ifork {
        int64_t                    if_bytes;             /*     0     8 */
        struct xfs_btree_block *   if_broot;             /*     8     8 */
        unsigned int               if_seq;               /*    16     4 */
        int                        if_height;            /*    20     4 */
        union {
                void *             if_root;              /*    24     8 */
                char *             if_data;              /*    24     8 */
        } if_u1;                                         /*    24     8 */
        short int                  if_broot_bytes;       /*    32     2 */
        unsigned char              if_flags;             /*    34     1 */

        /* size: 40, cachelines: 1, members: 7 */
        /* padding: 5 */
        /* last cacheline: 40 bytes */
};

it's already well inside a 64-byte single cacheline, even with a
64bit if_bytes. Yes, I've just pushed it from 32 to 40 bytes, but
but if that is a problem we could pack some things more tightly...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
