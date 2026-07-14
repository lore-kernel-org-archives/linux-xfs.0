Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C15D346A04
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 12:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784032934; cv=none; b=kFZEmk9/jOiw5UJzibs3tjFCRbFTD+9otmvEoHPv+W+aS1VyytKIhdx3Q7ks0a0CMLGK3Cf+3xsgPSx6+kqV4j6WRqiTlO+Zl1Z8lorU+VIp2uxqDhsO5EcyhgmwMicgx25doe+odoZqeD/bzCYtP3Im4ii9e8MMSOX6PvPfMXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784032934; c=relaxed/simple;
	bh=xWbtWOdlHabiSQQjWqxVExPTp+6PCECtMuR7MQkTalA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rPBQp33MGD39giDH5x5kXTaCm/2ZIBGM9QpNhhI21Zlvl0LFJpIF52IDpMU9YXQI3f1wEebfmmrTAqlt5et2RGrQnzYyMIiOc3yKyZtgSXD0ASd7/Td35ofGB/XUFyIWS4x48Nv1ahqSpUOQFyGMrXBz4uAvD9dHPZHQWNCqSF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BKArHnZy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BKArHnZy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784032931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YwBaRSULTrCyorFT0lx15gIFwn2O3+OsWXUfKBOZQCc=;
	b=BKArHnZyzfIwuTKwHCjB0CyPFtTxdgq/aCQD1HLe8Lu8dvOXAek/vjk039ILUiW9duWCux
	7UgGfhZrKyZRGd14TtYHumMtE5xmIuxaCdvvlW3GIgH7+jMqKNKeN4DetnSP+EMetkNXcA
	zi7suC7nv8GfLvE9ti6MGvswdtNo+pw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-658-Ew2gWBCwPs-pzW3Spe5hUQ-1; Tue,
 14 Jul 2026 08:42:05 -0400
X-MC-Unique: Ew2gWBCwPs-pzW3Spe5hUQ-1
X-Mimecast-MFC-AGG-ID: Ew2gWBCwPs-pzW3Spe5hUQ_1784032924
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7BD68195604C;
	Tue, 14 Jul 2026 12:42:04 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.111])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3FCB01800591;
	Tue, 14 Jul 2026 12:42:03 +0000 (UTC)
Date: Tue, 14 Jul 2026 08:42:00 -0400
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, cem@kernel.org,
	linux-xfs@vger.kernel.org, dgc@kernel.org, hch@lst.de
Subject: Re: [RFC PATCH] xfs: add new policy guidelines for llm-assisted
 patches
Message-ID: <alYumOWysqudowaq@bfoster>
References: <20260709110006.94905-1-cem@kernel.org>
 <ab8c9529-103d-4e25-b062-1700544a0bdb@sandeen.net>
 <20260709163352.GD15210@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709163352.GD15210@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Thu, Jul 09, 2026 at 09:33:52AM -0700, Darrick J. Wong wrote:
