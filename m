Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD2174BF1
	for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2024 21:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710453406; cv=none; b=ffMmNQO8/I8IiWbjxtD8JtG0q0baIVrdDcluK3uhxkWlXc0H3Y0qQtRoqNNuKchuIs++YqXb0MHSh+Bszf0/B0ddR9I5Irju4IDLbBaZIDdhhgqn1YVhI4+NdnKnqb+0UiZ8sNMxkecqGJBn9SJVMI7fOdkFI1Ql6ocEGh5bEhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710453406; c=relaxed/simple;
	bh=2jV4uTU7u240sagn24YXbY+VFmQ79Wt9i8hbhrmOS3o=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=FMIDpjz2uQ55aMdfwg4CjdtxffCqg0xiBsgEWJea132XdbHvgEqMFdsctWWMUdZsOzxW1f1Iufra0Oq9mMjKP751e3PauQCLc3Knv97j3/Vw29PJVues6qZu4T880kUPBIbqqAKT+7qhWpc5OFkULG1eB+54S6iOILR7p1PRMas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ejwGeayA; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ejwGeayA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=JJC6cDJGq7MJygFjk4A2+CGrNfRTMvA9qzOTsHxErFw=; b=ejwGeayAFRCLHNvvClsW9Yv7aT
	7lUejdiYuV7K/Tk7szPWIHZcyEV/QOh+p7FH29AsTqQ4XU/BhOGIapzhdNx+/15O6kYBC5rNCnSax
	MvZhoaz8LFFz3dUEdw3osxZzF7waeN6NqsBP319PdXBIz5EZZO+fKzwE/XJSp8Yiy+0CD4dQjxiwa
	VtQaA2X1ysKckErajOsM8dYZX4Sw2QDAe3zaCwD8KibmY06Kahh+BldX0OZzgWDfwlKayYrFPpfRP
	IVXuYzfuk2vmZnGmxvT3y7IdWOpHB5o/wXzx8I6tr9DL0UqvHjvjJy8IOoGmthZvboDHZhBM6E6H8
	Vr5RHP5Q==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkt44-00000008lpF-3xIt;
	Thu, 14 Mar 2024 21:56:41 +0000
Date: Thu, 14 Mar 2024 21:56:40 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] Remove duplicate definitions in xfsprogs
Message-ID: <ZfNymFxNLL9gtybv@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This is userspace.  I have no idea what I'm doing.

Building on current Debian testing gives:

/usr/bin/ld: ../libxlog/.libs/libxlog.a(util.o):xfsprogs/libxlog/util.c:25: multiple definition of `x'; init.o:xfsprogs/db/init.c:42: first defined here

and

/usr/bin/ld: ../libxfs/.libs/libxfs.a(init.o):xfsprogs/libxfs/init.c:39: multiple definition of `progname'; xfs_mdrestore.o:xfsprogs/mdrestore/xfs_mdrestore.c:22: first defined here

It seems to me that xfsprogs was relying on the linker to merge
duplicate definitions, and now the linker is declining to do so?

Feel free to split this up into individual patches, or whatever
seems best ...

diff --git a/db/init.c b/db/init.c
index b108a06cfe..42757e44c6 100644
--- a/db/init.c
+++ b/db/init.c
@@ -39,7 +39,6 @@ int			force;
 struct xfs_mount	xmount;
 struct xfs_mount	*mp;
 struct xlog		xlog;
-libxfs_init_t		x;
 xfs_agnumber_t		cur_agno = NULLAGNUMBER;
 
 static void
diff --git a/logprint/logprint.c b/logprint/logprint.c
index 37b8cb9116..a14ba185a5 100644
--- a/logprint/logprint.c
+++ b/logprint/logprint.c
@@ -36,7 +36,6 @@ int	print_buffer;
 int	print_overwrite;
 int     print_no_data;
 int     print_no_print;
-int     print_exit = 1; /* -e is now default. specify -c to override */
 int	print_operation = OP_PRINT;
 
 void
@@ -146,6 +145,7 @@ main(int argc, char **argv)
 	memset(&mount, 0, sizeof(mount));
 
 	progname = basename(argv[0]);
+	print_exit = 1; /* -e is now default. specify -c to override */
 	while ((c = getopt(argc, argv, "bC:cdefl:iqnors:tDVv")) != EOF) {
 		switch (c) {
 			case 'D':
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index c9d4b0c149..90383f6744 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -19,7 +19,6 @@
 #include "libxfs.h"
 #include "xfs_metadump.h"
 
-char 		*progname;
 int		show_progress = 0;
 int		show_info = 0;
 int		progress_since_warning = 0;
