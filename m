Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2IJRUL4051696 for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 14:27:35 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6697813DA1AA
	for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 12:30:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tOYZoqMr3nfrETIl for
	<xfs@oss.sgi.com>; Fri, 18 Mar 2011 12:30:26 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p2IJUPwh026585
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 15:30:26 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id p2IJUOSE013501
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 15:30:25 -0400
Message-ID: <4D83B2D0.1030607@redhat.com>
Date: Fri, 18 Mar 2011 14:30:24 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: ensure selinux xattrs don't interfere with quota
	tests
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

219 and 235 were failing on ext3 with selinux, because the extra
xattrs upped the quota usage.

Do the same trick we've used in the past to mount with an selinux
global context when doing quota tests.

Note the gross hack for remount,ro, though.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/235 b/235
index 5d9c7c0..de0d0fc 100755
--- a/235
+++ b/235
@@ -61,6 +61,11 @@ chown $qa_user:$qa_user $SCRATCH_MNT/testfile
 
 repquota -u -g $SCRATCH_MNT  | grep -v "^root" | _filter_scratch
 
+# XXX This is a nasty hack.  remount doesn't work on a fileystem
+# with a context; see https://bugzilla.redhat.com/show_bug.cgi?id=563267
+#
+# We work around it by editing the context out of mtab.  Sigh.
+sed -i "s#^$SCRATCH_DEV\(.*\),context=\"system_u:object_r:nfs_t:s0\"#$SCRATCH_DEV\1#" /etc/mtab
 mount -o remount,ro $SCRATCH_DEV 2>&1 | tee -a $seq.full | _filter_scratch
 touch $SCRATCH_MNT/failed 2>&1 | tee -a $seq.full | _filter_scratch
 mount -o remount,rw $SCRATCH_DEV 2>&1 | tee -a $seq.full | _filter_scratch
diff --git a/common.quota b/common.quota
index 96a36a6..3c87ce1 100644
--- a/common.quota
+++ b/common.quota
@@ -45,6 +45,13 @@ _require_quota()
 	_notrun "disk quotas not supported by this filesystem type: $FSTYP"
 	;;
     esac
+
+    # SELinux adds extra xattrs which can mess up our expected output.
+    # So, mount with a context, and they won't be created
+    # nfs_t is a "liberal" context so we can use it.
+    if [ -x /usr/sbin/selinuxenabled ] && /usr/sbin/selinuxenabled; then
+        export SELINUX_MOUNT_OPTIONS="-o context=system_u:object_r:nfs_t:s0"
+    fi
 }
 
 #

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
