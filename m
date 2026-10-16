Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DB1BA3D
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 01:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792114675; cv=none; b=KYTLwN1DoHewSyLjc9T3FAaXwCSESb04QH4GIBF9R+ISLzodfcP7I6G6zQlqtiTwRyZQ8pfzRrZKSNtcFKvFtFav+pC0rrsK033QnZ5gyVIK1py57HpF/lPILyWjz9JVgL8L9l8ZqtKc3caRPD0t0vI4bCzFAOmWx/RpZsmmOTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792114675; c=relaxed/simple;
	bh=f+w7CvHAZrk86slBBdZUluPh52/sFDhvU3/uvJ+oiDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jkGW4MWyP6qDsCgMLBMWCspudUU0ibvGJFQrDnbiSED7JuQtNCobFXh6u6vxpHSl/EBJcH7LC9IKo11lSgs8nuYNCpR2oyExQZtnZns3FaoSMB6KhupoCPYNp6iMVhuO5cmkImeAcoAMYYfaL6nVRj0wPY0gupZTbL5YBTZ9DKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PjHDqBmm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PjHDqBmm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEDE71F000C4;
	Fri, 16 Oct 2026 01:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792114673;
	bh=c59I1XK0u4cPf7vKWlirWulxe6pH4J0ZBWS6OVRqN0s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PjHDqBmm/bI4BfeBbsVb+sR487S25QHwKS9DfYlP4v2jvsBTFy1E4LX0laWKLPG78
	 zAkjchtYTcmWh9+u2abzi5TLv3FLJAKUacu4yuGrmOzMgGdSXPInOBDLPpaLH1xn49
	 joDouzPtrc1sl2qSoDUSeT/z008vnJH9ZyYyYr1afVkispRMovmbTZlMQVxh9vkaSC
	 5853hGXM8xh8QrROuUkPu/aGiv9fg522MAapNrZC8LsRc1E8XdzIMHVxMbTVMPfMW3
	 RhvAl94wTcQH5Hsgkn6rOo8YN+PA9PVQSKR9YoOqZGllPbLmu3bvlCKgba+95OJtYL
	 Zlko1i3FQbpuA==
Date: Fri, 16 Oct 2026 12:37:45 +1100
From: Dave Chinner <dgc@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH 02/48] xfs: add log recovery item validation design
 document
Message-ID: <atF_6cmjhGmVI5HU@dread>
References: <20261013060204.3138690-1-dgc@kernel.org>
 <20261013060204.3138690-3-dgc@kernel.org>
 <20261014233117.GL2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014233117.GL2705364@frogsfrogsfrogs>

On Wed, Oct 14, 2026 at 04:31:17PM -0700, Darrick J. Wong wrote:
> On Tue, Oct 13, 2026 at 05:00:52PM +1100, Dave Chinner wrote:
> > Add a design document describing a systematic approach to validating log
> > items during journal recovery. Log item data read from the journal cannot
> > be fully trusted - corruption from torn writes, hardware errors or
> > software bugs can produce invalid type codes, wrong region counts,
> > truncated regions or internally inconsistent format structures that the
> > current recovery code largely uses unchecked.
> > 
> > The document describes a three-layer validation scheme (generic region
> > header decode, per-region type-specific validation, and full cross-region
> > item validation), the treatment of the transaction header as a validated
> > region type, and a set of additional safety fixes for the generic region
> > assembly code. It also lays out a phased implementation plan.
> > 
> > Changes:
> > - Add Documentation/filesystems/xfs/xfs-log-recovery-validation-design.rst
> > - Add the new document to the XFS documentation index
> > 
> > Created-by-AI: Claude Opus 4.8 (1M context)
> >
> > Prompt: Let's start by converting the existing verification doc to kernel
> > .rst format and moving it to Documentation/filesystems/xfs/ and adding it
> > to the relevant doc index file. The file should be tracked in a new patch.
> 
> Eheheh.

Yeah, I forgot this was written about 3 months ago before I
completely rewrote all the patch header generation skills. If you
read through the patch headers, you'll probably spot changes in the
way the read that coincide with refinements to the skills...

i.e. my workflow has been rapidly evolving over the past few months,
and this patch series spans quite a lot of change and refinement...

> > diff --git a/Documentation/filesystems/xfs/xfs-log-recovery-validation-design.rst b/Documentation/filesystems/xfs/xfs-log-recovery-validation-design.rst
> > new file mode 100644
> > index 000000000000..188b1bebf171
> > --- /dev/null
> > +++ b/Documentation/filesystems/xfs/xfs-log-recovery-validation-design.rst
> 
> The document sounds pretty reasonable for a first pass at hardening the
> log recovery code.  This is a good start.

OK, that's good to hear.

> <snip>
> 
> > +Layer 3: Full item validation (type-specific, cross-region)
> > +-----------------------------------------------------------
> 
> <snip>
> 
> > +Other intent/done items
> > +    similar field-level validation
> 
> But please be more specific.

Yup, it needs to be revised to match what that actually meant :)

> > +Phase 3: Full item validation
> > +-----------------------------
> > +
> > +Patch M: Add validate_item callback infrastructure
> > +    - Add the callback to the ops struct
> > +    - Call it from ``xlog_recover_reorder_trans()`` after ops verification
> > +    - Return ``-EFSCORRUPTED`` on failure, aborting recovery
> > +
> > +Patches M+1 to M+N: Implement validate_item for each item type
> > +    - Move existing validation out of ``commit_pass2`` into
> > +      ``validate_item`` where possible (e.g. ICREATE field checks)
> > +    - Add new cross-region validation
> > +    - Order: simple types first, complex types last
> > +    - INODE validation is the most complex (fork format vs region size)
> > +
> > +Phase 4: Cleanup
> > +----------------
> > +
> > +- Remove redundant validation from ``commit_pass1``/``commit_pass2`` that
> > +  is now covered by ``validate_region``/``validate_item``
> > +- Add ``ASSERT()``\ s in commit handlers to verify validation has run
> > +- Review and update error messages for consistency
> 
> Why is the plan for splitting scope across M+N patches relevant for a
> design document that will live in the kernel?

It's not. This document was derived from the original planning work
I did in the LLM. I forgot to remove this stuff once the LLM didn't
need it as a reference anymore. I'll match sure the design doc is
updated before the next version.

FWIW, the reason for writing the design/planning doc in this way was
to give the LLM something to re-reference whilst working through the
patch series. The plannig and coding wasn't all done in one session.
The work was also large enough in scope that frequent context
compaction was required to manage context size and minimise token
cache re-read costs. I simply forgot to tell it to clean up the
design doc as the work was completed.

I've since changed how I record the implementation plan for new
development - the design docs still exist for the "LLM needs
guidance" reasons, but I use LLM session memory for maintaining the
implementation plan now. Hence the LLM now automatically removes
work from the plan as it is complete, and I don't have to remember
to tell it to do so anymore. That's likely why I forgot about this
altogether...

Cheers,

Dave.

-- 
Dave Chinner
dgc@kernel.org
