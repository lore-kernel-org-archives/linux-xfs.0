Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3232B7F50
	for <linux-xfs@oss.sgi.com>; Thu, 16 May 2013 20:12:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0BC82304059
	for <linux-xfs@oss.sgi.com>; Thu, 16 May 2013 18:12:51 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id YLK4pL57d6fNquSy for <linux-xfs@oss.sgi.com>;
	Thu, 16 May 2013 18:12:50 -0700 (PDT)
Message-ID: <51958411.70008@sandeen.net>
Date: Thu, 16 May 2013 20:12:49 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: see the file content by xfs_db
References: <loom.20130516T084318-878@post.gmane.org>
In-Reply-To: <loom.20130516T084318-878@post.gmane.org>
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
To: "chen.szu.fan" <chen.szu.fan@gmail.com>
Cc: linux-xfs@oss.sgi.com

On 5/16/13 1:48 AM, chen.szu.fan wrote:
> is it possible to see the file content by xfs_db? and how-to?

you can get the file mapping & dump file blocks one at a time, anyway:

[root@bp-05 ~]# mount /dev/sdb4 /mnt/test
[root@bp-05 ~]# echo "mydata" > /mnt/test/testfile
[root@bp-05 ~]# ls -i /mnt/test/testfile
53573991 /mnt/test/testfile
[root@bp-05 ~]# umount /dev/sdb4


[root@bp-05 ~]# xfs_db /dev/sdb4
xfs_db> inode 53573991
xfs_db> p u.bmx
u.bmx[0] = [startoff,startblock,blockcount,extentflag] 0:[0,3348403,1,0]
xfs_db> fsblock 3348403
xfs_db> type text
xfs_db> p
000:  6d 79 64 61 74 61 0a 00 00 00 00 00 00 00 00 00  mydata..........
010:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
<snip>

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
