Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 May 2007 02:27:04 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4U9QuWt009244
	for <xfs@oss.sgi.com>; Wed, 30 May 2007 02:26:58 -0700
Date: Wed, 30 May 2007 19:27:14 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: [GIT PULL] xfs bug fix for 2.6.22
Message-ID: <9F557877728BD541CEF0E542@timothy-shimmins-power-mac-g5.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: akpm@osdl.org, xfs@oss.sgi.com

Hi Linus,

A bug fix for a regression which went in rc-1
for the NULL files problem.

Please pull from the for-linus branch:
    git pull git://oss.sgi.com:8090/xfs/xfs-2.6 for-linus

This will update the following files:

 fs/xfs/linux-2.6/xfs_aops.c |   26 +++++++++++++++++---------
 1 files changed, 17 insertions(+), 9 deletions(-)

through these commits:

commit df3c7244264f1d12562413aa32d56be802486516
Author: David Chinner <dgc@sgi.com>
Date:   Thu May 24 15:27:03 2007 +1000

    [XFS] Write at EOF may not update filesize correctly.

    The recent fix for preventing NULL files from being left around does not
    update the file size corectly in all cases. The missing case is a write
    extending the file that does not need to allocate a block.

    In that case we used a read mapping of the extent which forced the use of
    the read I/O completion handler instead of the write I/O completion
    handle. Hence the file size was not updated on I/O completion.

    SGI-PV: 965068
    SGI-Modid: xfs-linux-melb:xfs-kern:28657a

    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Nathan Scott <nscott@aconex.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>
