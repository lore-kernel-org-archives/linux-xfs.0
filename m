Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BCF1C04A68
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jul 2022 23:15:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbiG0XP0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jul 2022 19:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236104AbiG0XPK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jul 2022 19:15:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A2858B6E;
        Wed, 27 Jul 2022 16:14:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71EBB61723;
        Wed, 27 Jul 2022 23:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBAB3C433D6;
        Wed, 27 Jul 2022 23:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658963674;
        bh=LDKeOJalYAL72ebZcB0ezxMWhiW0gSlv0v4i1sMiJos=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TcQz4hdzRXbSYFMDQmSTomVUYKgNAIe3ycDSHelbTPUbWNW9Po6L2xb/UqIW4Jbxq
         8PS77aVfNnRzG0RbfdHfsb6eXBOG9jH0k51TjmPG8m8NBrM4YKnzSZQF9ieOurEqxf
         HzWQ0hG0vdDztsxpfen+ppGDVwYfnc04XZgLn0RZ+oMlHSC7JJYH6pf+9WpfbkWQ1F
         EQPWGhbNVoQij16gyg0iF0NGutnoyWvd7iueGb0Z7LIiNJ1oTPlqeL54+59VZnha2Z
         qgOI9AsGydWT0rWlOUTHTGQlMlvAZL2s+nlbV70zi7X20pxBJrMMYkF+w6VGUFWTCk
         d0VwEiymTe4OA==
Date:   Wed, 27 Jul 2022 16:14:34 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfs/432: fix this test when external devices are in useOM
Message-ID: <YuHG2jLYMcyvujJ7@magnolia>
References: <YuBFw4dheeSRHVQd@magnolia>
 <20220727122142.ktp5loclqazchncw@zlang-mailbox>
 <YuFS6/9iMXzjv/YX@magnolia>
 <20220727172137.7vsspxca764ma5xj@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727172137.7vsspxca764ma5xj@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 28, 2022 at 01:21:37AM +0800, Zorro Lang wrote:
> On Wed, Jul 27, 2022 at 07:59:55AM -0700, Darrick J. Wong wrote:
> > On Wed, Jul 27, 2022 at 08:21:42PM +0800, Zorro Lang wrote:
> > > On Tue, Jul 26, 2022 at 12:51:31PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > This program exercises metadump and mdrestore being run against the
> > > > scratch device.  Therefore, the test must pass external log / rt device
> > > > arguments to xfs_repair -n to check the "restored" filesystem.  Fix the
> > > > incorrect usage, and report repair failures, since this test has been
> > > > silently failing for a while now.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  tests/xfs/432 |   11 ++++++++++-
> > > >  1 file changed, 10 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/tests/xfs/432 b/tests/xfs/432
> > > > index 86012f0b..5c6744ce 100755
> > > > --- a/tests/xfs/432
> > > > +++ b/tests/xfs/432
> > > > @@ -89,7 +89,16 @@ _scratch_xfs_metadump $metadump_file -w
> > > >  xfs_mdrestore $metadump_file $metadump_img
> > > >  
> > > >  echo "Check restored metadump image"
> > > > -$XFS_REPAIR_PROG -n $metadump_img >> $seqres.full 2>&1
> > > > +repair_args=('-n')
> > > > +[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
> > > > +	repair_args+=('-l' "$SCRATCH_LOGDEV")
> > > > +
> > > > +[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
> > > > +	repair_args+=('-r' "$SCRATCH_RTDEV")
> > > > +
> > > > +$XFS_REPAIR_PROG "${repair_args[@]}" $metadump_img >> $seqres.full 2>&1
> > > > +res=$?
> > > > +test $res -ne 0 && echo "xfs_repair on restored fs returned $res?"
> > > 
> > > Make sense to me, I don't have better idea. One question, is xfs_metadump
> > > and xfs_mdrestore support rtdev? Due to I didn't find xfs_metadump have
> > > a "-r" option, although it has "-l logdev" :)
> > 
> > Oops, no it doesn't, so I'll remove that.
> 
> Hmm... it doesn't for now or won't for future?
> 
> So all test cases about xfs_metadump can't run with SCRATCH_RTDEV? Do we need
> something likes _require_nortdev?

There's no need for metadump to touch the realtime device since it
contains only file data.

> > 
> > > About the "$res", I don't know why we need this extra variable, as it's
> > > not used in other place.
> > 
> > If you don't pass the correct arguments to xfs_repair or the metadump
> > trashes the fs, it'll exit with a nonzero code.  All the output goes to
> > $seqres.full, which means the test runner has no idea anything went
> > wrong and marks the test passed even though repair failed.
> 
> Oh, I mean why not use the "$?" directly? Or :
> $XFS_REPAIR_PROG "${repair_args[@]}" $metadump_img >> $seqres.full 2>&1 || \
> 	echo "xfs_repair on restored fs returned $res?"
> 
> Looks like we don't need to save this return status and use it on other place.
> The "$res" looks redundant, although it's not wrong :)

Oh, yeah, I can do that too.

--D

> Thanks,
> Zorro
> 
> > 
> > --D
> > 
> > > Thanks,
> > > Zorro
> > > 
> > > >  
> > > >  # success, all done
> > > >  status=0
> > > > 
> > > 
> > 
> 
