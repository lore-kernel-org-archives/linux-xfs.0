Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E776DC38A02
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Oct 2022 16:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbiJ1Q4v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Oct 2022 12:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiJ1Q4S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Oct 2022 12:56:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BC53A4A4
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 09:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666976118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LXA7Rc8z1607yJ2O9yRvftFn+WKBicrfPZzQj5e9Os8=;
        b=esqReI6h6wAXS9fx/08Dnx4sKh3w3aA15Ttmc/3eRwhv6Y4Z/IvZF6UEJR6oZcmWHoeF/G
        kPCxOD6KNyFEApOu2wtnYAxramGehastEUxWyA+zEnNiMpazpKwpAHITnfFYMNe/+6e3fH
        1UhVnx6iq8V99AvP0/Zub11GPU3vhsQ=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-478-C-MpkwbDPZy61mVYqvKs1Q-1; Fri, 28 Oct 2022 12:55:16 -0400
X-MC-Unique: C-MpkwbDPZy61mVYqvKs1Q-1
Received: by mail-qt1-f199.google.com with SMTP id cp8-20020a05622a420800b003a4f4f7b621so3636426qtb.6
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2022 09:55:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LXA7Rc8z1607yJ2O9yRvftFn+WKBicrfPZzQj5e9Os8=;
        b=lR2KYi4mmQultCC0pe5oduItllYmH9zjfgISm9Xocb0Ei3m+DC3AXTKRJ5vi8DUByc
         zX8NuEtvL3NfKOXYkRBZDYxZ6biV8UHM95Y/Sc1+LI17J5SARZP1E+tJMfF22H1eej7n
         WDCqO6FnyjN6sA3bHF0iOZ5x9YOzgZNOTFeDA0Wz0T0IrHynIgNaJKILmD84kso8aGrF
         iOk9eHGzIFBfI2UWrkzMQOAr8vvriQisfDzOwzL8iHFEPtsMk8ck7AFszl8ndTRi3K7p
         Sn3xIQEIdTL2XI8cl1yg/XVcfiZ0FjmtpxyhjRodp2lZOvikfYTzJZWhbLrKjaODN2p9
         00/w==
X-Gm-Message-State: ACrzQf0wfZFwV+2Acg2/fkoAjRke5gLD1TgMooZRYo59rNNLECg8s1yy
        FuBdgzOGBEg6/ChTuJeI755j1uS9GTULwLRNLxOT0qrS1IEQM98vWvgnuTbobqcfnwfIQQbHWIf
        o3TkDcvpsJkxzSry61Tam
X-Received: by 2002:a05:6214:2346:b0:496:ae16:f602 with SMTP id hu6-20020a056214234600b00496ae16f602mr340753qvb.37.1666976116365;
        Fri, 28 Oct 2022 09:55:16 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5+Ae9pS6X8lf7a20EWBaCftR0TAE+nW851zR4MIar9jtY6YSSb/WYJUg7ic9zZ1Nc5+9NK4w==
X-Received: by 2002:a05:6214:2346:b0:496:ae16:f602 with SMTP id hu6-20020a056214234600b00496ae16f602mr340728qvb.37.1666976116048;
        Fri, 28 Oct 2022 09:55:16 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id o24-20020a05620a229800b006ee7923c187sm3195298qkh.42.2022.10.28.09.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 09:55:15 -0700 (PDT)
Date:   Sat, 29 Oct 2022 00:55:10 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: refactor filesystem directory block size
 extraction logic
Message-ID: <20221028165510.aqf5h6hfsq4ia4kt@zlang-mailbox>
References: <166681099421.3403789.78493769502226810.stgit@magnolia>
 <166681100562.3403789.14498721397451474651.stgit@magnolia>
 <20221027165916.4ttwfx7g66pznsrt@zlang-mailbox>
 <Y1q5yYiIjWole+lj@magnolia>
 <20221028060814.r3lrrnymeqpf4x7t@zlang-mailbox>
 <Y1wBjytToTqRTXC2@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1wBjytToTqRTXC2@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 28, 2022 at 09:21:35AM -0700, Darrick J. Wong wrote:
