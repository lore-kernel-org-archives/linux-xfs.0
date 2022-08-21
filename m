Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D0C2C00140
	for <linux-xfs@archiver.kernel.org>; Sun, 21 Aug 2022 06:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiHUG3Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 21 Aug 2022 02:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiHUG3P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 Aug 2022 02:29:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CBA26132;
        Sat, 20 Aug 2022 23:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3ERvMu4POZUsMD6yq39TfKZ1EskT5FRYgihPSMVzLrE=; b=sRfYAE8N3StEyCR2m/Z/a1OEMB
        2JBYBMUt6t2Ug76nY/K2hvyqHwgyWsw5Ms5DzFFXqsNhmC1ZAOKAOJEEvgnXScGH+OFrtTJQ0W12T
        pQ6rmYvwk/qHJxalUZDm1DkzvmkLMYAPikRXindZlJVlHSGniH9t53J44pXX3rXE29FC5XNOhl3gD
        nV8vH1Q5muzYhD5iCVgVkZZ8gMWV8bWnAfbqt58a3ByNUuMX6+7jOjtCx6C7qM72qU11IgjbHf097
        5r2LGGcQ2Hf43JQ0BO0jlzAl/EuGt10sDyrXvTat1yQRiLymXrc2zzaHA2KRBV8C0knkZCul+ZrMh
        VMzCTG7Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oPeSH-006lfG-GK; Sun, 21 Aug 2022 06:29:05 +0000
Date:   Sat, 20 Aug 2022 23:29:05 -0700
From:   hch <hch@infradead.org>
To:     Siddh Raman Pant <code@siddh.me>
Cc:     Matthew Wilcox <willy@infradead.org>, david <david@fromorbit.com>,
        djwong <djwong@kernel.org>, fgheet255t <fgheet255t@gmail.com>,
        hch <hch@infradead.org>, linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        riteshh <riteshh@linux.ibm.com>,
        syzbot+a8e049cd3abd342936b6 
        <syzbot+a8e049cd3abd342936b6@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: [syzbot] WARNING in iomap_iter
Message-ID: <YwHQsbH/aYtH5pVs@infradead.org>
References: <20220818110031.89467-1-code@siddh.me>
 <20220818111117.102681-1-code@siddh.me>
 <Yv5RmsUvRh+RKpXH@casper.infradead.org>
 <182b18b5d92.7a2e2b1623166.1514589417142553905@siddh.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <182b18b5d92.7a2e2b1623166.1514589417142553905@siddh.me>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 18, 2022 at 08:51:16PM +0530, Siddh Raman Pant wrote:
> On Thu, 18 Aug 2022 20:20:02 +0530  Matthew Wilcox  wrote:
> > I don't think changing these from u64 to s64 is the right way to go.
> 
> Why do you think so? Is there somnething I overlooked?
> 
> I think it won't intorduce regression, since if something is working,
> it will continue to work. If something does break, then they were
> relying on overflows, which is anyways an incorrect way to go about.

Well, for example userspace code expecting unsignedness of these
types could break.  So if we really think changing the types is so
much preferred we'd need to audit common userspace first.  Because
of that I think the version proposed by willy is generally preferred.

> Also, it seems even the 32-bit compatibility structure uses signed
> types.

We should probably fix that as well.
