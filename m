Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p96KBj65199494 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 15:11:46 -0500
Received: from mailout.mucip.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 10A5C16B7774
	for <xfs@oss.sgi.com>; Thu,  6 Oct 2011 13:02:00 -0700 (PDT)
Received: from mailout.mucip.net (mail.svr02.mucip.net [83.170.6.69]) by
	cuda.sgi.com with ESMTP id k0GMNc3DiObGrbTS for
	<xfs@oss.sgi.com>; Thu, 06 Oct 2011 13:02:00 -0700 (PDT)
Received: from localhost (mail.svr02.mucip.net [127.0.0.1])
	by mailout.mucip.net (Postfix) with ESMTP id E2CC9CFC
	for <xfs@oss.sgi.com>; Thu,  6 Oct 2011 21:55:08 +0200 (CEST)
Received: from mailout.mucip.net ([127.0.0.1])
	by localhost (mail.svr02.mucip.net [127.0.0.1]) (amavisd-new,
	port 10125) with ESMTP id 8-gu7Q5RYwz4 for <xfs@oss.sgi.com>;
	Thu,  6 Oct 2011 21:55:08 +0200 (CEST)
Message-ID: <4E8E079B.4040103@birkenwald.de>
Date: Thu, 06 Oct 2011 21:55:07 +0200
From: Bernhard Schmidt <berni@birkenwald.de>
MIME-Version: 1.0
Subject: Premature "No Space left on device" on XFS
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

this is an XFS-related summary of a problem report I sent to the postfix 
mailinglist a few minutes ago after a bulkmail test system blew up 
during a stress test.

We have a few MTAs running SLES11.1 amd64 (2.6.32.45-0.3-default), 10 GB 
XFS Spooldirectory with default blocksize (4k). It was bombarded with 
mails faster than it could send them on, which eventually led to almost 
2 million files of ~1.5kB in one directory. Suddenly, this started to happen

lxmhs45:/var/spool/postfix-bulk/postfix-bulkinhss # touch a
touch: cannot touch `a': No space left on device
lxmhs45:/var/spool/postfix-bulk/postfix-bulkinhss # df .
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sdb              10475520   7471160   3004360  72% 
/var/spool/postfix-bulk
lxmhs45:/var/spool/postfix-bulk/postfix-bulkinhss # df -i .
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/sdb             10485760 1742528 8743232   17% /var/spool/postfix-bulk

So we could not create any file in the spool directory anymore despite 
df claiming to have both free blocks and inodes. This led to a pretty 
spectacular lockup of the mail processing chain.

My theory is that XFS is using a full 4k block for each 1.5kB file, 
which accounts to some loss. But still, 10GB / 4kB makes 2.5 mio files, 
which have surely not been reached here. Is there that high overhead? 
Why is neither df-metric reporting this problem? Is there any way to get 
reasonable readings out of df in this case? The system would have 
stopped accepting mail from outside if the freespace would have sunk 
below 2GB, so out-of-space happened way to early for it.

Thanks for your answers,
Bernhard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
