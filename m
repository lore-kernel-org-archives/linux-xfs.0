Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4720018C933
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 01:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744595273; cv=none; b=rZ0lGmgRnD9VMl3anKr0fn6CqBR6SZcaufye9BKKZHJTTL1m44zp2D3PeQUH599xrQmTYn15Gb50Osbtyi/88BBS3R/c1PZbj459PijXNtmub2PDzGkT7EGQXjzvA3jlDE4jKGYiW+u5pdWhnFT6v4uvdbx+tWZtLsNan/GYRmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744595273; c=relaxed/simple;
	bh=5k+iwTuy+xrcUMLjSCP+Obud++46WTKcsMGcr7dqciE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZdSJe+a0AYOlqZN1P+Glo0j8NtnMBVlwr7iGmJZfKz/gWt4AjeG7SPr3KP7tVC/Ov41Lv+zCRiybKRdm3Vv1A4z6E/aMgTzSmRnVvEzXStS8meNg6K+HWzR8cCyjSazhflBpOXaQ1tkIZMROqG88tMHDR9n8DCNFLjdNpfaqi9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Received: from macsyma.thunk.org (c-73-9-28-129.hsd1.il.comcast.net [73.9.28.129])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 53E1lLNq026151
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 13 Apr 2025 21:47:23 -0400
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id BF5C0345F0A; Sun, 13 Apr 2025 17:48:58 -0400 (EDT)
Date: Sun, 13 Apr 2025 17:48:58 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com, djwong@kernel.org, zlang@kernel.org,
        david@fromorbit.com
Subject: Re: [PATCH v2 2/3] check: Add -q <n> option to support unconditional
 looping.
Message-ID: <20250413214858.GA3219283@mit.edu>
References: <cover.1743670253.git.nirjhar.roy.lists@gmail.com>
 <762d80d522724f975df087c1e92cdd202fd18cae.1743670253.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <762d80d522724f975df087c1e92cdd202fd18cae.1743670253.git.nirjhar.roy.lists@gmail.com>

On Thu, Apr 03, 2025 at 08:58:19AM +0000, Nirjhar Roy (IBM) wrote:
> This patch adds -q <n> option through which one can run a given test <n>
> times unconditionally. It also prints pass/fail metrics at the end.
> 
> The advantage of this over -L <n> and -i/-I <n> is that:
>     a. -L <n> will not re-run a flakey test if the test passes for the first time.
>     b. -I/-i <n> sets up devices during each iteration and hence slower.
> Note -q <n> will override -L <n>.

I'm wondering if we need to keep the current behavior of -I/-i.  The
primary difference between them and how your proposed -q works is that
instead of iterating over the section, your proposed option iterates
over each test.  So for example, if a section contains generic/001 and
generic/002, iterating using -i 3 will do this:

generic/001
generic/002
generic/001
generic/002
generic/001
generic/002

While generic -q 3 would do this instead:

generic/001
generic/001
generic/001
generic/002
generic/002
generic/002


At least for all of the use cases that I can think of where I might
use -i 3, -q 3 is strictly better.  So instead of adding more options
which change how we might do iterations, could we perhaps just replace
-i with your new -q?  And change -I so that it also works like -q,
except if any test fails, that we stop?

					- Ted
