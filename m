Return-Path: <SRS0=9/io=XV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EBC9C432C2
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 07:34:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4D342146E
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 07:34:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="LYc4j16U";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="yhNDnnuX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729859AbfIZHef (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 03:34:35 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:49147 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729404AbfIZHef (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Sep 2019 03:34:35 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 0559142C;
        Thu, 26 Sep 2019 03:34:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 26 Sep 2019 03:34:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        vvEtVuEqTzqJgB/2W8jOAX+4FvnXPmOrAZd2/n4cHDY=; b=LYc4j16UE8GyDfVT
        d/rCJkOr4LX4PZwdpaRwmVifjR6Ei4b/z3K6kZ6klFMQo2WgIBcJWSOSs2xdr+Rt
        buY0T0MYN5xWwGxrZqr0nzqc6X9j0yd9Qb70hqqSW+7CKap4IlmuCaUeK1UdwL7P
        1wQrmvSasRJUe/Px8mw8cno09OXNL9cUfRlSQvGLyqrvukhogbM+AqvDW8I4RIR7
        kYmevgUHRoZE/KaLcAgbgZ4AhG+wHtYdJI4YGSo55i0T6WJ/h6L+7yK9d8R9150V
        inFBF2bKJMZR4/Fqk0F6uE5i4iYNy5uLgEhgGRIs0Eei+FVF8sMiya2CR6CTiPQu
        Tq3Xgg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=vvEtVuEqTzqJgB/2W8jOAX+4FvnXPmOrAZd2/n4cH
        DY=; b=yhNDnnuXxo6novUzJh1cnu2vILZaa01PttYVIBKn0dptoJuft3f7nNoIg
        0nNDc/2QfALJtHdO9g00nzXjbNGee6VAtXfjTkugZG6lc02y+BhN1Ng6U8xDkUhy
        wo1qnlk8aP+FwSvU/Dnp322mcTeo1K58MGV+Bn1HiaOvdCs3Krivs/cysarbb5CG
        4DLm8xjSachgRKXB7WvaV8BkdmirAWIP9+YCkyH+f/HkgRFpX8+4+BjzaT9LtGx+
        6sMo7sqUJHYvpQK/AIolg+TsNflwTOPNdjgfPKC0cQHeoJ9P9YdTBJ+o33/8QAFv
        4iX7CdDu192MAuhWlg9zrLu78WQQQ==
X-ME-Sender: <xms:CWqMXSXWD1J4ogkRdAWL3lszjWwe5dV71YnIeATHBPijGVW5hlqEEA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrfeefgdduvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucfkphepuddukedrvddtle
    drudeikedrvdeinecurfgrrhgrmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgr
    fidrnhgvthenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:CWqMXeaId0-40Iz7VtkIrdUZTVUbBDKkxIH1UlrYQIaJgR1UeADmdw>
    <xmx:CWqMXY91HnCB-uF5WgYthuW2o-Rh9U1c4-UgOESe4g0K3cyAGzyXGA>
    <xmx:CWqMXV7gcuOKZ33K_S1zln0-qY_PS6utiI7bhewVzDKClgYjQCwVXA>
    <xmx:CWqMXd3HaSLUpKBnmMqV47TYlLv-gFf_wTGUeNtCf47ovhQFzS5MSQ>
Received: from mickey.themaw.net (unknown [118.209.168.26])
        by mail.messagingengine.com (Postfix) with ESMTPA id C49CB8005A;
        Thu, 26 Sep 2019 03:34:30 -0400 (EDT)
Message-ID: <29dfc21d55af91c82cdc34cb61187389739da372.camel@themaw.net>
Subject: Re: [REPOST PATCH v3 06/16] xfs: mount-api - make xfs_parse_param()
 take context .parse_param() args
From:   Ian Kent <raven@themaw.net>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Thu, 26 Sep 2019 15:34:25 +0800
In-Reply-To: <e31c4e16d1e056767f8997145df6f4b800398469.camel@themaw.net>
References: <156933112949.20933.12761540130806431294.stgit@fedora-28>
         <156933135322.20933.2166438700224340142.stgit@fedora-28>
         <20190926041427.GT26530@ZenIV.linux.org.uk>
         <e31c4e16d1e056767f8997145df6f4b800398469.camel@themaw.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2019-09-26 at 15:06 +0800, Ian Kent wrote:
> On Thu, 2019-09-26 at 05:14 +0100, Al Viro wrote:
> > On Tue, Sep 24, 2019 at 09:22:33PM +0800, Ian Kent wrote:
> > 
> > > +	opt = fs_parse(fc, &xfs_fs_parameters, param, &result);
> > > +	if (opt < 0) {
> > > +		/*
> > > +		 * If fs_parse() returns -ENOPARAM and the parameter
> > > +		 * is "source" the VFS needs to handle this option
> > > +		 * in order to boot otherwise use the default case
> > > +		 * below to handle invalid options.
> > > +		 */
> > > +		if (opt != -ENOPARAM ||
> > > +		    strcmp(param->key, "source") == 0)
> > > +			return opt;
> > 
> > Just return opt; here and be done with that.  The comment is bloody
> > misleading - for one thing, "in order to boot" is really "in order
> > to
> > mount anything", and the only reason for the kludge is that the
> > default for "source" (in vfs_parse_fs_param(), triggered in case
> > when -ENOPARAM had been returned by ->parse_param()) won't get
> > triggered
> > if you insist on reporting _all_ unknown options on your own.
> > 
> > > +	}
> > >  	default:
> > > -		xfs_warn(mp, "unknown mount option [%s].", p);
> > > +		xfs_warn(mp, "unknown mount option [%s].", param->key);
> > >  		return -EINVAL;
> > 
> > ... here, instead of letting the same vfs_parse_fs_param() handle
> > the warning.
> > 
> > Or you could add Opt_source for handling that, with equivalent of
> > that
> > fallback (namely,
> >                 if (param->type != fs_value_is_string)
> >                         return invalf(fc, "VFS: Non-string
> > source");
> >                 if (fc->source)
> >                         return invalf(fc, "VFS: Multiple sources");
> >                 fc->source = param->string;
> >                 param->string = NULL;
> >                 return 0;
> > ) done in your ->parse_param().
> 
> Either of those makes sense to me.
> 
> The only other thing relevant to either case is messages not going
> to the kernel log if fsconfig() is being used which could make
> problem
> resolution more difficult.
> 
> Any objection to changing logfc() to always log to the kernel log
> and save messages to the context if fc->log is non-null rather than
> the either or behaviour we have now?

Actually, forget about this.

That "e", "w" and "i" will attract inconsistent log formatting
comments.

Probably simplest to just add an xfs log macro to log to the
kernel log and also use the mount-api log macro if context ->log
is non-null.

> 
> Ian
> 

