Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n32Ewf2v148510 for <xfs@oss.sgi.com>; Thu, 2 Apr 2009 09:58:51 -0500
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com
	[134.14.52.130])
	by relay2.corp.sgi.com (Postfix) with SMTP id 2768E30408B
	for <xfs@oss.sgi.com>; Thu,  2 Apr 2009 07:58:17 -0700 (PDT)
Message-ID: <49D4CBA0.40408@sgi.com>
Date: Fri, 03 Apr 2009 01:28:48 +1100
From: Greg Banks <gnb@sgi.com>
MIME-Version: 1.0
Subject: [ANNOUNCE] Filesystem test tools open-sourced by SGI
Reply-To: Greg Banks <gnb@fmeh.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: NFS list <linux-nfs@vger.kernel.org>, Linux Filesystem list <linux-fsdevel@vger.kernel.org>, XFS OSS list <xfs@oss.sgi.com>, Linux kernel list <linux-kernel@vger.kernel.org>

G'day,

SGI is releasing to the Open Source community a number of internal
SGI testing and debugging tools for NFS.  Some of these tools are
also applicable to filesystems in general.

These tools are being released under the GNU General Public License
(GPL) version 2, in the hope that the Linux filesystem development
community may find them useful.  They are provided as-is, without any
support.  Please do not contact SGI for support on any of these tools.

Some of these tools are unfinished.  Others rely on build
infrastructure in internal SGI trees which cannot be released.
The tools are provided as tarball snapshots of internal SGI source
control trees; for a number of technical reasons it is not possible
to provide access to those trees or to create external repositories.

The tools are available for download now at

http://oss.sgi.com/projects/nfs/testtools/

A brief description of each tool follows.

Checkstream
-----------

Simple data corruption testing utilities based on the concept of
generating a stream of small self-contained records which can be
decoded in a way which makes certain common data corruption modes
automatically diagnosable.  Has been useful for automated testing of
NFS, XFS, and CXFS in SGI.

Weber
-----

Test load generator for NFS.  Uses multiple threads, multiple sockets
and multiple IP addresses to simulate loads from many machines,
thus enabling testing of NFS server setups with larger client counts
than can be tested with physical infrastructure (or Virtual Machine
clients).  Has been useful in automated NFS testing and as a pinpoint
NFS load generator tool for performance development.

NFS PMDA
--------

PCP Data Agent for extended NFS server statistics.  Exports to PCP
the new statistics (measuring per-client and per-server performance)
which are provided by SGI's EnhancedNFS kernel patches.

Samba PMDA
----------

PCP Data Agent for extended Samba server statistics.  Exports to
PCP the additional statistics (measuring per-client and per-server
performance) which are provided by SGI's patches to Samba.

Ddnfs
-----

Filesystem load generation program designed to simulate the IO
load placed on an XFS filesystem by the NFS server in response
to certain NFS loads.  Intended for use in XFS automated testing,
to test performance and correctness of certain XFS functionality
not otherwise exercised by the existing XFS test suite, but never
integrated into XFSQA.

Pmapload
--------

Test suite for the portmap and rpcbind programs (which are
NFS infrastructure components based on code open-sourced by Sun
Microsystems and used by every Unix and Linux).  Developed by SGI to
test changes imported into those programs from newer Sun source code
during the NFS on IPv6 work for Irix several years ago.

RPC Exerciser
-------------

Test suite for the userspace RPC infrastructure libraries, (which
are NFS infrastructure components based on code open-sourced by Sun
Microsystems and used by every Unix and Linux).  Developed by SGI to
test changes imported into those libraries from newer Sun source code
during the NFS on IPv6 work for Irix several years ago.

Testfs
------

Linux kernel module which provides an in-memory filesystem which
forgets all data written to it.  Also can be configured to simulate
timing behaviour on reads and writes.  This is useful for NFS
performance testing without a fast disk subsystem.

StReplay
--------

Program which reads the system call trace of another program (obtained
using the widely available strace utility) and replays the IO pattern.
This was intended to be used for automated NFS and XFS testing and
for NFS and XFS problem diagnosis, but was never completed as the
author transferred to another team.  Could be the basis for a very
useful filesystem test tool.


-- 
Greg Banks, P.Engineer, SGI Australian Software Group.
the brightly coloured sporks of revolution.
I don't speak for SGI.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
