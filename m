Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A42CC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 18:27:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A52A64E62
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 18:27:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhBKSPL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 13:15:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:53306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232791AbhBKSNQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Feb 2021 13:13:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39E2464E05;
        Thu, 11 Feb 2021 18:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613067155;
        bh=Mox6q0jJXgFY8d7sDzN+PiRpQHmunHC/lwX5MAkuZaM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=neOpxtbtsVrlIKeinrwxnw7NHeL7ya4V8wvBLgzMx2EAsLCVy3hNs8mxywZ0SjkqI
         7y5vezbO/lxqLrHXrMp4GWC9YT1JnIWhDI7+7W9hC3gRAJIdSkUMDKbFCMZ1a6I+MW
         JGeC+/nG/8PYWdTE3YZtU8U204hC3cRVfhtFbNXOQOu0e58rYygTgmNmqPFKMhFkk7
         reAIpALZkH2xKepgIId7xI2gUJ0PO8YT6wDItYbE+lhG9hi6238aBzMLNOXFiZ6WNt
         UhoBXPV+QHFDD8qS79rwWE/9mL6MyDZxSS6c51n8it5C0WBnkAFFPnhlNdYX1LX5wP
         ZTy5rBmpIAoVw==
Date:   Thu, 11 Feb 2021 10:12:34 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/6] common: capture metadump output if xfs filesystem
 check fails
Message-ID: <20210211181234.GE7193@magnolia>
References: <161292577956.3504537.3260962158197387248.stgit@magnolia>
 <161292579087.3504537.10519481439481869013.stgit@magnolia>
 <20210211135958.GB222065@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211135958.GB222065@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 11, 2021 at 08:59:58AM -0500, Brian Foster wrote:
> On Tue, Feb 09, 2021 at 06:56:30PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@djwong.org>
> > 
> > Capture metadump output when various userspace repair and checker tools
> > fail or indicate corruption, to aid in debugging.  We don't bother to
> > annotate xfs_check because it's bitrotting.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  README     |    2 ++
> >  common/xfs |   26 ++++++++++++++++++++++++++
> >  2 files changed, 28 insertions(+)
> > 
> > 
> > diff --git a/README b/README
> > index 43bb0cee..36f72088 100644
> > --- a/README
> > +++ b/README
> > @@ -109,6 +109,8 @@ Preparing system for tests:
> >               - Set TEST_FS_MODULE_RELOAD=1 to unload the module and reload
> >                 it between test invocations.  This assumes that the name of
> >                 the module is the same as FSTYP.
> > +	     - Set SNAPSHOT_CORRUPT_XFS=1 to record compressed metadumps of XFS
> > +	       filesystems if the various stages of _check_xfs_filesystem fail.
> >  
> >          - or add a case to the switch in common/config assigning
> >            these variables based on the hostname of your test
> > diff --git a/common/xfs b/common/xfs
> > index 2156749d..ad1eb6ee 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -432,6 +432,21 @@ _supports_xfs_scrub()
> >  	return 0
> >  }
> >  
> > +# Save a compressed snapshot of a corrupt xfs filesystem for later debugging.
> > +_snapshot_xfs() {
> 
> The term snapshot has a well known meaning. Can we just call this
> _metadump_xfs()?

Ok.

> 
> > +	local metadump="$1"
> > +	local device="$2"
> > +	local logdev="$3"
> > +	local options="-a -o"
> > +
> > +	if [ "$logdev" != "none" ]; then
> > +		options="$options -l $logdev"
> > +	fi
> > +
> > +	$XFS_METADUMP_PROG $options "$device" "$metadump" >> "$seqres.full" 2>&1
> > +	gzip -f "$metadump" >> "$seqres.full" 2>&1 &
> 
> Why compress in the background?

Sometimes the metadumps can become very large and I don't tend to have a
lot of space on the test appliances for storing blobs.

Also, I was under the impression that it was customary for people to
share compressed metadumps of crashes, so why not save everyone a step?

I do this in the background to avoid holding up the next fstest.

> I wonder if we should just skip the
> compression step since this requires an option to enable in the first
> place..

Seeing as it's optional, I think that's all the more reason to compress.

> 
> > +}
> > +
> >  # run xfs_check and friends on a FS.
> >  _check_xfs_filesystem()
> >  {
> ...
> > @@ -540,6 +564,8 @@ _check_xfs_filesystem()
> >  			cat $tmp.repair				>>$seqres.full
> >  			echo "*** end xfs_repair output"	>>$seqres.full
> >  
> > +			test "$SNAPSHOT_CORRUPT_XFS" = "1" && \
> > +				_snapshot_xfs "$seqres.rebuildrepair.md" "$device" "$2"
> 
> Why do we collect so many metadump images? Shouldn't all but the last
> TEST_XFS_REPAIR_REBUILD thing not modify the fs? If so, it seems like we
> should be able to collect one image (and perhaps just call it
> "$seqres.$device.md") if any of the first several checks flag a problem.

Yes, the number of metadumps collected can be reduced to two.  One if
scrub or logprint or repair -n fail, and a second one if the user set
TEST_XFS_REPAIR_REBUILD=1 and either the repair or the repair -n fail.

Will change that.

--D

> 
> Brian
> 
> >  			ok=0
> >  		fi
> >  		rm -f $tmp.repair
> > 
> 
