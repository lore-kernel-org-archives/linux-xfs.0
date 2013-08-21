Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BFC2D7F95
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 00:08:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5C5A3AC001
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 22:08:50 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 8YBDJDnuJJGTSAfj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 20 Aug 2013 22:08:49 -0700 (PDT)
Date: Wed, 21 Aug 2013 01:08:22 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: Re: linux-next: build failure after merge of the final tree
Message-ID: <20130821010822.220f592a@oracle.com>
In-Reply-To: <201308202246.30869.arnd@arndb.de>
References: <20130820172052.1f0d89ddf6a1a40ef70333fd@canb.auug.org.au>
	<20130820120702.000b044e@oracle.com>
	<201308202246.30869.arnd@arndb.de>
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
To: Arnd Bergmann <arnd@arndb.de>
Cc: cbe-oss-dev@lists.ozlabs.org, Stephen Rothwell <sfr@canb.auug.org.au>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, linux-next@vger.kernel.org, Gao feng <gaofeng@cn.fujitsu.com>, linuxppc-dev@lists.ozlabs.org, Jeremy Kerr <jk@ozlabs.org>

On Tue, 20 Aug 2013 22:46:30 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Tuesday 20 August 2013, Dwight Engen wrote:
> > diff --git a/arch/powerpc/platforms/cell/spufs/inode.c
> > b/arch/powerpc/platforms/cell/spufs/inode.c index f390042..90fb308
> > 100644 --- a/arch/powerpc/platforms/cell/spufs/inode.c
> > +++ b/arch/powerpc/platforms/cell/spufs/inode.c
> > @@ -620,12 +620,12 @@ spufs_parse_options(struct super_block *sb,
> > char *options, struct inode *root) case Opt_uid:
> >                         if (match_int(&args[0], &option))
> >                                 return 0;
> > -                       root->i_uid = option;
> > +                       root->i_uid = make_kuid(&init_user_ns,
> > option); break;
> >                 case Opt_gid:
> >                         if (match_int(&args[0], &option))
> >                                 return 0;
> > -                       root->i_gid = option;
> > +                       root->i_gid = make_kgid(&init_user_ns,
> > option); break;
> >                 case Opt_mode:
> >                         if (match_octal(&args[0], &option))
> 
> Doesn't this mean the uid/gid is taken from the initial namespace
> rather than from the namespace of the 'mount' process calling this? I
> think the logical choice would be to have the UID be the one that
> gets passed here in the caller's namespace.

Yes, I agree. The other filesystems that take an Opt_uid as well do use
current_user_ns() and not init_user_ns. They also do a uid_valid()
check and fail the mount (or fallback to GLOBAL_ROOT_UID). So I think
that would look like this:

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index f390042..87ba7cf 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -620,12 +620,16 @@ spufs_parse_options(struct super_block *sb, char *options, struct inode *root)
                case Opt_uid:
                        if (match_int(&args[0], &option))
                                return 0;
-                       root->i_uid = option;
+                       root->i_uid = make_kuid(current_user_ns(), option);
+                       if (!uid_valid(root->i_uid))
+                               return 0;
                        break;
                case Opt_gid:
                        if (match_int(&args[0], &option))
                                return 0;
-                       root->i_gid = option;
+                       root->i_gid = make_kgid(current_user_ns(), option);
+                       if (!gid_valid(root->i_gid))
+                               return 0;
                        break;
                case Opt_mode:
                        if (match_octal(&args[0], &option))

Again, I have not run tested this so we may just want to disable SPU_FS
with USER_NS until they can be tested together.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
