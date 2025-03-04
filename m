Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5432E3375;
	Tue,  4 Mar 2025 18:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741112473; cv=none; b=MreK34GXC4o68zAgCZvqzXQyox5P45bkZ0rK27eh6hqIiv/5lIrUTNFRPXLC6vhnqus9hdXaC2P/IXJv3QZnWJFMQv5hMMf7RZdNEPyhMKW+JZohZoAeiwoVXJw1myI+Me+UZ+yS+mileAvWaXk0Q3VpRs5EyMHpq2VoSQM9mBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741112473; c=relaxed/simple;
	bh=VTQFXOYllTlcr9vYSd2P7Rl0RRizMkZACCi/GABP9Uo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YrIJao1rvcyhD0eshUC3bS+DwnqHSiqvDd6/PzZ+OY0IxFTmH0P2Q92HdXCQeNDt0wiL4y3w1qyj+hEz8oaDJS2TMNSxlI8O5AaeHBx+5PEfDkYGb1RtULrAzFPPUOjoDeZ1vS7NL1ZV988S4hj0p1+8JCyakmsiiMvXtR7fP+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cJg1OTFl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cJg1OTFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24E6C4CEE5;
	Tue,  4 Mar 2025 18:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741112472;
	bh=VTQFXOYllTlcr9vYSd2P7Rl0RRizMkZACCi/GABP9Uo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cJg1OTFl0CBCYyFUzo/omTa3VgDUAhaHJ6H9xTSA10LF1vgqP7yax9V5m9DvFalbG
	 L75z40uZGOsJuWI1kqxfnK7kDLNyJLyCqyU8trOMd7xbfW9+CbEVXqzYmKlvhmTIky
	 Ywn++G4DYiFgHUikdCRWqmDFVybWDb/YiCb/Xul+KcD+Q/eMqgyV1UzHpdptg2gdO3
	 phmukZIm9Xgbcoynqeja/V2BNzIv6qb+WcM5DDeG/YfxDc1ZoXiKvmCYGwqr6pLHtM
	 jxn425ztKbEhNJugz0EZhwVKwv4FxxlOF8JJOmK1y4y8GHgKhmGhlicPr2QcsdefjB
	 p5/iFrtK3LlLQ==
Date: Tue, 4 Mar 2025 10:21:12 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: Zorro Lang <zlang@kernel.org>, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] fstests: test mkfs.xfs protofiles with xattr support
Message-ID: <20250304182112.GB2803740@frogsfrogsfrogs>
References: <173706975660.1928701.8344148155038133836.stgit@frogsfrogsfrogs>
 <173706975673.1928701.14882814105946770615.stgit@frogsfrogsfrogs>
 <20250302131544.5om3lil64kw5nnyo@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20250304174242.GA2803749@frogsfrogsfrogs>
 <20250304180040.7yoddqyciqajw47d@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250304180040.7yoddqyciqajw47d@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Wed, Mar 05, 2025 at 02:00:40AM +0800, Zorro Lang wrote:
