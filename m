Return-Path: <SRS0=FqvN=X5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A693C4CED1
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 08:25:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC137215EA
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 08:25:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="Kp/14xbD";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="KtM5leoO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729466AbfJDIZq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Oct 2019 04:25:46 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60595 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728462AbfJDIZq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Oct 2019 04:25:46 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 5CB4D21FC2;
        Fri,  4 Oct 2019 04:25:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 04 Oct 2019 04:25:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm1; bh=
        chE72ySyf/tlP/0EnwuvezC8eUl/57HYdZiYOM74yVM=; b=Kp/14xbD3v8G2Ysi
        wGBgUNKw1aD2hg2Zy5/3bNy1nxY6sXh4UpbBWkeBpIodYqGHWrjS4xQDvFkCMKcv
        dZ17q4ft0fvErwDyBYDU5Zt/8T5J6oQ0gDfUYuq6fqiikFr7ca2VoITgtQgeCU7L
        B83TrQ+N1z47PFTy4UNywOtmK8JNgAl1LdNjCIddyG3Rck0S4HKGN8WY6XFt4D2T
        bF+gPJ76HC/sEEDaGkg8dV0UgVCkRAvr5c6CSkFaJJQ3kMkPfsJO5X8m1RMMVkBI
        yIqDjg2pHOZTfuXjsOtLI2kJJj9JZUaxQ2sjPVSmYwjkCndivX3glsfHEKn5V8xn
        nZfyCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=chE72ySyf/tlP/0EnwuvezC8eUl/57HYdZiYOM74y
        VM=; b=KtM5leoOupodhl6dP3qRU5L7Hl7mx2s9w4V7uvx4V2YbmjJkVbTYChRRf
        ZDJLsthW2+6oSko98bXHAjTEDeGFUu2I3mYDxPgLGs2meFiKCAhajdGxv1DRWf1G
        EDYqAsXy5r9dKQkzXeu42WEeMsxZfTOKlEi5nFPCePPfalvOY6sWX88tz8NTRVMS
        fm64waxeE2WbMI+q5S1njmw+IPD8THNtURA2fBp1ZiUhlmrvpPdw+BvNCVR+L3tG
        nLmMAqreopCRvhGU7CmHneHuiuUw/jOvGAWrwr0E9BC6zn4KysmRot2AegjG9D6y
        97oXufFFCQ6eB1mWyC9NCNqCicUPA==
X-ME-Sender: <xms:CAKXXTXGvpqODSK0EtOn9_va7ICIIWekaaXW-qopqjF_kjvGDS-BcA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrhedtgdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecuffhomhgrihhnpehkvghrnh
    gvlhdrohhrghdplhifnhdrnhgvthenucfkphepuddukedrvddtkedrudekjedrudekieen
    ucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgifrdhnvghtnecuve
    hluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:CAKXXSYeZlxfv6ZhdpfZ0zs8lbXJ28NdmE8rMYk9W1wu3mVj0zQNVA>
    <xmx:CAKXXTptBIuw_lk0GZcnUR-S1djBXWmGCFHVF1ZN5eWVrqdumsxEuw>
    <xmx:CAKXXXEhaS9LbT6SY6TKt5RwaA_7ACFYjpQCQvEz3F4HAvYIcVZWqQ>
    <xmx:CQKXXV-JVF1EWGFXXj4iEmWcmRnXJex7n2HuS3qXQrXzSzjwBvHefA>
Received: from mickey.themaw.net (unknown [118.208.187.186])
        by mail.messagingengine.com (Postfix) with ESMTPA id 78D77D6005B;
        Fri,  4 Oct 2019 04:25:42 -0400 (EDT)
Message-ID: <f1b016cd013699cab3aaa449958fefeba3ddc5ed.camel@themaw.net>
Subject: Re: [PATCH v4 00/17] xfs: mount API patch series
From:   Ian Kent <raven@themaw.net>
To:     Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Fri, 04 Oct 2019 16:25:37 +0800
In-Reply-To: <dc18b6f374221fbc1fd2168a40854f78aaaaf373.camel@themaw.net>
References: <157009817203.13858.7783767645177567968.stgit@fedora-28>
         <37be0aa4-c8b5-4b40-dabd-13961bfb77a7@sandeen.net>
         <dc18b6f374221fbc1fd2168a40854f78aaaaf373.camel@themaw.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 2019-10-04 at 14:57 +0800, Ian Kent wrote:
> On Thu, 2019-10-03 at 18:30 -0500, Eric Sandeen wrote:
> > On 10/3/19 5:25 AM, Ian Kent wrote:
> > > This patch series add support to xfs for the new kernel mount API
> > > as described in the LWN article at 
> > > https://lwn.net/Articles/780267/
> > > .
> > > 
> > > In the article there's a lengthy description of the reasons for
> > > adopting the API and problems expected to be resolved by using
> > > it.
> > > 
> > > The series has been applied to the repository located at
> > > git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git, and built and
> > > some simple tests run on it along with the generic xfstests.
> > > 
> > > Other things that continue to cause me concern:
> > > 
> > > - Message logging.
> > 
> > ...
> > 
> > Haven't actually reviewed yet, but just playing with it, I noticed
> > an
> > oddity;
> > 
> > # mount -o loop,allocsize=abc fsfile mnt
> > 
> > fails as expected, but with no dmesg to be found.  Is that a known
> > behavior?
> 
> That's interesting.

But it's not actually.

> 
> I'll see if I can work out what path that is taking though the
> kernel, don't think it's getting to the xfs options handling.

In the original xfs code, if there's a failure in xfs_parseargs()
such as in this case when suffix_kstrtoint() fails, probably at
kstrtoint(), the -EINVAL is returned to xfs_fs_fill_super() which
subsequently returns that to the VFS.

The VFS itself doesn't log a failure message, it just returns the
error to user space.

With the patch series applied, xfs_parse_param() does essentially
the same thing and because it returns other than -ENOPARAM to the
VFS the error is returned, without the VFS logging an error, to
user space.

There are a few cases in xfs options handling where this happens.
The series hasn't tried to change this.

> 
> > -Eric

