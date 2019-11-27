Return-Path: <SRS0=zxI9=ZT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D568C432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Nov 2019 14:19:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57ABA2068E
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Nov 2019 14:19:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nD9YCaLj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfK0OTe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Nov 2019 09:19:34 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:54882 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfK0OTd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Nov 2019 09:19:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/XgQAWv10BKxoiWal2dYQXudY6OZNCIjuTNUQh2sHBU=; b=nD9YCaLjuyhwPI5ny0CARKILK
        8Pke4hpKt9aXRnvxvPTF73/ZDalXv5eABX6YAWTb5u6JLaRezmdmaPdPOB8Y+FSYs+6SBdWNWiXsQ
        CGdZr5k3fsComAKN/mv4zQ3Nk9pA92D4yRVZK8fQOfCTTYVAqRgSUNKsX16Uy1HBnarCZR+M02yu9
        2RrfPoAO42wBEvYUcUsAkZkzHMDmyEiRBKwq7PyYZy5EYyT3fNFksgvGid0F+OvbpN9qQgPqzY9Hi
        q3caiMU3ft85jqbl3NzAaB2rkm7S6DGqCnmdJoObl9QaymQqw7bEx8KvLoaamsDcAK0t3NYd5+TeH
        wOR2BO8tg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iZyAD-0005hL-Pn; Wed, 27 Nov 2019 14:19:29 +0000
Date:   Wed, 27 Nov 2019 06:19:29 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Alex Lyakas <alex@zadara.com>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC-PATCH] xfs: do not update sunit/swidth in the superblock to
 match those provided during mount
Message-ID: <20191127141929.GA20585@infradead.org>
References: <1574359699-10191-1-git-send-email-alex@zadara.com>
 <20191122154314.GA31076@bfoster>
 <CAOcd+r3_gKYBv4vtM7nfPEPvkVp-FgHKvgQQx-_zMDt+QZ9z+g@mail.gmail.com>
 <20191125130744.GA44777@bfoster>
 <CAOcd+r2wMaX02acHffbNKXX4tZ1fXo-y1-OAW-dVGTq63qJcaw@mail.gmail.com>
 <20191126115415.GA50477@bfoster>
 <CAOcd+r3h=0umb-wdY058rQ=kPHpksMOwSh=Jc-did_tLkaioFw@mail.gmail.com>
 <0a1f2372-5c5b-85c7-07b8-c4a958eaec47@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a1f2372-5c5b-85c7-07b8-c4a958eaec47@sandeen.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Can we all take a little step back and think about the implications
of the original patch from Alex?  Because I think there is very little.
And updated sunit/swidth is just a little performance optimization,
and anyone who really cares about changing that after the fact can
trivially add those to fstab.

So I think something like his original patch plus a message during
mount that the new values are not persisted should be perfectly fine.

We can still make xfs_repair smarter about guessing the root inode
of course.
