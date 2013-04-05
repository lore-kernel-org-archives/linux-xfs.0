Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 334FF29E24
	for <xfs@oss.sgi.com>; Fri,  5 Apr 2013 12:32:21 -0500 (CDT)
Message-ID: <515F0ABB.804@sgi.com>
Date: Fri, 5 Apr 2013 12:32:43 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: Check concurrently of readdir and read on the
	same directory fd
References: <515BC786.3070102@gmail.com>
In-Reply-To: <515BC786.3070102@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Zhao Hongjiang <zhaohongjiang37@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

Zhao,

Thanks for submitting this test, it has been committed.

--Rich
commit bbaf78c01bc98b2afc3bb3d31eac38fc5d4b3b19
Author: Zhao Hongjiang <zhaohongjiang@huawei.com>
Date:   Wed Apr 3 06:09:10 2013 +0000

     xfstests generic 310: check concurrently of readdir and read on the 
same directory fd

     Check if there are two threads,one keeps calling read() or lseek(), and
     the other calling readdir(), both on the same directory fd.

     Based on a testcase from Li Zefan <lizefan@huawei.com>.
     http://marc.info/?l=linux-kernel&m=136123703211869&w=2

     Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
     Reviewed-by: Rich Johnston <rjohnston@sgi.com>
     [rjohnston@sgi.com minor white space fixes and test renumbering]
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
