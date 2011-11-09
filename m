Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA9GsDl8239061 for <xfs@oss.sgi.com>; Wed, 9 Nov 2011 10:54:13 -0600
Received: from hades.usersys.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A30116D29B2
	for <xfs@oss.sgi.com>; Wed,  9 Nov 2011 08:54:11 -0800 (PST)
Received: from hades.usersys.redhat.com ([187.60.101.4]) by cuda.sgi.com with
	ESMTP id w3hvpQzAIVRGc1ei for <xfs@oss.sgi.com>;
	Wed, 09 Nov 2011 08:54:11 -0800 (PST)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 0/2] Set lost+found inode as used after its allocation 
Date: Wed,  9 Nov 2011 14:54:05 -0200
Message-Id: <1320857647-25511-1-git-send-email-cmaiolino@redhat.com>
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
Cc: Carlos Maiolino <cmaiolino@redhat.com>

This patch set ensure the inode allocated to the lost+found directory is
set as used in AVL tree if it needs to be created (in case no lost+found
directory is already created on the disk). Also, I added a new inline
function to get AVL tree node offset which currently is being calculated
whenever the offset is needed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
