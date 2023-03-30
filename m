Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F8FFC761A6
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Mar 2023 02:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjC3COH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Mar 2023 22:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjC3COG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Mar 2023 22:14:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C51946B4;
        Wed, 29 Mar 2023 19:14:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EC4BB82371;
        Thu, 30 Mar 2023 02:14:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C328C433D2;
        Thu, 30 Mar 2023 02:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680142442;
        bh=kNMrVph3c4Kf2HJcuTo8yStr0eCqGYaZY5FM6xIbOwQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QAk107W25hmQaBd3uFIESv28lvM5a9qlizeyASMTSIDnq3qijbkBfFVqwSb11hVg1
         8qCkA+0Ye53EAPsDQab68f1iymHbCU+YccmD3lS+rZx3uFyQwhUfweczTvtPaA4NMt
         mTPcs+FUpeGCGcGfglCXtFfeVVxal7l/qn0TKQQr8aVZNryOefCSkw/rkZ6vKDPWrU
         wy04on2NMr43sMn8a8MGzGxUPizzhXHtvcjX+5e5fVifY8XLXZjVG3lkREkcfrd/01
         xzUYE9QgcNmWti+gHde5ROLW14HsSRHKFxMQo+ibPPurC1huBGUFw8R4HQEOORL6hP
         cJBBhEgXGMK+Q==
Date:   Wed, 29 Mar 2023 19:14:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     David Disseldorp <ddiss@suse.de>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/3] generic/{251,260}: compute maximum fitrim offset
Message-ID: <20230330021402.GC991605@frogsfrogsfrogs>
References: <168005148468.4147931.1986862498548445502.stgit@frogsfrogsfrogs>
 <168005149047.4147931.2729971759269213680.stgit@frogsfrogsfrogs>
 <20230329123917.7f436940@echidna.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329123917.7f436940@echidna.fritz.box>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 29, 2023 at 12:39:17PM +0200, David Disseldorp wrote:
> On Tue, 28 Mar 2023 17:58:10 -0700, Darrick J. Wong wrote:
> 
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > FITRIM is a bizarre ioctl.  Callers are allowed to pass in "start" and
> > "length" parameters, which are clearly some kind of range argument.  No
> > means is provided to discover the minimum or maximum range.  Although
> > regular userspace programs default to (start=0, length=-1ULL), this test
> > tries to exercise different parameters.
> > 
> > However, the test assumes that the "size" column returned by the df
> > command is the maximum value supported by the FITRIM command, and is
> > surprised if the number of bytes trimmed by (start=0, length=-1ULL) is
> > larger than this size quantity.
> > 
> > This is completely wrong on XFS with realtime volumes, because the
> > statfs output (which is what df reports) will reflect the realtime
> > volume if the directory argument is a realtime file or a directory
> > flagged with rtinherit.  This is trivially reproducible by configuring a
> > rt volume that is much larger than the data volume, setting rtinherit on
> > the root dir at mkfs time, and running either of these tests.
> > 
> > Refactor the open-coded df logic so that we can determine the value
> > programmatically for XFS.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  common/rc         |   15 +++++++++++++++
> >  common/xfs        |   11 +++++++++++
> >  tests/generic/251 |    2 +-
> >  tests/generic/260 |    2 +-
> >  4 files changed, 28 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/common/rc b/common/rc
> > index 90749343f3..228982fa4d 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -3927,6 +3927,21 @@ _require_batched_discard()
> >  	fi
> >  }
> >  
> > +# Given a mountpoint and the device associated with that mountpoint, return the
> > +# maximum start offset that the FITRIM command will accept, in units of 1024
> > +# byte blocks.
> > +_discard_max_offset_kb()
> > +{
> > +	case "$FSTYP" in
> > +	xfs)
> > +		_xfs_discard_max_offset_kb "$1"
> > +		;;
> > +	*)
> > +		$DF_PROG -k | grep "$1" | grep "$2" | awk '{print $3}'
> > +		;;
> 
> Might as well fix it to properly match full paths, e.g.
>   $DF_PROG -k|awk '$1 == "'$dev'" && $7 == "'$mnt'" { print $3 }'

I think I could simplify that even more to:

$DF_PROG -k | awk -v dev="$dev" -v mnt="$mnt" '$1 == dev && $7 == mnt {print $3}'

> With this:
>    Reviewed-by: David Disseldorp <ddiss@suse.de>

Thanks!

> One other minor suggestion below...
> 
> > +	esac
> > +}
> > +
> >  _require_dumpe2fs()
> >  {
> >  	if [ -z "$DUMPE2FS_PROG" ]; then
> > diff --git a/common/xfs b/common/xfs
> > index e8e4832cea..a6c82fc6c7 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -1783,3 +1783,14 @@ _require_xfs_scratch_atomicswap()
> >  		_notrun "atomicswap dependencies not supported by scratch filesystem type: $FSTYP"
> >  	_scratch_unmount
> >  }
> > +
> > +# Return the maximum start offset that the FITRIM command will accept, in units
> > +# of 1024 byte blocks.
> > +_xfs_discard_max_offset_kb()
> > +{
> > +	local path="$1"
> > +	local blksz="$($XFS_IO_PROG -c 'statfs' "$path" | grep "geom.bsize" | cut -d ' ' -f 3)"
> > +	local dblks="$($XFS_IO_PROG -c 'statfs' "$path" | grep "geom.datablocks" | cut -d ' ' -f 3)"
> > +
> > +	echo "$((dblks * blksz / 1024))"
> 
> This could be simplified a little:
>  $XFS_IO_PROG -c 'statfs' "$path" \
>    | awk '{g[$1] = $3} END {print (g["geom.bsize"] * g["geom.datablocks"] / 1024)}'

Oooh, I like this better.  Thanks for the suggestion!

--D

> 
> > +}
