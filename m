Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6109188A12
	for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 14:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724681205; cv=none; b=I1ELd3F0tknDKwZg4ql231hxnK043hQk+w4Ek7QkUPDZKmmzsfb8/0atEP3AWw56GhqF4bDuy/JJpYp0V06zF5VPO2RuyibsJHBGhtq9jcKg3WLo98bN546IaeZoMP/KfHysI9mhuaxb27Dm1vCnIWw5Pq6+fMIyc85b2+z9Eu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724681205; c=relaxed/simple;
	bh=S7KCAcZlTHlL6IZZSjByJR01Jx+dNJZkM+l8CLKATAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eq+jDmkTRr3KasrlVQ+XU5vgunh83zrg2n/AmOCtcL1GQuyaCbaBjExrhY3pZ6c6yEwZTzl0qN3WVMsz0ND/nbynB6d1yxZFaf9r98yE+GeAvHW0OrHlo8ufHEQ0J4JgeGcigUo6J/kej/kHLkzX48XMPsoCulC4UgMNqU6iBMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h0rLkxi3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h0rLkxi3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724681201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5aRd4rFr7LIWlAGKgwuEmrevSyr0KYJo9n8hiZeDPiE=;
	b=h0rLkxi3+APCQnxFGDW5vCI0vXrdLBRSg6CZKw9HpAm7RG9/uTnz6a7EzIscQXqxixhyEU
	legOoT+DRE045A1fnXhoMizoQ/8ov8TqmIlVOri4+r6PTNccDd5sx2phC7DQ4BVKONvpCj
	S2gqPMS90CorsfzYwpJYIpqXKul0OVM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-629-zzB28F-uMz-UGhx8cDGzjw-1; Mon,
 26 Aug 2024 10:06:38 -0400
X-MC-Unique: zzB28F-uMz-UGhx8cDGzjw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C983E18BEFE1;
	Mon, 26 Aug 2024 14:06:35 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.22])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B96851955F40;
	Mon, 26 Aug 2024 14:06:34 +0000 (UTC)
Date: Mon, 26 Aug 2024 10:07:31 -0400
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	josef@toxicpanda.com, david@fromorbit.com
Subject: Re: [PATCH 3/3] generic: test to run fsx eof pollution
Message-ID: <ZsyMI-yNdZkoQt9g@bfoster>
References: <20240822144422.188462-1-bfoster@redhat.com>
 <20240822144422.188462-4-bfoster@redhat.com>
 <20240822205430.GX865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240822205430.GX865349@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Thu, Aug 22, 2024 at 01:54:30PM -0700, Darrick J. Wong wrote:
> On Thu, Aug 22, 2024 at 10:44:22AM -0400, Brian Foster wrote:
> > Filesystem regressions related to partial page zeroing can go
> > unnoticed for a decent amount of time. A recent example is the issue
> > of iomap zero range not handling dirty pagecache over unwritten
> > extents, which leads to wrong behavior on certain file extending
> > operations (i.e. truncate, write extension, etc.).
> > 
> > fsx does occasionally uncover these sorts of problems, but failures
> > can be rare and/or require longer running tests outside what is
> > typically run via full fstests regression runs. fsx now supports a
> > mode that injects post-eof data in order to explicitly test partial
> > eof zeroing behavior. This uncovers certain problems more quickly
> > and applies coverage more broadly across size changing operations.
> > 
> > Add a new test that runs an fsx instance (modeled after generic/127)
> > with eof pollution mode enabled. While the test is generic, it is
> > currently limited to XFS as that is currently the only known major
> > fs that does enough zeroing to satisfy the strict semantics expected
> > by fsx. The long term goal is to uncover and fix issues so more
> > filesystems can enable this test.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  tests/generic/362     | 27 +++++++++++++++++++++++++++
> >  tests/generic/362.out |  2 ++
> >  2 files changed, 29 insertions(+)
> >  create mode 100755 tests/generic/362
> >  create mode 100644 tests/generic/362.out
> > 
> > diff --git a/tests/generic/362 b/tests/generic/362
> > new file mode 100755
> > index 00000000..30870cd0
> > --- /dev/null
> > +++ b/tests/generic/362
> > @@ -0,0 +1,27 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2024 Red Hat, Inc.  All Rights Reserved.
> > +#
> > +# FSQA Test No. 362
> > +#
> > +# Run fsx with EOF pollution enabled. This provides test coverage for partial
> > +# EOF page/block zeroing for operations that change file size.
> > +#
> > +
> > +. ./common/preamble
> > +_begin_fstest rw auto
> > +
> > +FSX_FILE_SIZE=262144
> > +# on failure, replace -q with -d to see post-eof writes in the dump output
> > +FSX_ARGS="-q -l $FSX_FILE_SIZE -e 1 -N 100000"
> > +
> > +_require_test
> > +
> > +# currently only xfs performs enough zeroing to satisfy fsx
> > +_supported_fs xfs
> 
> Should get rid of this. ;)
> 

Agreed. But just to be clear, I was planning to leave this in for now so
we don't have to go and fix the various other filesystem issues
(assuming various maintainers agree) as a gate to fixing iomap zeroing
and having decent test coverage. I'm planning to look into the other
failures once I get through the iomap revalidation thing to avoid the
flush on XFS.

> > +ltp/fsx $FSX_ARGS $FSX_AVOID $TEST_DIR/fsx.$seq > $tmp.output 2>&1
> 
> I wonder, is there a reason not to use run_fsx from common/rc?
> 

At first glance the only thing that stands out to me is run_fsx
hardcodes the file to $TEST_DIR/junk instead of using and leaving around
a test-specific file. I find that ever so slightly annoying, but not
enough to hardcode the fsx command in the test, so I'll make that
change.

My initial hope was to be able to just turn on the eof pollution thing
by default and rely on existing fstests to (which I've confirmed do)
detect the iomap zeroing problems, but the other non-iomap fs failures
mean we can't do that without being disruptive and hence the need for
the custom fstest. If we can get to the point of completely removing the
_supported_fs check above, then perhaps we could also revisit changing
the fsx default and removing this test.

> Otherwise this looks ok to me.
> 

Thanks for the comments.

Brian

> --D
> 
> > +cat $tmp.output
> > +
> > +status=0
> > +exit
> > diff --git a/tests/generic/362.out b/tests/generic/362.out
> > new file mode 100644
> > index 00000000..7af6b96a
> > --- /dev/null
> > +++ b/tests/generic/362.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 362
> > +All 100000 operations completed A-OK!
> > -- 
> > 2.45.0
> > 
> > 
> 

