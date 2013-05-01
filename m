Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 499407F5D
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 15:12:12 -0500 (CDT)
Message-ID: <51817723.9090603@sgi.com>
Date: Wed, 1 May 2013 15:12:19 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: xfsdump-3.1.3 pre-release  please test!
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>
Cc: Nathan Scott <nathans@debian.org>

Hi Folks,

Here are the changes for this release:

xfsdump-3.1.3 (1 May 2013)
	- Fix a segfault in xfsrestore when a path name is too long,
	  thanks to Nigel Tamplin.
	- Fix a backward compatibility problem.  Dumps created with
	  version 3.1.2 where extended attributes are in use failed
	  to restore with v3.1.0 due to file header checksum errors.
	  Thanks to Fugazzi for reporting.
	- Refactored release scripts to conform to using git archive.
	- Changed the build process so that 'make deb' uses the same
	  process of creating a source tree as the release script.

I have placed a pre-release tarball here:

ftp://oss.sgi.com/projects/xfs/cmd_tars/pre-release/xfsdump-pre-3.1.3-3.tar.gz

Please take a look and report any issues before next Wednesday (08 May 
2013).  If there are other patches which you feel are essential, now is 
the time to say so.

Regards
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
