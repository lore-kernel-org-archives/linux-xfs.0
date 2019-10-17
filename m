Return-Path: <SRS0=4OPL=YK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFE0CECE599
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 00:58:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FB26218DE
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 00:58:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="d9dANSdG";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="tEM4ARh5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395273AbfJQA6f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Oct 2019 20:58:35 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60793 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726521AbfJQA6e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Oct 2019 20:58:34 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 3DCDE2206E;
        Wed, 16 Oct 2019 20:58:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 16 Oct 2019 20:58:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        2+vX7Wxv7+TvM4KCxk41RWLKPQUfzGpk7CbfFzafLXg=; b=d9dANSdGqxhYtutO
        CxtLzMFdwVjkRhFkCc474jvXrIei5aoP1ZX55GYE9AnWO7g4viESMbEyIMId0Ejy
        NHzYY1iU/Y/PBsCZx3ZvX+2crk/UlfgIXwGSvvjiA2itbHyvsFf2l9yZ4PXfQsnB
        2ysJTw/az00noHs2/a0UEHANSfvoANRY0ENcz/1M84GvxthYcOMCK8QnynXlKaAq
        EfYQz9yYDq8+T+BKQAhdncxxFVEAIfNgKuc/9HqgOqQYnIB4xZwcD4bVhJnVXgcW
        SYkuWPB4L8+gefIo5aaYZTcVJlgXKrqgpOt84yfHnLeHjR34DG8tQiuU7wEJehiv
        uzjJFg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=2+vX7Wxv7+TvM4KCxk41RWLKPQUfzGpk7CbfFzafL
        Xg=; b=tEM4ARh5jr6BxlAvIj4mGYBb2WwpqFc8YC1Ffn72fsMmjfyYd2oZM8CGm
        UKYdwwpe5Bz8CqTITrmg6Fi+oCENOEp9ck0Vde5Pv8xPVGgtgpCTqTEZJiSBEvaq
        L+jVUJSwADZ7fg2k3MGL6xxjD/7lxn/SbJ1O+fSoY0MBbly+l7lxwYkIJPws9l9E
        nfim8QZbFcAPOYMYaPBQWXy2CyJCgkCdCZ6joeMHcLaj1ekt6E56HgTgK4lXVGNy
        mStVRELI5MXrUXFOiAk31hgkVY5vkEprBY3db14io5VzhZl69hRsSxVohZO/bICy
        05Jti8CXpZWhwtJq7fUQEfsGVkIHg==
X-ME-Sender: <xms:uLynXRG6BPhxPk94c3S9aV_GQh_ZdYVotRW2bhrO3IcT_kNIQKeGeA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjeeigdefkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdelrd
    dukeefrdejudenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgif
    rdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:uLynXfZ0SXj5BitcOGYXISFk1JkwhEHRECgnqq6Jl-7tv9cyZk8xwA>
    <xmx:uLynXcMtkGGIS96E0rRoc4t8YEkFpUzJeTeZs3B3z3VkuP9M3N0-qw>
    <xmx:uLynXS0tJ36R-M0c08LaTf3lSpW74lhU1HshDWGSBJh8Z26Luz9eGw>
    <xmx:ubynXX5jq3O70Kn9cPhc9p51s77xyKfQW2lWbsyOpjtgM6cvVdm3YQ>
Received: from mickey.themaw.net (unknown [118.209.183.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9E62280059;
        Wed, 16 Oct 2019 20:58:29 -0400 (EDT)
Message-ID: <53f92136d385e9764976e6b9aa393dda2d55683e.camel@themaw.net>
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
Date:   Thu, 17 Oct 2019 08:58:26 +0800
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
> 
> > +	if (nooptions)
> > +		goto noopts;
> 
> This option is always false in this patch.  I'd suggest you only add
> it once we actually add a user.

Thanks for looking at the series and for the comments.
I'll get on with the recommended changes and post an update.

Ian

