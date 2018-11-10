Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35880 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728983AbeKJVgg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Nov 2018 16:36:36 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: fstests: various fixups uncovered by the always_cow mode
Date: Sat, 10 Nov 2018 12:51:40 +0100
Message-Id: <20181110115145.30356-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

Mostly just being stricter in checking for preallocation support in
various places.
