Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3U9j1iv219165 for <xfs@oss.sgi.com>; Thu, 30 Apr 2009 04:45:01 -0500
Received: from spamfilter2.mailnara.co.kr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E63831CFBB76
	for <xfs@oss.sgi.com>; Thu, 30 Apr 2009 02:45:00 -0700 (PDT)
Received: from spamfilter2.mailnara.co.kr (spamfilter2.mailnara.co.kr
	[61.109.252.92]) by cuda.sgi.com with ESMTP id fY1QDdCSImBJTbVV
	for <xfs@oss.sgi.com>; Thu, 30 Apr 2009 02:45:00 -0700 (PDT)
Message-ID: <49F97318.4040103@gmail.com>
Date: Thu, 30 Apr 2009 18:44:56 +0900
From: hgichon <hgichon@gmail.com>
MIME-Version: 1.0
Subject: Sometimes df is not updated after remove within xfs via nfs.
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
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org


Hi guys.

I used xfs and nfs for a long time.
Recently, I have problem with df when removing files via nfs client.
df result is not updated both local and nfs client.
It's hard to reproducing same problem.
But I have seen the problem several times in this month.

I can't remember exactly, df was updated when new files was created.

Are there any known issue or any check point?
Any comments appreciated.

Related xfs/nfsd Kernel Version.
- 2.6.23.1
- 2.6.24.7
- 2.6.27.21

My Environment
- nfs client (AIX5.3 , CentOS 5.3)
- nfs tcp v3
- Intel DR2500, Xeon Dual core, 4G RAM

- kpkim

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
