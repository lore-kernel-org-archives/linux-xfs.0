Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D67E67CBF
	for <xfs@oss.sgi.com>; Fri,  5 Jul 2013 23:45:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6268EAC003
	for <xfs@oss.sgi.com>; Fri,  5 Jul 2013 21:45:01 -0700 (PDT)
Received: from youngberry.canonical.com (youngberry.canonical.com
	[91.189.89.112]) by cuda.sgi.com with ESMTP id FrSzhaapNxiJoxVI
	for <xfs@oss.sgi.com>; Fri, 05 Jul 2013 21:44:59 -0700 (PDT)
Date: Fri, 5 Jul 2013 23:44:50 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: [PATCH 1/1] export inode_capable
Message-ID: <20130706044450.GA5402@tp>
References: <20130619110948.0bfafa2b@oracle.com>
	<20130620001341.GM29338@dastard>
	<20130620095410.1917d235@oracle.com>
	<20130620220311.GT29376@dastard>
	<20130621111420.5592707e@oracle.com>
	<20130624003316.GH29376@dastard>
	<20130624091035.6274800f@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130624091035.6274800f@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: "Eric W. Biederman" <ebiederm@gmail.com>, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

Hi Dwight,

as I mentioned earlier I did need this patch to build with xfs=m.  But
other than that, I've got a kernel built using your patchset (full src at
http://kernel.ubuntu.com/git?p=serge/ubuntu-saucy.git;a=summary) and
was able to start a user ns container with that kernel.  I'll use that
kernel for some more regular lxc testing next week.

Thanks!

Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
---
 kernel/capability.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/capability.c b/kernel/capability.c
index f6c2ce5..a04f86f 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -464,3 +464,5 @@ bool inode_capable(const struct inode *inode, int cap)
 
 	return ns_capable(ns, cap) && kuid_has_mapping(ns, inode->i_uid);
 }
+
+EXPORT_SYMBOL_GPL(inode_capable);
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
