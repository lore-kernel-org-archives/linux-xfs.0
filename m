Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59812 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751906AbdCHQOf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2017 11:14:35 -0500
Date: Wed, 8 Mar 2017 07:53:13 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] misc: use system FICLONE/FICLONERANGE/FIDEDUPERANGE
 definitions
Message-ID: <20170308155313.GC4353@infradead.org>
References: <148893300446.23674.6348172768180643163.stgit@birch.djwong.org>
 <148893301058.23674.10160100843692497809.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148893301058.23674.10160100843692497809.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

xfs_fs.h should never removed previously define APIs - that'll just
break application.

So to be honest I'm not sure there is any upside to this patch - it
adds tons of lines, does not add any functionality and breaks existing
apps.
