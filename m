Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58690 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728539AbfAUPXc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Jan 2019 10:23:32 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: move noatime and automount flags setting into common code
Date: Mon, 21 Jan 2019 16:23:24 +0100
Message-Id: <20190121152326.9954-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>, Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, devel@lists.orangefs.org

Hi Al,

can you take a look at this series that fixes incorrect attributes
reported for filesystems like XFS that don't use generic_filattr?
