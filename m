Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J0aBCc142305 for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 18:36:11 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F1828F1C57F
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 16:37:09 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	170gJLnTNCoZgMEC for <xfs@oss.sgi.com>;
	Mon, 18 Jan 2010 16:37:09 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11561591-1927428
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 11:07:08 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NX25e-0003EW-0a
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:37:02 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NX25d-0003aP-CI
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:37:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/7] xfsprogs: fix warning in adfs superblock probe
Date: Tue, 19 Jan 2010 11:36:48 +1100
Message-Id: <1263861413-13729-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1263861413-13729-1-git-send-email-david@fromorbit.com>
References: <1263861413-13729-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The probe gets an array subscript warning because gcc is not smart
enough to realise that a structure made up of multiple byte arrays
in it can be referenced as a flat buffer and it is valid to access
bytes beyond the first array in the structure....

Fix it by passing the adfs superblock in and using the internal
checksum array to get the checksum value.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libdisk/fstype.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/libdisk/fstype.c b/libdisk/fstype.c
index f84b4e4..548f297 100644
--- a/libdisk/fstype.c
+++ b/libdisk/fstype.c
@@ -142,16 +142,16 @@ may_be_swap(const char *s) {
 
 /* rather weak necessary condition */
 static int
-may_be_adfs(const char *s) {
+may_be_adfs(const struct adfs_super_block *sb) {
 	char *p;
 	int sum;
 
-	p = (char *) s + 511;
+	p = (char *)sb->s_checksum;
 	sum = 0;
-	while(--p != s)
+	while(--p != (char *)sb)
 		sum = (sum >> 8) + (sum & 0xff) + *p;
 
-	return (sum == p[511]);
+	return (sum & 0xff) == sb->s_checksum[0];
 }
 
 static int is_reiserfs_magic_string (struct reiserfs_super_block * rs)
@@ -304,7 +304,7 @@ fstype(const char *device) {
              goto io_error;
 
 	/* only a weak test */
-        if (may_be_adfs((char *) &adfssb)
+        if (may_be_adfs(&adfssb)
             && (adfsblksize(adfssb) >= 8 &&
                 adfsblksize(adfssb) <= 10))
              type = "adfs";
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
