Return-Path: <SRS0=9/io=XV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B390C432C2
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 07:06:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3108E222C3
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 07:06:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="4raCjDDB";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Hem11uNw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbfIZHGy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 03:06:54 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:32867 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726907AbfIZHGy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Sep 2019 03:06:54 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id A3C87686;
        Thu, 26 Sep 2019 03:06:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 26 Sep 2019 03:06:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        vq0FhgK1G2rjeK1thDBG26nmVD05roalJ9Y0m0xxxPQ=; b=4raCjDDBE1WmBY0t
        eEqLiWjAd8N/HzhZHEW0NRAM5BJU0ZKTu2tX0UTf8qboKGW2VkB1LMbSD8bOjHTe
        wAqN+snusx8Yc60vS4Xf9hP9EjaPKaYeSeEooS064BXtO7gX5imtwTuVDGKyLcMH
        Luyexw4conotaAcrM1QlJUBhLkOY5FKSSMzbjAj1oacdE6k/ssvcgeq7+DgXL1lN
        zYgzgrUq3+JCIhvrmdVO5qxPVjyd9pQ2gpOB4sS4rybM4YkUpuI98SygpGR5UpoC
        jX844zJadbLKyccf96LrkwAUpLVxYtZE7jbHjQunYe2HcorILeN5l8bdqR6BVlkp
        pdo3fQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=vq0FhgK1G2rjeK1thDBG26nmVD05roalJ9Y0m0xxx
        PQ=; b=Hem11uNwsq9Z+jFoYOgy50qpwfWDYhGxZ3/nG2Gyy7bI1yaXCFm3feec2
        KkB7WQcSLA0EMmp0tTuVwPJaMque6KZoMyWkTbbG6Fh5sAzG9oH62Tz+2TzgvDET
        TbQw6apwzQQTuQhgrBToLSth+kTlrTwoXJAL8m7c4VYyfolg73w3dxdL5dtLUpaZ
        CqMSYiVYvXSS+Dk3uG9YoqHW3QTToJCyU8cgZ65eyHvog1+fMueWPMj+9mfKXOiA
        5gIRQCHV7Hq0euk18GImNwCHOneU1x/ar9UTRywTRXZ+O2OVm/QtHhET7KPQnlTH
        vDLusyink2qv0pH0aoueoDQzqB4vA==
X-ME-Sender: <xms:i2OMXbNeW1jrUKj_5KtZhPM6iBF0iT-Pe4MODOEAQIYhTkHuBONu9A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrfeefgdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucfkphepuddukedrvddtle
    drudeikedrvdeinecurfgrrhgrmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgr
    fidrnhgvthenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:i2OMXeflkhqgSuqRjZ7RGJ7f4Kt84vBqigGIX3BvpL1UdzwgEYF1UA>
    <xmx:i2OMXfmJSvdbLt0MHzB876AZFg4E5JVAwRE-GqYP9xfR9ArjVhbTZQ>
    <xmx:i2OMXYdDXa9mTM6uRoD593jm1hwz9DAbLPGpj1n7tMdZ56fx-g5MNQ>
    <xmx:jGOMXXNoIpvVAbeumR2Tu_-KZ27K25ifK3a4P0vKohnvlIQx8pjzUQ>
Received: from mickey.themaw.net (unknown [118.209.168.26])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7158ED60057;
        Thu, 26 Sep 2019 03:06:49 -0400 (EDT)
Message-ID: <e31c4e16d1e056767f8997145df6f4b800398469.camel@themaw.net>
Subject: Re: [REPOST PATCH v3 06/16] xfs: mount-api - make xfs_parse_param()
 take context .parse_param() args
From:   Ian Kent <raven@themaw.net>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Thu, 26 Sep 2019 15:06:44 +0800
In-Reply-To: <20190926041427.GT26530@ZenIV.linux.org.uk>
References: <156933112949.20933.12761540130806431294.stgit@fedora-28>
         <156933135322.20933.2166438700224340142.stgit@fedora-28>
         <20190926041427.GT26530@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2019-09-26 at 05:14 +0100, Al Viro wrote:
> On Tue, Sep 24, 2019 at 09:22:33PM +0800, Ian Kent wrote:
> 
> > +	opt = fs_parse(fc, &xfs_fs_parameters, param, &result);
> > +	if (opt < 0) {
> > +		/*
> > +		 * If fs_parse() returns -ENOPARAM and the parameter
> > +		 * is "source" the VFS needs to handle this option
> > +		 * in order to boot otherwise use the default case
> > +		 * below to handle invalid options.
> > +		 */
> > +		if (opt != -ENOPARAM ||
> > +		    strcmp(param->key, "source") == 0)
> > +			return opt;
> 
> Just return opt; here and be done with that.  The comment is bloody
> misleading - for one thing, "in order to boot" is really "in order to
> mount anything", and the only reason for the kludge is that the
> default for "source" (in vfs_parse_fs_param(), triggered in case
> when -ENOPARAM had been returned by ->parse_param()) won't get
> triggered
> if you insist on reporting _all_ unknown options on your own.
> 
> > +	}
> >  	default:
> > -		xfs_warn(mp, "unknown mount option [%s].", p);
> > +		xfs_warn(mp, "unknown mount option [%s].", param->key);
> >  		return -EINVAL;
> 
> ... here, instead of letting the same vfs_parse_fs_param() handle
> the warning.
> 
> Or you could add Opt_source for handling that, with equivalent of
> that
> fallback (namely,
>                 if (param->type != fs_value_is_string)
>                         return invalf(fc, "VFS: Non-string source");
>                 if (fc->source)
>                         return invalf(fc, "VFS: Multiple sources");
>                 fc->source = param->string;
>                 param->string = NULL;
>                 return 0;
> ) done in your ->parse_param().

Either of those makes sense to me.

The only other thing relevant to either case is messages not going
to the kernel log if fsconfig() is being used which could make problem
resolution more difficult.

Any objection to changing logfc() to always log to the kernel log
and save messages to the context if fc->log is non-null rather than
the either or behaviour we have now?

Ian

