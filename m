Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AC61C47404
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 18:01:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AF0621848
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 18:01:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QP5Pv7nL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730955AbfJISBG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 14:01:06 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54440 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730546AbfJISBG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 14:01:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6ZhP/rcUrii8bESruUVlQpzTgpRl/gqphA+BDKAOllc=; b=QP5Pv7nL+Yr/3J5hrydGZvQSY
        RbjRR3LZZhQo1VSUd56Hf1wI/Y//j1Mh22tBE5OuxHFT8AO9rYbsWl6MuZK6zSv+AlWrEasNIyxsH
        b8d0NV43oUuti8IUmFBn4bNftU5zkKs2FzVJtrEmAwZdiIKB1wYEUR+M/wawLaQssTrth6pLjGmwH
        cUhMTi0+nd7fG0/tD6db0AOWyV5GhWLiqLkN1EP2uxLEufir3OQLqptHqQwpr445dRy8DlgmvoGww
        bkaZPFPnW4aR9JE510BLZiPno3qwSs3lVcvXc02FpcpLbz47lbuaZ4Yf7jvJgTjDMBfG6SEZTOGXw
        nWOIAR2sA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iIGGk-0003lg-CL; Wed, 09 Oct 2019 18:01:02 +0000
Date:   Wed, 9 Oct 2019 11:01:02 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christoph Hellwig <hch@infradead.org>, Ian Kent <raven@themaw.net>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v5 05/17] xfs: mount-api - refactor suffix_kstrtoint()
Message-ID: <20191009180102.GA9056@infradead.org>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
 <157062063684.32346.12253005903079702405.stgit@fedora-28>
 <20191009144859.GB10349@infradead.org>
 <20191009152127.GZ26530@ZenIV.linux.org.uk>
 <20191009152911.GA30439@infradead.org>
 <20191009160310.GA26530@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009160310.GA26530@ZenIV.linux.org.uk>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 05:03:10PM +0100, Al Viro wrote:
> Except that I want to be able to have something like
> -       fsparam_enum   ("errors",             Opt_errors),
> +       fsparam_enum   ("errors",             Opt_errors, gfs2_param_errors),
> with
> +static const struct fs_parameter_enum gfs2_param_errors[] = {
> +       {"withdraw",   Opt_errors_withdraw },
> +       {"panic",      Opt_errors_panic },
> +       {}
> +};
> instead of having them all squashed into one array, as in

Makes total sense and still fits the above scheme.

> IOW, I want to kill ->enums thing.  And ->name is also trivial
> to kill, at which point we are left with just what used to be
> ->specs.

Agreed.

> I have some experiments in that direction (very incomplete right
> now) in #work.mount-parser-later; next cycle fodder, I'm afraid.

I like that a lot, and feel like we really shouldn't do more
conversions until that ground work has been done
