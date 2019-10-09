Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D9CC47404
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 15:29:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C955C20679
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 15:29:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sZAjNa8S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbfJIP3O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 11:29:14 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46290 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729865AbfJIP3O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 11:29:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZlSFLd2BnxtSSbWSG9UHFR5Xczdn1eWJtEVbsjWQ4Gk=; b=sZAjNa8S9ixVrF+H/Sl9KsqGo
        ggu5Oc2JtuBkPHFzCBGV4pBo2AaQ2Qfkz6M+a/M0X29/mgoy8Sox9rmdGHrQdXKnJzQMkfbsQoklm
        Pq/Wd7/0U7xznAhJZYPgwXf+tn6Bj+voZHLQKYrVr6JefydYHmDhbgrDzj87PLKefgZ12VvD1gifZ
        uSForHVGTrXIrZAzdUGCCeJMZB2Oxj1O+0vzVvxa5yhA24pzaLDhn5chCyodzqj9NCbehJJNFxdhK
        M7yWeaOXgS0V6ePTHVoPLQ31CeubOGqlIAlDOqnASxPNmDUXqjVteUwrcmOe89Ej/5DdUMHeRGNYH
        NhLpuY6mw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iIDto-0002wH-06; Wed, 09 Oct 2019 15:29:12 +0000
Date:   Wed, 9 Oct 2019 08:29:11 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christoph Hellwig <hch@infradead.org>, Ian Kent <raven@themaw.net>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v5 05/17] xfs: mount-api - refactor suffix_kstrtoint()
Message-ID: <20191009152911.GA30439@infradead.org>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
 <157062063684.32346.12253005903079702405.stgit@fedora-28>
 <20191009144859.GB10349@infradead.org>
 <20191009152127.GZ26530@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009152127.GZ26530@ZenIV.linux.org.uk>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 04:21:27PM +0100, Al Viro wrote:
> What we need to do is to turn fs_parameter_type into a pointer
> to function.  With fs_param_is_bool et.al. becoming instances
> of such, and fs_parse() switch from hell turning into
> 	err = p->type(p, param, result);
> 
> That won't affect the existing macros or any filesystem code.
> If some filesystem wants to have helpers of its own - more
> power to it, just use __fsparam(my_bloody_helper, "foo", Opt_foo, 0)
> and be done with that.

Actually, while we could keep the old macros around at least
temporarily for existing users I think killing them actually would
improve the file systems as well.

This:

static const struct fs_parameter_spec afs_param_specs[] = {
	{ "autocell",	Opt_autocell,	fs_parse_flag },
	{ "dyn",	Opt_dyn,	fs_parse_flag },
	{ "flock",	Opt_flock,	fs_parse_enum },
	{ "source",	Opt_source,	fs_parse_string },
        {}
};


is a lot more obvious than:

static const struct fs_parameter_spec afs_param_specs[] = {
        fsparam_flag  ("autocell",      Opt_autocell),
        fsparam_flag  ("dyn",           Opt_dyn),
        fsparam_enum  ("flock",         Opt_flock),
        fsparam_string("source",        Opt_source),
        {}
};
