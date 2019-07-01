Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44594 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfGAVyw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 17:54:52 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: RFC: use the iomap writepage path in gfs2
Date: Mon,  1 Jul 2019 23:54:24 +0200
Message-Id: <20190701215439.19162-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com

Hi all,

in this straight from the jetplane edition I present the series to
convert gfs2 to full iomap usage for the ordered and writeback mode,
that is we use iomap_page everywhere and entirely get rid of
buffer_heads in the data path.  This has only seen basic testing
which ensured neither 4k or 1k blocksize in ordered mode regressed
vs the xfstests baseline, although that baseline tends to look
pretty bleak.

The series is to be applied on top of my "lift the xfs writepage code
into iomap v2" series.
