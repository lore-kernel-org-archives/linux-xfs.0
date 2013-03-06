Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5340F8004
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 07:02:55 -0600 (CST)
Message-ID: <51373E85.9050408@sgi.com>
Date: Wed, 6 Mar 2013 07:03:01 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: Fix hang when mkfs.btrfs isn't present
References: <512D1E3E.9050907@redhat.com> <513674B2.9030900@sandeen.net>
In-Reply-To: <513674B2.9030900@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-btrfs <linux-btrfs@vger.kernel.org>, Stefan Behrens <sbehrens@giantdisaster.de>, xfs-oss <xfs@oss.sgi.com>

This patch has been committed.

Thanks
--Rich

commit 52f4953ac4a377f9f7fc870d2a81f30c3e5d3c7f
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Tue Mar 5 22:41:54 2013 +0000

     xfstests: Fix hang when mkfs.btrfs isn't present

     My earlier patch (xfstests: handle new mkfs.btrfs -f option cleanly)
     had a flaw in that if set_prog_path mkfs.btrfs returns nothing,
     the grep will hang.

     Test for that case to avoid it, and just return the empty string
     in that case.

     Reported-by: Rich Johnston <rjohnston@sgi.com>
     Signed-off-by: Eric Sandeen <sandeen@redhat.com>
     Reviewed-by: Rich Johnston <rjohnston@sgi.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
