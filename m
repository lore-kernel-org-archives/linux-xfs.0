Return-Path: <SRS0=apCn=YD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD6EAC47404
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Oct 2019 01:17:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFA4520B7C
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Oct 2019 01:17:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="asGq9gEQ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="pZ1t96Mn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732034AbfJJBRJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 21:17:09 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:38803 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731553AbfJJBRJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 21:17:09 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id C70E061B;
        Wed,  9 Oct 2019 21:17:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 09 Oct 2019 21:17:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        kN2+21nYjJ1z1HKrw5Af5Xseqisg6KZq+tNI/njAoSM=; b=asGq9gEQ2mC318sH
        moryFOYqgGMFoMWwwy87qlahVqACAXJvGRxEWqvOuqZDC5+GVQrmIpjSyn6iAqgZ
        tOw4sIEXXe0c7PpRgMbVvrMIA7clnZ5ZGyn+7Luqc1YFDthx2ZsDA0+ImivZlSR8
        SLxz8j6hdL5EUjZlL9x71cR5DemphliwC7f0aIA1e7a8+xRn9TjgzrmaNv689WEL
        8dYlyAIEVrmaNFTVBRt7R5f3OvCn9T0myuNd5TnHx+3kkeeWE1d+7/eMDaFXsl2F
        UuiFKnDcKD98GEY+xABZCOcwU7/qlkYSrTuXPBh5YBChs1gXcP+wyjq/ipWWn8eJ
        6pbbMA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=kN2+21nYjJ1z1HKrw5Af5Xseqisg6KZq+tNI/njAo
        SM=; b=pZ1t96Mn+hCZ+OO6QMmHO2XXugLSrTSn57k1Q51oCiFsbM4LjxajUmfjm
        utYFgpXUSnkdb5EJmfKESoqZ3IA3ltGazLYFZHgTlSH/i2raQ188upLKfejW7l/N
        2GAZgRyF7TqqiwC7YwZk95lUjJc7RvrSZR/NwJPADRbwQ9dV3bTaRyPli4fi3Pke
        p2vOzcWEjOom1z3WyWGoQW77hFDzkPclBi9qGeqmSSdKP1ppoptk6f8Kwd6ljx2w
        3GVrya4OxYcwhIg5+iynAjdt5VEL1NpbqSI6gaT9pUxAsAJbZVx5iISLZI7uqUvR
        dxHBGj382D4QdRfRkrpidveRCnarw==
X-ME-Sender: <xms:k4aeXQYX2x40Xe5p4b4ccycMsj-_55eqXBYuWKqgz95j67q-SWN4iQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedriedvgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdelrd
    dukeefrdejudenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgif
    rdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:k4aeXSXsVGl4e47eBcZGiYcHV6Wfs7sdsx2CLAk0DFsuULDFuBbWcQ>
    <xmx:k4aeXT7_4LdLrmHvFsO-7KuQ8NHkc7X-taXMHDmWvoNSKXGbTRVnxA>
    <xmx:k4aeXSdZFN5spSVou7bp3xAp-sUKJMRjMlr5pRuA3BaPkdjFYcZNTQ>
    <xmx:k4aeXUO5sxVC4d5c1vS-dGKbUsq1IGd3_3BIFCBGetXSLAoXV78Qkg>
Received: from mickey.themaw.net (unknown [118.209.183.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4B2BBD6005F;
        Wed,  9 Oct 2019 21:17:03 -0400 (EDT)
Message-ID: <a602f4aa17208e86ac26b98b96ee9ea0fe1306f7.camel@themaw.net>
Subject: Re: [PATCH v5 17/17] xfs: mount-api - remove remaining legacy mount
 code
From:   Ian Kent <raven@themaw.net>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu, 10 Oct 2019 09:17:01 +0800
In-Reply-To: <20191009151031.GK10349@infradead.org>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
         <157062070050.32346.18387589090342427440.stgit@fedora-28>
         <20191009151031.GK10349@infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2019-10-09 at 08:10 -0700, Christoph Hellwig wrote:
> On Wed, Oct 09, 2019 at 07:31:40PM +0800, Ian Kent wrote:
> > Now that the new mount api is being used the remaining old mount
> > code can be removed.
> 
> Needs to be folded into the previous patch instead of leaving dead
> code
> around there.

Right, I was tempted to do that after making some changes that
Brian suggested.

I'll do that too.

Ian

