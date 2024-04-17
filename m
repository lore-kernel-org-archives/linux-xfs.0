Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E7B4685;
	Wed, 17 Apr 2024 01:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713318667; cv=none; b=jRG+2baEqZMIUAI7TQbs8mXxSAu9QnRXVGDxurDe6OaazwaCt9RXQp4ayplkASY8HolCCRfmh3v6alQnPFNaxBCiAKRN81752gpKs+Xt9kZO7sBiiqTF5sxOiBNmG5FtEcd2caFLRCIc83suwbo2g6hvjgKsi55Qu6BBdP1fEdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713318667; c=relaxed/simple;
	bh=neUdLTCreotu8dYTcp4RYK0p19x1VtMe8OCr96oT4fI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eWKzZsuabo+riUzle8APyED23denbb3pxgCtRcbvCa2DSjZ9xO2Xi0tKpWZdQglIxqSz5yR/SfNAtjYgLi9wLV10vELnrBk4z8RfV36Sydgg5HyUoB+2Rgtlx1sjztEUMohxOKR5BXNw0ueVeW/Qo8oVTNusRiIC6YJC/ybtdVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AehWTqFH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AehWTqFH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cGpC/M1kNENHhDjd0PzxgPuqcyCo/7+JobXGUjFbx7A=; b=AehWTqFHI5PCIr20bMkXEaDJXD
	g2nLfJv39ksGFXIMxX2QjjCqwXjF4ukjWgUbdHMps2ZCxzFL2zT40Usw81/xLeYWBHLT/G3WPrp67
	kHcoNEoX2NsaYQvwLitZXf4eJrnAAw8sV8Yt8lVUBgEXAHW/o4p/X15F2Sudu18hikXTYTzHU4h5O
	4Y4VciJyVKFEoBv8gJTKgRNAHhmABTES1BRu/kjQUXFqWcf1IkO9bpm3oSXzsfbaKTTThCqC7Esv4
	NL0KAld9b/2olqTNkMBA4KPI624w2mA3jsv1WOXVd2a/UNWrLjWHjQn4svdOtnSlBS/p4OdNKPGpo
	M7XhmqnQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwuS1-0000000EPYA-0mJm;
	Wed, 17 Apr 2024 01:51:05 +0000
Date: Tue, 16 Apr 2024 18:51:05 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: kdevops@lists.linux.dev, linux-xfs@vger.kernel.org
Subject: Re: [PATCH kdevops] xfs: add xfs/242 as failing on xfs_reflink_2k
Message-ID: <Zh8rCZwltAm3SGNx@bombadil.infradead.org>
References: <20240416235108.3391394-1-mcgrof@kernel.org>
 <20240417003755.GK11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417003755.GK11948@frogsfrogsfrogs>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Tue, Apr 16, 2024 at 05:37:55PM -0700, Darrick J. Wong wrote:
> On Tue, Apr 16, 2024 at 04:51:08PM -0700, Luis Chamberlain wrote:
> > This test is rather simple, and somehow we managed to capture a
> > non-crash failure. The test was added to fstests via fstests commit
> > 0c95fadc35c8e450 ("expand 252 with more corner case tests") which
> > essentially does this:
> > 
> > +       $XFS_IO_PROG $xfs_io_opt -f -c "truncate $block_size" \
> > +               -c "pwrite 0 $block_size" $sync_cmd \
> > +               -c "$zero_cmd 128 128" \
> > +               -c "$map_cmd -v" $testfile | $filter_cmd
> > 
> > The map_cmd in this case is: 'bmap -p'. So the test does:
> > 
> > a) truncates data to the block size
> > b) sync
> > c) zero-fills the the blocksize
> 
> Which subtest is this?

It's the:

17. data -> hole in single block file

> I've seen periodic failures in xfs/242 that I can't reproduce either:

Oh good to hear.

> --- /tmp/fstests/tests/xfs/242.out	2024-02-28 16:20:24.448887914 -0800
> +++ /var/tmp/fstests/xfs/242.out.bad	2024-04-15 17:36:46.736000000 -0700
> @@ -6,8 +6,7 @@ QA output created by 242
>  1aca77e2188f52a62674fe8a873bdaba
>  	2. into allocated space
>  0: [0..127]: data
> -1: [128..383]: unwritten
> -2: [384..639]: data
> +1: [128..639]: unwritten
>  2f7a72b9ca9923b610514a11a45a80c9
>  	3. into unwritten space
>  0: [0..639]: unwritten

Oh curious, you hit #2 while I saw #17.

VM or bare metal? If VM, real drive or sparse files? Mine guest files
are virtio drives on files placed on the host on an XFS partition, the
guest uses btrfs truncated files for the sparse files and loopback
devices.

ie: TEST_DEV=/dev/loop16

kdevops@base-xfs-reflink-2k ~ $ sudo losetup -a| grep loop16
/dev/loop16: [0038]:268 (/media/sparsefiles/sparse-disk16)

kdevops@base-xfs-reflink-2k ~ $ df -h /media/sparsefiles/sparse-disk16
Filesystem      Size  Used Avail Use% Mounted on
/dev/vdc        100G  408M   96G   1% /media/sparsefiles

kdevops@base-xfs-reflink-2k ~ $ du -hs /media/sparsefiles/sparse-disk16
70M     /media/sparsefiles/sparse-disk16

kdevops@base-xfs-reflink-2k ~ $ mount | grep -E "sparse|loop16"
/dev/vdc on /media/sparsefiles type btrfs (rw,relatime,discard=async,noacl,space_cache=v2,subvolid=5,subvol=/)
/dev/loop16 on /media/test type xfs (rw,relatime,attr2,inode64,logbufs=8,logbsize=32k,noquota)

> It's very strange to me that the block map changes but the md5 doesn't?

Great point! How is that possible?

> The pwrite should have written 0xcd into the file and then the space
> between 64k and 192K got replaced with an unwritten extent.  But
> everything between 192K and 320K should still be written data.

  Luis
