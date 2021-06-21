Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02F27C49361
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 05:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCD8B61183
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 05:20:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhFUFXM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Jun 2021 01:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbhFUFXM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Jun 2021 01:23:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83671C061574;
        Sun, 20 Jun 2021 22:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RmnGNYxD0DXeHEZ0u+JkPf/yQlVZ0wR0OQWyNvlyvT0=; b=ra0YgzVxF/qjRM0r7jv9fdpTnJ
        QFSsbQwOEJPp6ih/EpqW4dvMtzd+ijGq8+hsU3RDNIMH3UXzQ6bWwL/ED0mFWsIVmu0DyO3Cwvrbs
        FIPCBLvC5ERy8FTUHdsSkUtCFp4WPXSEXZrQP6Mp3LavfCOBuwpA3uWb30kSsaOOg6SuT3Ze6LiAq
        JxbHE+y7NOj2amFGO1LhZSZYdm10vdlE29HO2N1CqdeqtjicSn9lJ04bJiTvkBaeG9excuJHmTITx
        qFu3l5RCytbcb+SBpyYoeYzcV1A3u4C7Q0zl0Mne1rSNz/nLnK/dKpGjHE1BDaJOlu963vOX4Wa2B
        yz7AZhSA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lvCLy-00CkLs-26; Mon, 21 Jun 2021 05:20:18 +0000
Date:   Mon, 21 Jun 2021 06:20:10 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Eryu Guan <guaneryu@gmail.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>,
        ebiggers@kernel.org
Subject: Re: [PATCH 07/13] fstests: automatically generate group files
Message-ID: <YNAhip+sLWk7B4ZV@infradead.org>
References: <162370433910.3800603.9623820748404628250.stgit@locust>
 <162370437774.3800603.15907676407985880109.stgit@locust>
 <YMmpDGT9b4dBdSh2@infradead.org>
 <20210617001320.GK158209@locust>
 <YMsAEQsNhI1Y5JR8@infradead.org>
 <20210617171500.GC158186@locust>
 <YMyjgGEuLLcid9i+@infradead.org>
 <CAOQ4uxjvkJh2XcfDgj7g+JUkFXEc36_6YOKQHJ=pX2hpGfUDhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjvkJh2XcfDgj7g+JUkFXEc36_6YOKQHJ=pX2hpGfUDhQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 18, 2021 at 06:32:18PM +0300, Amir Goldstein wrote:
> > Just stick to the original version and see if anyone screams loud
> 
> What is the original version?

The patch that Darrick posted, which requires make to be run to
generatethe group files.
