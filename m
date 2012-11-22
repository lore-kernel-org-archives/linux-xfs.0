Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAM53bjd148883 for <xfs@oss.sgi.com>; Wed, 21 Nov 2012 23:03:38 -0600
Received: from fgwmail6.fujitsu.co.jp (fgwmail6.fujitsu.co.jp [192.51.44.36])
	by cuda.sgi.com with ESMTP id Fk5jkixTXscPTwGH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 21 Nov 2012 21:05:48 -0800 (PST)
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 6A3D83EE0BB
	for <xfs@oss.sgi.com>; Thu, 22 Nov 2012 14:05:46 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 4EC6145DEBC
	for <xfs@oss.sgi.com>; Thu, 22 Nov 2012 14:05:46 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 378D545DEB7
	for <xfs@oss.sgi.com>; Thu, 22 Nov 2012 14:05:46 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 218C91DB803E
	for <xfs@oss.sgi.com>; Thu, 22 Nov 2012 14:05:46 +0900 (JST)
Received: from g01jpexchkw09.g01.fujitsu.local
	(g01jpexchkw09.g01.fujitsu.local [10.0.194.48])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id D12D81DB803C
	for <xfs@oss.sgi.com>; Thu, 22 Nov 2012 14:05:45 +0900 (JST)
Message-ID: <50ADB27F.8070806@jp.fujitsu.com>
Date: Thu, 22 Nov 2012 14:05:03 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
Subject: [BUG] xfs_quota: can't handle the users managed by LDAP
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
To: xfs ML <xfs@oss.sgi.com>

Hi,

Current xfs_quota (I pulled xfsprogs today) seems not be able to the users
managed by LDAP. There is no patch since I'm not good at LDAP and don't know
the root cause yet ;-(

Step to reproduce(in this case, "sat" is the user managed by LDAP):
===============================================================================
# uname -r
3.7.0-rc5
# mount -o loop,usrquota xfs.img mnt
# xfsprogs/quota/xfs_quota -xc "limit bsoft=10M bhard=10M sat" /dev/loop0
xfs_quota: invalid user name: sat                                          # denied
# su sat
$                                                                          # But this user acutally exists.
===============================================================================

The kernel is a bit old, but I suspect this is a userland problem.
I'll try to reproduce it on 3.7.0-rc6 too.

Thanks,
Satoru Takeuchi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
