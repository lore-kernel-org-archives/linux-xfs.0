Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Jun 2007 23:01:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5J612do018447
	for <xfs@oss.sgi.com>; Mon, 18 Jun 2007 23:01:04 -0700
Message-ID: <4677711A.4000109@sgi.com>
Date: Tue, 19 Jun 2007 16:00:58 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: [GIT PULL] XFS cleanup fix and maintainers file update
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>

Hi Linus,

Please pull from the for-linus branch:
     git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

Will stop the annoying warning for memclear_highpage_flush in xfs.

This will update the following files:

  MAINTAINERS                |    2 +-
  fs/xfs/linux-2.6/xfs_lrw.c |    2 +-
  2 files changed, 2 insertions(+), 2 deletions(-)

through these commits:

commit e99f056b2777f3fc6871ff6347c98c0321ad2f8f
Author: Tim Shimmin <tes@chook.melbourne.sgi.com>
Date:   Tue Jun 19 15:26:35 2007 +1000

     [XFS] Update the MAINTAINERS file entry for XFS - change git repo name.

     Make the git repository bare and so give it the conventional .git suffix.

     Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 700716c8468d95ec6d03566a4e4fb576c3223cbc
Author: Christoph Hellwig <hch@lst.de>
Date:   Thu May 24 15:27:17 2007 +1000

     [XFS] s/memclear_highpage_flush/zero_user_page/

     SGI-PV: 957103
     SGI-Modid: xfs-linux-melb:xfs-kern:28678a

     Signed-off-by: Christoph Hellwig <hch@infradead.org>
     Signed-off-by: Tim Shimmin <tes@sgi.com>
