Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51568 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933383AbeEIHsg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 May 2018 03:48:36 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: stop using buffer heads in xfs and iomap
Date: Wed,  9 May 2018 09:47:57 +0200
Message-Id: <20180509074830.16196-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

Hi all,

this series adds support for reading blocks from disk using the iomap
interface, and then gradually switched the buffered I/O path to not
require buffer heads.  It has survived xfstests for 1k and 4k block
size.

There are various small changes to the core VFS, block and readahead
code to make this happen.


A git tree is available at:

    git://git.infradead.org/users/hch/xfs.git xfs-remove-bufferheads

Gitweb:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-remove-bufferheads
