Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40782 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932398AbeFFKki (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Jun 2018 06:40:38 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: iomap preparations for GFS2
Date: Wed,  6 Jun 2018 12:40:27 +0200
Message-Id: <20180606104033.4947-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, linux-ext4@vger.kernel.org

Hi all,

this is a slight rework of the patches from Andreas to prepare for gfs2
using the iomap code.  I'd like to start with an immutable branch for
iomap patches in either the XFS tree or a tree of mine own with something
like this so that we can have a nice common base for both the major
iomap changes for XFS and the GFS2 work.
