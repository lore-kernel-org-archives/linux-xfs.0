Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ECC6C29E41
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 14:12:58 -0500 (CDT)
Received: from xmail.sgi.com (pv-excas1-dc21-nlb.corp.sgi.com [137.38.102.126])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CB55B8F8049
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 12:12:58 -0700 (PDT)
Message-ID: <518AA3CE.9000702@sgi.com>
Date: Wed, 8 May 2013 14:13:18 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: [ANNOUNCE] xfsdump v3.1.3
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

Version 3.1.3 of xfsdump has been released.

The source code can be accessed via git using this URL:

     git://oss.sgi.com/xfs/cmds/xfsdump.git

A gzipped-tar archive of the source code is available here:

     ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsdump-3.1.3.tar.gz

The development tree previously hosted on kernel.org for this code has 
been deprecated:

     git://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git

Below is a summary (from the doc/CHANGES file) of changes
since release 3.1.2:

xfsdump-3.1.3 (08 May 2013)
         - Fix a segfault in xfsrestore when a path name is too long,
           thanks to Nigel Tamplin.
         - Fix a backward compatibility problem.  Dumps created with
           version 3.1.2 where extended attributes are in use failed
           to restore with v3.1.0 due to file header checksum errors.
           Thanks to Fugazzi for reporting.
         - Refactored release scripts to conform to using git archive.
         - Changed the build process so that 'make deb' uses the same
           process of creating a source tree as the release script.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
