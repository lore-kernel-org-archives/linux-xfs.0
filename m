Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F0C35836E
	for <linux-xfs@vger.kernel.org>; Mon, 28 Sep 2026 02:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790564037; cv=none; b=pwEttLvlyzfggFnLu1T88+u4SA9KnAEhP9tA1bg4jFDPe47mBjzWUI/JV3yfJ4KPh6HoUuofExJRvgyTM7WNyVtoPNTkjJPUG1uppzQboBNgLZBEM8NvZv+wUAfrDMhPb1Zq07BKYv61LaD8sRG7hoctZfqzXPkMgYeBon41z9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790564037; c=relaxed/simple;
	bh=ByL3qFHrV4IyE62TuSmAG7D0QAHurhQksLht8ZCHZGs=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=OFw3F/YSRW5nH4KIiQaLMwCD7Al4c6dKaogI4kC6P4PCjyad1AzMwKDelQMcxAo+eA+C6moYKxwZKP47ZzyAZ8H2lCjy63yqRR64jitCOJdzwv64nPahQXfFXU4BWSwrmTF+J+aTDxLtDmvKCdGSNPP1wiJ60KySotqshWydT3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=mVqQgmpx; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="mVqQgmpx"
Received: from macsyma.thunk.org (pool-108-26-156-127.bstnma.fios.verizon.net [108.26.156.127])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 68S2rkoe002730
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 27 Sep 2026 22:53:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1790564028; bh=QZumIsGaKYKZZqP+QjbcWePDP3lb/suttY++K2JmhO0=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=mVqQgmpxM63EEjv5rN3vGToT4qAlnh+0PRMWIX7+Lrx02Dy7S0IPKUqEqnpfw6nPb
	 RUbL76YkZm0XN9XlhH+WRYmXdWyFZ3SOGdjoa2ZMlcRsZa2iVGS3rtHziuFNg3zG8x
	 542MhV72T1EKAqjElSsMxgxiTPwWif/yJMJSL24f8D/bZhufAJKUKCMfdYHDNrqS1O
	 I3Rf2RxgOLkbWuM2zNe+NF6wZ2wQfxZMcpOhz6Kkkzb3ERjhoMFfMilnqpuTzdjX+B
	 T/te6hY5C5096AxxENCr9jb50C90g7wg0xnO1tYbzfwy28XFakWGe3AYTnNOLFfaTe
	 Ih7y5cDB8eIsQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 2B1081D5FA21; Sun, 27 Sep 2026 22:52:46 -0400 (EDT)
Date: Sun, 27 Sep 2026 22:52:46 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: linux-xfs@vger.kernel.org
Subject: running "make clean" in xfsprogs doesn't wipe mkfs/*.o files
Message-ID: <arnTiMxkxgR7oRYb@mit.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I recently ran into an issue where "make clean" (or "make realclean")
in the xfsprogs sources isn't deleting the *.o files in the mkfs
directory.

This is causing a problem because I first build xfsprogs for arm64,
and then I build it for x86_64, with a "make realclean" between.  The
fact that object files in the mkfs directory aren't getting cleaned
results in build failures.  This wasn't happening before when I was
building on a different build machime, but it's pretty clear the
problem is for soem reasone "make clean" isn't deleting the object
files in mkfs.

I tried to debug xfsprogs's makefiles, but it wasn't immediately
obvious, so I thought I would just file a report and hope someone can
take a look at it.

In the meantime, I'll work around it by adding a "find . -type f -name
\*.o -print0 | xargs -0 rm" to my test appiance build script.  Which
should work, but it seems really unfortunate that it's necessary.

Thanks,

					- Ted
