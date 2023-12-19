Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C811BDD8
	for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2023 14:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2FB2768BFE; Tue, 19 Dec 2023 15:46:28 +0100 (CET)
Date: Tue, 19 Dec 2023 15:46:27 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs: remove xfs_attr_shortform_lookup
Message-ID: <20231219144627.GA1477@lst.de>
References: <20231219120817.923421-1-hch@lst.de> <20231219120817.923421-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231219120817.923421-6-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

So, the buildbot rightly complained that this can return an
uninitialized error variable in xfs_attr_shortform_addname now
(why are we disabling the goddam use of uninitialized variable
warnings in Linux again, sigh..).

I then not only created the trivial fix, but also wrote a simple wrapper
for the setxattr syscall as the existing setfattr and attr tools don't
allow to control the flag, which I assumed means xfstests didn't really
test this as much as it should.  But that little test showed we're still
getting the right errno values even with the unininitialized variable
returns, which seemed odd.

It turns out we're not even exercising this code any more, as
xfs_attr_set already does a xfs_attr_lookup lookup first and has a
copy of this logic executed much earlier (and I should have really though
about that because I got very close to that code for the defer ops
cleanup).

So..  I'm tempted to just turn these checks into asserts with something
like the below on top of this patch, I'll just need to see if it survives
testing:

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index d6173888ed0d56..abdc58f286154a 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1066,13 +1066,13 @@ xfs_attr_shortform_addname(
 	struct xfs_da_args	*args)
 {
 	int			newsize, forkoff;
-	int			error;
 
 	trace_xfs_attr_sf_addname(args);
 
 	if (xfs_attr_sf_findname(args)) {
-		if (!(args->op_flags & XFS_DA_OP_REPLACE))
-			return error;
+		int		error;
+
+		ASSERT(args->op_flags & XFS_DA_OP_REPLACE);
 
 		error = xfs_attr_sf_removename(args);
 		if (error)
@@ -1086,8 +1086,7 @@ xfs_attr_shortform_addname(
 		 */
 		args->op_flags &= ~XFS_DA_OP_REPLACE;
 	} else {
-		if (args->op_flags & XFS_DA_OP_REPLACE)
-			return error;
+		ASSERT(!(args->op_flags & XFS_DA_OP_REPLACE));
 	}
 
 	if (args->namelen >= XFS_ATTR_SF_ENTSIZE_MAX ||

