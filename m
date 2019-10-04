Return-Path: <SRS0=FqvN=X5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED898C4360C
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 06:57:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDA4820862
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 06:57:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="e/9OFLf9";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Zn0AXKVe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728935AbfJDG5a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Oct 2019 02:57:30 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54583 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728264AbfJDG5a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Oct 2019 02:57:30 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id BDBC1217FC;
        Fri,  4 Oct 2019 02:57:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 04 Oct 2019 02:57:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        jDoxZbR4TPsl/fgPV8KQpJS9Bzzciqj0RvL2TASf/U0=; b=e/9OFLf9m3Db3Z8N
        obTHtBCPLRniitkYrR6GJNFUSqUdz3cy4sKFtIrvu+qImdL9zpTMJ/j6bkkLQu0i
        rdxtVMFuCB3Gb628HwMOWytnG3nIEUKfUYDEkG8gpxG5efCWLYRIqO1Su4vTYq7G
        eZAv7G6ckBDx9xiw4v3dvD3wmuwUC/BL/8cTGCkLHGC8KLOEccojXLOXEHn9l1HU
        jgUTZD8cxyWQXqVnV4qEY8om4LZx+eBtJCBa5Czw+NWh6umlyUpNMSQJYj1co+5x
        fmrDu8Bxoy4KeWxM3GjX8DMd/n3uEKgwEeHZCKpkIahonTnBYxGJle9cxDSWEUbM
        dJXqfA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=jDoxZbR4TPsl/fgPV8KQpJS9Bzzciqj0RvL2TASf/
        U0=; b=Zn0AXKVej73MBOVWTI88TZqqmeJe06zUk3JcXp5AjpR+JCRxSLSZ/OjVc
        orWXANw0y1+mFLIaxKVAlWfJYxVbPYsSkq5lb83T3cOgDGMhx3MwNABpKeEEmVe/
        NlyPl7vJroBuVsPqemFA/xbkrA5qHdUajV5HnFnyMjZzcDq2l8RGYLxaZj29vJDg
        9xR/ZUXFKHEq7Hs2bQ2RBXzEkWfmUaRRkWgOo82kn0yQ+7NpInriqUzMXc787P31
        QlAsG5xgvAIlPVkbIynkP0n7BV3+C9iVfhflhk+0NsD8ivlZfIb+73OMp3rz2UTw
        8wiuPxsCLNyWXUYcLb0G39Us7cExA==
X-ME-Sender: <xms:WO2WXYIvgLtWMvd5LAIuHdgJgetcGD5cimqWVhsvE9zi5lShQlYsWA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrhedtgdeglecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecuffhomhgrihhnpehkvghrnh
    gvlhdrohhrghdplhifnhdrnhgvthenucfkphepuddukedrvddtkedrudekjedrudekieen
    ucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgifrdhnvghtnecuve
    hluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:WO2WXaeqFCVUVnDyVcR9PYey0CrlCewlHkTbiJmSMo6pVjInqu2OVQ>
    <xmx:WO2WXXYQ5psQfVS5UsKpWTaYjB58LotqPRKttgKtIyt0q8OSP0kd7g>
    <xmx:WO2WXSUctA16MzeOwYvAFgbwo9wg2CmtGy_cBSwRLMrmV8jktpZi-Q>
    <xmx:WO2WXau-bxcfhhDpLtYeVrUckWsBvIMuTIA_IVD4Z5DbGjIKQmRskg>
Received: from mickey.themaw.net (unknown [118.208.187.186])
        by mail.messagingengine.com (Postfix) with ESMTPA id 92D1380065;
        Fri,  4 Oct 2019 02:57:25 -0400 (EDT)
Message-ID: <dc18b6f374221fbc1fd2168a40854f78aaaaf373.camel@themaw.net>
Subject: Re: [PATCH v4 00/17] xfs: mount API patch series
From:   Ian Kent <raven@themaw.net>
To:     Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Fri, 04 Oct 2019 14:57:21 +0800
In-Reply-To: <37be0aa4-c8b5-4b40-dabd-13961bfb77a7@sandeen.net>
References: <157009817203.13858.7783767645177567968.stgit@fedora-28>
         <37be0aa4-c8b5-4b40-dabd-13961bfb77a7@sandeen.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2019-10-03 at 18:30 -0500, Eric Sandeen wrote:
> On 10/3/19 5:25 AM, Ian Kent wrote:
> > This patch series add support to xfs for the new kernel mount API
> > as described in the LWN article at https://lwn.net/Articles/780267/
> > .
> > 
> > In the article there's a lengthy description of the reasons for
> > adopting the API and problems expected to be resolved by using it.
> > 
> > The series has been applied to the repository located at
> > git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git, and built and
> > some simple tests run on it along with the generic xfstests.
> > 
> > Other things that continue to cause me concern:
> > 
> > - Message logging.
> 
> ...
> 
> Haven't actually reviewed yet, but just playing with it, I noticed an
> oddity;
> 
> # mount -o loop,allocsize=abc fsfile mnt
> 
> fails as expected, but with no dmesg to be found.  Is that a known
> behavior?

That's interesting.

I'll see if I can work out what path that is taking though the
kernel, don't think it's getting to the xfs options handling.

> 
> -Eric

