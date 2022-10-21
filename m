Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B170C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Oct 2022 03:14:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiJUDOE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Oct 2022 23:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiJUDN7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Oct 2022 23:13:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901C7BE51B
        for <linux-xfs@vger.kernel.org>; Thu, 20 Oct 2022 20:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666322036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BvptVinJwcmZE7hiJrJjd3K0DJZgErM1skFHa3yBiAQ=;
        b=MxkAX6pB/PzNLvdP1x7gBmWpNTSDfu6CPK+udAcOyPoBk+eq2+nIJs+hwf9sCF8AqZD88f
        k+rYmAGqWWJ90ETIXb+D3nttjJMuN/t288I5MuBBZ4j7O8cRtR6c1vC0bG6ByvD5qM6PWi
        pU0m2YTtFWtg/Wfjryu2kfF6qQhXjn0=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-640-mPkgu__GPgyHQ22Z5p9Cwg-1; Thu, 20 Oct 2022 23:13:54 -0400
X-MC-Unique: mPkgu__GPgyHQ22Z5p9Cwg-1
Received: by mail-pj1-f69.google.com with SMTP id il7-20020a17090b164700b0020d1029ceaaso3167453pjb.8
        for <linux-xfs@vger.kernel.org>; Thu, 20 Oct 2022 20:13:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BvptVinJwcmZE7hiJrJjd3K0DJZgErM1skFHa3yBiAQ=;
        b=xeExcW8qa2YMVAkSoCtL5qdfl/yOn2u47hw87zqd0LSPAQrgm5x9Yq71uIiUSLtVsv
         pi7ThjGpeshTC9MRKTiRFCYwE6LtpzR1tWLsq/tKks1XFW80wClDn8AlPyEfEhoSok9/
         WPl+kXHCS8Fkt6qPYAXysjfp8eb4Jq3+EdNSJhKiV1S3OtU+a4DBTMOEYxT63CPcufoq
         sKpT5V/l+Fke6/n5Tiq69pNbjNoKCpZSO7ck6PpVAU2a8PFRaPILztWvcg4mLcGuJJND
         xIfeJLX+z6hRA5wr9mYpvMJ+hFTDnAqCkQ+/sOV+0hCnPe9/hqYTNfq6YFgcjyLOaWA8
         38+Q==
X-Gm-Message-State: ACrzQf1ErjRB+MqJaLyFpPp5IPGo79Y6glRNoW1HR2ssOxKHi0Mq9JmU
        zYpMv0Tvx1tL1FXDFO9lYyJLkmWXv8SqSIMb7Bn+EDxUolNw6nDlU79c4XqlnmLTtVHBw+S59F1
        1UcH/GzmDCqC6Vzh3Lirh
X-Received: by 2002:a17:90a:8c97:b0:20d:a1a2:bfda with SMTP id b23-20020a17090a8c9700b0020da1a2bfdamr19649722pjo.234.1666322033672;
        Thu, 20 Oct 2022 20:13:53 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7OOu3KaK+5Q+o6FU7Ivg1fNDhsymAfO/z0/k/nZlDhLRm/UOM/Z5KqNGF3gwl1DGOBgZh+vw==
X-Received: by 2002:a17:90a:8c97:b0:20d:a1a2:bfda with SMTP id b23-20020a17090a8c9700b0020da1a2bfdamr19649688pjo.234.1666322033273;
        Thu, 20 Oct 2022 20:13:53 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d4-20020a62f804000000b005628a30a500sm14061462pfh.41.2022.10.20.20.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 20:13:52 -0700 (PDT)
Date:   Fri, 21 Oct 2022 11:13:48 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: refactor filesystem realtime geometry detection
 logic
Message-ID: <20221021031348.rteteenwvznnxcmk@zlang-mailbox>
References: <166613312194.868141.5162859918517610030.stgit@magnolia>
 <166613313870.868141.4913572781093963547.stgit@magnolia>
 <20221020121534.pp7esou4wxneaz4i@zlang-mailbox>
 <Y1G7xOI+0Nfwz5nJ@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y1G7xOI+0Nfwz5nJ@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 20, 2022 at 02:21:08PM -0700, Darrick J. Wong wrote:
