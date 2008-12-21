Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBLHC53l027429 for <xfs@oss.sgi.com>; Sun, 21 Dec 2008 11:12:05 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 65F123B45F
	for <xfs@oss.sgi.com>; Sun, 21 Dec 2008 09:12:03 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id u6aHVvGerDnPP0cm for <xfs@oss.sgi.com>;
	Sun, 21 Dec 2008 09:12:03 -0800 (PST)
Message-ID: <494E78E3.7080003@sandeen.net>
Date: Sun, 21 Dec 2008 11:12:03 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair problem.
References: <7bcfcfff0812210703r4bd889cave8e2d60c56587e3e@mail.gmail.com>	<494E66D9.5030704@sandeen.net>
	<7bcfcfff0812210852v6c1cd522i334de914e1e9a112@mail.gmail.com>
In-Reply-To: <7bcfcfff0812210852v6c1cd522i334de914e1e9a112@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: David Bernick <dbernick@gmail.com>
Cc: xfs@oss.sgi.com

David Bernick wrote:

> How do you go about writing to these inodes with these values:
> rootino = 128
> rbmino = 129
> rsumino = 130
> without affecting the data?

forgot this answer...

start xfs_db with -x, then:

xfs_db> sb 0
xfs_db> write rsumino 130
rsumino = 130

etc

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
