Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC377F7D3
	for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2024 22:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718834947; cv=none; b=IizXA/gA1afhnijfomSj80SSr9NydX5QdpbUXSpxtg6yyVmH+il+gwxt6gW3VO9uFOCScvGHuPcV9Wf1EB6GbQLym2UpXB/iyoRmDQt5CVGYLJZCIaccpm9aapGtoaPfUDbSaH6zIpXTfsQdJ2n3HKibfoU8gRK9yaKvnkXW8r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718834947; c=relaxed/simple;
	bh=UhbIfLF1iydY66hrLtq7za0/hHRvB/ju4rQPFeUHr9Y=;
	h=Content-Disposition:MIME-Version:Content-Type:From:To:CC:Subject:
	 Message-ID:References:Date; b=iFs8TCJzlCHX7AyVwIirrjHd+byCYW2hg8OyNwe8bkX//OsK60geZYNOsO5rDvx9GVrtqv5TzikBE2U/qViOXAvqqfWYhVy5ObNJrWjKjSN58mxg8OkqUlJGRHWHLfTFcWy8aQu/+qOGCj1HJjKYpNnfMTf+gwHz6P1LIg9ssog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org; spf=none smtp.mailfrom=buxtehude.debian.org; dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b=U3Rw0syC; arc=none smtp.client-ip=209.87.16.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=buxtehude.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b="U3Rw0syC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
	:CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
	Content-ID:Content-Description:In-Reply-To;
	bh=UhbIfLF1iydY66hrLtq7za0/hHRvB/ju4rQPFeUHr9Y=; b=U3Rw0syCLwZi2x05kycpvi2Sw7
	XIynjOYPjWRph3kAPT2STbgf8V2wRjP5gedbVkhmCZb3FdPsBaxZ4EP9NgMcvLKKWwuFfDLqEQe3l
	41dPv/EMnwGhxITf7PaZaOpxPHWFbIACRyxuvt/MgmyVW7gu4zS4unL6bUDfJs9ifD6CEwdVDFPQe
	kRXPa7iIe+Hfh1ZWtHEROHHZCsgMwzL3w1JLcQopAL5aU/EpmlP0dXFNoq2ZuZrGDDvfucYfWrQhQ
	ulUGRoalllyYVn5wNHw6SJQmH8jBGcDFCC7uaEa5IbDfR6w75Xa+N90fUoByTqn1zaXgLEM2LE8BH
	UFc7atQg==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.94.2)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1sK3UG-00BwKi-Qw; Wed, 19 Jun 2024 22:09:04 +0000
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
Content-Type: text/plain; charset=utf-8
From: "Debian Bug Tracking System" <owner@bugs.debian.org>
To: Chris Hofstaedtler <zeha@debian.org>
CC: linux-xfs@vger.kernel.org
Subject: Processed: xfsprogs: diff for NMU version 6.8.0-2.2
Message-ID: <handler.s.B1073831.17188347522843853.transcript@bugs.debian.org>
References: <20240619220547.sjywgljd2ziwxjh6@debian.org>
 <20240619112859.26ekvlxkt4sb5jt2@debian>
X-Debian-PR-Package: xfslibs-dev
X-Debian-PR-Source: xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date: Wed, 19 Jun 2024 22:09:04 +0000

Processing control commands:

> tags 1073831 + patch
Bug #1073831 [xfslibs-dev] xfsdump:FATAL ERROR: could not find a current XF=
S handle library
Added tag(s) patch.
> tags 1073831 + pending
Bug #1073831 [xfslibs-dev] xfsdump:FATAL ERROR: could not find a current XF=
S handle library
Added tag(s) pending.
> affects -1 + src:partclone
Bug #1073831 [xfslibs-dev] xfsdump:FATAL ERROR: could not find a current XF=
S handle library
Added indication that 1073831 affects src:partclone

--=20
1073831: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1073831
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
