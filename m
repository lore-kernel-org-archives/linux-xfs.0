Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8HG3jb5181199 for <xfs@oss.sgi.com>; Mon, 17 Sep 2012 11:03:45 -0500
Received: from exprod7og120.obsmtp.com (exprod7og120.obsmtp.com [64.18.2.18])
	by cuda.sgi.com with SMTP id bQ9nFbrnfFDwvJjx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Sep 2012 09:04:54 -0700 (PDT)
Message-ID: <50574709.9000301@genband.com>
Date: Mon, 17 Sep 2012 09:51:37 -0600
From: Chris Friesen <chris.friesen@genband.com>
MIME-Version: 1.0
Subject: given a pointer to xfs_inode_t, how to determine path?
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
To: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, xfs@oss.sgi.com


Hi,

We're running 2.6.27 (upgrading not currently possible, embedded product).

We had a situation arise where we could see in stack traces that a 
number of tasks were stuck in vn_iowait().  That function takes a 
pointer to xfs_inode_t.  Given that, would it be possible to work 
backwards to determine a filesystem path corresponding to that inode?  I 
realize it would likely only go back to the head of the filesystem, but 
that would be fine.

Thanks,
Chris


-- 

Chris Friesen
Software Designer

3500 Carling Avenue
Ottawa, Ontario K2H 8E9
www.genband.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