> On Thu, Oct 20, 2022 at 08:15:34PM +0800, Zorro Lang wrote:
> > On Tue, Oct 18, 2022 at 03:45:38PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > There are a lot of places where we open-code detecting the realtime
> > > extent size and extent count of a specific filesystem.  Refactor this
> > > into a couple of helpers to clean up the code.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  common/populate |    2 +-
> > >  common/xfs      |   29 +++++++++++++++++++++++++++--
> > >  tests/xfs/146   |    2 +-
> > >  tests/xfs/147   |    2 +-
> > >  tests/xfs/530   |    3 +--
> > >  5 files changed, 31 insertions(+), 7 deletions(-)
> > > 
> > > 
> > > diff --git a/common/populate b/common/populate
> > > index 23b2fecf69..d9d4c6c300 100644
> > > --- a/common/populate
> > > +++ b/common/populate
> > > @@ -323,7 +323,7 @@ _scratch_xfs_populate() {
> > >  	fi
> > >  
> > >  	# Realtime Reverse-mapping btree
> > > -	is_rt="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep -c 'rtextents=[1-9]')"
> > > +	is_rt="$(_xfs_get_rtextents "$SCRATCH_MNT")"
> > >  	if [ $is_rmapbt -gt 0 ] && [ $is_rt -gt 0 ]; then
> > >  		echo "+ rtrmapbt btree"
> > >  		nr="$((blksz * 2 / 32))"
> > > diff --git a/common/xfs b/common/xfs
> > > index 6445bfd9db..20da537a9d 100644
> > > --- a/common/xfs
> > > +++ b/common/xfs
> > > @@ -174,6 +174,24 @@ _scratch_mkfs_xfs()
> > >  	return $mkfs_status
> > >  }
> > >  
> > > +# Get the number of realtime extents of a mounted filesystem.
> > > +_xfs_get_rtextents()
> > > +{
> > > +	local path="$1"
> > > +
> > > +	$XFS_INFO_PROG "$path" | grep 'rtextents' | \
> > > +		sed -e 's/^.*rtextents=\([0-9]*\).*$/\1/g'
> > 
> > Same as patch 2/3, how about:
> > 
> > 	$XFS_INFO_PROG "$path" | sed -n "s/^.*rtextents=\([[:digit:]]*\).*/\1/p"
> 
> Actually, if you don't mind, I'd like to retain the hoisted grep/sed
> patterns in this patch (and patch 2) and add a new patch that simplifies
> the grep|sed pattern throughout common/xfs.

Sure, that makes sense too, I'm OK to have one more patch. Actually that's
not a necessary change, I don't know if it's worth being a individual patch.
Anyway, I have no objection on that:)

Thanks,
Zorro

