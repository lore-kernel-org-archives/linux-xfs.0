Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FEC13B58F;
	Sat,  9 Nov 2024 16:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731169170; cv=none; b=MdTYCs8xwxBeXR1D67WlcUIDluMmXVWM3sGf9Ohh++yAV47XgkMSwl/AMcAf/a+qPq1TpWWT0WXL93fEuM7YxTbF2frf2TPJ8YNKQhmrpupJMzr0Cg/gktFhDhr9Udm4QzI1OLAUNavRs+6JUlJJboG1/tttwY9AfPXymplOF00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731169170; c=relaxed/simple;
	bh=OmQbHN8SUBS17RgtQKYC9IfdEKn5BJlFxbGXB4lrFPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KjA9XIR8786A8h8QhRCaQTRwJTmAYK3svBuUFSZx3iMB/++zDft0NLeUbbD8SV9/3pE4mZz5ycgjavqdn03PQAzfts5WroTmR3CuInkOE03xIGV+QAJGd/tbtBe4cG9BvQ9OsR2WIuXUptzfdgAraKErvnYxawN6Ibrn1gt8hB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OmR0jT/f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OmR0jT/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774EEC4CECE;
	Sat,  9 Nov 2024 16:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731169169;
	bh=OmQbHN8SUBS17RgtQKYC9IfdEKn5BJlFxbGXB4lrFPg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OmR0jT/fKNLpcKg2upR8exOTxnIadEFEcPZHBFSEYgGESP9LmH3an9JAJrJmXVyNI
	 lTD/tT/2O+wMayUI+9LOJZrvtOODTRdedD/asleWI4Mb6eDwtkbgGMNi4hz5StjZJR
	 TwAavgBKKZ9Dn0s7PXHN1WveqJpUzvdE1fXtfcpeqLeO8lNMDaB1P8gccI+Su0pbjD
	 U6ZKKtA3oZde90d6i/bXY9fAXZb2TPy/2IovZsq57iySl5PUnVSiodSg0KWBp90oCk
	 7vHNkihWG3BOCS5V1z4GSLDsI23eovKuohVjNlCp+AAHdBlCO6rclC5IYmQHGgIoy9
	 UGDJ7oooOq5FA==
Date: Sat, 9 Nov 2024 08:19:28 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: Zizhi Wo <wozizhi@huawei.com>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>, fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH] xfs/273: check thoroughness of the fsmappings
Message-ID: <20241109161928.GA9462@frogsfrogsfrogs>
References: <20241108173907.GB168069@frogsfrogsfrogs>
 <20241108174146.GA168062@frogsfrogsfrogs>
 <20241109144516.irgjz2zllkpkqsqz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241109144516.irgjz2zllkpkqsqz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Sat, Nov 09, 2024 at 10:45:16PM +0800, Zorro Lang wrote:
> On Fri, Nov 08, 2024 at 09:41:46AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Enhance this test to make sure that there are no gaps in the fsmap
> > records, and (especially) that they we report all the way to the end of
> > the device.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/273 |   47 +++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 47 insertions(+)
> > 
> > diff --git a/tests/xfs/273 b/tests/xfs/273
> > index d7fb80c4033429..ecfe5e7760a092 100755
> > --- a/tests/xfs/273
> > +++ b/tests/xfs/273
> > @@ -24,6 +24,8 @@ _require_scratch
> >  _require_populate_commands
> >  _require_xfs_io_command "fsmap"
> >  
> > +_fixed_by_git_commit kernel XXXXXXXXXXXXXX "xfs: fix off-by-one error in fsmap's end_daddr usage"
> 
> The _fixed_by_kernel_commit can replace the "_fixed_by_git_commit kernel".

<nod>

> > +
> >  rm -f "$seqres.full"
> >  
> >  echo "Format and mount"
> > @@ -37,6 +39,51 @@ cat $TEST_DIR/a $TEST_DIR/b >> $seqres.full
> >  
> >  diff -uw $TEST_DIR/a $TEST_DIR/b
> >  
> > +# Do we have mappings for every sector on the device?
> > +ddev_fsblocks=$(_xfs_statfs_field "$SCRATCH_MNT" geom.datablocks)
> > +rtdev_fsblocks=$(_xfs_statfs_field "$SCRATCH_MNT" geom.rtblocks)
> > +fsblock_bytes=$(_xfs_statfs_field "$SCRATCH_MNT" geom.bsize)
> > +
> > +ddev_daddrs=$((ddev_fsblocks * fsblock_bytes / 512))
> > +rtdev_daddrs=$((rtdev_fsblocks * fsblock_bytes / 512))
> > +
> > +ddev_devno=$(stat -c '%t:%T' $SCRATCH_DEV)
> > +if [ "$USE_EXTERNAL" = "yes" ] && [ -n "$SCRATCH_RTDEV" ]; then
> > +	rtdev_devno=$(stat -c '%t:%T' $SCRATCH_RTDEV)
> > +fi
> > +
> > +$XFS_IO_PROG -c 'fsmap -m -n 65536' $SCRATCH_MNT | awk -F ',' \
> > +	-v data_devno=$ddev_devno \
> > +	-v rt_devno=$rtdev_devno \
> > +	-v data_daddrs=$ddev_daddrs \
> > +	-v rt_daddrs=$rtdev_daddrs \
> > +'BEGIN {
> > +	next_daddr[data_devno] = 0;
> > +	next_daddr[rt_devno] = 0;
> > +}
> > +{
> > +	if ($1 == "EXT")
> > +		next
> > +	devno = sprintf("%x:%x", $2, $3);
> > +	if (devno != data_devno && devno != rt_devno)
> > +		next
> > +
> > +	if (next_daddr[devno] < $4)
> > +		printf("%sh: expected daddr %d, saw \"%s\"\n", devno,
> > +				next_daddr[devno], $0);
> > +		next = $5 + 1;
> 
> Ahaha, awk expert Darrick :) I tried this patch, but got below error when
> I tried this patch:
> 
>   +awk: cmd. line:15:             next = $5 + 1;
>   +awk: cmd. line:15:                  ^ syntax error

Aha, I forgot to commit the change renaming next to n before sending. :(

--D

> Thanks,
> Zorro
> 
> > +		if (next > next_daddr[devno])
> > +		       next_daddr[devno] = next;
> > +}
> > +END {
> > +	if (data_daddrs != next_daddr[data_devno])
> > +		printf("%sh: fsmap stops at %d, expected %d\n",
> > +				data_devno, next_daddr[data_devno], data_daddrs);
> > +	if (rt_devno != "" && rt_daddrs != next_daddr[rt_devno])
> > +		printf("%sh: fsmap stops at %d, expected %d\n",
> > +				rt_devno, next_daddr[rt_devno], rt_daddrs);
> > +}'
> > +
> >  # success, all done
> >  status=0
> >  exit
> > 
> 
