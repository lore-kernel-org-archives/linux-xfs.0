Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BC5877F3F
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 05:38:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 65328304081
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 03:38:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YdHwZM7fZI1nO8S0 for
	<xfs@oss.sgi.com>; Thu, 11 Jul 2013 03:38:12 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r6BAcCtN015006
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 06:38:12 -0400
From: Lukas Czerner <lczerner@redhat.com>
Subject: [RFC][PATCH 00/10 v2] xfstests: Add support for config section
Date: Thu, 11 Jul 2013 12:37:55 +0200
Message-Id: <1373539085-8577-1-git-send-email-lczerner@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: lczerner@redhat.com

This patch set adds support for sections in the configuration file
while maintaining unchanged behaviour when no sections are present in the
configuration file, or no configuration file is provided.

V2: Recreate test list when FSTYP changed between sections


Explanation, syntax and example follows.


Configuration file with sections
================================

Configuration file with sections is useful for running xfstests on multiple
file systems, or multiple file system setups in a single run without any
help of external scripts.


Syntax
------

Syntax for defining a section is the following:

	[section_name]

Section name should consist of alphanumeric characters and '_'. Anything
else is forbidden and the section will not be recognised.

Each section in the configuration file should contain options in the format

	OPTION=value

'OPTION' must not contain any white space characters. 'value' can contain
any character you want with one simple limitation - characters ' and " can
only appear at the start and end of the 'value', however it is not required.

Note that options are carried between sections so the same options does not
have to be specified in each and every sections. However caution should be
exercised not to leave unwanted options set from previous sections.


Results
-------

For every section xfstests will run with specified options and will produce
separate results in the '$RESULT_BASE/$section_name' directory.


Different mount options
-----------------------

Specifying different mount options in difference config sections is allowed.
When MOUNT_OPTIONS differs in the following section TEST_DEV will be remounted
with new MOUNT_OPTIONS automatically before running the test.


Multiple file systems
---------------------

Having different file systems in different config sections is allowed. When
FSTYP differs in the following section the FSTYP file system will be created
automatically before running the test.

Note that if MOUNT_OPTIONS, MKFS_OPTIONS, or FSCK_OPTIONS are not directly
specified in the section it will be reset to the default for a given file
system.

You can also force the file system recreation by specifying RECREATE_TEST_DEV.


Example
-------

Here is an example of config file with sections:

[ext4_4k_block_size]
TEST_DEV=/dev/sda
TEST_DIR=/mnt/test
SCRATCH_DEV=/dev/sdb
SCRATCH_MNT=/mnt/test1
MKFS_OPTIONS="-q -F -b4096"
FSTYP=ext4
RESULT_BASE="`pwd`/results/`date +%d%m%y_%H%M%S`"

[ext4_1k_block_size]
MKFS_OPTIONS="-q -F -b1024"

[ext4_nojournal]
MKFS_OPTIONS="-q -F -b4096 -O ^has_journal"

[xfs_filesystem]
MKFS_OPTIONS="-f"
FSTYP=xfs

[ext3_filesystem]
FSTYP=ext3
MOUNT_OPTIONS="-o noatime"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
