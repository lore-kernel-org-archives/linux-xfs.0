Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr002msb.fastweb.it ([85.18.95.86]:56414 "EHLO
        mr002msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754246AbdHUT7E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Aug 2017 15:59:04 -0400
Received: from ceres.assyoma.it (93.63.55.57) by mr002msb.fastweb.it (8.5.140.05)
        id 5934D22002FCDDB9 for linux-xfs@vger.kernel.org; Mon, 21 Aug 2017 21:59:01 +0200
Subject: =?UTF-8?Q?xfs=5Fmetadump=20as=20a=20backup=20tool?=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 21 Aug 2017 21:59:01 +0200
From: Gionatan Danti <g.danti@assyoma.it>
Message-ID: <c8f366449091c278310acb5fbb13a11f@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: g.danti@assyoma.it

Hi all,
I wish to ask if someone is using xfs_metadump as a "real" backup tool - 
ie: in production.

I was wondering how to lower recovery time in case of filesystem 
corruption, and the idea of using xfs_metadump + xfs_mdrestore struck 
me.

I plan to have a single, relatively big XFS volume with an handfull of 
fully preallocated large files (VM disk images). Basically, I was 
thinking about:
- take a LVM snapshot;
- mount the snap volume as read-only;
- copy the user data (via tar/rsync/whatever);
- additionally, xfs_metadump its metadata content.

If a major filesystem corruption occour, as a first step I should be 
able to simply restore its metadata with xfs_mdrestore and re-gain 
access to files/data blocks. A potential pitfall would be related to 
extents that at the time of xfs_metadump where marked as "unwritten" but 
later were written - restoring the old metadata will immediately turn 
user data into zeroes. It is possible to fully allocate a file *without* 
marking the allocated extents as "unwritten"? Yes, I know this has 
security implications...

Is this a good idea? I am missing something?
Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
