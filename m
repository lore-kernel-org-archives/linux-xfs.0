Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1AD6C47082
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 22:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAC7261407
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 22:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhFCWXB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 18:23:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229656AbhFCWXA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Jun 2021 18:23:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9524261401;
        Thu,  3 Jun 2021 22:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622758875;
        bh=qqdgWHziyl95HA79sWD2GxVpSJT0F4g6uAOG18jTqzE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m2cmErDRfwEcY74FaxPhiEaQ7L7HfbUGrxiyVCyBo2DYocQA3etG8L4oD5/r0LI5A
         ntnW5flve/IOQOcgFzLlu8SdPsv6F+mJt56svpfc8cpYokSBuuyImouMxkJiDFMsk2
         AvnQGJUcus9TZTjqA0HPrqymEvxCIwmhmdMx0/XVjPB0Us4jJgKYaLxDVjUzPIxPMq
         9M8ZwQgUpxeTDhB2B0o/vh1py24CHqPpV8swIN/PqxcTfS2kgAhp5wjUTRYI6U9Wb7
         gyQC0P/WeEycYjUClrsCnyr/TCQ652FrGOS/GJAOx9E3vlon8FWQ0XQL71YoSjtQs2
         Fn9OHRszi7IBg==
Date:   Thu, 3 Jun 2021 15:21:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Subject: Re: [PATCHSET RFC 00/10] fstests: move test group lists into test
 files
Message-ID: <20210603222115.GC26353@locust>
References: <162199360248.3744214.17042613373014687643.stgit@locust>
 <CAOQ4uxioTzuo5B3kEKX_GY_aDyps1WXHH7OsOw6N0sNyf31+7w@mail.gmail.com>
 <20210603153406.GV26380@locust>
 <CAOQ4uxiVSCjMfCv8+tK84jLV6d9torFo-16esk3+15PNn_+T3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiVSCjMfCv8+tK84jLV6d9torFo-16esk3+15PNn_+T3w@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 03, 2021 at 07:56:49PM +0300, Amir Goldstein wrote:
> On Thu, Jun 3, 2021 at 6:34 PM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Thu, Jun 03, 2021 at 09:32:16AM +0300, Amir Goldstein wrote:
> > > On Wed, May 26, 2021 at 5:50 AM Darrick J. Wong <djwong@kernel.org> wrote:
> > > >
> > > > Hi all,
> > > >
> > > > Test group files (e.g. tests/generic/group) are a pain to keep up.
> > > > Every week I rebase on Eryu's latest upstream, and every week I have to
> > > > slog through dozens of trivial merge conflicts because of the
> > > > groupfiles.  Moving tests is annoying because we have to maintain all
> > > > this code to move the group associations from one /group file to
> > > > another.
> > > >
> > > > It doesn't need to be this way -- we could move each test's group
> > > > information into the test itself, and automatically generate the group
> > > > files as part of the make process.  This series does exactly that.
> > > >
> > >
> > > This looks very nice :)
> > >
> > > I do have one concern.
> > > If the auto-generated group files keep the same path as the existing
> > > source controlled group files, checkout of pre/post this change is
> > > going to be challenging for developers running make in the source
> > > directory.
> >
> > <nod> A temporary pain until everyone rebases, but you're right, that's
> > going to annoy people unnecessarily.
> >
> > Admittedly I left it as tests/*/group to avoid making any other changes.
> > All three lines' worth in check. :P
> >
> > > Also .gitignore entries are needed for the auto-generated group files.
> >
> > Heh, oops.  Will fix.
> >
> > > I wonder if it wouldn't be easier for everyone if the auto-generated
> > > groups had a different name.
> >
> > Probably.  We could blast fstests 25 years into the future and change
> > the name to "hashtag" :P
> >
> > How about "group.map" ?
> >
> 
> <shrug> that's the hardest part ;-)
> 
> I'm fine with group.map group.list group.autogen or whatnot.
> 
> I am used to typing the prefix of the group file path in shell commands,
> but auto-complete should take care of any suffix.

I went with group.list.

--D

> Thanks,
> Amir.
