Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 337B37F37
	for <xfs@oss.sgi.com>; Sun, 31 May 2015 20:25:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BB199AC002
	for <xfs@oss.sgi.com>; Sun, 31 May 2015 18:25:06 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	uBEpWU6ABqf8ulFK for <xfs@oss.sgi.com>;
	Sun, 31 May 2015 18:25:03 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1YzETB-0004Hu-Bm
	for xfs@oss.sgi.com; Mon, 01 Jun 2015 11:24:49 +1000
Date: Mon, 1 Jun 2015 11:24:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs v3.2.3-rc2: master branch updated to 29358c9
Message-ID: <20150601012449.GB9143@dastard>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi folks,

The xfsprogs repository at git://oss.sgi.com/xfs/cmds/xfsprogs has
just been updated and tagged vi v3.2.3-rc2. Please download and
test; if nothing critical arises this tree will become the 3.2.3
release.

The new head of the master branch is commit:

29358c9 xfsprogs: update for 3.2.3-rc2 release

New Commits:

Darrick J. Wong (3):
      [a98b22b] xfs_repair: validate superblock against known v5 feature flags
      [0519f66] xfs_repair: better checking of v5 metadata fields
      [01914f0] xfs_repair: ensure .. is set sanely when rebuilding dir

Dave Chinner (1):
      [29358c9] xfsprogs: update for 3.2.3-rc2 release

Eric Sandeen (1):
      [d6cfd5a] xfs_repair: properly detect reserved attribute names


Code Diffstat:

 VERSION                |   2 +-
 doc/CHANGES            |   5 ++
 include/xfs_dir2.h     |   2 +
 libxfs/xfs_dir2_priv.h |   1 -
 repair/attr_repair.c   |   7 +--
 repair/dir2.c          |   7 +++
 repair/phase6.c        | 127 +++++++++++++++++++++++++++++++++++++++++++++----
 repair/scan.c          |  19 +++++++-
 repair/versions.c      |  14 ++++++
 9 files changed, 170 insertions(+), 14 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
