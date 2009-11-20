Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAK7ariw130394 for <xfs@oss.sgi.com>; Fri, 20 Nov 2009 01:36:53 -0600
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7CD1512359C5
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2009 23:37:16 -0800 (PST)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id xFsgQ4J5g7MXRU5c for <xfs@oss.sgi.com>;
	Thu, 19 Nov 2009 23:37:16 -0800 (PST)
Date: Thu, 19 Nov 2009 23:30:00 -0800
From: Brandon Philips <bphilips@suse.de>
Subject: [ANNOUNCE] acl v2.2.49 released
Message-ID: <20091120072959.GA32542@jenkins.home.ifup.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Hello All-

Version 2.2.49 of acl has been released. 

The Tarball can be found here:
 http://download.savannah.gnu.org/releases-noredirect/acl/acl-2.2.49.src.tar.gz

The git repository can be found here:
 http://git.savannah.gnu.org/cgit/acl.git/

The CHANGES can be found here:
 http://git.savannah.gnu.org/cgit/acl.git/tree/doc/CHANGES?id=HEAD

This release fixes two bugs in the tarball package of v2.2.48:
- docs/CHANGES wasn't updated
- tests/sort-getfacl-output and examples/copyperm.c didn't make it
  into the tarball

No code has changed but these fixes are important for distros looking
to version bump[1].

Also, for distros that like to test packages at build time try out 
`make tests` which was added in v2.2.48.

Thanks,

	Brandon

[1] http://bugs.gentoo.org/show_bug.cgi?id=292842

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