> On Thu, Jul 09, 2026 at 07:30:41AM -0500, Eric Sandeen wrote:
> > On 7/9/26 6:59 AM, cem@kernel.org wrote:
> > > From: Carlos Maiolino <cem@kernel.org>
> > > 
> > > Hi, this idea came from some observations on the current inflow of patches
> > > sent to xfs, amount of time we've been spending reviewing patches, lack of
> > > testing coverage for them and sporadically bollocks patches that make no
> > > sense or even do not compile.
> > > 
> > > A talk I had with Dave earlier today made me come up with an INITIAL
> > > DRAFT of what should IMHO make 'reviewable' any LLM-assisted patch
> > > submitted to the list.
> > > 
> > > Most of the information there is also valid for non-LLM assisted code,
> > > but LLM-assisted code makes these policies exceptionally important
> > > giving LLMs make the code generation way faster and easier than we have
> > > time to follow through.
> > > 
> > > We do have tooling now like Sashiko to help with a gross review of
> > > patches and some general policies, but none of those tooling/policies
> > > target xfs specifically so I thought we ought to have a specific policy
> > > in place, specially regarding testing-coverage as submitting
> > > LLM-assisted patches also implies the same tooling can be used to create
> > > fully-functional testing coverage in xfstests.
> > > 
> > > I'll appreciate your thoughts on this.
> > 
> > I like it.
> > 
> > (applying my pedantic liberal arts native English speaker editorial preferences,
> > you can take it or leave it)
> > 
> > > Cheers
> > > 
> > > Signed-off-by: Carlos Maiolino <cem@kernel.org>
> > > ---
> > >  ...m-assisted-patch-submission-guidelines.rst | 59 +++++++++++++++++++
> > >  1 file changed, 59 insertions(+)
> > >  create mode 100644 Documentation/filesystems/xfs/xfs-llm-assisted-patch-submission-guidelines.rst
> > > 
> > > diff --git a/Documentation/filesystems/xfs/xfs-llm-assisted-patch-submission-guidelines.rst b/Documentation/filesystems/xfs/xfs-llm-assisted-patch-submission-guidelines.rst
> > > new file mode 100644
> > > index 000000000000..1f7921789988
> > > --- /dev/null
> > > +++ b/Documentation/filesystems/xfs/xfs-llm-assisted-patch-submission-guidelines.rst
> > > @@ -0,0 +1,59 @@
> > > +.. SPDX-License-Identifier: GPL-2.0
> > > +.. _xfs_llm_assisted_patch_submission_guidelines:
> > > +
> > > +============================
> > > +XFS LLM-Assisted patch submission guidelines
> > > +============================
> > > +
> > > +Introduction
> > > +============
> > 
> > > +LLMs are a great tool for improving code quality when well used. But they also
> 
> I'd change that to "...when used well."  I dunno if this is a local
> colloquialism but to me "used well" means "used in a beneficial manner"
> whereas "well used" just means "used very much".
> 
> > > +have been creating a lot of extra workload for developers with the increasing
> > 
> > have the potential to create an extra workload for the XFS developer community with
> 
> "But the increasing patch flow creates a lot of extra work for the XFS
> developer community." ?
> 
> > > +patch flow. Requiring much more time with reviewing and testing changes.
> > > +
> > > +Some patches submited fixes obvious bugs and are welcome, while other patches
> > 
> > Some LLM generated patches fix obvious bugs and are welcome, while others
> > have obvious flaws, create regressions caught by xfstests, fix theoretical bugs
> > that may never be hit in the real world, and sometimes do not even build.
> 
> I agree.
> 
> > > +being submitted have obviously flaws, create regressions caught by xfstests,
> > > +fixes theoretical bugs that may never be hit in real world (even though are
> > > +worth fixing) and sometimes do not even build.
> > > +
> > > +So the goal of the policies described by this document is two-fold:
> > 
> > The goal of the policies described by 
> 
> Agree here too.
> 
> > > +
> > > +	- Increase XFS's code quality ensuring all code modifications are
> > > +	  properly tested and have extra coverage
> > 
> 
> "Increase XFS's code quality by ensuring..." ?
> 
> > sufficient coverage?
> 
> Yes.
> 
> > > +	- Reduce developers/maintainers workload with the extra income of
> > > +	  machine-generated patches.
> > 
> > Reduce developer / maintainer workload with the extra influx of
> 
> Hah, I wish I got extra income from all this LOLLM slop. ;)
> 
> > > +
> > > +Patch description
> > > +-----------------
> > > +
> > > +Patches description should be carefully trimmed by the patch submitter removing
> > > +all extra and unnecessary data from it.
> > 
> > Patch descriptions should be succinct and clear.
> 
> "The patch description should state clearly the specific reasons why the
> change is being made.  It should not be a summary of the changes in the
> diff." ?
> 

+1 to this. ISTM that the robot tools like to create text that literally
restates what the logic does, but adds no real reasoning as to why, no
additional useful context, etc. Of course we humans are guilty of this
at time too, but that's often just a mistake/learning experience than a
consistent behavior like an LLM.

The larger point is that the commit log and code comments are targeted
at aiding human understanding of why things are done a certain way. I
wonder if we should figure a way to require that the human submitter has
at least reviewed the commit log and all code comments as fit for
purpose, so we know comments provide useful information, exist where
they should, don't where they shouldn't, etc., so this doesn't
consistently fall onto reviewers as well.

