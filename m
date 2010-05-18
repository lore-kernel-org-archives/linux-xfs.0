Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4INY7ss083570 for <xfs@oss.sgi.com>; Tue, 18 May 2010 18:34:09 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DC4891299E78
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 16:37:30 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id cchkvuCdp7vUJWev for <xfs@oss.sgi.com>;
	Tue, 18 May 2010 16:37:30 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: Quota tests for XFSQA
Date: Wed, 19 May 2010 01:36:13 +0200
Message-Id: <1274225776-26987-1-git-send-email-jack@suse.cz>
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
Cc: hch@infradead.org


  Hi,

  in this series are three tests I have written (basically gathered from
various scripts) for XFSQA. The test quota accounting and also limits
basic enforcement for VFS quotas (i.e. mainly ext? filesystems). Could
the tests be included?

I'd like to add two more tests (fsstress running under 'nobody' with quota
limits tightly set so that we get often EDQUOT failures) and a test where
setquota would be stressing addition and removal of quota structures.
Hopefully I'll get to it later this week.

								Honza

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
