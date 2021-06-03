Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 143E7C47099
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 15:23:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02CC76101B
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 15:23:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbhFCPYt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 11:24:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232057AbhFCPYs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Jun 2021 11:24:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF136613E3;
        Thu,  3 Jun 2021 15:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622733783;
        bh=GfrUYIJ9clQgKie4HUv4frK6Q/6WBB9sIL3miPosnDY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iptvT3aJhw0OA+yuEehMUdw0BHDhYhFXN1PxY8fwn2Z7YgHxu3HhmQRfcjilQKEJX
         VQ6luYirx0NaN+zspdcYwRjAtuyi/gturr1UDuxGRaVLnqVo/UNNnVaaAz/uhRX1se
         w57G0GM7qrYYfafQuERotN8fuky1nkCNneEUyzQ2r6DbSX54oj3DLZj4AxsoC+zt8i
         lWfkGAZAXTd3Pvr/3ukO7/jIlYJzzom6+xmfSsmtQPZjyEQ8ZeP7UOXYqlKwgsbxIl
         RbA/Wpd1FsUMTPuT9gnPgpkxkmKUYQkoE6zL2OSVbuaLqh3t76HTfhTC8heo8TG+an
         lLkTc2h5gsGew==
Date:   Thu, 3 Jun 2021 08:23:03 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 04/10] fstests: move test group info to test files
Message-ID: <20210603152303.GE26402@locust>
References: <162199360248.3744214.17042613373014687643.stgit@locust>
 <162199362461.3744214.7536635976092405399.stgit@locust>
 <YLhhW17x/Kq0Bnq3@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLhhW17x/Kq0Bnq3@sol.localdomain>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 02, 2021 at 09:58:03PM -0700, Eric Biggers wrote:
> On Tue, May 25, 2021 at 06:47:04PM -0700, Darrick J. Wong wrote:
> > diff --git a/tests/btrfs/001 b/tests/btrfs/001
> > index fb051e8a..2248b6f6 100755
> > --- a/tests/btrfs/001
> > +++ b/tests/btrfs/001
> > @@ -6,13 +6,9 @@
> >  #
> >  # Test btrfs's subvolume and snapshot support
> >  #
> > -seq=`basename $0`
> > -seqres=$RESULT_DIR/$seq
> > -echo "QA output created by $seq"
> > +. ./common/test_names
> > +_set_seq_and_groups auto quick subvol snapshot
> 
> The naming is a little weird here.  This feels more like a common preamble,
> especially given that it also sets $here, $tmp, and $status -- not just the test
> groups.  Maybe it should look like:
> 
> . ./common/preamble
> _begin_fstest quick subvol snapshot

I like that much better than my current names!  Will fix for v2.

--D
