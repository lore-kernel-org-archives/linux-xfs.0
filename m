Return-Path: <SRS0=1kUG=AT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A0A0C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jul 2020 01:55:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D064720738
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jul 2020 01:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgGHBzu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jul 2020 21:55:50 -0400
Received: from smtprelay0188.hostedemail.com ([216.40.44.188]:54202 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728191AbgGHBzu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jul 2020 21:55:50 -0400
X-Greylist: delayed 437 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jul 2020 21:55:49 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave04.hostedemail.com (Postfix) with ESMTP id 599AB18010607
        for <linux-xfs@vger.kernel.org>; Wed,  8 Jul 2020 01:48:33 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 2656A837F24C;
        Wed,  8 Jul 2020 01:48:32 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: hand52_200294f26eb9
X-Filterd-Recvd-Size: 1327
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf20.hostedemail.com (Postfix) with ESMTPA;
        Wed,  8 Jul 2020 01:48:31 +0000 (UTC)
Message-ID: <96f58df8a489093fb239cea8d36768b921269056.camel@perches.com>
Subject: Re: [PATCH] xfs: Use fallthrough pseudo-keyword
From:   Joe Perches <joe@perches.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 07 Jul 2020 18:48:29 -0700
In-Reply-To: <20200707205036.GL7606@magnolia>
References: <20200707200504.GA4796@embeddedor>
         <20200707205036.GL7606@magnolia>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2020-07-07 at 13:50 -0700, Darrick J. Wong wrote:
> On Tue, Jul 07, 2020 at 03:05:04PM -0500, Gustavo A. R. Silva wrote:
> > Replace the existing /* fall through */ comments and its variants with
> > the new pseudo-keyword macro fallthrough[1]. Also, remove unnecessary
> > fall-through markings when it is the case.
[]
> I don't get it, what's the point?  Are gcc/clang
> refusing to support -Wimplicit-fallthrough=[1-4] past a certain date?

clang doesn't support comments