> 
> > 
> > and ...
> > 
> > > +}
> > > +
> > > +# Get the realtime extent size of a mounted filesystem.
> > > +_xfs_get_rtextsize()
> > > +{
> > > +	local path="$1"
> > > +
> > > +	$XFS_INFO_PROG "$path" | grep 'realtime.*extsz' | \
> > > +		sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g'
> > 
> > ...
> > 	$XFS_INFO_PROG "$path" | sed -n "s/^realtime.*extsz=\([[:digit:]]*\).*/\1/p"
> 
> But thanks for getting me most of the way there. :)
> 
> > > +}
> > > +
> > >  # Get the size of an allocation unit of a file.  Normally this is just the
> > >  # block size of the file, but for realtime files, this is the realtime extent
> > >  # size.
> > > @@ -191,7 +209,7 @@ _xfs_get_file_block_size()
> > >  	while ! $XFS_INFO_PROG "$path" &>/dev/null && [ "$path" != "/" ]; do
> > >  		path="$(dirname "$path")"
> > >  	done
> > > -	$XFS_INFO_PROG "$path" | grep realtime | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g'
> > > +	_xfs_get_rtextsize "$path"
> > >  }
> > >  
> > >  # Decide if this path is a file on the realtime device
> > > @@ -436,13 +454,20 @@ _require_xfs_crc()
> > >  # third option is -v, echo 1 for success and 0 for not.
> > >  #
> > >  # Starting with xfsprogs 4.17, this also works for unmounted filesystems.
> > > +# The feature 'realtime' looks for rtextents > 0.
> > >  _xfs_has_feature()
> > >  {
> > >  	local fs="$1"
> > >  	local feat="$2"
> > >  	local verbose="$3"
> > > +	local feat_regex="1"
> > >  
> > > -	local answer="$($XFS_INFO_PROG "$fs" 2>&1 | grep -w -c "$feat=1")"
> > > +	if [ "$feat" = "realtime" ]; then
> > > +		feat="rtextents"
> > > +		feat_regex="[1-9][0-9]*"
> > > +	fi
> > 
> > How about use this format:
> > 
> > case "$feat" in
> > realtime)
> > 	feat="rtextents"
> > 	feat_regex="[1-9][0-9]*"
> > 	;;
> > ...)
> > 	feat="..."
> > 	feat_regex="..."
> > 	;;
> > *)
> > 	feat="$2“
> > 	feat_regex="1"
> > 	;;
> > esac
> > 
> > due to I think you might add more "$feat" which not simply equal to 1/0 later :)
> 
> I haven't, but I don't mind setting things up for the future.
> 
> --D
> 
> > Others looks good to me.
> > 
> > Thanks,
> > Zorro
> > 
> > > +
> > > +	local answer="$($XFS_INFO_PROG "$fs" 2>&1 | grep -E -w -c "$feat=$feat_regex")"
> > >  	if [ "$answer" -ne 0 ]; then
> > >  		test "$verbose" = "-v" && echo 1
> > >  		return 0
> > > diff --git a/tests/xfs/146 b/tests/xfs/146
> > > index 5516d396bf..123bdff59f 100755
> > > --- a/tests/xfs/146
> > > +++ b/tests/xfs/146
> > > @@ -31,7 +31,7 @@ _scratch_mkfs > $seqres.full
> > >  _scratch_mount >> $seqres.full
> > >  
> > >  blksz=$(_get_block_size $SCRATCH_MNT)
> > > -rextsize=$($XFS_INFO_PROG $SCRATCH_MNT | grep realtime.*extsz | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g')
> > > +rextsize=$(_xfs_get_rtextsize "$SCRATCH_MNT")
> > >  rextblks=$((rextsize / blksz))
> > >  
> > >  echo "blksz $blksz rextsize $rextsize rextblks $rextblks" >> $seqres.full
> > > diff --git a/tests/xfs/147 b/tests/xfs/147
> > > index e21fdd330c..33b3c99633 100755
> > > --- a/tests/xfs/147
> > > +++ b/tests/xfs/147
> > > @@ -29,7 +29,7 @@ _scratch_mkfs -r extsize=256k > $seqres.full
> > >  _scratch_mount >> $seqres.full
> > >  
> > >  blksz=$(_get_block_size $SCRATCH_MNT)
> > > -rextsize=$($XFS_INFO_PROG $SCRATCH_MNT | grep realtime.*extsz | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g')
> > > +rextsize=$(_xfs_get_rtextsize "$SCRATCH_MNT")
> > >  rextblks=$((rextsize / blksz))
> > >  
> > >  echo "blksz $blksz rextsize $rextsize rextblks $rextblks" >> $seqres.full
> > > diff --git a/tests/xfs/530 b/tests/xfs/530
> > > index c960738db7..56f5e7ebdb 100755
> > > --- a/tests/xfs/530
> > > +++ b/tests/xfs/530
> > > @@ -73,8 +73,7 @@ _try_scratch_mount || _notrun "Couldn't mount fs with synthetic rt volume"
> > >  formatted_blksz="$(_get_block_size $SCRATCH_MNT)"
> > >  test "$formatted_blksz" -ne "$dbsize" && \
> > >  	_notrun "Tried to format with $dbsize blocksize, got $formatted_blksz."
> > > -$XFS_INFO_PROG $SCRATCH_MNT | grep -E -q 'realtime.*blocks=0' && \
> > > -	_notrun "Filesystem should have a realtime volume"
> > > +_require_xfs_has_feature "$SCRATCH_MNT" realtime
> > >  
> > >  echo "Consume free space"
> > >  fillerdir=$SCRATCH_MNT/fillerdir
> > > 
> 

