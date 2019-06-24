Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50572 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbfFXFw5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 01:52:57 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: lift the xfs writepage code into iomap
Date: Mon, 24 Jun 2019 07:52:41 +0200
Message-Id: <20190624055253.31183-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

Hi all,

this series cleans up the xfs writepage code and then lifts it to
fs/iomap.c so that it could be use by other file system.  I've been
wanting to this for a while so that I could eventually convert gfs2
over to it, but I never got to it.  Now Damien has a new zonefs
file system for semi-raw access to zoned block devices that would
like to use the iomap code instead of reinventing it, so I finally
had to do the work.
