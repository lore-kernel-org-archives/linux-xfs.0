Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3EB8C05027
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Feb 2023 17:05:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbjBBRE7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Feb 2023 12:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbjBBRE6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2023 12:04:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B1245220;
        Thu,  2 Feb 2023 09:04:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E45761C1D;
        Thu,  2 Feb 2023 17:04:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE34AC433EF;
        Thu,  2 Feb 2023 17:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675357496;
        bh=BILE4Z5D3pYwdBWGGlIe/yaRJAvlsXHvzGys4Q0mpY4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Up6lVayoDHXaR/L5Su9abta7yinRSsMHxCU5YDsEf53ToAJJo4C9vAeEehaXOCDMC
         84v1uYfs5JtSHajaPnNVJlcDgKRYgoElulPAFSqSCYJn3Izj0DJzV/EivlicTIHb7L
         JpR0mORBWJAi+E9elfUMEsaEDhnh1TWoLK8JDT0iekfHQEGv98pS5jybknIdd052eJ
         coQ4NDQ3HukzGpaFTTlrReudtlpG9MDlBiYyczES0MtQA+uMeItzMENcWAXUy+qevy
         0+yMNFC5sMZaETbwkflzComna5yDFy3ONqOe7Gw5aIA5fu0ZqFA+os55W7gCK+BNmw
         hkzhtjAB1EEvg==
Date:   Thu, 2 Feb 2023 09:04:56 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] generic/500: skip this test if formatting fails
Message-ID: <Y9vtOPDXt75bO9uX@magnolia>
References: <167521268927.2382722.13701066927653225895.stgit@magnolia>
 <167521270079.2382722.2799074346773170090.stgit@magnolia>
 <20230202100057.hooqqf2mdinhaaj6@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202100057.hooqqf2mdinhaaj6@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 02, 2023 at 06:00:57PM +0800, Zorro Lang wrote:
