Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D01D2FF
	for <linux-xfs@vger.kernel.org>; Wed,  2 Apr 2025 00:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743553376; cv=none; b=CCI7NBRb5G5/4nhBGEojheQoQqr0JCky9fUIy8SwWzq8W7vj7ELHsG38zNaJH9baf816ueR4orFUT24NkHSKK1tOA8gR1IwQUvvMW5CLeua36JCp2FnQw9R8fBen7I4QarqQrz5KrcMBYk7e2v0FWk/w68iTwlvYuyVqV2U2PlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743553376; c=relaxed/simple;
	bh=ol9al4HiJ/f5fEKwvphsmMWX9dBhP3risuqcasjpLus=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=YzdXsQpIcvhysuSuFrL5cC4uihRsuYCtncV3Ri/Zjx79cG5tRWUqZ5ZU3SDYYlYW3r9Yhrson4ZQ8I/vfkVQBjbLNKV9vupSa2liWlSObNSPxnUw+0U/NjMJeotVWKvZtQ9DIk/hni/+538NOcliaN7aRpeSD/xt/p1jCRaQkKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Received: from trampoline.thunk.org (pool-173-48-82-222.bstnma.fios.verizon.net [173.48.82.222])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 5320MX1F006609
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 1 Apr 2025 20:22:34 -0400
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 7D6C62E0019; Tue, 01 Apr 2025 20:22:33 -0400 (EDT)
Date: Tue, 1 Apr 2025 20:22:33 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Pavel Reichl <preichl@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
        Andrey Albershteyn <aalbersh@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsprogs: Fix mismatched return type of filesize()
Message-ID: <20250402002233.GA2299061@mit.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 21, 2025 at 07:57:57PM +0100, Pavel Reichl wrote:
> The function filesize() was declared with a return type of 'long' but
> defined with 'off_t'. This mismatch caused build issues due to type
> incompatibility.
> 
> This commit updates the declaration to match the definition, ensuring
> consistency and preventing potential compilation errors.
> 
> Fixes: 73fb78e5ee8 ("mkfs: support copying in large or sparse files")

I had run into this issue when building xfsprogs on i386, and had
investigated the compilation failure before finding this commit in
origin/for-next.  But in my fix, I also found that there was a missing
long -> off_t conversion in setup_proto():

diff --git a/mkfs/proto.c b/mkfs/proto.c
index 7f56a3d8..52ef64ff 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -61,7 +61,7 @@ setup_proto(
 	char		*buf = NULL;
 	static char	dflt[] = "d--755 0 0 $";
 	int		fd;
-	long		size;
+	off_t		size;
 
 	if (!fname)
 		return dflt;

... since setup_proto() also calls filesize():

	if ((fd = open(fname, O_RDONLY)) < 0 || (size = filesize(fd)) < 0) {

How important is it fix this up?  I can send a formal patch if that
would be helpful, but commit a5466cee9874 is certainly enough to fix
the build failure so maybe it's enough.

Cheers,

					- Ted
