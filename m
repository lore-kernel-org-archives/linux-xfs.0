Return-Path: <SRS0=WxS8=ZX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04164C432C0
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Dec 2019 23:29:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE8EE215E5
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Dec 2019 23:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbfLAX3I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 Dec 2019 18:29:08 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46275 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727279AbfLAX3I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Dec 2019 18:29:08 -0500
Received: from dread.disaster.area (pa49-179-150-192.pa.nsw.optusnet.com.au [49.179.150.192])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 5E10D7EA3D5;
        Mon,  2 Dec 2019 10:29:05 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ibYeG-0006yc-Cw; Mon, 02 Dec 2019 10:29:04 +1100
Date:   Mon, 2 Dec 2019 10:29:04 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Alex Lyakas <alex@zadara.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [RFC-PATCH] xfs: do not update sunit/swidth in the superblock to
 match those provided during mount
Message-ID: <20191201232904.GC2695@dread.disaster.area>
References: <20191122154314.GA31076@bfoster>
 <CAOcd+r3_gKYBv4vtM7nfPEPvkVp-FgHKvgQQx-_zMDt+QZ9z+g@mail.gmail.com>
 <20191125130744.GA44777@bfoster>
 <CAOcd+r2wMaX02acHffbNKXX4tZ1fXo-y1-OAW-dVGTq63qJcaw@mail.gmail.com>
 <20191126115415.GA50477@bfoster>
 <CAOcd+r3h=0umb-wdY058rQ=kPHpksMOwSh=Jc-did_tLkaioFw@mail.gmail.com>
 <0a1f2372-5c5b-85c7-07b8-c4a958eaec47@sandeen.net>
 <20191127141929.GA20585@infradead.org>
 <20191130202853.GA2695@dread.disaster.area>
 <CAOcd+r21Ur=jxvJgUdXs+dQj37EnC=ZWP8F45sLesQFJ_GCejg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOcd+r21Ur=jxvJgUdXs+dQj37EnC=ZWP8F45sLesQFJ_GCejg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=ZXpxJgW8/q3NVgupyyvOCQ==:117 a=ZXpxJgW8/q3NVgupyyvOCQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=pxVhFHJ0LMsA:10
        a=7-415B0cAAAA:8 a=zv8hiwqb5gS_nyWeXhUA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 01, 2019 at 11:00:32AM +0200, Alex Lyakas wrote:
> We can definitely adhere to the recommended behavior of setting
> sunit/swidth=1 during mkfs, provided the repair still works after
> mounting with different sunit/swidth.

FWIW, sunit/sw=1fsb doesn't work reliably either, if you grow the
sunit by a large enough value that it changes the alignment of the
root inode....

Essentially, there is no magic bullet here. We need to ensure that
the kernel doesn't do something that breaks assumptions about root
inode location, and we need to fix xfs_repair not to trash the root
inode without first checking that the current root inode pointer is
invalid...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
