Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B30C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jul 2022 21:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbiGYVCI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Jul 2022 17:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232608AbiGYVCE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jul 2022 17:02:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400142317F;
        Mon, 25 Jul 2022 14:02:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC7F8B80ECE;
        Mon, 25 Jul 2022 21:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3BAC341C8;
        Mon, 25 Jul 2022 21:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658782920;
        bh=7eZBw3izG2Y+pmV+4Nbh9TMo63YxDDjQ4Nid00T0gm4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fr59ZiUPb6EzU4Kck26Vd262VG1aNApL3EvDozZMjdbvoq2DW4e6W816Ph18V7gGN
         IWLYhc7gFSn/PpMOwUPEqPd6sP6rxSW9GeL5NseMgVWlUAQQ0bUDOpGcEAYGpEjBFG
         msRw8y4n/DjwyIns4f98+e1KVS7iP5qrndWVoCSDijlLZxZM37oTe2xM332LKIh/MR
         naJDJ7t55+fTEC3/6Vs23rcKQTjW0QJR/w7Gjw58uih+qMaKY054fONeJtFmTB7uj/
         L1BejSGddqDynPve22ERojitIQ8FBR42J1CLhKSLlwMAhg6GE0mFl4iBcf5qlD4Jez
         yq0UJNKPJ5dxQ==
Date:   Mon, 25 Jul 2022 14:02:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCHSET v2 0/8] fstests: check file block congruency of file
 range operations
Message-ID: <Yt8EyJEJPpBVt9eV@magnolia>
References: <165826663647.3249494.13640199673218669145.stgit@magnolia>
 <20220724140127.dm5lf6ibrkzvkcis@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220724140127.dm5lf6ibrkzvkcis@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 24, 2022 at 10:01:27PM +0800, Zorro Lang wrote:
> On Tue, Jul 19, 2022 at 02:37:16PM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > I started running fstests with XFS filesystems that don't have the usual
> > file geometry characteristics -- block sizes larger than 4k, realtime
> > filesystems with extent sizes that aren't a power of two, etc.  What I
> > found is that many file operation tests (fallocate, reflink, etc.) that
> > operate on disk blocks assume that aligning the arguments to 64k is
> > sufficient to avoid EINVAL.  Unfortunately, this just means that these
> > tests fail left and right on realtime filesystems where the file
> > allocation unit is large (~2MB, anyone?) or a weird number (28K).
> > 
> > Add a predicate to all of these tests so that we can _notrun them if
> > they make assumptions about file size /and/ encode something (usually
> > file hashes) in the golden output that mean we can't easily accomodate
> > these corner cases without redesigning each test.
> > 
> > v2: skip congruency tests for network filesystems, be more consistent about
> >     TEST_DIR in the arguments, fix a bug in a helper's callsite reported by
> >     Zorro.
> > 
> > If you're going to start using this mess, you probably ought to just
> > pull from my git trees, which are linked below.
> > 
> > This is an extraordinary way to destroy everything.  Enjoy!
> > Comments and questions are, as always, welcome.
> > 
> > --D
> 
> I'd like to merge this patchset after my personal review and testing. As I
> didn't find any regression from this patchset, and there's not any objection
> from anyone after two weeks passed. So I'm going to merge it, to help Darrick
> shift to his next patchset he's working on.

Thanks!

--D

