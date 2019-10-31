Return-Path: <SRS0=K+Ru=YY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4949CA9EC7
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Oct 2019 00:06:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9326F20656
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Oct 2019 00:06:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="I7rJ27fI";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="LqybDlr1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbfJaAG4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Oct 2019 20:06:56 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:40895 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727617AbfJaAGz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 20:06:55 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 493FA52D;
        Wed, 30 Oct 2019 20:06:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 30 Oct 2019 20:06:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        v9XEk8uMvpCUndHRUtMMY5MfSVPQrGQEonOht4k9uBw=; b=I7rJ27fIF9NpdstB
        5HCzA86hxqNbd5tLL3GJf/dD5naX9pAdSm98UTldCP185BXrDa8hgBjmJKqa4lkT
        7uIr7+889uZrf+qwpChbCebfHU2rwKxKHc+o90dfMtt3a/drtok2beA8dxyYnRvm
        iXNne/ytThZeOUo6oApsrt9ZiJsipqkrLWbA3QjFXG4xBDAFQPNTTkQO7SjCVLES
        r3ng3+3s1zx0NvBNSszEQVE16ClHHzLazyQZveEEVIKHrFIZTEIlwaB0hcnt3HjE
        4dL3OvOchr3SZTC2JKQydlunB1VUdF74+jPH+sjSTGt+gEkDFY4fNwBrtPrqqlCG
        LFYsbQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=v9XEk8uMvpCUndHRUtMMY5MfSVPQrGQEonOht4k9u
        Bw=; b=LqybDlr1F/hfdHJ8Ux02vY26Oji63RH8iOfTg7AwnsuZp/NfeCHTTKX36
        lTLuLuzkHajJ+WMejnyjm/bKiiNNkLAeJilt6HK0+3OuQJYMIvuNn8R01mNpMwjz
        UBg4/z5MIHRFwsh0t+IM1o2Gc/33CbZ0Gc0T76dH5IQTqnXGFn4T5Z1MdLlh2xV3
        YNiP+bu97lzMMywB4R++UG289TpAqiMC69xBR1T5RVg40cQjm56ZrQ+aKX+DYZNZ
        BRsE80eQqpaFcVXWmeHc730Ti2XKpTc+t/6XYHsZdM8oa85A+3OsfeagpoAO22bb
        WxIR3z64mV/i87GRQml7ae27sn3eg==
X-ME-Sender: <xms:nSW6XZBiOb4FkfDmc1XtRm1b286YwiFsI1lMd3mX5XgRh3ZHAjHl0A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddtgedgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkffuhffvffgjfhgtfggggfesthejredttderjeenucfhrhhomhepkfgrnhcu
    mfgvnhhtuceorhgrvhgvnhesthhhvghmrgifrdhnvghtqeenucffohhmrghinhepkhgvrh
    hnvghlrdhorhhgpddtuddrohhrghenucfkphepuddukedrvddtkedrudekjedrfedvnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgrfidrnhgvthenucevlh
    hushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:nSW6XU4v2qVeqjp6alTwu84qxItcm636QUDf42g3wgk1ySrEaWDsww>
    <xmx:nSW6Xb6vUL1goX_vBPY4WHPgl2FSrNjmfQdnYu57J2wAIUYuP7x9Cg>
    <xmx:nSW6XeTwJ3R_SMb05I5-mchhVqjUwd1s-rEvAuBVJ2Q0HclfUofZlA>
    <xmx:nSW6XcWF1ITqPFWwm_pliXtZvwE6P86h9l3Vw7rV6nFTrW0RxX9zYw>
Received: from mickey.themaw.net (unknown [118.208.187.32])
        by mail.messagingengine.com (Postfix) with ESMTPA id 87B6B3060065;
        Wed, 30 Oct 2019 20:06:50 -0400 (EDT)
Message-ID: <64f818691c707dfaecff334aafaabd74b14948c7.camel@themaw.net>
Subject: Re: [djwong-xfs:mount-api-crash 91/104] fs/xfs/xfs_message.c:23:40:
 warning: address of array 'mp->m_super->s_id' will always evaluate to 'true'
