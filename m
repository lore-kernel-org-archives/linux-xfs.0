Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40441 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932493AbcLMP7v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2016 10:59:51 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: minleft fixes
Date: Tue, 13 Dec 2016 16:59:23 +0100
Message-Id: <1481644767-9098-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: eguan@redhat.com, darrick.wong@oracle.com

[now to the correct list address]

This is my attempt to fix the problems with rmap and reflink file system
running out of space during delayed extent conversions.  It turns out
the way minleft has been handled has always been bogus, but the rmap
enablement made it even worse..

This has survived xfstests xfs/109 on a 2k fs for 2 1/2 hour here now,
but Eryu was much better than me at reproducing the problems, so it could
use some further testing.

