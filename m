Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1664129DF9
	for <xfs@oss.sgi.com>; Thu, 16 Jan 2014 11:07:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BC0CBAC002
	for <xfs@oss.sgi.com>; Thu, 16 Jan 2014 09:07:19 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id UAHuBorBZgShbeC2 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 Jan 2014 09:07:18 -0800 (PST)
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id CEAD0AC3E
	for <xfs@oss.sgi.com>; Thu, 16 Jan 2014 17:07:16 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/5] xfstests: A few updates to non-test code
Date: Thu, 16 Jan 2014 18:07:10 +0100
Message-Id: <cover.1389891730.git.dsterba@suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: David Sterba <dsterba@suse.cz>

Minor bugfixes or enhancements.

David Sterba (5):
  xfstests: fix minor build warning
  xfstests: use value of FSTYP if defined externally
  xfstests: don't suggest to run full diff when DIFF_LENGTH is 0
  xfstests: accept tests/ prefix for test name on commandline
  xfstests: update lsqa.pl for new tests layout

 Makefile |  3 +--
 README   |  3 +++
 check    | 16 +++++++++-------
 lsqa.pl  | 32 ++++++++++++++++++++++++--------
 4 files changed, 37 insertions(+), 17 deletions(-)

-- 
1.8.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
