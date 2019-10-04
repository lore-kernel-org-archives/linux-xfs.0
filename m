Return-Path: <SRS0=FqvN=X5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC2B5C4360C
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 08:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94BD2222C2
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 08:54:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="5KQJC12L";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ZjIt/dF+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729311AbfJDIyN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Oct 2019 04:54:13 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40099 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725730AbfJDIyM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Oct 2019 04:54:12 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 19CDA21F18;
        Fri,  4 Oct 2019 04:54:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 04 Oct 2019 04:54:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        LwtUHafjVl7fkQFoFLMB6fw8DLlXQlSgo0hHVSWk7eQ=; b=5KQJC12LFsA4OVsF
        yAeAO2NG9Ht3UkYpcBUkgTUkWAbfosxZ+OFsMSkKfixvfQHQf8XXFgTVKtOpxdS7
        6ucbKosKQ9GmP3vvWq2WeLdLc9oXgXGWIHLZ59rL0Wvam62HboH7/Yphe7yLfFHn
        IbAbplmOwfIaeKaZHZ/NlVTVvLK5pWiRoeR0OeJQlDJRcF72dujFSvKN6MaWm83w
        1J76/sGsvGBvOsM5WE+f/WM4E+6SZduTxZAm21tO8wKP6b6rhd8dhSIeQnw0su3X
        Ug9cpmj5thSIHWlVjBYDzR+ykqdvGnhIbPDk3MmP7KcmDkvwt0Nc9Oyyax73xbti
        GgP0vw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=LwtUHafjVl7fkQFoFLMB6fw8DLlXQlSgo0hHVSWk7
        eQ=; b=ZjIt/dF+tRX8aKP/v4tsHZ//sfA2vJeiACDowWCIYtL71xYOhFx/vWYML
        nijawxcdAd83umsgdnf91jXGfOYNxfsu8fAs0peluEN6ZBjb+YZ8hckvrQun8Vxf
        8jP+QwuuxXKSPtYqlmYNP/Za1gfHkOrsYe11kbmhMLrOm/DmhVOcKwVe+D5WVPfn
        CnA1smSNFbJ6wRRlauTJv1wL+bZZ2jjSRqdEZrnjc4Mc517mss8gdQz3qORMQ4iH
        AiTgVorfVi8fODxqxSnuKdUSN4o4772sC6rVl16GO2YTEiBTuorY0WtU6W/angud
        VnxLHtNS3KXU/gzbaCICsyQ2LWPeA==
X-ME-Sender: <xms:swiXXdoHpSPFnaGvt4ZOsSK0uG_7LTjJT-HfiLjbxMiVHqMihMJviA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrhedugddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecuffhomhgrihhnpehkvghrnh
    gvlhdrohhrghdplhifnhdrnhgvthenucfkphepuddukedrvddtkedrudekjedrudekieen
    ucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgifrdhnvghtnecuve
    hluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:swiXXXrTvZxgvugGjaEUPwOSscOYdkAtAGxgjtcfXo-ZCJnFVxuwkw>
    <xmx:swiXXa18BzsgCWTmImP1bN68e37Tb4T65nSk1WJv0VRVt0nOU_5bjA>
    <xmx:swiXXYe2nG7PSKr6LLhbw_vVa_ML6akNipB3Kn8gUmpddQJgLO7fxw>
    <xmx:tAiXXU3L8jkRg_87VH9IghCtTAo0bror5gYPhtWvYM9W_UFWeutDYg>
Received: from mickey.themaw.net (unknown [118.208.187.186])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0661ED6005B;
        Fri,  4 Oct 2019 04:54:08 -0400 (EDT)
Message-ID: <c34ecdc7195b16df42b3e8d85a9c8a71fab4cd65.camel@themaw.net>
Subject: Re: [PATCH v4 00/17] xfs: mount API patch series
From:   Ian Kent <raven@themaw.net>
To:     Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Fri, 04 Oct 2019 16:54:02 +0800
In-Reply-To: <f1b016cd013699cab3aaa449958fefeba3ddc5ed.camel@themaw.net>
References: <157009817203.13858.7783767645177567968.stgit@fedora-28>
         <37be0aa4-c8b5-4b40-dabd-13961bfb77a7@sandeen.net>
         <dc18b6f374221fbc1fd2168a40854f78aaaaf373.camel@themaw.net>
         <f1b016cd013699cab3aaa449958fefeba3ddc5ed.camel@themaw.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 2019-10-04 at 16:25 +0800, Ian Kent wrote:
> On Fri, 2019-10-04 at 14:57 +0800, Ian Kent wrote:
> > On Thu, 2019-10-03 at 18:30 -0500, Eric Sandeen wrote:
> > > On 10/3/19 5:25 AM, Ian Kent wrote:
> > > > This patch series add support to xfs for the new kernel mount
> > > > API
> > > > as described in the LWN article at 
> > > > https://lwn.net/Articles/780267/
> > > > .
> > > > 
> > > > In the article there's a lengthy description of the reasons for
> > > > adopting the API and problems expected to be resolved by using
> > > > it.
> > > > 
> > > > The series has been applied to the repository located at
> > > > git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git, and built
> > > > and
> > > > some simple tests run on it along with the generic xfstests.
> > > > 
> > > > Other things that continue to cause me concern:
> > > > 
> > > > - Message logging.
> > > 
> > > ...
> > > 
> > > Haven't actually reviewed yet, but just playing with it, I
> > > noticed
> > > an
> > > oddity;
> > > 
> > > # mount -o loop,allocsize=abc fsfile mnt
> > > 
> > > fails as expected, but with no dmesg to be found.  Is that a
> > > known
> > > behavior?
> > 
> > That's interesting.
> 
> But it's not actually.
> 
> > I'll see if I can work out what path that is taking though the
> > kernel, don't think it's getting to the xfs options handling.
> 
> In the original xfs code, if there's a failure in xfs_parseargs()
> such as in this case when suffix_kstrtoint() fails, probably at
> kstrtoint(), the -EINVAL is returned to xfs_fs_fill_super() which
> subsequently returns that to the VFS.
> 
> The VFS itself doesn't log a failure message, it just returns the
> error to user space.
> 
> With the patch series applied, xfs_parse_param() does essentially
> the same thing and because it returns other than -ENOPARAM to the
> VFS the error is returned, without the VFS logging an error, to
> user space.
> 
> There are a few cases in xfs options handling where this happens.
> The series hasn't tried to change this.

While the description above is accurate in terms of xfs options
handling behaviour, in this case it's not the invalid allocsize
that's causing the failure, it fails with a valid size as well.

Certainly mount(8) is calling mount(2) trying a bunch of alternate
fs types, xfs being one, and is getting -EINVAL back from them all.

Not sure of the value of tracking down an explanation of this since
it's fairly well outside the scope of the series but I will if you
want me to.

> 
> > > -Eric