> On Tue, Jan 31, 2023 at 04:51:40PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > This testcase exercises what happens when we race a filesystem
> > perforing discard operations against a thin provisioning device that has
> > run out of space.  To constrain runtime, it creates a 128M thinp volume
> > and formats it.
> > 
> > However, if that initial format fails because (say) the 128M volume is
> > too small, then the test fails.  This is really a case of test
> > preconditions not being satisfied, so let's make the test _notrun when
> > this happens.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  common/dmthin     |    7 ++++-
> >  common/rc         |   80 +++++++++++++++++++++++++++--------------------------
> >  tests/generic/500 |    3 +-
> >  3 files changed, 48 insertions(+), 42 deletions(-)
> > 
> > 
> > diff --git a/common/dmthin b/common/dmthin
> > index 91147e47ac..7107d50804 100644
> > --- a/common/dmthin
> > +++ b/common/dmthin
> > @@ -234,5 +234,10 @@ _dmthin_mount()
> >  _dmthin_mkfs()
> >  {
> >  	_scratch_options mkfs
> > -	_mkfs_dev $SCRATCH_OPTIONS $@ $DMTHIN_VOL_DEV
> > +	_mkfs_dev $SCRATCH_OPTIONS "$@" $DMTHIN_VOL_DEV
> 
> This patch adds quote marks to $@, that an extra change. So I hope to know if
> this change fix something wrong or you just felt it's better to have?

Putting double quotes around "$@" (and any other array access) tells
bash that it shouldn't word split any array elements that contain
spaces[1].  Observe:

$ cat /tmp/a.sh
#!/bin/bash

strace -s99 -e execve echo $@
$ /tmp/a.sh 'how now' moo cow
execve("/usr/bin/echo", ["echo", "how", "now", "moo", "cow"], 0x7ffcfb44f218 /* 68 vars */) = 0
how now moo cow
+++ exited with 0 +++

Oops, 'how now' was supposed to be a single argument, but now it is two.

$ cat /tmp/a.sh
#!/bin/bash

strace -s99 -e execve echo "$@"
$ /tmp/a.sh 'how now' moo cow
execve("/usr/bin/echo", ["echo", "how now", "moo", "cow"], 0x7ffccb72d810 /* 68 vars */) = 0
how now moo cow
+++ exited with 0 +++

With the quoted usage, strings with spaces are copied through correctly.
At the moment I don't think this has any practical effect on fstests
because most kernel developers "know" they shouldn't be putting spaces
in anything they feed to fstests, but I've decided that I'll at least
try to fix some of the more egregious problems as I go.

On that topic, does anyone use shellcheck to static-analyze their
fstests code?

--D

[1] https://www.shellcheck.net/wiki/SC2068

> If this part has a good explanation, others good to me, then I'd like to give
> it:
> 
> Reviewed-by: Zorro Lang <zlang@redhat.com>
> 
> Thanks,
> Zorro
> 
> > +}
> > +_dmthin_try_mkfs()
> > +{
> > +	_scratch_options mkfs
> > +	_try_mkfs_dev $SCRATCH_OPTIONS "$@" $DMTHIN_VOL_DEV
> >  }
> > diff --git a/common/rc b/common/rc
> > index 36eb90e1f1..376a0138b4 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -604,49 +604,49 @@ _test_mkfs()
> >      esac
> >  }
> >  
> > +_try_mkfs_dev()
> > +{
> > +    case $FSTYP in
> > +    nfs*)
> > +	# do nothing for nfs
> > +	;;
> > +    9p)
> > +	# do nothing for 9p
> > +	;;
> > +    fuse)
> > +	# do nothing for fuse
> > +	;;
> > +    virtiofs)
> > +	# do nothing for virtiofs
> > +	;;
> > +    overlay)
> > +	# do nothing for overlay
> > +	;;
> > +    pvfs2)
> > +	# do nothing for pvfs2
> > +	;;
> > +    udf)
> > +        $MKFS_UDF_PROG $MKFS_OPTIONS $*
> > +	;;
> > +    btrfs)
> > +        $MKFS_BTRFS_PROG $MKFS_OPTIONS $*
> > +	;;
> > +    ext2|ext3|ext4)
> > +	$MKFS_PROG -t $FSTYP -- -F $MKFS_OPTIONS $*
> > +	;;
> > +    xfs)
> > +	$MKFS_PROG -t $FSTYP -- -f $MKFS_OPTIONS $*
> > +	;;
> > +    *)
> > +	yes | $MKFS_PROG -t $FSTYP -- $MKFS_OPTIONS $*
> > +	;;
> > +    esac
> > +}
> > +
> >  _mkfs_dev()
> >  {
> >      local tmp=`mktemp -u`
> > -    case $FSTYP in
> > -    nfs*)
> > -	# do nothing for nfs
> > -	;;
> > -    9p)
> > -	# do nothing for 9p
> > -	;;
> > -    fuse)
> > -	# do nothing for fuse
> > -	;;
> > -    virtiofs)
> > -	# do nothing for virtiofs
> > -	;;
> > -    overlay)
> > -	# do nothing for overlay
> > -	;;
> > -    pvfs2)
> > -	# do nothing for pvfs2
> > -	;;
> > -    udf)
> > -        $MKFS_UDF_PROG $MKFS_OPTIONS $* 2>$tmp.mkfserr 1>$tmp.mkfsstd
> > -	;;
> > -    btrfs)
> > -        $MKFS_BTRFS_PROG $MKFS_OPTIONS $* 2>$tmp.mkfserr 1>$tmp.mkfsstd
> > -	;;
> > -    ext2|ext3|ext4)
> > -	$MKFS_PROG -t $FSTYP -- -F $MKFS_OPTIONS $* \
> > -		2>$tmp.mkfserr 1>$tmp.mkfsstd
> > -	;;
> > -    xfs)
> > -	$MKFS_PROG -t $FSTYP -- -f $MKFS_OPTIONS $* \
> > -		2>$tmp.mkfserr 1>$tmp.mkfsstd
> > -	;;
> > -    *)
> > -	yes | $MKFS_PROG -t $FSTYP -- $MKFS_OPTIONS $* \
> > -		2>$tmp.mkfserr 1>$tmp.mkfsstd
> > -	;;
> > -    esac
> > -
> > -    if [ $? -ne 0 ]; then
> > +    if ! _try_mkfs_dev "$@" 2>$tmp.mkfserr 1>$tmp.mkfsstd; then
> >  	# output stored mkfs output
> >  	cat $tmp.mkfserr >&2
> >  	cat $tmp.mkfsstd
> > diff --git a/tests/generic/500 b/tests/generic/500
> > index bc84d219fa..1151c8f234 100755
> > --- a/tests/generic/500
> > +++ b/tests/generic/500
> > @@ -58,7 +58,8 @@ CLUSTER_SIZE=$((64 * 1024 / 512))		# 64K
> >  
> >  _dmthin_init $BACKING_SIZE $VIRTUAL_SIZE $CLUSTER_SIZE 0
> >  _dmthin_set_fail
> > -_dmthin_mkfs
> > +_dmthin_try_mkfs >> $seqres.full 2>&1 || \
> > +	_notrun "Could not format small thinp filesystem for test"
> >  _dmthin_mount
> >  
> >  # There're two bugs at here, one is dm-thin bug, the other is filesystem
> > 
> 
