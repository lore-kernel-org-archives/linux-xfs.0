Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41281 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750775AbdFCNPP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Jun 2017 09:15:15 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: 4.11-stable updates for XFS
Date: Sat,  3 Jun 2017 15:14:48 +0200
Message-Id: <20170603131511.25032-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

Hi all,

below are backports up to (almost) 4.12-rc4 for XFS.  I've selected all
clear bugfixes for reported bugs.  One patch is a little odd as it's a
subset of a patch that went into mainline, which included a bit of
infrastructure in addition to the new feature, and we only need the
infrastructure for stable.  Also a fs/iomap.c fix for code only used
by XFS is included.

[sorry for the resend, one commit contained an existing stable@ Cc
 with a "#" sign in it that made the mail server throw up.  This also
 means you might get these commits twice, but the whole set here is
 one that passed xfstests testing]
