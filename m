Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A30817F51
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 11:26:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2F602AC004
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 09:26:44 -0700 (PDT)
Received: from youngberry.canonical.com (youngberry.canonical.com
	[91.189.89.112]) by cuda.sgi.com with ESMTP id vD4zvKKmuNBEW6oL
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 09:26:41 -0700 (PDT)
Message-ID: <53D91CBC.1000901@canonical.com>
Date: Wed, 30 Jul 2014 12:26:36 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
MIME-Version: 1.0
Subject: [PATCH][v3.2.y] xfs: really fix the cursor leak in
	xfs_alloc_ag_vextent_near
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
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, "stable@vger.kernel.org" <stable@vger.kernel.org>, xfs@oss.sgi.com

Hello,
    
Please consider including mainline commit
e3a746f5aab71f2dd0a83116772922fb37ae29d6 in the next v3.2.y release.  It
was included in the mainline tree as of v3.5.  It has been tested and
confirmed
to resolve http://bugs.launchpad.net/bugs/1327360 .


commit e3a746f5aab71f2dd0a83116772922fb37ae29d6
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Jul 12 07:40:42 2012 +1000

    xfs: really fix the cursor leak in xfs_alloc_ag_vextent_near


Sincerely,
Joseph Salisbury

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
