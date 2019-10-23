Return-Path: <SRS0=UAxe=YQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D72ECA9EA0
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Oct 2019 02:59:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D41D6214B2
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Oct 2019 02:59:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="U+ZOkJrd";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="lG3+6q4l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732748AbfJWC7X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Oct 2019 22:59:23 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:45693 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731979AbfJWC7X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 22:59:23 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 7D27121E97;
        Tue, 22 Oct 2019 22:59:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 22 Oct 2019 22:59:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        50GUW7dCJXU0QxnNJgfP80iIB1MgW3hWF2kLamGo33g=; b=U+ZOkJrdSThVo9Gj
        XOYDaSi2Sizyy5mo6ttsGbKbeCLYNK+H19ABYnIGhDdJoEhiGKT1OARPJGqWsYLI
        BoxpYyMKqcobSyMs+Tad3eWfV0lCbrkE2IBQONjhrD4+WHI75vZgRQtNf077KxCH
        O4y/G/v3azhhxi05LKhhElrrXnToUZoQZr7YkJGUn/Ua10KbXVcmvbiAdwafZFYy
        0OfrrqOABE9kpH9nZeG6iVsMhps2O9LsyCan9gN+rDkIbZX1F4bEXi2ORjfwrlz4
        utRIpABQuYrUtaaUTM/v9BJwnaiOiFrEahQ9SPE3rnLsdKchbZ075cRKIjSoW1si
        A4l7Ng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=50GUW7dCJXU0QxnNJgfP80iIB1MgW3hWF2kLamGo3
        3g=; b=lG3+6q4lADYKGNY5DkCNG7VDT2GSeVo449ISN2FIXYZH1KbyN/5mWVhbY
        rtJ4jBcAKeFt1hBKp2nsM031ETJ/ALvHl8lhCOAmC92qEOq6oDr8kHc/m9dk4Kxk
        xalAx+NN/lOMUqAGrAyuhLk99x2eP4w8MqYyA4C4hiulphg1Xmfdxs2/aplsTYb6
        ulZ8BZ4huASMuhoy1rqst4WpzO2CobCvOwNibuoK4UkYcqwFbci1mjJl5lx8QId/
        gpg6VarXB783D6WUPNGX5Pf0HinfPuCUYtzKa12ZeLX2oXgOcgCshwFUYudyYGF+
        NqOTIFoUiwUOxircHSJupj92WMbjg==
X-ME-Sender: <xms:CcKvXdqZcQBbZRR7cGlsZ6l9Tk5yYk_mRFjqljke17PQK0Xhx0yfIg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrkeekgdeifecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdelrd
    dukeefrdejudenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgif
    rdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:CcKvXYdrSqCeivFnuVVIR964hcuh8xQEcc9vUg5TRfwUf0BrP73KWA>
    <xmx:CcKvXbjDkOxgtPEsWFw4lvIWc8veIiTM6VdPtSX5AX3hGHp5EOt5kw>
    <xmx:CcKvXeKpSWJa68toR4PYNUOby3jeJoPazgneODbh9LnhiaTzJbNjiQ>
    <xmx:CsKvXfq2ZGG3kpnVOHihFPoaBq8ASedqJP8wn9yznCa5wY6XdtLzbg>
Received: from donald.themaw.net (unknown [118.209.183.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0FDA58005B;
        Tue, 22 Oct 2019 22:59:18 -0400 (EDT)
Message-ID: <d0750a6ebebc549adf1986f36fffe81f23e21552.camel@themaw.net>
Subject: Re: [PATCH v6 10/12] xfs: move xfs_parseargs() validation to a
 helper
From:   Ian Kent <raven@themaw.net>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Date:   Wed, 23 Oct 2019 10:59:15 +0800
In-Reply-To: <20191016084009.GA21814@infradead.org>
References: <157118625324.9678.16275725173770634823.stgit@fedora-28>
         <157118649791.9678.5158511909924114010.stgit@fedora-28>
         <20191016084009.GA21814@infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2019-10-16 at 01:40 -0700, Christoph Hellwig wrote:
> On Wed, Oct 16, 2019 at 08:41:38AM +0800, Ian Kent wrote:
> > +static int
> > +xfs_validate_params(
> > +	struct xfs_mount        *mp,
> > +	int			dsunit,
> > +	int			dswidth,
> > +	uint8_t			iosizelog,
> > +	bool			nooptions)
> 
> Please add a refactor patch before this one to always set the stripe
> unit / width / log I/O size values in the mount structure at parsing
> time as suggested before.  The will also remove the need for the
> xfs_fs_context structure in the last patch.

With the mount api it looks like this means adding the validation
checks to xfs_parse_param().

That could be done for iosizelog without problem other than the check
being redone for each instance of the "allocsize" option which is
probably ok.

But the dsunit and dswidth checks depend on one another so that check
needs to be done after all the options have been handled.

After the change to use the mount api the options string separation
is done in the VFS and xfs_parse_param() called separately for each
option.

This is done so that the new system call fsconfig() can be implemented
which will call the .parse_param() method separately for each option
too.

So it isn't known if both "sunit" and "swidth" have been given until
aft
er all the options have been looked at.

Ian

