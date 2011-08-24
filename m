Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7OLrxbA113444 for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 16:53:59 -0500
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 0/3] xfsprogs: xfs_quota: a few fixes
Date: Wed, 24 Aug 2011 16:53:40 -0500
Message-Id: <1314222823-24101-1-git-send-email-aelder@sgi.com>
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

The main problem solved in this series is that for project
quotas, the numbers of blocks reported by the xfs_quota "df"
subcommand is twice what it should be.  While looking at
this I also noticed two other problems that I corrected.

Below is a script that demonstrates the problem.

					-Alex

#!/bin/bash

############################################################
# Note that the following clobbers whatever is on /dev/sdk
# It also clobbers files /etc/project and /etc/projid.
# And it uses and then removes /qmnt.
############################################################

# Initialize the filesystem and mount it with project quotas
mkfs.xfs -f /dev/sdk
mkdir -p /qmnt
mount -t xfs -o prjquota /dev/sdk /qmnt

# Set up the project quota configuration files
echo test:1 > /etc/projid
echo 1:/qmnt/test > /etc/projects

# Make the top-level directory, set up quotas on it
mkdir /qmnt/test
xfs_quota -x -c 'project -s test' /qmnt

# Assign block quota limits 
xfs_quota -x -c 'limit -p bsoft=500m bhard=500m test' /qmnt

# The "report" command will show the right numbers
xfs_quota -x -c report /qmnt
# But the "df" command will show doubled block counts
xfs_quota -x -c df /qmnt

# This time using "human readable" output
xfs_quota -x -c 'report -h' /qmnt
xfs_quota -x -c 'df -h' /qmnt

# Clean up
umount /qmnt
rmdir /qmnt
rm /etc/projid /etc/projects

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
