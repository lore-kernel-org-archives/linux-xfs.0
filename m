Return-Path: <SRS0=apCn=YD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82711ECE58C
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Oct 2019 01:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59E262190F
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Oct 2019 01:10:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="UNcLYuk9";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="dbTpu5dw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732228AbfJJBKv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 21:10:51 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:44789 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731134AbfJJBKv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 21:10:51 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 3697B616;
        Wed,  9 Oct 2019 21:10:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 09 Oct 2019 21:10:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        T2NPSsx6kFIRtbhXwqxOlU3fsUtd1VNYM75g0pWf4g0=; b=UNcLYuk9N/IEL3r9
        CmKppoF3IJr7c649pfLlHKNfg4Qkpt2wrOW4gkcCVxmsOLDy3jZ9dJYQWExAQRPW
        ETeWZE9Uikirt+mPjOojwl2fZRwiPtdT+V0o5MgtjwvHfVeFRcEqdVnpjmH8lfiH
        gbWRy8bsjvGfEBYeaKuXRW6+8xOzZBXJOSTMUaqEbZFmN5IMDW8P9GkKbdXUCb5N
        Oo856gejypFJRxXpxo8nkH72Hhi3lqZrnEcg6MkYkESsLX2SgXItYCDlXnKtExyp
        6lxEqfPF8ZTWjFuW4M7RmINtJsCdIyevlAMpXSKO/hw5nte1vWQvv/VaYkTo4PP8
        Iwc9qw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=T2NPSsx6kFIRtbhXwqxOlU3fsUtd1VNYM75g0pWf4
        g0=; b=dbTpu5dwW3wW2esKTDTZ7EL9gINx9906c30ISd36CNW9GKrablBbubJ5+
        IozxS6GosC/5+5/D4zjHx1bwwf/Ztsuxai73aRQe0+8NWJYw+01LtAxjoKOOCzZN
        9ydryfQD62ZAqlLMw1ULG78eCj7NIMfWn9WF3z2sizVCff/sgJvjM3c0mlP3O9nu
        g4h3AeH+xVPVP3zjXpK6ttnEJxcOL9dSg9RpxeCx8LUPzniWCFOTXcm9Uo/cyTS9
        5dj3owiCWsVk+kl01FApQKnG9nI/vVzfuKiLiL/SfR63ZbYLOEYxFLeTrDK+JydP
        3X2NPO4jn+PsKaTfHFaqjo8tKSnRQ==
X-ME-Sender: <xms:GIWeXac1bJL3luMtgH1fzePSZHhz0MDwLj9vIlc3U9Kckz-JOF2WmA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedriedvgdeggecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdelrd
    dukeefrdejudenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgif
    rdhnvghtnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:GIWeXfUHtz4FBt6zb_sOzKDEa2t-wR5eR91JlAqL9kVGN54denQtAQ>
    <xmx:GIWeXQ6cehvT1jeVw_-Nl4VoQp0Oq3pm0F63wgQQLiL8yobIGIOqDA>
    <xmx:GIWeXXzFltwZt1mSyoys77qbyG5jbW7iclAttok-Z2BP9d0HimA35g>
    <xmx:GYWeXWAh1p3emF3AH2b9cwuq71i_9VXEyRGkP_pjFnVXP7Z2oD_SlA>
Received: from mickey.themaw.net (unknown [118.209.183.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8CF95D60057;
        Wed,  9 Oct 2019 21:10:45 -0400 (EDT)
Message-ID: <05a42ffe7a66e971bdc872f7c9d8e8d8c68d9474.camel@themaw.net>
Subject: Re: [PATCH v5 09/17] xfs: mount-api - refactor xfs_fs_fill_super()
From:   Ian Kent <raven@themaw.net>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu, 10 Oct 2019 09:10:42 +0800
In-Reply-To: <20191009150300.GG10349@infradead.org>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
         <157062065791.32346.8183392339697088078.stgit@fedora-28>
         <20191009150300.GG10349@infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2019-10-09 at 08:03 -0700, Christoph Hellwig wrote:
> On Wed, Oct 09, 2019 at 07:30:58PM +0800, Ian Kent wrote:
> > Much of the code in xfs_fs_fill_super() will be used by the fill
> > super
> > function of the new mount-api.
> > 
> > So refactor the common code into a helper in an attempt to show
> > what's
> > actually changed.
> 
> I hate how this ends up leaving a pointless helper around.  If you
> really absolutely want to add the helper here please also remove it
> again at the end of the series.

I think I do want to retain the helper.
Merging it back in afterwards is fine too, I'll do that.

Ian

