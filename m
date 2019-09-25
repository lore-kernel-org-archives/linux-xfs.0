Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 470AAC432C1
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 05:15:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 118A420665
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 05:15:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="Vdutqsxo";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ZYclLjGF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406354AbfIYFPv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 01:15:51 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:47429 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392973AbfIYFPv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 01:15:51 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 1298D482;
        Wed, 25 Sep 2019 01:15:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 25 Sep 2019 01:15:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        XOlhzptW2QSByt06265+FB67J+6Xq/7S6wQKe0TFrB4=; b=VdutqsxoJskCkT/V
        V0mnzPH5Kyi9/mwYi09qKZDPZ0WI1jWs2sRbG755bbGYFtVlCzNmaoqe0Vu3gQ1e
        Rwpt0Uvz54Yyrk2/PJKMQM9U2QN4StcGuNSZNuwTkDGu/w8XvNStDiUqVdWUCJrh
        CsB4qedYe1/jOXmL1sJwmc8DiPO1NI+dfqDkxi8nzUSZ3zNQD3Rg9kHCzDxzBZmf
        8+ifvaeSi7hXwxGVCOOvnVKtvFe+cPRdCz/dgoaA3M4ka2fjjDUgQH82tcEX4Wdi
        IiqymyWzCCJczZ3EgPGoJ0YboQ+6kBAUdyAkUr8KOr23aTCfUEPEttIqpvHPwaxW
        YuLOdw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=XOlhzptW2QSByt06265+FB67J+6Xq/7S6wQKe0TFr
        B4=; b=ZYclLjGFVlytnvoPbrcOZ9ZUPMoITKLYM7EGrqw5xJAax/T2X2COcofHN
        rZjWW49A55PxROUYocFxrQemeHgMqEFJYOamz9tL0XlXc3gbOcGlkORqDL5/YAI0
        UwSs/6zMdliXM1+K5ktu8s8AHOa49fve6K9GYgxhMDpq/Px1fguvNjTkSTVprgtX
        Ad5se6HFfZJx1MZsQ3oBi3UfqI5nRhpcrWvDdVMnnPnByBBQLG0nyAK03xSUvpkU
        8Nypq/b1/BhghSWWlkx0hkapFA/k/OuAdQp43PPbG9Byg15j++gfUdYaIg4Tyh7r
        9s6HPAUJDq02Kqt/XxAg6Q41z3miA==
X-ME-Sender: <xms:BPiKXe6wS4msS9cdfp8fhL-7vfK3x8-CcNvlpEl2NYIR28P1pMnKiQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrfedugdelgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdekrd
    duieefrddvvdefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgr
    fidrnhgvthenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:BPiKXbGGaxKuykzW7dl6pvYK4VWoLKazbycQrBs0Z_WEbVzQK7cylQ>
    <xmx:BPiKXUR1JJVWr3VJH30o617-_u1uiUcEySWDiazpdBAzdnzDw8FhXw>
    <xmx:BPiKXQMjIvJ33LvG-a3yzXVOG16v51TWBadRA77xQ2vY83fBxQxuiw>
    <xmx:BPiKXap8wHYCbSh_8P6E2aq1u2EMov_R_LDjSA-OEGM9lQ6B2mD5cg>
Received: from mickey.themaw.net (unknown [118.208.163.223])
        by mail.messagingengine.com (Postfix) with ESMTPA id C2D9F8005C;
        Wed, 25 Sep 2019 01:15:45 -0400 (EDT)
Message-ID: <a6d3bef179f3434dc785626a9ac4fad6805bd231.camel@themaw.net>
Subject: Re: [REPOST PATCH v3 01/16] vfs: Create fs_context-aware
 mount_bdev() replacement
From:   Ian Kent <raven@themaw.net>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Wed, 25 Sep 2019 13:15:42 +0800
In-Reply-To: <20190924213313.GH26530@ZenIV.linux.org.uk>
References: <156933112949.20933.12761540130806431294.stgit@fedora-28>
         <156933132524.20933.7026640044241445520.stgit@fedora-28>
         <20190924213313.GH26530@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2019-09-24 at 22:33 +0100, Al Viro wrote:
> On Tue, Sep 24, 2019 at 09:22:05PM +0800, Ian Kent wrote:
> > From: David Howells <dhowells@redhat.com>
> > 
> > Create a function, vfs_get_block_super(), that is fs_context-aware
> > and a
> > replacement for mount_bdev().  It caches the block device pointer
> > and file
> > open mode in the fs_context struct so that this information can be
> > passed
> > into sget_fc()'s test and set functions.
> 
> NAK.  Use get_tree_bdev() instead.

Thanks Al, will do.

Ian

