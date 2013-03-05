Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 257E88067
	for <xfs@oss.sgi.com>; Tue,  5 Mar 2013 14:09:34 -0600 (CST)
Message-ID: <513650F2.8060406@sgi.com>
Date: Tue, 5 Mar 2013 14:09:22 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: use native definition of O_DIRECT flag
References: <20130226210322.GB5275@wallace>
In-Reply-To: <20130226210322.GB5275@wallace>
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
To: Eric Whitney <enwlinux@gmail.com>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com

This patch has been committed.

Thanks
--Rich

commit 5825ecd3b99ed8c177895d5e6a830133fed384ea
Author: Eric Whitney <enwlinux@gmail.com>
Date:   Tue Feb 26 21:03:22 2013 +0000

     xfstests: use native definition of O_DIRECT flag

     The definition of O_DIRECT in src/trunc.c causes xfstest 125 to fail
     when run on a Pandaboard.  On ARM, the value used (0x040000) is
     O_DIRECTORY rather than O_DIRECT as it is on x86.  Prefer the 
platform's
     native definition of O_DIRECT supplied by fcntl.h if available.  Also,
     fix a couple of error messages to properly reflect their context.

     Signed-off-by: Eric Whitney <enwlinux@gmail.com>
     Reviewed-by: Dave Chinner <dchinner@redhat.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
