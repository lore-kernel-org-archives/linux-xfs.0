Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E23D17F37
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 11:43:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BA1BC8F8035
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 09:43:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WKT4iwLxgs3aiaVC for
	<xfs@oss.sgi.com>; Mon, 14 Apr 2014 09:43:16 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3EGhFcS004366
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 12:43:15 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s3EGhFmt007950
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 12:43:15 -0400
Date: Mon, 14 Apr 2014 12:43:14 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: xfs readdir hang on for-next (3.15.0-rc1)
Message-ID: <20140414164313.GA62307@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Hi all,

This is a heads up that I'm seeing a blatant readdir hang on the current
for-next with selinux enabled. To reproduce, I format a clean fs, mount
and attempt an ls.

The problem does not occur with selinux disabled, if I back out the
following commit:

40194ecc6d78 xfs: reinstate the ilock in xfs_readdir

... or if I remove the locking around xfs_attr_get(), so I suspect this
is another instance of a recursive deadlock. I'm getting no output
whatsoever in order to confirm this and it also leads to a complete
system lockup. It's also interesting that this hasn't been observed
until now, given the above commit was introduced in 3.14. So the above
commit doesn't appear to be the most recent change that triggers this.

I reproduced on the latest linus tree and do not reproduce on 3.14, so
I'm trying to do a bisect to find out what else might have changed to
trigger this.

Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