> > > +LLMs tend to generate extra-long documentation full of unnecessary information
> > > +that won't help neither the reviewer nor anybody looking into the git history
> > 
> > that won't help the reviewer or anyone reading git history in the future, 
> 
> (Agree)
> 
> > > +in the future, and these consumes a lot of time during review.
> > 
> > and these consume a lot of time during review.
> 
> "Reading the unnecessarily wordy documentation consumes too much time
> during reviews." ?
> 
> > > +It's the patch submitter responsibility to trim it down to a concise, easily
> > 
> > It's the patch submitter's responsibility to ...
> 
> (Agree)
> 
> > > +readable document, removing all the extra unnecessary information from it.
> > 
> > Strike "removing all the extra unnecessary information from it" which is extra
> > and unnecessary. ;) 
> 
> Yes.
> 
> > > + 
> > > +This also helps adding extra guardrails that the patch submitter fully understands
> > > +what the patch is doing without letting the LLM loose.
> > 
> > (this is a little unclear to me)
> 
> How about:
> 
> "These guidelines are a means for the person submitting the patch to
> demonstrate that they fully understand the changes in the diff.
> Reviewers may ask follow-up questions if they are not convinced of this
> point.  The person submitting the change is always fully responsible for
> those changes."
> 
> (and then drop the next section)
> 
> > > +
> > > +Patch changes
> 
> Do you mean the diff part?
> 
> > > +-------------
> > > +
> > > +The patch submitter is fully responsible for the changes and must understand what
> > > +the paitch does. And it should be in full agreement with the patch description.
> 
> Don't start a sentence with "And".
> 
> I also can't tell what "it" refers to -- does that mean the diff should
> agree with the description?  Or that the submitter themself should?
> 
> "The patch diff must match the patch description."
> 
> > "patch" - but also not entirely sure what this means or how to better word it.
> > "Patch changes" is a bit of an odd heading. In general I 100% agree with
> > "you, the human, had better understand what the patch is doing before you submit it."
> > > +
> > > +Testing the changes
> > > +---------------
> > > +
> > > +LLM-generated patches should be coupled with a fully-functional xfstests test case
> 
> "...should be submitted with..." ?
> 
> (also, don't we call it fstests nowadays?)
> 
> > > +which exercises the bug being fixed by the patch. This will not only improve testing
> > > +coverage but also provide extra help for reviewers and the maintainer to properly
> > > +review and test the changes being made.
> > 
> > This will also help you, the submitter, have confidence that your patch is doing
> > what you expect it to do.
> 
> "...the person submitting the patch..." ?
> 
> > > +Also, every patch/series submitted must be exercised through xfstests suite
> > > +- at least - through the auto group (and others depending on the change) as a way
> > > +to add extra coverage through the already existing regression cases and help
> > > +reviewers/maintainers through the integration process.
> 
> What about patches to online fsck, in which case the auto group may or
> may not cover it other than incidentally through xfs/28[56]? ;)
> 
> How about:
> 
> "Every patch submitted must be exercised through the fstests suite
> because good test coverage makes review and maintenance processes
> easier.  Ideally, the change should be exercised by a fstest case in the
> "auto" group, but another group may be more appropriate depending on the
> change."
> 

Since some things are not practical to test directly with an fstest, I
wonder if we should require or recommend that in absence of a viable
fstest, the submitter of an LLM generated patch should include a brief
description of how some change was unit and/or code coverage tested.

That way for things that look like hard to hit races, require crafted fs
images for log recovery corruption cases, etc., we have at least some
indication that the change works and doesn't tickle some other
previously unknown problem (like busted error paths, etc.).

IME even these sorts of cases can be coverage tested with custom
instrumentation. For example, "I don't have a custom fs image that
reproduced this broken log record condition, so I added an if (1) at
LINE XYZ to trigger the error check on a standard dirty log test fs
image. I confirm it works as expected, doesn't explode the kernel, and
the mount fails gracefully."

Just a thought.

Brian

> --D
> 

