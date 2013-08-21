Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F0B3A7FB4
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 13:36:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DA80E30408C
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 11:36:29 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id fBWoyjwi0OokzxqX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 21 Aug 2013 11:36:29 -0700 (PDT)
Date: Wed, 21 Aug 2013 14:33:51 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH] powerpc/spufs: convert userns uid/gid mount options to
	kuid/kgid
Message-ID: <20130821143351.5840d556@oracle.com>
In-Reply-To: <20130821155654.GI5262@sgi.com>
References: <20130820172052.1f0d89ddf6a1a40ef70333fd@canb.auug.org.au>
	<20130820120702.000b044e@oracle.com>
	<201308202246.30869.arnd@arndb.de>
	<20130821010822.220f592a@oracle.com> <52145E6C.80404@ozlabs.org>
	<20130821155654.GI5262@sgi.com>
Mime-Version: 1.0
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
To: Ben Myers <bpm@sgi.com>
Cc: cbe-oss-dev@lists.ozlabs.org, Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-next@vger.kernel.org, Jeremy Kerr <jk@ozlabs.org>, linuxppc-dev@lists.ozlabs.org, Gao feng <gaofeng@cn.fujitsu.com>

Acked-by: Jeremy Kerr <jk@ozlabs.org>
Tested-by: Jeremy Kerr <jk@ozlabs.org>
Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
---
 arch/powerpc/platforms/cell/spufs/inode.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index f390042..87ba7cf 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -620,12 +620,16 @@ spufs_parse_options(struct super_block *sb, char *options, struct inode *root)
 		case Opt_uid:
 			if (match_int(&args[0], &option))
 				return 0;
-			root->i_uid = option;
+			root->i_uid = make_kuid(current_user_ns(), option);
+			if (!uid_valid(root->i_uid))
+				return 0;
 			break;
 		case Opt_gid:
 			if (match_int(&args[0], &option))
 				return 0;
-			root->i_gid = option;
+			root->i_gid = make_kgid(current_user_ns(), option);
+			if (!gid_valid(root->i_gid))
+				return 0;
 			break;
 		case Opt_mode:
 			if (match_octal(&args[0], &option))
-- 
1.8.1.4

On Wed, 21 Aug 2013 10:56:54 -0500
Ben Myers <bpm@sgi.com> wrote:

> Hey Dwight,
> 
> On Wed, Aug 21, 2013 at 02:30:04PM +0800, Jeremy Kerr wrote:
> > > Yes, I agree. The other filesystems that take an Opt_uid as well
> > > do use current_user_ns() and not init_user_ns. They also do a
> > > uid_valid() check and fail the mount (or fallback to
> > > GLOBAL_ROOT_UID). So I think that would look like this:
> > 
> > Looks good to me. Builds and mounts as expected.
> > 
> > Acked-by: Jeremy Kerr <jk@ozlabs.org>
> 
> Could you repost this patch with the right subject and a commit
> header?  Given Jeremy's Ack I think we could proceed to pull this in.

Sure, I just wanted to make sure someone had tested it first, which it
looks like Jeremy did, thanks.

> Regards,
> 	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
