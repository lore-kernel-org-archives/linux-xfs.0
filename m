Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44904 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752564AbcKECJ1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Nov 2016 22:09:27 -0400
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B7B333D949
        for <linux-xfs@vger.kernel.org>; Sat,  5 Nov 2016 02:09:26 +0000 (UTC)
Received: from [IPv6:::1] (ovpn03.gateway.prod.ext.phx2.redhat.com [10.5.9.3])
        by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uA529PHp002004
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Fri, 4 Nov 2016 22:09:26 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/2] xfs: fix up xfs_swap_extent_forks inline extent handling
Message-ID: <d279d52e-49f6-6fc2-c78b-0054d7ee0a1e@redhat.com>
Date: Fri, 4 Nov 2016 21:09:25 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

xfs_swap_extent_forks() was wrongly using di_nextents
(on-disk extents) for determining whether the /incore/
inode could keep extents inline.  The code should be testing
if_bytes, not di_nextents, to make this determination.

The mistake led to an oops in some situations when running
xfs_fsr.

Throughout the code we have this sort of open-coded handling
like:

nextents = ip->i_df.if_bytes / (uint)sizeof(xfs_bmbt_rec_t);

so patch 2 creates a helper for that and uses it throughout
the codebase.

I should maybe also create a helper for the things that expand
it back out, i.e. nextents * (uint)sizeof(xfs_bmbt_rec_t) but
that seems error prone...

-Eric