From:   Ian Kent <raven@themaw.net>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Cc:     kbuild@lists.01.org, Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com,
        kbuild test robot <lkp@intel.com>,
        xfs <linux-xfs@vger.kernel.org>
Date:   Thu, 31 Oct 2019 08:06:46 +0800
In-Reply-To: <20191030154543.GF15221@magnolia>
References: <201910291437.fsxNAnIM%lkp@intel.com>
         <20191030033925.GA14630@ubuntu-m2-xlarge-x86>
         <20191030154543.GF15221@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2019-10-30 at 08:45 -0700, Darrick J. Wong wrote:
> On Tue, Oct 29, 2019 at 08:39:25PM -0700, Nathan Chancellor wrote:
> > On Tue, Oct 29, 2019 at 02:45:40PM +0800, kbuild test robot wrote:
> > > CC: kbuild-all@lists.01.org
> > > CC: "Darrick J. Wong" <darrick.wong@oracle.com>
> > > TO: Ian Kent <raven@themaw.net>
> > > CC: "Darrick J. Wong" <darrick.wong@oracle.com>
> > > CC: Christoph Hellwig <hch@lst.de>
> 
> FYI, It's customary to cc the patch author [and the xfs list]...
> 
> > > tree:   
> > > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git
> > > mount-api-crash
> > > head:   e35c37b1b9987c8d87d91dbeca6c24aade2a3390
> > > commit: a5a36409da3a608c815b38b0ff2eb5bcfc1adec6 [91/104] xfs:
> > > use super s_id instead of struct xfs_mount
> > > config: x86_64-rhel-7.6 (attached as .config)
> > > compiler: clang version 10.0.0 (git://gitmirror/llvm_project
> > > 7cd595df96d5929488063d8ff5cc3b5d800386da)
> > > reproduce:
> > >         git checkout a5a36409da3a608c815b38b0ff2eb5bcfc1adec6
> > >         # save the attached .config to linux build tree
> > >         make ARCH=x86_64 
> > > 
> > > If you fix the issue, kindly add following tag
> > > Reported-by: kbuild test robot <lkp@intel.com>
> > > 
> > > All warnings (new ones prefixed by >>):
> > > 
> > > > > fs/xfs/xfs_message.c:23:40: warning: address of array 'mp-
> > > > > >m_super->s_id' will always evaluate to 'true' [-Wpointer-
> > > > > bool-conversion]
> > >            if (mp && mp->m_super && mp->m_super->s_id) {
> > >                                  ~~ ~~~~~~~~~~~~~^~~~
> 
> ...so, Ian, I guess this isn't necessary ^^^^^^^^^^^^^^^^
> because it's a char array, not a pointer. :)
> 
> Good catch!

Indeed, better now than later, ;)

> 
> --D
> 
> > >    1 warning generated.
> > > 
> > > vim +23 fs/xfs/xfs_message.c
> > > 
> > >     13	
> > >     14	/*
> > >     15	 * XFS logging functions
> > >     16	 */
> > >     17	static void
> > >     18	__xfs_printk(
> > >     19		const char		*level,
> > >     20		const struct xfs_mount	*mp,
> > >     21		struct va_format	*vaf)
> > >     22	{
> > >   > 23		if (mp && mp->m_super && mp->m_super->s_id) {
> > >     24			printk("%sXFS (%s): %pV\n", level, mp-
> > > >m_super->s_id, vaf);
> > >     25			return;
> > >     26		}
> > >     27		printk("%sXFS: %pV\n", level, vaf);
> > >     28	}
> > >     29	
> > > 
> > > ---
> > > 0-DAY kernel test infrastructure                Open Source
> > > Technology Center
> > > https://lists.01.org/pipermail/kbuild-all                   Intel
> > > Corporation
> > > 
> > 
> > Hi Darrick,
> > 
> > The 0day team has been doing clang builds for us and we've been
> > forwarding the valid warnings along to developers. This appeared
> > after
> > the commit listed above. That check should be unnecessary, perhaps
> > you
> > meant to check for something else? Thanks for looking into this.
> > 
> > Cheers,
> > Nathan