> Reviewed-by: Zorro Lang <zlang@redhat.com>
> 
> > 
> > fstests git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=check-blocksize-congruency
> > ---
> >  common/filter     |    4 ++--
> >  common/punch      |    3 ++-
> >  common/rc         |   28 +++++++++++++++++++++++++++-
> >  tests/generic/017 |    2 +-
> >  tests/generic/031 |    1 +
> >  tests/generic/064 |    2 +-
> >  tests/generic/116 |    1 +
> >  tests/generic/118 |    1 +
> >  tests/generic/119 |    1 +
> >  tests/generic/121 |    1 +
> >  tests/generic/122 |    1 +
> >  tests/generic/134 |    1 +
> >  tests/generic/136 |    1 +
> >  tests/generic/137 |    1 +
> >  tests/generic/144 |    1 +
> >  tests/generic/149 |    1 +
> >  tests/generic/153 |    2 +-
> >  tests/generic/158 |    2 +-
> >  tests/generic/162 |    1 +
> >  tests/generic/163 |    1 +
> >  tests/generic/164 |    1 +
> >  tests/generic/165 |    1 +
> >  tests/generic/168 |    1 +
> >  tests/generic/170 |    1 +
> >  tests/generic/181 |    1 +
> >  tests/generic/183 |    1 +
> >  tests/generic/185 |    1 +
> >  tests/generic/186 |    1 +
> >  tests/generic/187 |    1 +
> >  tests/generic/188 |    1 +
> >  tests/generic/189 |    1 +
> >  tests/generic/190 |    1 +
> >  tests/generic/191 |    1 +
> >  tests/generic/194 |    1 +
> >  tests/generic/195 |    1 +
> >  tests/generic/196 |    1 +
> >  tests/generic/197 |    1 +
> >  tests/generic/199 |    1 +
> >  tests/generic/200 |    1 +
> >  tests/generic/201 |    1 +
> >  tests/generic/284 |    1 +
> >  tests/generic/287 |    1 +
> >  tests/generic/289 |    1 +
> >  tests/generic/290 |    1 +
> >  tests/generic/291 |    1 +
> >  tests/generic/292 |    1 +
> >  tests/generic/293 |    1 +
> >  tests/generic/295 |    1 +
> >  tests/generic/352 |    1 +
> >  tests/generic/358 |    1 +
> >  tests/generic/359 |    1 +
> >  tests/generic/372 |    1 +
> >  tests/generic/404 |    2 +-
> >  tests/generic/414 |    1 +
> >  tests/generic/483 |    4 ++++
> >  tests/generic/495 |    4 ++++
> >  tests/generic/501 |    1 +
> >  tests/generic/503 |    4 ++++
> >  tests/generic/515 |    1 +
> >  tests/generic/516 |    1 +
> >  tests/generic/540 |    1 +
> >  tests/generic/541 |    1 +
> >  tests/generic/542 |    1 +
> >  tests/generic/543 |    1 +
> >  tests/generic/544 |    1 +
> >  tests/generic/546 |    1 +
> >  tests/generic/578 |    1 +
> >  tests/generic/588 |    2 ++
> >  tests/generic/673 |    1 +
> >  tests/generic/674 |    1 +
> >  tests/generic/675 |    1 +
> >  tests/generic/677 |    4 ++++
> >  tests/generic/683 |    1 +
> >  tests/generic/684 |    1 +
> >  tests/generic/685 |    1 +
> >  tests/generic/686 |    1 +
> >  tests/generic/687 |    1 +
> >  tests/generic/688 |    1 +
> >  tests/xfs/069     |    1 +
> >  tests/xfs/114     |    2 ++
> >  tests/xfs/166     |    4 ++++
> >  tests/xfs/180     |    1 +
> >  tests/xfs/182     |    1 +
> >  tests/xfs/184     |    1 +
> >  tests/xfs/192     |    1 +
> >  tests/xfs/193     |    1 +
> >  tests/xfs/198     |    1 +
> >  tests/xfs/200     |    1 +
> >  tests/xfs/203     |    4 ++++
> >  tests/xfs/204     |    1 +
> >  tests/xfs/208     |    1 +
> >  tests/xfs/209     |    1 +
> >  tests/xfs/210     |    1 +
> >  tests/xfs/211     |    1 +
> >  tests/xfs/212     |    1 +
> >  tests/xfs/215     |    1 +
> >  tests/xfs/218     |    1 +
> >  tests/xfs/219     |    1 +
> >  tests/xfs/221     |    1 +
> >  tests/xfs/223     |    1 +
> >  tests/xfs/224     |    1 +
> >  tests/xfs/225     |    1 +
> >  tests/xfs/226     |    1 +
> >  tests/xfs/228     |    1 +
> >  tests/xfs/230     |    1 +
> >  tests/xfs/231     |    1 +
> >  tests/xfs/232     |    1 +
> >  tests/xfs/237     |    1 +
> >  tests/xfs/239     |    1 +
> >  tests/xfs/240     |    1 +
> >  tests/xfs/241     |    1 +
> >  tests/xfs/248     |    1 +
> >  tests/xfs/249     |    1 +
> >  tests/xfs/251     |    1 +
> >  tests/xfs/254     |    1 +
> >  tests/xfs/255     |    1 +
> >  tests/xfs/256     |    1 +
> >  tests/xfs/257     |    1 +
> >  tests/xfs/258     |    1 +
> >  tests/xfs/280     |    1 +
> >  tests/xfs/312     |    1 +
> >  tests/xfs/315     |    1 +
> >  tests/xfs/322     |    1 +
> >  tests/xfs/326     |    1 +
> >  tests/xfs/329     |    1 +
> >  tests/xfs/346     |    1 +
> >  tests/xfs/347     |    1 +
> >  tests/xfs/436     |    1 +
> >  tests/xfs/507     |    3 +++
> >  tests/xfs/537     |    2 +-
> >  130 files changed, 180 insertions(+), 10 deletions(-)
> > 
> 
