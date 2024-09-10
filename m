Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B6319ABBB;
	Tue, 10 Sep 2024 15:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725981062; cv=none; b=HvrJgEJtab/m/21ppr1t1Pfyyq6bwOev+QmF+m5ru33DiLHQ6IfdVRA/kUl8+AGb2PPMlEQ5RVX0i9BunCVlVmWrplLzzKeLv1bVO3gV83WNYFV7gW9bYvv/d0aVaiDHcHakC3LiLs31RpyJuUlFxHrYllqZR6T9FaBYIFHlt94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725981062; c=relaxed/simple;
	bh=GkyWBpJa3Ke+icifW07RqiULbHbpyxIA5WPXS9z3Jy8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kx370n+1aAd5a4gDTUwQ1iCWdd7vA7XtqKiZxmrpXI4PB1g8t8vM61Zvwwd3RwI7Nr9wk7IoSFX5axDw74PMHDuN3cC3gpa4ep+NRhkZzAuSA6ReIZE5U4zuHq65hEAFkBBs0AEumTndxoAC8S2jGN9T6UtOdXmh8pS9vzSUa7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C6B4A227AAE; Tue, 10 Sep 2024 17:10:54 +0200 (CEST)
Date: Tue, 10 Sep 2024 17:10:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org, djwong@kernel.org,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test log recovery for extent frees right after
 growfs
Message-ID: <20240910151053.GA22643@lst.de>
References: <20240910043127.3480554-1-hch@lst.de> <ZuBVhszqs-fKmc9X@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuBVhszqs-fKmc9X@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 10, 2024 at 10:19:50AM -0400, Brian Foster wrote:
> No real issue with the test, but I wonder if we could do something more
> generic. Various XFS shutdown and log recovery issues went undetected
> for a while until we started adding more of the generic stress tests
> currently categorized in the recoveryloop group.
> 
> So for example, I'm wondering if you took something like generic/388 or
> 475 and modified it to start with a smallish fs, grew it in 1GB or
> whatever increments on each loop iteration, and then ran the same
> generic stress/timeout/shutdown/recovery sequence, would that eventually
> reproduce the issue you've fixed? I don't think reproducibility would
> need to be 100% for the test to be useful, fwiw.
> 
> Note that I'm assuming we don't have something like that already. I see
> growfs and shutdown tests in tests/xfs/group.list, but nothing in both
> groups and I haven't looked through the individual tests. Just a
> thought.

It turns out reproducing this bug was surprisingly complicated.
After a growfs we can now dip into reserves that made the test1
file start filling up the existing AGs first for a while, and thus
the error injection would hit on that and never even reach a new
AG.

So while agree with your sentiment and like the highlevel idea, I
suspect it will need a fair amount of work to actually be useful.
Right now I'm too busy with various projects to look into it
unfortunately.

