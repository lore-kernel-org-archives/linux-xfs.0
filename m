Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48588 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755396AbdDMJyh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2017 05:54:37 -0400
Date: Thu, 13 Apr 2017 02:54:36 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: xfs/384 failures
Message-ID: <20170413095436.GB21980@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org

Current xfs/348 reliably fails for me due to this:

 -stat: 'SCRATCH_MNT/test/SYMLINK' is a directory
 +stat: cannot stat 'SCRATCH_MNT/test/SYMLINK': Structure needs cleaning

Any idea what's going on there?
