Return-Path: <SRS0=apCn=YD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C8EEC47404
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Oct 2019 01:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 504CF2086D
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Oct 2019 01:12:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="ihpyzZWS";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="kV4I7tZj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731166AbfJJBME (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 21:12:04 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:47825 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731155AbfJJBMD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 21:12:03 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 6EC013E7;
        Wed,  9 Oct 2019 21:12:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 09 Oct 2019 21:12:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        5KXRQeKMFufUcr1m0UrW4J17LGf6DU0m935PBvTmD1E=; b=ihpyzZWSuqIKT/uI
        TiNf+rxpkYXAt3KKNfzK0OXiaU7Sadh6DWisYsXnJweAC6Cten52+CTZWppqjp/Z
        02cPM4xmGy5WOEpWgvsSz9xUV2xltNf2tn6sNb0YL0mf3oxuWuQrDk9y+F/aaa/A
        DKdPXIDKia8vkG/ypEyThJMl3DyaS78Rke6wjwTGBvDr6pr3b0Epdpud1go1IGbs
        q4f2o/tFciCc8MJnzbz49jvNkNZeQDwZvK2A9IjXdZ0CWI9LNH0g4LyjkU7+be89
        GJuys3XLqn4Ldiu+Irrqd06GC4bLJqUsJNZtcMHeTKQ7j6hy38n/J2UHDnhRpwvS
        8BfvBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=5KXRQeKMFufUcr1m0UrW4J17LGf6DU0m935PBvTmD
        1E=; b=kV4I7tZj8mgwS9kV9nuXyHSLfH4APguTAnqMZD9Od9HLnTiU26/ozf1UD
        l7E2Pe6531cfyuwXJfD9D1OfQ3MdrDlqaTTB2AZYL0Z4LE14o6QJ+m52AfVShvs8
        IYhFuBiNZcjsMLKzOsUzKavEe1H9hJs4CDkZSw/HJh3gBUw7oJEoVfOVHmiymixO
        Gw3j9NMT/95SiMRUY0iNm/0Jt52qqeCO1BHLdxck0uZsf/lB938opyMRXdZK4WyS
        0kBomYMg2MihoLKgnPqJ2oYSwuXXeqr7rxstgS3svhxjd1+Fce/xmR+vXkEpK+UC
        //71gvpZumb929IQLiJT8vHzXSUpg==
X-ME-Sender: <xms:YYWeXSPJZI57hoyfHXoGV6kJ-qpRXdxgxUos9rm29SyZCHsdjxpHfw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedriedvgdeghecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdelrd
    dukeefrdejudenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgif
    rdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:YYWeXVVPNLxW6fNNRgXpWEKbPbd_QcmmzX6d2QFNk-GhZCFk3x-uCw>
    <xmx:YYWeXXJilizkqB7Q1nxf1bxA2A-cp-Snh24_TwVGn-Q9s77YYIvttQ>
    <xmx:YYWeXQrtHPy9aZ_4XdyHCcFPvMPvm4Ty7hfX1jh_o3B4dwDFvLjwxw>
    <xmx:YoWeXXtpmDkbWi1Scf6wK2ao03Mm_5UAmsehkyrreaGsKSFDyovNTw>
Received: from mickey.themaw.net (unknown [118.209.183.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id DA882D6005B;
        Wed,  9 Oct 2019 21:11:58 -0400 (EDT)
Message-ID: <cfffa97dfaad4a1cebf81838b68d644647a07dea.camel@themaw.net>
Subject: Re: [PATCH v5 10/17] xfs: mount-api - add xfs_get_tree()
From:   Ian Kent <raven@themaw.net>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu, 10 Oct 2019 09:11:55 +0800
In-Reply-To: <20191009150421.GH10349@infradead.org>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
         <157062066316.32346.11258138585168789863.stgit@fedora-28>
         <20191009150421.GH10349@infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2019-10-09 at 08:04 -0700, Christoph Hellwig wrote:
> > +	/*
> > +	 * set up the mount name first so all the errors will refer to
> > the
> > +	 * correct device.
> > +	 */
> > +	mp->m_fsname = kstrndup(sb->s_id, MAXNAMELEN, GFP_KERNEL);
> > +	if (!mp->m_fsname)
> > +		goto out_error;
> > +	mp->m_fsname_len = strlen(mp->m_fsname) + 1;
> 
> m_fsname_len is entirelt unused.  m_fsname just has a few users, so
> maybe in a prep patch just kill both of them and use sb->s_id
> instead.

Ok, I'll also have a look at doing that.

Ian

