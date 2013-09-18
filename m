Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9D1C729E10
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 16:17:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2FFEFAC004
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 14:17:58 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	DrCOlGLOk34be8zd for <xfs@oss.sgi.com>;
	Wed, 18 Sep 2013 14:17:56 -0700 (PDT)
Date: Thu, 19 Sep 2013 07:17:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: initialize filetype for lost+found creation
Message-ID: <20130918211753.GC4330@dastard>
References: <52388C61.1000001@sandeen.net> <523A135D.7030509@sgi.com>
	<523A156A.5040502@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <523A156A.5040502@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Sep 18, 2013 at 04:04:42PM -0500, Eric Sandeen wrote:
> On 9/18/13 3:55 PM, Mark Tinguely wrote:
> > On 09/17/13 12:07, Eric Sandeen wrote:
> >> If we create lost+found make sure it's got the proper filetype.
> >>
> >> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> >> ---
> >>
> >> (sorry, untested, not sure how to force creation when I can't use
> >> xfs_db to craft a filesystem that needs lost+found)
> > 
> > The {lib}xfs_dir_lookup() doesn't use the field - just like extended attributes use xfs_names but it won't use the field entry, but it does not hurt to have it initialized to something.
> 
> Thanks for the review - just FWIW, I was thinking that it needs
> to be initialized so that when created, it is created with the proper
> type, rather than random stack noise.
> 
> It seems, though, that we're still missing bits in libxfs to actually
> write the types to disk; I'll look into that.

Patch below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


libxfs: fix missing filetype updates to xfs_dir2.c

From: Dave Chinner <dchinner@redhat.com>

They were missed in the original patch that was committed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_dir2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 010c701..96a3c1d 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -194,6 +194,7 @@ xfs_dir_createname(
 	memset(&args, 0, sizeof(xfs_da_args_t));
 	args.name = name->name;
 	args.namelen = name->len;
+	args.filetype = name->type;
 	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args.inumber = inum;
 	args.dp = dp;
@@ -268,6 +269,7 @@ xfs_dir_lookup(
 	memset(&args, 0, sizeof(xfs_da_args_t));
 	args.name = name->name;
 	args.namelen = name->len;
+	args.filetype = name->type;
 	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args.dp = dp;
 	args.whichfork = XFS_DATA_FORK;
@@ -323,6 +325,7 @@ xfs_dir_removename(
 	memset(&args, 0, sizeof(xfs_da_args_t));
 	args.name = name->name;
 	args.namelen = name->len;
+	args.filetype = name->type;
 	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args.inumber = ino;
 	args.dp = dp;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
