Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 05682806B
	for <xfs@oss.sgi.com>; Tue,  5 Mar 2013 14:23:31 -0600 (CST)
Message-ID: <5136544B.2030004@sgi.com>
Date: Tue, 5 Mar 2013 14:23:39 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: handle new mkfs.btrfs -f option cleanly
References: <512D1E3E.9050907@redhat.com>
In-Reply-To: <512D1E3E.9050907@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Stefan Behrens <sbehrens@giantdisaster.de>, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

Looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

This patch has been committed.

Thanks
--Rich

commit 24fef70ef3fa0be047264b7a40b0bcf86533ec22
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Tue Feb 26 20:42:38 2013 +0000

     xfstests: handle new mkfs.btrfs -f option cleanly

     I added an "-f" option to mkfs.btrfs to force overwrite
     of an existing filesystem.  Now on an xfstests run, new
     mkfs.btrfs requires it, and old mkfs.btrfs cannot accept
     it.

     So, add a helper which works out whether -f is needed,
     and add it to the MKFS_BTRFS_PROG env. var as necessary,
     so that it is an always-included option during the tests.

     Signed-off-by: Eric Sandeen <sandeen@redhat.com>
     Reviewed-by: Rich Johnston <rjohnston@sgi.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
