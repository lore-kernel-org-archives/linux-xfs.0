Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE5D1C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jan 2022 17:39:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344512AbiAKRj5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jan 2022 12:39:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49250 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344444AbiAKRj5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jan 2022 12:39:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76C38B81C18
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jan 2022 17:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C50DC36AF2;
        Tue, 11 Jan 2022 17:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641922795;
        bh=UI/65aC+uoU06TZfUyYU3DdtXYdNdf1LQFitp8PCLkU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hEVxcTa+IjD9mLquHmSlolfyVSXymsO5Mi9C9ctgmD/by7C27P6rejuBHASscqjqh
         /W/uiSXFUs+fvQDwdG5IAfC43bdi8uhKiUjMe+O1wuJPL/fYU8R+vaCYUq7YTzW3a/
         +fZ/Fi2wzXBLqadYDXskkV/Su/BJ7WbMuqGtSUECnKEg4A8c+YfPUKo6eJ5FC3fbbh
         99eNJk+tvgd6nvo6mPVdmqZ4TaU27OvUvM6FuIPGWJvATA2W667O1usvA60iXL6W41
         wPcXRPzd4R3VsIcjraOQrE1xr6djtkQQCEQVnkKbeNwVHUCXno8um5B+lNPO/begEQ
         8ZpqrGNOCrGpA==
Date:   Tue, 11 Jan 2022 09:39:54 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libxfs-apply: support filterdiff >= 0.4.2 only
Message-ID: <20220111173954.GB656707@magnolia>
References: <20210713235330.2591572-1-david@fromorbit.com>
 <a3ee5c0b-5507-395f-30f5-db3340b46e0d@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3ee5c0b-5507-395f-30f5-db3340b46e0d@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 10, 2022 at 07:30:26PM -0600, Eric Sandeen wrote:
> On 7/13/21 6:53 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We currently require filterdiff v0.3.4 as a minimum for handling git
> > based patches. This was the first version to handle git diff
> > metadata well enough to do patch reformatting. It was, however, very
> > buggy and required several workarounds to get it to do what we
> > needed.
> > 
> > However, these bugs have been fixed and on a machine with v0.4.2,
> > the workarounds result in libxfs-apply breaking and creating corrupt
> > patches. Rather than try to carry around workarounds for a broken
> > filterdiff version and one that just works, just increase the
> > minimum required version to 0.4.2 and remove all the workarounds for
> > the bugs in 0.3.4.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> I had missed this, sorry. I'm using it now, seems to work fine.
> 
> Darrick is still on the older version, so we probably need to come
> to agreement on requiring something newer.  Thanks for working through
> this!

/me built 0.4.2 for his local systems and drops his objections.  The
plan is to update to Ubuntu 2022 in May, but we'll see how much of
Ubuntu gets borg'd^Wsnapify'd in that timeframe.

--D

> -Eric
> 
> > ---
> >   tools/libxfs-apply | 42 +++++++++++++++++-------------------------
> >   1 file changed, 17 insertions(+), 25 deletions(-)
> > 
> > diff --git a/tools/libxfs-apply b/tools/libxfs-apply
> > index 9271db380198..097a695f942b 100755
> > --- a/tools/libxfs-apply
> > +++ b/tools/libxfs-apply
> > @@ -30,21 +30,22 @@ fail()
> >   	exit
> >   }
> > -# filterdiff 0.3.4 is the first version that handles git diff metadata (almost)
> > -# correctly. It just doesn't work properly in prior versions, so those versions
> > -# can't be used to extract the commit message prior to the diff. Hence just
> > -# abort and tell the user to upgrade if an old version is detected. We need to
> > +# filterdiff didn't start handling git diff metadata correctly until some time
> > +# after 0.3.4. The handling in 0.3.4 was buggy and broken, requiring working
> > +# around that bugs to use it. Now that 0.4.2 has fixed all those bugs, the
> > +# work-arounds for 0.3.4 do not work. Hence set 0.4.2 as the minimum required
> > +# version and tell the user to upgrade if an old version is detected. We need to
> >   # check against x.y.z version numbers here.
> >   _version=`filterdiff --version | cut -d " " -f 5`
> >   _major=`echo $_version | cut -d "." -f 1`
> >   _minor=`echo $_version | cut -d "." -f 2`
> >   _patch=`echo $_version | cut -d "." -f 3`
> >   if [ $_major -eq 0 ]; then
> > -	if [ $_minor -lt 3 ]; then
> > -		fail "filterdiff $_version found. 0.3.4 or greater is required."
> > +	if [ $_minor -lt 4 ]; then
> > +		fail "filterdiff $_version found. 0.4.2 or greater is required."
> >   	fi
> > -	if [ $_minor -eq 3 -a $_patch -le 3 ]; then
> > -		fail "filterdiff $_version found. 0.3.4 or greater is required."
> > +	if [ $_minor -eq 4 -a $_patch -lt 2 ]; then
> > +		fail "filterdiff $_version found. 0.4.2 or greater is required."
> >   	fi
> >   fi
> > @@ -158,8 +159,7 @@ filter_kernel_patch()
> >   			--addoldprefix=a/fs/xfs/ \
> >   			--addnewprefix=b/fs/xfs/ \
> >   			$_patch | \
> > -		sed -e 's, [ab]\/fs\/xfs\/\(\/dev\/null\), \1,' \
> > -		    -e '/^diff --git/d'
> > +		sed -e 's, [ab]\/fs\/xfs\/\(\/dev\/null\), \1,'
> >   	rm -f $_libxfs_files
> > @@ -187,8 +187,7 @@ filter_xfsprogs_patch()
> >   			--addoldprefix=a/ \
> >   			--addnewprefix=b/ \
> >   			$_patch | \
> > -		sed -e 's, [ab]\/\(\/dev\/null\), \1,' \
> > -		    -e '/^diff --git/d'
> > +		sed -e 's, [ab]\/\(\/dev\/null\), \1,'
> >   	rm -f $_libxfs_files
> >   }
> > @@ -209,30 +208,23 @@ fixup_header_format()
> >   	local _diff=`mktemp`
> >   	local _new_hdr=$_hdr.new
> > -	# there's a bug in filterdiff that leaves a line at the end of the
> > -	# header in the filtered git show output like:
> > -	#
> > -	# difflibxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > -	#
> > -	# split the header on that (convenient!)
> > -	sed -e /^difflib/q $_patch > $_hdr
> > +	# Split the header on the first ^diff --git line (convenient!)
> > +	sed -e /^diff/q $_patch > $_hdr
> >   	cat $_patch | awk '
> > -		BEGIN { difflib_seen = 0; index_seen = 0 }
> > -		/^difflib/ { difflib_seen++; next }
> > +		BEGIN { diff_seen = 0; index_seen = 0 }
> > +		/^diff/ { diff_seen++; next }
> >   		/^index/ { if (++index_seen == 1) { next } }
> > -		// { if (difflib_seen) { print $0 } }' > $_diff
> > +		// { if (diff_seen) { print $0 } }' > $_diff
> >   	# the header now has the format:
> >   	# commit 0d5a75e9e23ee39cd0d8a167393dcedb4f0f47b2
> >   	# Author: Eric Sandeen <sandeen@sandeen.net>
> >   	# Date:   Wed Jun 1 17:38:15 2016 +1000
> > -	#
> > +	#
> >   	#     xfs: make several functions static
> >   	#....
> >   	#     Signed-off-by: Dave Chinner <david@fromorbit.com>
> >   	#
> > -	#difflibxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > -	#
> >   	# We want to format it like a normal patch with a line to say what repo
> >   	# and commit it was sourced from:
> >   	#
