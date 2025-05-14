Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3539218787A;
	Wed, 14 May 2025 15:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747237240; cv=none; b=Nx1U4jpq7WS5Zt0G+/SUsIw+4Dug0rOp1jbNvc59YWDISeoQYLOCc/t8oeIza9E//oXP7SQ4N1GRlWSi7KhjeRtoffJjLwirc/IQUqrKEjoa78Hgq1xx3bQaqV7qEC0QRW5UYuA9GxPPqi4MLuLbf8Loco6YVW+Eja6SX8ZOKCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747237240; c=relaxed/simple;
	bh=SBmYWFaWQ2385KrvjNJQTouDKV9XJOjvjwxmBdpRRKk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GDlkCRBSf3dWLvDApHrVgwBtG4XtsGBmz7Z4pwTVfmgxfdziahoNvqNOJ/Yxibt7dLRMXMhgBtVlzARoNpHFAYEMnfwCJQca0MiCEyAR55w43MwPW2fguzwnNawgU7GEUhs1ExZZun8seUl9pjFlA++RryaIpCyredxyT+26G4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nOOMOfTM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nOOMOfTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77B1C4CEE3;
	Wed, 14 May 2025 15:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747237239;
	bh=SBmYWFaWQ2385KrvjNJQTouDKV9XJOjvjwxmBdpRRKk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nOOMOfTMvfQ5+fyrNXOp1aGLZnf30g7co9WiVTV0KRFbhDlJXEtZZrLba/PcU8eSW
	 zNyCGj0GpNcMnhJ7b/S/rMzCKlTjCoLi33RgSxPMHzW5CFE2VqZInmd0ti5jJC/rzt
	 I73KS1LZpbrhYK+0AncViAkx004OKNTsYzClLmW1DBF1t5QltTMKUBLXpcVi5bzcKP
	 wTF+DPSOS2hMgS1mYw3fu79fnYOk8exH8oDs93IUD8Ch/HZ5Ig++h7PqR6VdQO+w39
	 Y83IVQk50qv+r5rvi+irmAklAyzvFgK8dnlgpMCoFsFe1aO+y6piRWk9+0yGunQCRO
	 50soVWtH4ZDZQ==
Date: Wed, 14 May 2025 08:40:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 4/6] common/atomicwrites: adjust a few more things
Message-ID: <20250514154039.GV25667@frogsfrogsfrogs>
References: <20250514002915.13794-1-catherine.hoang@oracle.com>
 <20250514002915.13794-5-catherine.hoang@oracle.com>
 <73af7165-630b-469d-965e-a50c381298cb@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73af7165-630b-469d-965e-a50c381298cb@oracle.com>

On Wed, May 14, 2025 at 02:11:00PM +0100, John Garry wrote:
> On 14/05/2025 01:29, Catherine Hoang wrote:
> > From: "Darrick J. Wong"<djwong@kernel.org>
> > 
> > Always export STATX_WRITE_ATOMIC so anyone can use it, make the "cp
> > reflink" logic work for any filesystem, not just xfs, and create a
> > separate helper to check that the necessary xfs_io support is present.
> > 
> > Signed-off-by: "Darrick J. Wong"<djwong@kernel.org>
> > Signed-off-by: Catherine Hoang<catherine.hoang@oracle.com>
> 
> Just a small comment query below.
> 
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> 
> > ---
> >   common/atomicwrites | 18 +++++++++++-------
> >   tests/generic/765   |  2 +-
> >   2 files changed, 12 insertions(+), 8 deletions(-)
> > 
> > diff --git a/common/atomicwrites b/common/atomicwrites
> > index fd3a9b71..9ec1ca68 100644
> > --- a/common/atomicwrites
> > +++ b/common/atomicwrites
> > @@ -4,6 +4,8 @@
> >   #
> >   # Routines for testing atomic writes.
> > +export STATX_WRITE_ATOMIC=0x10000
> > +
> >   _get_atomic_write_unit_min()
> >   {
> >   	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
> > @@ -26,8 +28,6 @@ _require_scratch_write_atomic()
> >   {
> >   	_require_scratch
> > -	export STATX_WRITE_ATOMIC=0x10000
> > -
> >   	awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
> >   	awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
> > @@ -51,6 +51,14 @@ _require_scratch_write_atomic()
> >   	fi
> >   }
> > +# Check for xfs_io commands required to run _test_atomic_file_writes
> > +_require_atomic_write_test_commands()
> > +{
> > +	_require_xfs_io_command "falloc"
> > +	_require_xfs_io_command "fpunch"
> > +	_require_xfs_io_command pwrite -A
> > +}
> > +
> >   _test_atomic_file_writes()
> >   {
> >       local bsize="$1"
> > @@ -64,11 +72,7 @@ _test_atomic_file_writes()
> >       test $bytes_written -eq $bsize || echo "atomic write len=$bsize failed"
> >       # Check that we can perform an atomic single-block cow write
> > -    if [ "$FSTYP" == "xfs" ]; then
> > -        testfile_cp=$SCRATCH_MNT/testfile_copy
> > -        if _xfs_has_feature $SCRATCH_MNT reflink; then
> > -            cp --reflink $testfile $testfile_cp
> > -        fi
> > +    if cp --reflink=always $testfile $testfile_cp 2>> $seqres.full; then
> 
> I suppose that previously for xfs where the cp --reflink failed, we would
> pointlessly try the write - am I correct?

Correct.

> If so, now seems much better.

That and any filesystem that supports reflink and atomic writes will now
test this. :)

Thanks for review!

--D

> >           bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile_cp | \
> 
> 
