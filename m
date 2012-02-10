Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1AG4JLL006362 for <xfs@oss.sgi.com>; Fri, 10 Feb 2012 10:04:19 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id k5F5CQEoZvAZHGT7 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Feb 2012 08:04:17 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4] Generic O_SYNC AIO DIO handling
Date: Fri, 10 Feb 2012 17:03:58 +0100
Message-Id: <1328889842-23231-1-git-send-email-jack@suse.cz>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: cluster-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com


  Hi Jeff,

  these patches implement generic way of handling O_SYNC AIO DIO. They work
for all filesystems except for ext4 and xfs. Thus together with your patches,
all filesystems should handle O_SYNC AIO DIO correctly. I've tested ext3,
btrfs, and xfs (to check that I didn't break anything when the generic code
is unused) and things seem to work fine. Will you add these patches to your
series please? Thanks.

								Honza

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
