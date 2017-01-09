Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56068 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754704AbdAIPjI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 10:39:08 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: 4.9-stable updates for XFS
Date: Mon,  9 Jan 2017 16:38:31 +0100
Message-Id: <1483976343-661-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

Hi all,

below are backports from 4.10-rc3 for XFS.  I've selected all clear
bugfixes for reported bugs, and added about a handful of small
infrastructure backports so that we can take the fixes as is instead of
having to redo them in a different way than upstream.

These have passed xfstests on top of Linux 4.9.2.  Even if some of the 
patches might apply to older stable trees please do not backport them 
unless someone volunteers to QA them first.

