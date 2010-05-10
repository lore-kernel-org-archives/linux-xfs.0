Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4AFe1Pi011133 for <xfs@oss.sgi.com>; Mon, 10 May 2010 10:40:01 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1A7C5139D0D1
	for <xfs@oss.sgi.com>; Mon, 10 May 2010 08:42:13 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id QeOzplpOvpHwvH87 for
	<xfs@oss.sgi.com>; Mon, 10 May 2010 08:42:13 -0700 (PDT)
Message-ID: <4BE82955.2080009@sandeen.net>
Date: Mon, 10 May 2010 10:42:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: bad primary superblock - bad magic number !!!
References: <28512276.post@talk.nabble.com>
In-Reply-To: <28512276.post@talk.nabble.com>
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
To: stress_buster <leo1783@yahoo.com>
Cc: xfs@oss.sgi.com

stress_buster wrote:
> my hp proliant DL185 server hangs/crashes and sometimes do not boot
> correctly...
> 
> [root@localhost dev]# xfs_repair -n /dev/cciss/c0d0p1
> Phase 1 - find and verify superblock...
> bad primary superblock - bad magic number !!!
> 
> attempting to find secondary superblock...
> .....................................................................................Sorry,
> could not find valid secondary superblock
> Exiting now.
> 
> [root@localhost dev]# xfs_repair -n /dev/cciss/c0d2
> Phase 1 - find and verify superblock...
> superblock read failed, offset 0, size 524288, ag 0, rval -1
> 
> fatal error -- Input/output error
> 
> 
> [root@localhost dev]# xfs_db /dev/cciss/c0d0p1
> xfs_db: /dev/cciss/c0d0p1 is not a valid XFS filesystem (unexpected SB magic
> number 0x00000000)
> 
> The next time, server didnt even boot up alright
> 
> i've managed to capture the msgs & traces dumped to console. See below
> 
> 
> end_request: I/O error, dev cciss/c0d2, sector 0
> end_request: I/O error, dev cciss/c0d2, sector 0
> end_request: I/O error, dev cciss/c0d2, sector 1
> Quote:
> ciss: cmd f6c00000 has CHECK CONDITION sense key = 0x4
> end_request: I/O error, dev cciss/c0d3, sector 0
> cciss: cmd f6c00000 has CHECK CONDITION sense key = 0x4
> end_request: I/O error, dev cciss/c0d3, sector 0

You seem to have serious storage problems that are not XFS related.

You'll need to get that resolved.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