> On Tue, Mar 04, 2025 at 09:42:42AM -0800, Darrick J. Wong wrote:
> > On Sun, Mar 02, 2025 at 09:15:44PM +0800, Zorro Lang wrote:
> > > On Thu, Jan 16, 2025 at 03:35:04PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Make sure we can do protofiles with xattr support.
> > > > 
> > > > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > > > ---
> > > 
> > > This test always fails on my side, as below (diff output):
> > > 
> > >    ...
> > >    Attribute "rootdata" has a 5 byte value for SCRATCH_MNT/directory/test
> > >    Attribute "bigdata" has a 37960 byte value for SCRATCH_MNT/directory/test
> > >    Attribute "acldata" has a 5 byte value for SCRATCH_MNT/directory/test
> > >   +Attribute "selinux" has a 28 byte value for SCRATCH_MNT/directory/test
> > >    *** unmount FS
> > >    *** done
> > >    *** unmount
> > > 
> > > Looks like the $SELINUX_MOUNT_OPTIONS doesn't help the mkfs protofile
> > > with xattrs.
> > 
> > Oops.  Ok then, I'll filter them out below...
> > 
> > > Thanks,
> > > Zorro
> > > 
> > > 
> > > >  tests/xfs/1937     |  144 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  tests/xfs/1937.out |  102 +++++++++++++++++++++++++++++++++++++
> > > >  2 files changed, 246 insertions(+)
> > > >  create mode 100755 tests/xfs/1937
> > > >  create mode 100644 tests/xfs/1937.out
> > > >
>  
> [snip]
> 
> > > > +	echo "*** verify FS"
> > > > +	(cd $SCRATCH_MNT ; find . | LC_COLLATE=POSIX sort \
> > > > +		| grep -v ".use_space" \
> > > > +		| xargs $here/src/lstat64 | _filter_stat)
> > > > +	diff -q $SCRATCH_MNT/bigfile $tempfile.2 \
> > > > +		|| _fail "bigfile corrupted"
> > > > +	diff -q $SCRATCH_MNT/symlink $tempfile.2 \
> > > > +		|| _fail "symlink broken"
> > > > +
> > > > +	$ATTR_PROG -l $SCRATCH_MNT/directory/test | _filter_scratch
> > 
> > ...so they don't spill into the golden output.  As this is already in
> > patches-in-queue, do you want me to send a fixpatch on top of that?
> 
> If you just need a simple filter, I think you can tell me what do you
> want to change, I can amend the commit simply. Or if you need to change
> more, only re-send this patch is good to me :)

I /think/ changing the above line to this will fix it:

	$ATTR_PROG -l $SCRATCH_MNT/directory/test | \
		sed -e '/Attribute..selinux..has/d' | \
		_filter_scratch

--D

