Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B9C5E7F37
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 09:24:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5471FAC002
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 07:24:43 -0700 (PDT)
Received: from posta3.euchiamail.it (posta3.euchiamail.it [46.30.241.112]) by
	cuda.sgi.com with ESMTP id xCedlgQFFHNtVWGb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 07:24:38 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by posta3.euchiamail.it (Postfix) with ESMTP id B09F16D7854
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 16:24:36 +0200 (CEST)
Received: from posta3.euchiamail.it ([127.0.0.1])
	by localhost (sufferone.euchiamail.it [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id uDXINCKNbUpK for <xfs@oss.sgi.com>;
	Tue,  6 Oct 2015 16:24:34 +0200 (CEST)
Received: from linux (2-227-160-98.ip186.fastwebnet.it [2.227.160.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by posta3.euchiamail.it (Postfix) with ESMTPSA id 8E3D76D7850
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 16:24:33 +0200 (CEST)
Date: Tue, 6 Oct 2015 16:24:43 +0200
From: "krautus@kr916.org" <krautus@kr916.org>
Subject: all your slabs are belong to ram ?
Message-ID: <20151006162443.42f48ee7@linux>
MIME-Version: 1.0
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

Dear List, nice to meet you :)

First post, straight to the point:
I'm wrestling from few weeks with a problem: roundcube (a webmail client) takes too long to open a dovecot (pop/imap server) mailbox with many emails (files).
So, when such user has more than 10K emails, it takes around 1 minute to open the mailbox.
Meanwhile, I/O %util goes to 100% and bottlenecks the whole system.

I've tried memcache(d) integration with roundcube but it doesn't eliminate the problem.

OS is Debian Wheezy 32-bit, 16GB of ECC RAM and storage is a simple hardware raid-1 with a couple of sata2 hard disks.
I've just used mkfs.xfs (with no tuning) and no options while mounting (in fstab).

It looks like the problem is the slow access to dentries and inodes, so I've set vfs_cache_pressure to 1,
forced buffering with few "find /var/mail > /dev/null"
and have it running like this from around 4 days.
Didn't help: slabs still gets flushed and opening folders is slow as before.

Current slabtop usage shows:
235352K used by xfs_inode
and
49708K used by dentry
while I would expect to have at least 1 GB of xfs_inode and at least 200MB of dentry.

So I'm asking you:
1. is there a way to force dentries and inodes to stay in ram ?
2. can I perhaps move dentries and inodes to a dedicated SSD ?

I'm open to all possibilities, perhaps increase RAM ?
Upgrade to Debian Jessie and 64 bit ?

Let me know if I can provide more info.


Thank you very much!
Mike
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
