Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D2CDDAB;
	Tue, 25 Mar 2025 00:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742863920; cv=none; b=XrBvDs69icvan+kyHyDELfPEa6VFG1CQzc5DwvGqkokwqV3/bchUaXzkOSGTgR/pCAVFNAJa2ZEWlcKfUC3cQJ2zqm3vHTrFByQWHFp88hzjuR7/TxyafGh25txXweVwhrtuO3XqkROKJ7+z/fKXYql+HgRidM97/GbpRpzPNg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742863920; c=relaxed/simple;
	bh=dX70UKDTDe1rTNgsiP+mPLOzFIKFggL7PkBvVrQvfxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LiFKtSirOqqaY27VjwZ1uqyVz063dWEmyrDj/mvtZiUrG9Ve0uxr3P6h1ycE9XvAM81DQMkT26Zq6Vjqa2QC7ykN5oFhjmY6UzNsn6R+5LiUzKpvSXq0UIJdVGEaICVVWZ27C6xGhT0WxHZtc62YnP/QE6hXnRxwkGVKtloakZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QMD7igOD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QMD7igOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000E7C4CEDD;
	Tue, 25 Mar 2025 00:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742863919;
	bh=dX70UKDTDe1rTNgsiP+mPLOzFIKFggL7PkBvVrQvfxQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QMD7igODEE0obisQgcB9Wh2oY3IE47+U+jFAn4RzubhnFRRNOC4dLBdsHVGWu7xlU
	 4nPlzAmsF0Q2y7rWUDhYOg3AkoP2lQrSYaVy+1vDSy83Cuvo15JEgncLBBQRUefabC
	 R8b5QevXAf6gvw0npgGDF5UlsmCVGj4RICMp5nEUJLHdQEPp6KiGlXPgkf9WjQW53t
	 UsYMdtPJoiY374Pum66phrvboEbfOGomaadpO/LVviMAaV84e4tG1pyP8cIMaI9HMG
	 hLDyXn1xYmpoDbbmHfeZ6IevT5lIaL4XqAWham+nHDYTXzs181YTgY9cChaf53MXhq
	 kCQrIeI3PAyJA==
Date: Mon, 24 Mar 2025 17:51:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/4] generic/537: disable quota mount options for
 pre-metadir rt filesystems
Message-ID: <20250325005158.GJ4001511@frogsfrogsfrogs>
References: <174259233946.743619.993544237516250761.stgit@frogsfrogsfrogs>
 <174259233999.743619.6582695769493412159.stgit@frogsfrogsfrogs>
 <20250322143754.4fe7rges6whcz47u@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250322143754.4fe7rges6whcz47u@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Sat, Mar 22, 2025 at 10:37:54PM +0800, Zorro Lang wrote:
> On Fri, Mar 21, 2025 at 02:27:54PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Fix this regression in generic/537:
> > 
> > mount: /opt: permission denied.
> >        dmesg(1) may have more information after failed mount system call.
> > mount -o uquota,gquota,pquota, -o ro,norecovery -ortdev=/dev/sdb4 /dev/sda4 /opt failed
> > mount -o uquota,gquota,pquota, -o ro,norecovery -ortdev=/dev/sdb4 /dev/sda4 /opt failed
> > (see /var/tmp/fstests/generic/537.full for details)
> > 
> > for reasons explained in the giant comment.  TLDR: quota and rt aren't
> > compatible on older xfs filesystems so we have to work around that.
> > 
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  tests/generic/537 |   17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> > 
> > 
> > diff --git a/tests/generic/537 b/tests/generic/537
> > index f57bc1561dd57e..3be743c4133f4f 100755
> > --- a/tests/generic/537
> > +++ b/tests/generic/537
> > @@ -18,6 +18,7 @@ _begin_fstest auto quick trim
> >  
> >  # Import common functions.
> >  . ./common/filter
> > +. ./common/quota
> >  
> >  _require_scratch
> >  _require_fstrim
> > @@ -36,6 +37,22 @@ _scratch_mount -o ro >> $seqres.full 2>&1
> >  $FSTRIM_PROG -v $SCRATCH_MNT >> $seqres.full 2>&1
> >  _scratch_unmount
> >  
> > +# As of kernel commit 9f0902091c332b ("xfs: Do not allow norecovery mount with
> > +# quotacheck"), it is no longer possible to mount with "norecovery" and any
> > +# quota mount option if the quota mount options would require a metadata update
> > +# such as quotacheck.  For a pre-metadir XFS filesystem with a realtime volume
> > +# and quota-enabling options, the first two mount attempts will have succeeded
> > +# but with quotas disabled.  The mount option parsing for this next mount
> > +# attempt will see the same quota-enabling options and a lack of qflags in the
> > +# ondisk metadata and reject the mount because it thinks that will require
> > +# quotacheck.  Edit out the quota mount options for this specific
> > +# configuration.
> > +if [ "$FSTYP" = "xfs" ]; then
> > +	if [ "$USE_EXTERNAL" = "yes" ] && [ -n "$SCRATCH_RTDEV" ]; then
> > +		_qmount_option ""
> > +	fi
> > +fi
> 
> I don't know if there's a better way, maybe a _require_no_quota, or _disable_qmount?

_require_no_quota would decrease test coverage.

There is no such helper as _disable_qmount...?

> Anyway, for this single case, it's fine for me.
> 
> Reviewed-by: Zorro Lang <zlang@redhat.com>

Thanks!

--D

> > +
> >  echo "fstrim on ro mount with no log replay"
> >  norecovery="norecovery"
> >  test $FSTYP = "btrfs" && norecovery=nologreplay
> > 
> 
> 
