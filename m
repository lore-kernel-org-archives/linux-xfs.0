Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 506D4C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Jan 2022 17:08:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243708AbiANRIo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Jan 2022 12:08:44 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44032 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243679AbiANRIo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jan 2022 12:08:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4009E61FFA;
        Fri, 14 Jan 2022 17:08:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EFEEC36AE5;
        Fri, 14 Jan 2022 17:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642180123;
        bh=73sNrrejWAnOUS8DbsENhMWsreK3C8YaYC3pZACL5C4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rRqn+cxRG7p+ZbvGipDfPQCNHGOYqBPWI4yfwSIJzLoPOy6BhpZZ5fqMmIu6vNl9L
         3Ame963EcY6GDouv63xIoFKcy5jtoNchyfzsQ1rOLhEq6buvkMPeSQSgKYJ2u4oZRP
         U/UrlLHG3bMIM0vWRn7L8xt5AqhEQpGLTAky7g6VUIW5ifWpKbIB2UBflg+5KAawlC
         CiaspZiFOdwONlInc+6TDAuE566kgeNAYwPfusVqgNj03qxrG115bQWRHkB81ZiDO2
         EJ+zCAVwj44EcrexZ8kXTheWA08UHVEbPem441lctvEzPbDcbVIt58HAkTk3ikSiSl
         p442X6dwqQE0w==
Date:   Fri, 14 Jan 2022 09:08:43 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     "xuyang2018.jy@fujitsu.com" <xuyang2018.jy@fujitsu.com>
Cc:     "guaneryu@gmail.com" <guaneryu@gmail.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        "guan@eryu.me" <guan@eryu.me>
Subject: Re: [PATCH 3/8] xfs/220: fix quotarm syscall test
Message-ID: <20220114170843.GA90398@magnolia>
References: <164193780808.3008286.598879710489501860.stgit@magnolia>
 <164193782492.3008286.10701739517344882323.stgit@magnolia>
 <61DE2BAF.3000001@fujitsu.com>
 <61E0ECFE.9080300@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <61E0ECFE.9080300@fujitsu.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 14, 2022 at 03:23:50AM +0000, xuyang2018.jy@fujitsu.com wrote:
> on 2022/1/12 9:14, xuyang2018.jy@fujitsu.com wrote:
> > on 2022/1/12 5:50, Darrick J. Wong wrote:
> >> From: Darrick J. Wong<djwong@kernel.org>
> >>
> >> In commit 6ba125c9, we tried to adjust this fstest to deal with the
> >> removal of the ability to turn off quota accounting via the Q_XQUOTAOFF
> >> system call.
> >>
> >> Unfortunately, the changes made to this test make it nonfunctional on
> >> those newer kernels, since the Q_XQUOTARM command returns EINVAL if
> >> quota accounting is turned on, and the changes filter out the EINVAL
> >> error string.
> >>
> >> Doing this wasn't /incorrect/, because, very narrowly speaking, the
> >> intent of this test is to guard against Q_XQUOTARM returning ENOSYS when
> >> quota has been enabled.  However, this also means that we no longer test
> >> Q_XQUOTARM's ability to truncate the quota files at all.
> >>
> >> So, fix this test to deal with the loss of quotaoff in the same way that
> >> the others do -- if accounting is still enabled after the 'off' command,
> >> cycle the mount so that Q_XQUOTARM actually truncates the files.
> >>
> >> While we're at it, enhance the test to check that XQUOTARM actually
> >> truncated the quota files.
> > Looks good to me,
> > Reviewed-by：Yang Xu<xuyang2018.jy@fujitsu.com>
> >
> > Best Regards
> > Yang Xu
> >
> >>
> >> Fixes: 6ba125c9 ("xfs/220: avoid failure when disabling quota accounting is not supported")
> >> Cc: xuyang2018.jy@fujitsu.com
> >> Signed-off-by: Darrick J. Wong<djwong@kernel.org>
> >> ---
> >>    tests/xfs/220 |   30 +++++++++++++++++++++++-------
> >>    1 file changed, 23 insertions(+), 7 deletions(-)
> >>
> >>
> >> diff --git a/tests/xfs/220 b/tests/xfs/220
> >> index 241a7abd..88eedf51 100755
> >> --- a/tests/xfs/220
> >> +++ b/tests/xfs/220
> >> @@ -52,14 +52,30 @@ _scratch_mkfs_xfs>/dev/null 2>&1
> >>    # mount  with quotas enabled
> >>    _scratch_mount -o uquota
> >>
> >> -# turn off quota and remove space allocated to the quota files
> >> +# turn off quota accounting...
> >> +$XFS_QUOTA_PROG -x -c off $SCRATCH_DEV
> >> +
> >> +# ...but if the kernel doesn't support turning off accounting, remount with
> >> +# noquota option to turn it off...
> I used MS_REMOUNT flag with mount syscall in ltp quotactl07.c, so this 
> is the expected behaviour?

No, you have to unmount completely and mount again with '-o noquota'.
In other words, "mount -o remount,noquota" isn't sufficient to disable
accounting.

--D

> https://patchwork.ozlabs.org/project/ltp/patch/1641973691-22981-2-git-send-email-xuyang2018.jy@fujitsu.com/
> 
> Best Regards
> Yang Xu
> >> +if $XFS_QUOTA_PROG -x -c 'state -u' $SCRATCH_DEV | grep -q 'Accounting: ON'; then
> >> +	_scratch_unmount
> >> +	_scratch_mount -o noquota
> >> +fi
> >> +
> >> +before_freesp=$(_get_available_space $SCRATCH_MNT)
> >> +
> >> +# ...and remove space allocated to the quota files
> >>    # (this used to give wrong ENOSYS returns in 2.6.31)
> >> -#
> >> -# The sed expression below replaces a notrun to cater for kernels that have
> >> -# removed the ability to disable quota accounting at runtime.  On those
> >> -# kernel this test is rather useless, and in a few years we can drop it.
> >> -$XFS_QUOTA_PROG -x -c off -c remove $SCRATCH_DEV 2>&1 | \
> >> -	sed -e '/XFS_QUOTARM: Invalid argument/d'
> >> +$XFS_QUOTA_PROG -x -c remove $SCRATCH_DEV
> >> +
> >> +# Make sure we actually freed the space used by dquot 0
> >> +after_freesp=$(_get_available_space $SCRATCH_MNT)
> >> +delta=$((after_freesp - before_freesp))
> >> +
> >> +echo "freesp $before_freesp ->   $after_freesp ($delta)">>   $seqres.full
> >> +if [ $before_freesp -ge $after_freesp ]; then
> >> +	echo "expected Q_XQUOTARM to free space"
> >> +fi
> >>
> >>    # and unmount again
> >>    _scratch_unmount
> >>
