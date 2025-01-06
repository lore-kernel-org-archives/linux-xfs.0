Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D13E1DF985
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 19:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736192800; cv=none; b=Fnby9U3rGs2w9S2+2PGgPSDyNaoKoR2SfdowP2JCNvOKAJIFCruk5Icer3rbzonGehbA0sP6sgHwTsOGVRog715SH74bobYlmwBX6vb5+LBNi9rD0lPFX0bhwH6Ws5vdAw2VhqjU01oHfSuGtlTFYsn6VAXp0Q4qhePF/+hysdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736192800; c=relaxed/simple;
	bh=BfPO5xFgccA3GwAqzXPAtM86zAJUVaxxWGXIhEZzVEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o2SRYI41ZP/wsS1Nt7gUUA8Rt2FBNXVdsuWkTWyeJL6PBIKHmROHTKtyjy4VxFh/UCYT0lfe0qE/4WFOuzKwGpXhvoIwfSke3/GWLHOm/FoY92NHjChvGk1qQXqSaLpgDqkbghmFUQH8qbu7G8DPxxDuWEfgaxnBpjy3s0wgRu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZA5/396N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZA5/396N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB4DC4CED2;
	Mon,  6 Jan 2025 19:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736192799;
	bh=BfPO5xFgccA3GwAqzXPAtM86zAJUVaxxWGXIhEZzVEQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZA5/396NR3nbT0BZCrgYNm7fYu7TLLpoV7xxNXtLWfxa3aYuGkj7jrs5Kb+Gkdaqw
	 xymMHw75b3jXtnWD2/D5Bb/XJ+17IbByP2JG15P2hf2X4fJRsibyDcBBy+oJvhbIhe
	 /gSuRzxaitzQs5ldfFeTRFhNUZtlN1gjeRLIlflmS7R4V/qHq2tbuLd2AaNTh47DF0
	 q1ihA+f1AaIMr002ruvNrJyArtkfOrkicUaZVYR5gkr0n+3v2lXo2DuJ3ptpb4Gjj/
	 ZUeIV8phzh/rbFsg4kBJJpVKHP000dlTPr1t8XrSXmznq4afb1LaY8zEKj80neLyw2
	 As4AVV7ggR+Uw==
Date: Mon, 6 Jan 2025 11:46:39 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Sai Chaitanya Mitta <mittachaitu@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Approach to quickly zeroing large XFS file (or) tool to mark XFS
 file extents as written
Message-ID: <20250106194639.GH6174@frogsfrogsfrogs>
References: <CAN=PFfLfRFE9g_9UveWmAuc5_Pp_ihmc7x_po0e6=sTt2dynBQ@mail.gmail.com>
 <20241223215317.GR6174@frogsfrogsfrogs>
 <CAN=PFfKDd=Y=14re01hY970JJNG7QCKUb6NOiZisQ0WWNmhcsw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAN=PFfKDd=Y=14re01hY970JJNG7QCKUb6NOiZisQ0WWNmhcsw@mail.gmail.com>

On Tue, Dec 24, 2024 at 11:17:08AM +0530, Sai Chaitanya Mitta wrote:
> Hi Darrick,
>             Thanks for the quick response, we are exposing XFS file (created
> through fallocate -l <size> <path>) as block device through
> SPDK bdev (https://github.com/spdk/spdk) over NVMe-oF, Now initiator will
> connect to the target and provide a block device to database applications.
> What I have observed is databases' applications are issuing flush IO post
> each/couple of writes, this flush at backend at backend translates to
> fsync (through aio/io_uring) operation on FD (which is time taking process),
> if we are doing no-op for flush IO then performance is 5x better compared to
> serving flush operation. Doing no-op for flush and if system shutdown abruptly
> then we are observing data loss (since metadata for new extents are not yet
> persistent) to overcome this data loss issue and having better performance
> below are the steps used:
> 1. Created file through fallocate using FALLOC_FL_ZERO_RANGE option
> 2. Explicitly zeroed file as mentioned in code (this marks all extents as
>    written and there are no metadata changes related to data [what I observed],
>    but there are atime and mtime updates of file).
> 3. Expose zeroed file to user as block device (as mentioned above).
> 
> Using above approach if system shutdown abruptly then I am not able
> to reproduce data loss issue. So, planning to use above method to ensure
> both data integrity and better performance

That sounds brittle -- even if someday a FALLOC_FL_WRITE_ZEROES gets
merged into the kernel, if anything perturbs the file mapping (e.g.
background backup process reflinks the file) then you immediately become
vulnerable to these crash integrity problems without notice.

(Unless you're actually getting leases on the file ranges and reacting
appropriately when the leases break...)

--D

> On Tue, Dec 24, 2024 at 3:23 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Mon, Dec 23, 2024 at 10:12:32PM +0530, Sai Chaitanya Mitta wrote:
> > > Hi Team,
> > >            Is there any method/tool available to explicitly mark XFS
> > > file extents as written? One approach I
> > > am aware is explicitly zeroing the entire file (this file may be even
> > > in hundreds of GB in size) through
> > > synchronous/asynchronous(aio/io_uring) mechanism but it is time taking
> > > process for large files,
> > > is there any optimization/approach we can do to explicitly zeroing
> > > file/mark extents as written?
> >
> > Why do you need to mark them written?
> >
> > --D
> >
> > >
> > > Synchronous Approach:
> > >                     while offset < size {
> > >                         let bytes_written = img_file
> > >                             .write_at(&buf, offset)
> > >                             .map_err(|e| {
> > >                                 error!("Failed to zero out file: {}
> > > error: {:?}", vol_name, e);
> > >                             })?;
> > >                         if offset == size {
> > >                             break;
> > >                         }
> > >                         offset = offset + bytes_written as u64;
> > >                     }
> > >                     img_file.sync_all();
> > >
> > > Asynchronous approach:
> > >                    Currently used fio with libaio as ioengine but
> > > results are almost same.
> > >
> > > --
> > > Thanks& Regards,
> > > M.Sai Chaithanya.
> > >
> 
> 
> 
> -- 
> Thanks& Regards,
> M.Sai Chaithanya.
> 
