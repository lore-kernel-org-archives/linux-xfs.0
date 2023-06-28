Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88D0EEB64DA
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jun 2023 09:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbjF1J23 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jun 2023 05:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbjF1H4M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Jun 2023 03:56:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38A430F1
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 00:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ez/Z2zHWUBd1mh8aHsFgJlAr7+zbfSoMLzqwmgQ88JE=; b=YIBw1Ig1zbkSY8+mAUUC7KJQ5O
        rohB7QgwYN4aq7VZjcHA9glWCz/c8syWP6qPpyH5R7NvCSd4ajaOZrB4ycNPC4URhScvnD7J5JAvS
        0ISlOGKcHhrI5WE/uhXp9mo2TjfGLmZUXvakK3Hpr2Q+VGX96+tzbkNYa4BJT3FpqkchuRv28aR4d
        g+qnL5FitruxGRMKGSSFwcKV80nd1/Z88f+Zdji4jsfwlqILgNCcEoT5FQ2ZjUYSgIY5qz/0s9FEm
        7Je/K8H4VU2lokIfzM5mtpKKPso8OEx0zcBsSntrfXhWVJNiR0F9wmEsqL0z9fZ2BytS9pTSMul88
        yvRVZb0g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qENEX-00EpbI-0Y;
        Wed, 28 Jun 2023 04:56:49 +0000
Date:   Tue, 27 Jun 2023 21:56:49 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Masahiko Sawada <sawada.mshk@gmail.com>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: Question on slow fallocate
Message-ID: <ZJu9kb14LcXgGmjA@infradead.org>
References: <CAD21AoCWW20ga6GKR+7RwRtvPU0VyFt3_acut_y+Fg7E-4nzWw@mail.gmail.com>
 <ZJTrrwirZqykiVxn@dread.disaster.area>
 <CAD21AoC9=8Q2o3-+ueuP05+8298z--5vgBWtvSxMHHF2jdyr_w@mail.gmail.com>
 <3f604849-877b-f519-8cae-4694c82ac7e4@sandeen.net>
 <CAD21AoBHd35HhFpbh9YBHPsLN+F_TZX5b47iy+-s44jPT+fyZQ@mail.gmail.com>
 <82b74cbc-8a1d-6b6f-fa2f-5f120d958dad@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82b74cbc-8a1d-6b6f-fa2f-5f120d958dad@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 27, 2023 at 11:12:01AM -0500, Eric Sandeen wrote:
> Ok, but what is the reason for zeroing out the blocks prior to them being
> written with real data? I'm wondering what the core requirement here is for
> the zeroing, either via fallocate (which btw posix_fallocate does not
> guarantee) or pwrites of zeros.

Note that even a plain truncate will zero the data visible to the
user.  I could see this tring to reduce fragmentation by making sure
the whole file extension is allocated together insted of split up
as the difference processes write their areas.  But is there data
showing this fragmentation even happens and actually hurts?

