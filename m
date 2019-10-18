Return-Path: <SRS0=TFM3=YL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A743CA9EB3
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Oct 2019 00:38:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4620B21D80
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Oct 2019 00:38:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="Jig6UPG/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ei6jqlLA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391570AbfJRAix (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Oct 2019 20:38:53 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40707 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726633AbfJRAix (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Oct 2019 20:38:53 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 24E0321BF9;
        Thu, 17 Oct 2019 20:38:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 17 Oct 2019 20:38:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        AoTYpCtVhexiqtPeNw0D02oSJb4IBboHUR2usOR4ZfU=; b=Jig6UPG/uwFs6SJb
        NT7dSvtiMBbu7Cb8o7xcmWFOPXxigIjZ09rHEff0sBJQhuGA/a/PtVi0X4Jyn0U5
        Csy6+RlkKY9Nro68ObT0VE5ZwqaeXfDfs0WsO+HHHVhKqksuuLnCiPATWPI55M14
        qFftX8R2kdL8pcG/vGRkAaZkB0p6gVXRKZJnX5ZGqBJ0DP0dAwcmdEVBIHP7YTVN
        2cdlBuCa2V/xa8Jn/sEuAzEm+0oHAEBXz9gf2BBAcDWE5mUTTBTOSIqr/eThthRL
        63cGibf8sWsy97ae4z+EkIvLRCc9tTCgClNjDTz4t+d7Gwpla7zAA+hHENHoDvjk
        fM7Q+g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=AoTYpCtVhexiqtPeNw0D02oSJb4IBboHUR2usOR4Z
        fU=; b=ei6jqlLA6BuMVq9GPjmo7rGvbZmmvZPiHz3Df8ylxRueoFgqOsV/sXE4k
        LpOkQBMDOFLY75GBBqqxyskgpJwXUBSlbCdogNecekO/OIBCTT5lLj+6+yeWPObS
        +2PIFyKHzDXmsNgviPLZvhP8ffV0ssVTH/euqaYwLpc/8RuV4RrTZoHY1Db7AW3p
        7lWr+/rCC41f6o9aFaTevVjEbbuUiDzOTFdVH/tB6Kd4pOcquFHi4bcQlQaQL+y+
        8TJB+fH7b8FfGJtoPVqAoKL+33/WfDcnruGu2G12aynmRQj6MKrlLlrXDJXHOKu5
        ZTjjyeFfwE3e/dn5jWpSO0IUOmK2Q==
X-ME-Sender: <xms:mgmpXT_K6_FlM1wPSoB7qnACykTLhxSE-Y9FoUTltoqiHAtvQvVieQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjeekgdeffecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecuffhomhgrihhnpehkvghrnh
    gvlhdrohhrghenucfkphepuddukedrvddtledrudekfedrjedunecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehrrghvvghnsehthhgvmhgrfidrnhgvthenucevlhhushhtvghrufhiii
    gvpedt
X-ME-Proxy: <xmx:mgmpXbzJQu_CEERseesiP_Gn8HWzE1oDarMpR4SNJLblClB-NXmbOQ>
    <xmx:mgmpXabTmw-DOmZSeoHQ6ZtvXShTrjTQzd1AmYTlvrYG0yuThdNAgA>
    <xmx:mgmpXXoYIHqtGfcjzgbAXDvYP1K2snEkuC44uV1VSo24rm_j_IiPEQ>
    <xmx:nAmpXUi4YSDF0hxYp22gJUFCsS5-_gAF9hq3v6M54IlIoiO8mXJy8Q>
Received: from mickey.themaw.net (unknown [118.209.183.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 03B7ED6005A;
        Thu, 17 Oct 2019 20:38:46 -0400 (EDT)
Message-ID: <88c7e5fe1ee4e0cc3c3ca3e87588f8ebf9c86b14.camel@themaw.net>
Subject: Re: [PATCH v6 12/12] xfs: switch to use the new mount-api
From:   Ian Kent <raven@themaw.net>
To:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Date:   Fri, 18 Oct 2019 08:38:43 +0800
In-Reply-To: <20191017065147.GB32610@infradead.org>
References: <157118625324.9678.16275725173770634823.stgit@fedora-28>
         <157118650856.9678.4798822571611205029.stgit@fedora-28>
         <20191016181829.GA4870@infradead.org>
         <322766092bbf885ae17eee046c917937f9e76cfc.camel@themaw.net>
         <20191017045330.GI13108@magnolia> <20191017065147.GB32610@infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2019-10-16 at 23:51 -0700, Christoph Hellwig wrote:
> On Wed, Oct 16, 2019 at 09:53:30PM -0700, Darrick J. Wong wrote:
> > > The problem is that this will probably be used in logging later
> > > and
> > > there's a lot of logging that uses the upper case variant.
> > > 
> > > OTOH if all the log messages were changed to use lower case "xfs"
> > > then
> > > one of the problems I see with logging (that name inconsistency)
> > > would
> > > go away.
> > > 
> > > So I'm not sure what I should do here.
> > 
> > I would just leave it 'XFS' for consistency, but I might be in the
> > back
> > pocket of Big Letter. ;)
> 
> I isn't really used for much, and Al already has a patch from Eric in
> on
> of his trees that kills the field in favor of the file_system_type
> name
> field:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git/commit/?h=work.mount-parser-later&id=543fdf1d617edd6d681fcc50e16478e832a7a2ac

Yes, I was thinking about that when I replied.

> 
> So we should not spell them differently if we can.

I don't think it will make much difference in the long run, I'll just
change it to lower case for the time being.

I think the implications of the mount api on logging need to be
discussed further (see my thoughts in the series cover letter), there's
not just a log entry case issue. I plan on making some RFC patches for
this later.

Since I'm doing the mount api change for xfs I'll base my RFC patches
on xfs and they will need to go to a wider audience (fsdevel as well
I expect).

Ian