> On Fri, Oct 28, 2022 at 02:08:14PM +0800, Zorro Lang wrote:
> > On Thu, Oct 27, 2022 at 10:03:05AM -0700, Darrick J. Wong wrote:
> > > On Fri, Oct 28, 2022 at 12:59:16AM +0800, Zorro Lang wrote:
> > > > On Wed, Oct 26, 2022 at 12:03:25PM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > There are a lot of places where we open-code determining the directory
> > > > > block size for a specific filesystem.  Refactor this into a single
> > > > > helper to clean up existing tests.
> > > > > 
> > > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > > ---
> > > > 
> > > > Hmm... sorry I failed to merge this patchset:
> > > > 
> > > > $ git am ./20221026_djwong_fstests_refactor_xfs_geometry_computation.mbx
> > > > Applying: xfs: refactor filesystem feature detection logic
> > > > Applying: xfs: refactor filesystem directory block size extraction logic
> > > > error: sha1 information is lacking or useless (common/xfs).
> > > > error: could not build fake ancestor
> > > > Patch failed at 0002 xfs: refactor filesystem directory block size extraction logic
> > > > hint: Use 'git am --show-current-patch=diff' to see the failed patch
> > > > When you have resolved this problem, run "git am --continue".
> > > > If you prefer to skip this patch, run "git am --skip" instead.
> > > > To restore the original branch and stop patching, run "git am --abort".
> > > 
> > > I don't know what exactly failed, but if you're ok with pushing your
> > > working branch to kernel.org, I can rebase my changes atop that and
> > > send you a pull request.
> > 
> > Hi Darrick,
> > 
> > Not my working branch, it failed on offical for-next branch too. By checking the
> > patch 2/4, I found (see below) ...
> > 
> > > 
> > > --D
> > > 
> > > > >  common/populate |    4 ++--
> > > > >  common/xfs      |    9 +++++++++
> > > > >  tests/xfs/099   |    2 +-
> > > > >  tests/xfs/100   |    2 +-
> > > > >  tests/xfs/101   |    2 +-
> > > > >  tests/xfs/102   |    2 +-
> > > > >  tests/xfs/105   |    2 +-
> > > > >  tests/xfs/112   |    2 +-
> > > > >  tests/xfs/113   |    2 +-
> > > > >  9 files changed, 18 insertions(+), 9 deletions(-)
> > > > > 
> > > > > 
> > > > > diff --git a/common/populate b/common/populate
> > > > > index 9fa1a06798..23b2fecf69 100644
> > > > > --- a/common/populate
> > > > > +++ b/common/populate
> > > > > @@ -175,7 +175,7 @@ _scratch_xfs_populate() {
> > > > >  	_xfs_force_bdev data $SCRATCH_MNT
> > > > >  
> > > > >  	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> > > > > -	dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> > > > > +	dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
> > > > >  	crc="$(_xfs_has_feature "$SCRATCH_MNT" crc -v)"
> > > > >  	if [ $crc -eq 1 ]; then
> > > > >  		leaf_hdr_size=64
> > > > > @@ -602,7 +602,7 @@ _scratch_xfs_populate_check() {
> > > > >  	is_reflink=$(_xfs_has_feature "$SCRATCH_MNT" reflink -v)
> > > > >  
> > > > >  	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> > > > > -	dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> > > > > +	dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
> > > > >  	leaf_lblk="$((32 * 1073741824 / blksz))"
> > > > >  	node_lblk="$((64 * 1073741824 / blksz))"
> > > > >  	umount "${SCRATCH_MNT}"
> > > > > diff --git a/common/xfs b/common/xfs
> > > > > index c7496bce3f..6445bfd9db 100644
> > > > > --- a/common/xfs
> > > > > +++ b/common/xfs
> > > > > @@ -203,6 +203,15 @@ _xfs_is_realtime_file()
> > 
> > ...
> > I can't find this _xfs_is_realtime_file() in my common/xfs, did I miss someone
> > prepositive patch?
> 
> It was added in the xfs_scrub phase6 functional test that's out for
> review:
> 
> https://lore.kernel.org/fstests/166613311880.868072.17189668251232287066.stgit@magnolia/

Wow, sorry I forgot this one patch, feel free to ping me if your patch not get
reviewing for long time :)

> 
> That said, this patch doesn't modify _xfs_is_realtime_file; all it does
> is inserts _xfs_get_dir_blocksize above _xfs_force_bdev.  That's
> probably where git am got confused.

Could you rebase this patchset to current for-next branch, if you'd like
to have this change in fstests release of this weekend? That "xfs_scrub
phase6 functional test" patch is not a simple change, I need time to
read and test it more before merging it :-D

Thanks,
Zorro

> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > > > >  	$XFS_IO_PROG -c 'stat -v' "$1" | grep -q -w realtime
> > > > >  }
> > > > >  
> > > > > +# Get the directory block size of a mounted filesystem.
> > > > > +_xfs_get_dir_blocksize()
> > > > > +{
> > > > > +	local fs="$1"
> > > > > +
> > > > > +	$XFS_INFO_PROG "$fs" | grep 'naming.*bsize' | \
> > > > > +		sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g'
> > > > > +}
> > > > > +
> > > > >  # Set or clear the realtime status of every supplied path.  The first argument
> > > > >  # is either 'data' or 'realtime'.  All other arguments should be paths to
> > > > >  # existing directories or empty regular files.
> > > > > diff --git a/tests/xfs/099 b/tests/xfs/099
> > > > > index a7eaff6e0c..82bef8ad26 100755
> > > > > --- a/tests/xfs/099
> > > > > +++ b/tests/xfs/099
> > > > > @@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
> > > > >  
> > > > >  echo "+ mount fs image"
> > > > >  _scratch_mount
> > > > > -dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> > > > > +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
> > > > >  nr="$((dblksz / 40))"
> > > > >  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> > > > >  leaf_lblk="$((32 * 1073741824 / blksz))"
> > > > > diff --git a/tests/xfs/100 b/tests/xfs/100
> > > > > index 79da8cb02c..e638b4ba17 100755
> > > > > --- a/tests/xfs/100
> > > > > +++ b/tests/xfs/100
> > > > > @@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
> > > > >  
> > > > >  echo "+ mount fs image"
> > > > >  _scratch_mount
> > > > > -dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> > > > > +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
> > > > >  nr="$((dblksz / 12))"
> > > > >  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> > > > >  leaf_lblk="$((32 * 1073741824 / blksz))"
> > > > > diff --git a/tests/xfs/101 b/tests/xfs/101
> > > > > index 64f4705aca..11ed329110 100755
> > > > > --- a/tests/xfs/101
> > > > > +++ b/tests/xfs/101
> > > > > @@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
> > > > >  
> > > > >  echo "+ mount fs image"
> > > > >  _scratch_mount
> > > > > -dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> > > > > +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
> > > > >  nr="$((dblksz / 12))"
> > > > >  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> > > > >  leaf_lblk="$((32 * 1073741824 / blksz))"
> > > > > diff --git a/tests/xfs/102 b/tests/xfs/102
> > > > > index 24dce43058..43f4539181 100755
> > > > > --- a/tests/xfs/102
> > > > > +++ b/tests/xfs/102
> > > > > @@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
> > > > >  
> > > > >  echo "+ mount fs image"
> > > > >  _scratch_mount
> > > > > -dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> > > > > +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
> > > > >  nr="$((16 * dblksz / 40))"
> > > > >  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> > > > >  leaf_lblk="$((32 * 1073741824 / blksz))"
> > > > > diff --git a/tests/xfs/105 b/tests/xfs/105
> > > > > index 22a8bf9fb0..002a712883 100755
> > > > > --- a/tests/xfs/105
> > > > > +++ b/tests/xfs/105
> > > > > @@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
> > > > >  
> > > > >  echo "+ mount fs image"
> > > > >  _scratch_mount
> > > > > -dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> > > > > +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
> > > > >  nr="$((16 * dblksz / 40))"
> > > > >  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> > > > >  leaf_lblk="$((32 * 1073741824 / blksz))"
> > > > > diff --git a/tests/xfs/112 b/tests/xfs/112
> > > > > index bc1ab62895..e2d5932da6 100755
> > > > > --- a/tests/xfs/112
> > > > > +++ b/tests/xfs/112
> > > > > @@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
> > > > >  
> > > > >  echo "+ mount fs image"
> > > > >  _scratch_mount
> > > > > -dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> > > > > +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
> > > > >  nr="$((16 * dblksz / 40))"
> > > > >  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> > > > >  leaf_lblk="$((32 * 1073741824 / blksz))"
> > > > > diff --git a/tests/xfs/113 b/tests/xfs/113
> > > > > index e820ed96da..9bb2cd304b 100755
> > > > > --- a/tests/xfs/113
> > > > > +++ b/tests/xfs/113
> > > > > @@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
> > > > >  
> > > > >  echo "+ mount fs image"
> > > > >  _scratch_mount
> > > > > -dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> > > > > +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
> > > > >  nr="$((128 * dblksz / 40))"
> > > > >  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> > > > >  leaf_lblk="$((32 * 1073741824 / blksz))"
> > > > > 
> > > > 
> > > 
> 

