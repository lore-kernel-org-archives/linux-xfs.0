Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34182 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752165AbdEQMK4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 17 May 2017 08:10:56 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/3 v2] xfs: Fix SEEK_HOLE implementation
Date: Wed, 17 May 2017 14:10:43 +0200
Message-Id: <20170517121046.2632-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Jan Kara <jack@suse.cz>

Hello,

this is the second revision of the patches to fix bugs in XFS's SEEK_HOLE
implementation and cleanup the code a bit.

Changes since v1:
* Fixed some more buggy cases
* Simplified code a bit as suggested by Darrick
* Fixed range check as spotted by Brian

								Honza
