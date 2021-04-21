Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C1A1C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 03:21:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 037B161413
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 03:21:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbhDUDVf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 23:21:35 -0400
Received: from smtprelay0200.hostedemail.com ([216.40.44.200]:41538 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233874AbhDUDVe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Apr 2021 23:21:34 -0400
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Apr 2021 23:21:34 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave02.hostedemail.com (Postfix) with ESMTP id 2D77D1814CBEB
        for <linux-xfs@vger.kernel.org>; Wed, 21 Apr 2021 03:11:06 +0000 (UTC)
Received: from omf01.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id E606A180A4C06;
        Wed, 21 Apr 2021 03:11:04 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf01.hostedemail.com (Postfix) with ESMTPA id E390A1727B;
        Wed, 21 Apr 2021 03:11:03 +0000 (UTC)
Message-ID: <0d799df884ec9088501d6699c6ed97728eebad53.camel@perches.com>
Subject: Re: [PATCH][next] xfs: Fix fall-through warnings for Clang
From:   Joe Perches <joe@perches.com>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Date:   Tue, 20 Apr 2021 20:11:02 -0700
In-Reply-To: <20210420233850.GQ3122264@magnolia>
References: <20210420230652.GA70650@embeddedor>
         <20210420233850.GQ3122264@magnolia>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Stat-Signature: n8q5t1jinm7iudrkas9iyu5kh5yn19cp
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: E390A1727B
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18TDD6CZMrsoSDQXol/66jarNtjAfzvFAs=
X-HE-Tag: 1618974663-505523
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2021-04-20 at 16:38 -0700, Darrick J. Wong wrote:
> On Tue, Apr 20, 2021 at 06:06:52PM -0500, Gustavo A. R. Silva wrote:
> > In preparation to enable -Wimplicit-fallthrough for Clang, fix
> > the following warnings by replacing /* fall through */ comments,
> > and its variants, with the new pseudo-keyword macro fallthrough:
[]
> > Notice that Clang doesn't recognize /* fall through */ comments as
> > implicit fall-through markings, so in order to globally enable
> > -Wimplicit-fallthrough for Clang, these comments need to be
> > replaced with fallthrough; in the whole codebase.
> > 
> > Link: https://github.com/KSPP/linux/issues/115
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> I've already NAKd this twice, so I guess I'll NAK it a third time.

Sorry, I've must have missed it before.  Why did you NAK this?

