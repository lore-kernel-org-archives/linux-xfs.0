Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38E24C47082
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 15:34:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2282C613F5
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 15:34:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhFCPfw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 11:35:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229878AbhFCPfv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Jun 2021 11:35:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19533613EE;
        Thu,  3 Jun 2021 15:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622734447;
        bh=c86FaaF9zlIwiWdBjTSaHLsNmYx2MmtUhz9mWjL1CJI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W3Tzq77uAv8XLtaNIeS3BOe9WK3LSVIo11DhxFib0YqKHy13q7VStxeBSZRXGd+6N
         b+0dDQnlv15AJQYTftydPbDVw+OHQbOMAmVVUufT3knJ1jN2Glx5gCacVrJFdsSr9R
         Qz4Pe7XhlC5n3k6y9MF/B1/mhkuJ+wIVi/etehn7FhzJqliQNrHyBNEDztTk9RkEIJ
         ShHHNGJHq4L4dAe3LUdBubYElQlA4yHcqejlUEBq/UqlzDAwsoQ1HugvqfS77cEk1w
         n8nx2rFbfCFVPsRWftXQI7jlLAm8NdcWeRxRTMSPMVbbgvN0KWuxRx8SEI1qY1eo20
         4lNF0IlKknyMQ==
Date:   Thu, 3 Jun 2021 08:34:06 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Subject: Re: [PATCHSET RFC 00/10] fstests: move test group lists into test
 files
Message-ID: <20210603153406.GV26380@locust>
References: <162199360248.3744214.17042613373014687643.stgit@locust>
 <CAOQ4uxioTzuo5B3kEKX_GY_aDyps1WXHH7OsOw6N0sNyf31+7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxioTzuo5B3kEKX_GY_aDyps1WXHH7OsOw6N0sNyf31+7w@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 03, 2021 at 09:32:16AM +0300, Amir Goldstein wrote:
> On Wed, May 26, 2021 at 5:50 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > Hi all,
> >
> > Test group files (e.g. tests/generic/group) are a pain to keep up.
> > Every week I rebase on Eryu's latest upstream, and every week I have to
> > slog through dozens of trivial merge conflicts because of the
> > groupfiles.  Moving tests is annoying because we have to maintain all
> > this code to move the group associations from one /group file to
> > another.
> >
> > It doesn't need to be this way -- we could move each test's group
> > information into the test itself, and automatically generate the group
> > files as part of the make process.  This series does exactly that.
> >
> 
> This looks very nice :)
> 
> I do have one concern.
> If the auto-generated group files keep the same path as the existing
> source controlled group files, checkout of pre/post this change is
> going to be challenging for developers running make in the source
> directory.

<nod> A temporary pain until everyone rebases, but you're right, that's
going to annoy people unnecessarily.

Admittedly I left it as tests/*/group to avoid making any other changes.
All three lines' worth in check. :P

> Also .gitignore entries are needed for the auto-generated group files.

Heh, oops.  Will fix.

> I wonder if it wouldn't be easier for everyone if the auto-generated
> groups had a different name.

Probably.  We could blast fstests 25 years into the future and change
the name to "hashtag" :P

How about "group.map" ?

--D

> 
> Thanks,
> Amir.
