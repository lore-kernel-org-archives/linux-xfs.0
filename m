Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4MEGcxc221342 for <xfs@oss.sgi.com>; Fri, 22 May 2009 09:16:38 -0500
Received: from rv-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F2141A0A6DC
	for <xfs@oss.sgi.com>; Fri, 22 May 2009 07:16:49 -0700 (PDT)
Received: from rv-out-0708.google.com (rv-out-0708.google.com
	[209.85.198.244]) by cuda.sgi.com with ESMTP id
	Z7I8PyFvg5rhUEfe for <xfs@oss.sgi.com>;
	Fri, 22 May 2009 07:16:49 -0700 (PDT)
Received: by rv-out-0708.google.com with SMTP id k29so526229rvb.32
	for <xfs@oss.sgi.com>; Fri, 22 May 2009 07:16:49 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 22 May 2009 22:16:48 +0800
Message-ID: <7fe205990905220716v7d06b9bch40fe6136af17e345@mail.gmail.com>
Subject: about XFS_IOC_RESVSP
From: Joe Hsu <nagual.hsu@gmail.com>
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

        I pre-allocate blocks for a file. Then I use "open" and "write" system
calls to generate the content for that file. After the file is really
written to the disk,
I want to set all the extent(s) of that file unwritten. Then I will
write new content to
the same file. Is that possible? That means:
I want to dis-care the content just written and use the same allocated blocks.
In another words, I want to restore the state of the file to the state
when it was
first pre-allocated.

        Why am I doing this? Why not just over-write it? When doing
partial over-writing,
some blocks may be read for partial update before they are written
out. This hurts
some IO performance and If I can, I would prefer to dis-care old
content of the file and
use same (pre)allocated blocks. (In my case, I am doing intensive IO.)

        Any one can give me some hints? Thanks.

-- 
The sun is shinny but the ice is slippery.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
