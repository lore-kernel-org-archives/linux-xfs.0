Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF29AC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Jan 2022 17:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241495AbiAFRDX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Jan 2022 12:03:23 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56678 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241426AbiAFRDW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jan 2022 12:03:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6429D61D06;
        Thu,  6 Jan 2022 17:03:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6F6C36AEB;
        Thu,  6 Jan 2022 17:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641488601;
        bh=IcdanTKYrkbmH9+14ArDnUPPgrvybugmDr2La5xce+4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=js+D5ZoqLwAKxO08Vk4mn2zIKfvzSkcTcy8Hg8XiZXF7CRJokIR0VoFc/AcZBIcqf
         2dNGHPUVNk9W2Irme9nJFyXET/7biu8fyoOpJ59P+72yHoozL8Gfvvb+o80EpYarJ6
         rfgZVO3xTCU+Ax4biwFsH+4tbor6sAv/ixGro11RvVHJQgdBLFto/Uv60KNVbA0ape
         tnirNO9hZs3xzLBkcsJcjhw+tnr5J7SQbvJgBk9rOClYJekObDt5pppPwX4rQhJE+k
         DrYfhJKjqgWQaaPEyUVESyxmFHCLpkEjlajce2FWYY+DJRAyQIX90Tx+0vHiiGlC06
         IrCnHy2IA4ecA==
Date:   Thu, 6 Jan 2022 09:03:21 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     "xuyang2018.jy@fujitsu.com" <xuyang2018.jy@fujitsu.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH] xfs/220: fix quotarm syscall test
Message-ID: <20220106170321.GO656707@magnolia>
References: <20220105195352.GM656707@magnolia>
 <61D64732.3030505@fujitsu.com>
 <61D64C1C.1090602@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61D64C1C.1090602@fujitsu.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 06, 2022 at 01:55:01AM +0000, xuyang2018.jy@fujitsu.com wrote:
> on 2022/1/6 9:34, xuyang2018.jy@fujitsu.com wrote:
> > on 2022/1/6 3:53, Darrick J. Wong wrote:
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
> >>
> >> Fixes: 6ba125c9 ("xfs/220: avoid failure when disabling quota accounting is not supported")
> >> Signed-off-by: Darrick J. Wong<djwong@kernel.org>
> >> ---
> >>    tests/xfs/220 |   28 +++++++++++++++++++++-------
> >>    1 file changed, 21 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/tests/xfs/220 b/tests/xfs/220
> >> index 241a7abd..cfa90d3a 100755
> >> --- a/tests/xfs/220
> >> +++ b/tests/xfs/220
> >> @@ -52,14 +52,28 @@ _scratch_mkfs_xfs>/dev/null 2>&1
> >>    # mount  with quotas enabled
> >>    _scratch_mount -o uquota
> >>
> >> -# turn off quota and remove space allocated to the quota files
> >> +# turn off quota accounting...
> >> +$XFS_QUOTA_PROG -x -c off $SCRATCH_DEV
> >> +
> >> +# ...but if the kernel doesn't support turning off accounting, remount with
> >> +# noquota option to turn it off...
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
> >> +if [ $before_freesp -ge $after_freesp ]; then
> >> +	echo "before: $before_freesp; after: $after_freesp">>   $seqres.full
> > I prefer to move this info outside the if. So even case pass, I still
> > can see the difference in seqres.full.
> >> +	echo "expected more free space after Q_XQUOTARM"
> > Do you forget to add this into 220.out?
> Sorry, _get_available_space is designed for free space. I misunderstand it.
> 
> Just one nit, can we move the $seqres.full code outside the if?
> 
> after_freesp=$(_get_available_space $SCRATCH_MNT)
> delta=$(($after_freesp - $before_freesp))
> echo "before_freesp: $before_freesp; after_freesp: $after_freesp, delta:
> $delta" >> $seqres.full
> if [ $delta -le 0 ]; then
>         echo "expected more free space after Q_XQUOTARM"
> fi

Yes, I'll do that.

--D

> Best Regards
> Yang Xu
> > 
> > 
> > Also, I try this patch and add some output about delta.
> > It seems before_value greater than after value.
> > 
> >    #Make sure we actually freed the space used by dquot 0
> > after_freesp=$(_get_available_space $SCRATCH_MNT)
> > delta=$(($before_freesp - $after_freesp))
> > echo "before: $before_freesp; after: $after_freesp, delta: $delta">>
> > $seqres.full
> > if [ $delta -ge 0 ]; then
> >           echo "expected more free space after Q_XQUOTARM"
> > fi
> > 
> > MOUNT_OPTIONS =  -o defaults
> > before: 21280804864; after: 21280808960, delta: -4096
> > 
> > 
> > Best Regards
> > Yang Xu
> >> +fi
> >>
> >>    # and unmount again
> >>    _scratch_unmount
