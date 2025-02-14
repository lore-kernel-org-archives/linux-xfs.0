Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F3318EFD4
	for <linux-xfs@vger.kernel.org>; Fri, 14 Feb 2025 20:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739566257; cv=none; b=GzLN8ukFxHL7+MaOIz0k7OoxWzt3aKeZnG0+nneiP6P5MM8+lAFaOBR4bnhpqxZg068oGUjdNljAAWUVAHRolFLfjN3IIoa5mHSHmOo1Y9buoNDaCf25fnbXCNtdJUHWXZ1r+R35iI7R33eHNkKZUjrJ3W2Vn0l85T/BbtXkNi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739566257; c=relaxed/simple;
	bh=OTVRFo4aXH91wSlCu9kLzXx2uHr45Ji+trVu3i0Rqac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B4PQcyNR4rjcJMeMACdSWW5KAw9K9Kj0Xkm7auZ+6akmJT//PmeJr7YmlYJc090eJFeM+l8X8btrPLy94bf8wpw2eLao/BOyKpSq6G+/Us+dln8NFRj+sfOvtRgb6U6JiV11exFnQSAQrgUz54ezaMJlRW3GqE1cF9WdkSB5GV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Received: from cwcc.thunk.org (pool-173-48-82-224.bstnma.fios.verizon.net [173.48.82.224])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 51EKoVFg018427
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Feb 2025 15:50:32 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
	id 991B215C0009; Fri, 14 Feb 2025 15:50:31 -0500 (EST)
Date: Fri, 14 Feb 2025 15:50:31 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@redhat.com>, dchinner@redhat.com,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/34] common: fix pkill by running test program in a
 separate session
Message-ID: <20250214205031.GA509210@mit.edu>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
 <173933094569.1758477.13105816499921786298.stgit@frogsfrogsfrogs>
 <20250214173406.pf6j5pbb3ccoypui@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20250214175644.GN3028674@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250214175644.GN3028674@frogsfrogsfrogs>

On Fri, Feb 14, 2025 at 09:56:44AM -0800, Darrick J. Wong wrote:
> > The tools/ directory never be installed into /var/lib/xfstests. If someone runs
> > xfstests after `make install`, all tests will be failed due to:
> > 
> >   Failed to find executable ./tools/run_setsid: No such file or directory
> 
> Urrrk, yeah, I didn't realize that tools/ doesn't have a Makefile,
> therefore nothing from there get installed.  Three options:
> 
> 1) Add a tools/Makefile and an install target
> 2) Update the top level Makefile's install target to install the two
>    scripts
> 3) Move tools/run_* to the top level and (2)

Looking at tools, it seems like there are a couple of different
categories of scripts in the directory.  Some are useful to people who
are developing fstests (mkgroupfile, nextid, mvtest); some are useful
when debugging a test failure (dm-logwrite-replay); some are useful
only to xfs developers (ag-wipe, db-walk).

And to this we are adding utility programs that would be used during a
test execution.

I wonder if we should split out these scripts into different
directories?

	  	       	      	    	- Ted
				