> Thanks,
> Zorro
> 
> > 
> > --D
> > 
> > > > +
> > > > +	echo "*** unmount FS"
> > > > +	_full "umount"
> > > > +	_scratch_unmount >>$seqfull 2>&1 \
> > > > +		|| _fail "umount failed"
> > > > +}
> > > > +
> > > > +_verify_fs 2
> > > > +
> > > > +echo "*** done"
> > > > +status=0
> > > > +exit
> > > > diff --git a/tests/xfs/1937.out b/tests/xfs/1937.out
> > > > new file mode 100644
> > > > index 00000000000000..050c8318b1abca
> > > > --- /dev/null
> > > > +++ b/tests/xfs/1937.out
> > > > @@ -0,0 +1,102 @@
> > > > +QA output created by 1937
> > > > +Wrote 2048.00Kb (value 0x2c)
> > > > +*** create FS version 2
> > > > +*** check FS
> > > > +*** mount FS
> > > > +*** verify FS
> > > > + File: "."
> > > > + Size: <DSIZE> Filetype: Directory
> > > > + Mode: (0777/drwxrwxrwx) Uid: (3) Gid: (1)
> > > > +Device: <DEVICE> Inode: <INODE> Links: 4 
> > > > +
> > > > + File: "./bigfile"
> > > > + Size: 2097152 Filetype: Regular File
> > > > + Mode: (0666/-rw-rw-rw-) Uid: (3) Gid: (0)
> > > > +Device: <DEVICE> Inode: <INODE> Links: 1 
> > > > +
> > > > + File: "./block_device"
> > > > + Size: 0 Filetype: Block Device
> > > > + Mode: (0012/b-----x-w-) Uid: (3) Gid: (1)
> > > > +Device: <DEVICE> Inode: <INODE> Links: 1 Device type: 161,162
> > > > +
> > > > + File: "./char_device"
> > > > + Size: 0 Filetype: Character Device
> > > > + Mode: (0345/c-wxr--r-x) Uid: (3) Gid: (1)
> > > > +Device: <DEVICE> Inode: <INODE> Links: 1 Device type: 177,178
> > > > +
> > > > + File: "./directory"
> > > > + Size: <DSIZE> Filetype: Directory
> > > > + Mode: (0755/drwxr-xr-x) Uid: (3) Gid: (1)
> > > > +Device: <DEVICE> Inode: <INODE> Links: 2 
> > > > +
> > > > + File: "./directory/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_0"
> > > > + Size: 1348680 Filetype: Regular File
> > > > + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
> > > > +Device: <DEVICE> Inode: <INODE> Links: 1 
> > > > +
> > > > + File: "./directory/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_1"
> > > > + Size: 1348680 Filetype: Regular File
> > > > + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
> > > > +Device: <DEVICE> Inode: <INODE> Links: 1 
> > > > +
> > > > + File: "./directory/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_2"
> > > > + Size: 1348680 Filetype: Regular File
> > > > + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
> > > > +Device: <DEVICE> Inode: <INODE> Links: 1 
> > > > +
> > > > + File: "./directory/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_3"
> > > > + Size: 1348680 Filetype: Regular File
> > > > + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
> > > > +Device: <DEVICE> Inode: <INODE> Links: 1 
> > > > +
> > > > + File: "./directory/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_4"
> > > > + Size: 1348680 Filetype: Regular File
> > > > + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
> > > > +Device: <DEVICE> Inode: <INODE> Links: 1 
> > > > +
> > > > + File: "./directory/test"
> > > > + Size: 1348680 Filetype: Regular File
> > > > + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
> > > > +Device: <DEVICE> Inode: <INODE> Links: 1 
> > > > +
> > > > + File: "./directory_setgid"
> > > > + Size: <DSIZE> Filetype: Directory
> > > > + Mode: (2755/drwxr-sr-x) Uid: (3) Gid: (2)
> > > > +Device: <DEVICE> Inode: <INODE> Links: 2 
> > > > +
> > > > + File: "./directory_setgid/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_5"
> > > > + Size: 1348680 Filetype: Regular File
> > > > + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
> > > > +Device: <DEVICE> Inode: <INODE> Links: 1 
> > > > +
> > > > + File: "./pipe"
> > > > + Size: 0 Filetype: Fifo File
> > > > + Mode: (0670/frw-rwx---) Uid: (0) Gid: (0)
> > > > +Device: <DEVICE> Inode: <INODE> Links: 1 
> > > > +
> > > > + File: "./setgid"
> > > > + Size: 1348680 Filetype: Regular File
> > > > + Mode: (2666/-rw-rwsrw-) Uid: (0) Gid: (0)
> > > > +Device: <DEVICE> Inode: <INODE> Links: 1 
> > > > +
> > > > + File: "./setugid"
> > > > + Size: 1348680 Filetype: Regular File
> > > > + Mode: (6666/-rwsrwsrw-) Uid: (0) Gid: (0)
> > > > +Device: <DEVICE> Inode: <INODE> Links: 1 
> > > > +
> > > > + File: "./setuid"
> > > > + Size: 1348680 Filetype: Regular File
> > > > + Mode: (4666/-rwsrw-rw-) Uid: (0) Gid: (0)
> > > > +Device: <DEVICE> Inode: <INODE> Links: 1 
> > > > +
> > > > + File: "./symlink"
> > > > + Size: 7 Filetype: Symbolic Link
> > > > + Mode: (0123/l--x-w--wx) Uid: (0) Gid: (0)
> > > > +Device: <DEVICE> Inode: <INODE> Links: 1 
> > > > +Attribute "userdata" has a 5 byte value for SCRATCH_MNT/directory/test
> > > > +Attribute "rootdata" has a 5 byte value for SCRATCH_MNT/directory/test
> > > > +Attribute "bigdata" has a 37960 byte value for SCRATCH_MNT/directory/test
> > > > +Attribute "acldata" has a 5 byte value for SCRATCH_MNT/directory/test
> > > > +*** unmount FS
> > > > +*** done
> > > > +*** unmount
> > > > 
> > > 
> > 
> 
> 
