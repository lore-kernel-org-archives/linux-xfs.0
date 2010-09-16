Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8GIbYZE009360 for <xfs@oss.sgi.com>; Thu, 16 Sep 2010 13:37:34 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3D8097C701
	for <xfs@oss.sgi.com>; Thu, 16 Sep 2010 11:38:23 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id MOgNrjdawcFAcaQI for
	<xfs@oss.sgi.com>; Thu, 16 Sep 2010 11:38:23 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 434354A8B9EA
	for <xfs@oss.sgi.com>; Thu, 16 Sep 2010 13:38:23 -0500 (CDT)
Message-ID: <4C92641F.7080504@sandeen.net>
Date: Thu, 16 Sep 2010 13:38:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: sector size warning at mount time
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
To: xfs-oss <xfs@oss.sgi.com>

On ppc64 I'm tripping this warning:

        if (verbose &&
            (PAGE_CACHE_SIZE / BITS_PER_LONG) > sectorsize) {
                printk(KERN_WARNING
                        "XFS: %u byte sectors in use on device %s.  "
                        "This is suboptimal; %u or greater is ideal.\n",
                        sectorsize, XFS_BUFTARG_NAME(btp),
                        (unsigned int)PAGE_CACHE_SIZE / BITS_PER_LONG);
        }

and it's telling me I should have 1024-byte sectors...

If the kernel is going to complain at mount, should we get it right
at mkfs time?  I'm not even quite sure why it's recommending this?

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
