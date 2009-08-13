Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7DCbW77020987 for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 07:37:42 -0500
Received: from mail.bgs.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id B07583C741A
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 05:37:49 -0700 (PDT)
Received: from mail.bgs.hu (bgs.hu [195.228.254.245]) by cuda.sgi.com with
	SMTP id 1PH8LZEdUsGU5ASP for <xfs@oss.sgi.com>;
	Thu, 13 Aug 2009 05:37:49 -0700 (PDT)
Message-ID: <4A84090A.6040601@bgs.hu>
Date: Thu, 13 Aug 2009 14:37:30 +0200
From: Bgs <bgs@bgs.hu>
MIME-Version: 1.0
Subject: fs change on read-only mount
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
To: SGI Project XFS mailing list <xfs@oss.sgi.com>


 Greetings,

I don't know xfs' superblock handling well enough, so I'm asking for
advice here:

Does xfs write anything on the disk when mounting read-only? Is it
possible to use a partitions hash (or some well defined portion of the
partition) for integrity checks?

The partitions are used read-only and hash would be re-generated  if any
rw action was done (after remount ro or full reboot of course). Can this
be done? I'm concerned about 'mount count' like writes...

Thanks in advance
Bgs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
