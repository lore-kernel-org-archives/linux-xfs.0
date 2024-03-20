Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD99515E9C
	for <linux-xfs@vger.kernel.org>; Wed, 20 Mar 2024 14:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710946409; cv=none; b=ELI0fVplsqZQnZF3mvnEiYcUyKTCa4wKRUvAQ/tTYYbvwtgXHmpF8OilLfBHizLGNvLmZrrNOaFbolD+hdhVzUNPHLyGS+PXzpPGvA2w9yc3FW2Ehgyply19tKnkTqgJ4ueKidQ+iNpzfz3ysAlFH9N2W565LxT4fDRZ1yZylgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710946409; c=relaxed/simple;
	bh=r+gh/iklFT3L8b/jAjNYWa9xoJc26fEJUJOKO9Ms2IM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NfZRlek6kNufh4lerf9Zk3yIEe4GOTRM/+nx9qbhXTzGIgylEY/wG5OuVOHb0w96lMN/wzcTVOpzSFnHw4YSJwpyug+lLIEOO9jyXqDLcEEELieZR+HyHY9+M5qa0M0F5XJtHM9ptZM0WHVT35s4AKzJFZN9+UWZ6ftnw23JS0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M8rYJa+h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M8rYJa+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D14C433F1;
	Wed, 20 Mar 2024 14:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710946409;
	bh=r+gh/iklFT3L8b/jAjNYWa9xoJc26fEJUJOKO9Ms2IM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M8rYJa+hVp5lRxeVjivRQ/phHWbyUqT/h6e3EnSQ9WlwavZAJkRWAR6S/IuR4gSka
	 8AaTfLQFdyX0/6RGbaZsoKuiTehie6aVx9VbrM00xJ6zT9jkc1xc6lmogQTe/0vadM
	 8pgdaiSQjR5sTBbHdY0uoDFRk7GZfe149VGT4fWulKoT7/mHexjQKFoU/QKRKwdGmc
	 KeVnal9MoV7YXwmzNKgHA68d6Ns2EHiGV4fAVPks2Vqhp/GfKep3rq4gFSaSGzyKpo
	 rRBbDXHSaRFAK7sDiY0Tib0Q98L5L8oTfLeEFucq+cw3cO2KrNYFAHbb6XCZdwqLIs
	 TGNMEkY4fqJIQ==
Date: Wed, 20 Mar 2024 07:53:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andre Noll <maan@tuebingen.mpg.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: reactivate XFS_NEED_INACTIVE inodes from
 xfs_iget
Message-ID: <20240320145328.GX1927156@frogsfrogsfrogs>
References: <20240319001707.3430251-1-david@fromorbit.com>
 <20240319001707.3430251-5-david@fromorbit.com>
 <Zfqg3b3mC8Se7GMU@tuebingen.mpg.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zfqg3b3mC8Se7GMU@tuebingen.mpg.de>

On Wed, Mar 20, 2024 at 09:39:57AM +0100, Andre Noll wrote:
> On Tue, Mar 19, 11:16, Dave Chinner wrote
> > +		/*
> > +		 * Well, that sucks. Put the inode back on the inactive queue.
> > +		 * Do this while still under the ILOCK so that we can set the
> > +		 * NEED_INACTIVE flag and clear the INACTIVATING flag an not
> > +		 * have another lookup race with us before we've finished
> > +		 * putting the inode back on the inodegc queue.
> > +		 */
> > +		spin_unlock(&ip->i_flags_lock);
> > +		ip->i_flags |= XFS_NEED_INACTIVE;
> > +		ip->i_flags &= ~XFS_INACTIVATING;
> > +		spin_unlock(&ip->i_flags_lock);
> 
> This doesn't look right. Shouldn't the first spin_unlock() be spin_lock()?

Yes.  So much for my hand inspection of code. :(

(Doesn't simple lock debugging catch these sorts of things?)

((It sure would be nice if locking returned a droppable "object" to do
the unlock ala Rust and then spin_lock could be __must_check.))

--D

> Also, there's a typo in the comment (s/an/and).
> Best
> Andre
> -- 
> Max Planck Institute for Biology
> Tel: (+49) 7071 601 829
> Max-Planck-Ring 5, 72076 Tübingen, Germany
> http://people.tuebingen.mpg.de/maan/


