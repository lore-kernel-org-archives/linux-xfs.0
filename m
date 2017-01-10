Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20997 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756039AbdAJWxJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jan 2017 17:53:09 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v0AMr731027333
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 10 Jan 2017 22:53:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v0AMr6DM011507
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 10 Jan 2017 22:53:06 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v0AMr66Z031223
        for <linux-xfs@vger.kernel.org>; Tue, 10 Jan 2017 22:53:06 GMT
Date: Tue, 10 Jan 2017 14:53:05 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] docs: clarify what the ATTRBIT and ATTR2BIT feature flags do
Message-ID: <20170110225305.GN14038@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

It would seem that the disk format doesn't actually change depending on
ATTRBIT and ATTR2BIT.  The key difference is that ATTR2BIT (without the
'noattr2' mount option) allows di_forkoff to change depending on how
much space the attr fork needs, whereas ATTRBIT (without ATTR2BIT or
the 'attr2' mount option) does not allow di_forkoff to change.

In other words, at least one of the bits must be set if there are
extended attributes, but between the two bits the only difference is a
change in the default di_forkoff adjustment behaviors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../allocation_groups.asciidoc                     |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index 51ca57d..68f934a 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -174,7 +174,13 @@ indicate features introduced over time. If the value of the lower nibble is >=
 [options="header"]
 |=====
 | Flag				| Description
-| +XFS_SB_VERSION_ATTRBIT+	| Set if any inode have extended attributes.
+| +XFS_SB_VERSION_ATTRBIT+	|
+Set if any inode have extended attributes.  If this bit is set; the
++XFS_SB_VERSION2_ATTR2BIT+ is not set; and the +attr2+ mount flag is not
+specified, the +di_forkoff+ inode field will not be dynamically adjusted.
+See the section about xref:Extended_Attribute_Versions[extended attribute
+versions] for more information.
+
 | +XFS_SB_VERSION_NLINKBIT+	| Set if any inodes use 32-bit di_nlink values.
 | +XFS_SB_VERSION_QUOTABIT+	|
 Quotas are enabled on the filesystem. This
@@ -335,10 +341,11 @@ performance. The global free space and inode counts are only updated in the
 primary superblock when the filesystem is cleanly unmounted.
 
 | +XFS_SB_VERSION2_ATTR2BIT+	|
-Extended attributes version 2. Making a filesystem with this optimises the inode
-layout of extended attributes.  See the section about
-xref:Extended_Attribute_Versions[extended attribute versions] for more
-information.
+Extended attributes version 2. Making a filesystem with this optimises the
+inode layout of extended attributes.  If this bit is set and the +noattr2+
+mount flag is not specified, the +di_forkoff+ inode field will be dynamically
+adjusted.  See the section about xref:Extended_Attribute_Versions[extended
+attribute versions] for more information.
 
 | +XFS_SB_VERSION2_PARENTBIT+	|
 Parent pointers. All inodes must have an extended attribute that points back to
