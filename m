Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9CHYHYT078440 for <xfs@oss.sgi.com>; Wed, 12 Oct 2011 12:34:17 -0500
Received: from xmail.sgi.com (pv-excas3-dc21.corp.sgi.com [137.38.102.206])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 882F8AC008
	for <xfs@oss.sgi.com>; Wed, 12 Oct 2011 10:34:13 -0700 (PDT)
Subject: XFS "master" branch re-based
From: Alex Elder <aelder@sgi.com>
Date: Wed, 12 Oct 2011 12:34:10 -0500
Message-ID: <1318440850.2918.33.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: xfs@oss.sgi.com

The XFS master branch on oss.sgi.com has been re-based.
Commits made since the branch was last updated to
Linux v3.1-rc1 have been changed to be based on
Linux v3.1-rc9.

As a result, if you have any local branches tracking
the XFS master branch, a simple "pull" command will
not likely give the result you want.

The following command will forcibly update a local
branch named "xfs-master" to match what's in the
repository on oss.sgi.com.

    git pull -f git://oss.sgi.com/xfs/xfs.git \
        master:xfs-master

Another branch named "master-pre-3.1-rc9-rebase"
has been created in order to preserve the commits
that had been published prior to this rebase.

					-Alex




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
