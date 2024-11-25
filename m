Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10B92500DE;
	Mon, 25 Nov 2024 05:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732511800; cv=none; b=s647ey/EWqYLaK5XJLx3sm37lYUzqsD3WiLJhYy6fuKft4iiIN/7EGqUTTtvwYrhS0u5OWrn0BR8Yzm607VtQTptUEv8yPWNEsOwysPGryDAYDWRXjJkJ9sStz3rodHW4p4zW43izn31b1zUuofjaTE+TkL/fFQvKfv2pzn+tFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732511800; c=relaxed/simple;
	bh=+G3NskFpKj0tr1Eef04h+RrqnUH7suQKhxNK6bkEeBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aUWBrJKX87aG7AuVbTHW1gyPzzgw61Fd+W6eVEZtpd9aYKIfFoqmji3M8MspK600XGtyCtfJJTI7PGyutF0bW2qytZtQlRpTuCWdPhyeEG38y+nqVPpiS67E7sY/gVzJ0PBLDtRYhXgvhCRHofTBuF7umxqhTjkV3xL370SFS/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rJaxDYOa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rJaxDYOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755BDC4CECE;
	Mon, 25 Nov 2024 05:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732511800;
	bh=+G3NskFpKj0tr1Eef04h+RrqnUH7suQKhxNK6bkEeBI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rJaxDYOa1fmEQiGnyTlGWI/RwfZsuREo5wY/bzFV7kGVIELID2JYz1c28SmeHQkS3
	 qTXDg4eQ9icQsGGc3+7eRn8lHfx1IXE1i0N3NzY3pr56E/gEdkumxBkJh4QEeoFVc8
	 MpCu6kW7mXEhu6Q+85nk+3JbjaPZwT2KWSAABCks0DhxojKQBeXIzDx3pCbcIpy1Lk
	 pllV58nnsjydWx/nxtSXcO3K6UQlY37PTThYEnta2QiT3BlztZdXToCVboffXWhK9r
	 PpLaBycKYTL7HJRm/irPQ0Ilcj7yBMujcRX+1H2eMieGoQJGvwKDdsap9C9xV66EL/
	 LNNow6ZvGACKw==
Date: Sun, 24 Nov 2024 21:16:39 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/17] generic/562: handle ENOSPC while cloning gracefully
Message-ID: <20241125051639.GG9438@frogsfrogsfrogs>
References: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
 <173229420148.358248.4652252209849197144.stgit@frogsfrogsfrogs>
 <Z0QHw2IGqnTsNcqb@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0QHw2IGqnTsNcqb@infradead.org>

On Sun, Nov 24, 2024 at 09:14:43PM -0800, Christoph Hellwig wrote:
> On Fri, Nov 22, 2024 at 08:52:48AM -0800, Darrick J. Wong wrote:
> > +# with ENOSPC for example.  However, XFS will sometimes run out of space.
> > +_reflink $SCRATCH_MNT/bar $SCRATCH_MNT/foo >>$seqres.full 2> $tmp.err
> > +cat $tmp.err
> > +test "$FSTYP" = "xfs" && grep -q 'No space left on device' $tmp.err && \
> > +	_notrun "ran out of space while cloning"
> 
> Should this simply be unconditional instead of depend on XFS?

Felipe said no:
https://lore.kernel.org/fstests/CAL3q7H5KjvXsXzt4n0XP1FTUt=A5cKom7p+dGD6GG-iL7CyDXQ@mail.gmail.com/

(which I should reply to)

--D
