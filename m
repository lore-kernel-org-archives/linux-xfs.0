Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3IIvhWO001026 for <xfs@oss.sgi.com>; Mon, 18 Apr 2011 13:57:44 -0500
Received: from ifup.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E6A6914E5B59
	for <xfs@oss.sgi.com>; Mon, 18 Apr 2011 12:01:08 -0700 (PDT)
Received: from ifup.org (ifup.org [198.145.64.140]) by cuda.sgi.com with ESMTP
	id Mq5UqUDDHuATHHsz for <xfs@oss.sgi.com>;
	Mon, 18 Apr 2011 12:01:08 -0700 (PDT)
Date: Mon, 18 Apr 2011 10:01:29 -0700
From: Brandon Philips <brandon@ifup.org>
Subject: [ANNOUNCE] attr: 2.4.45 release
Message-ID: <20110418170129.GN332@Maya.local>
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
To: acl-devel@nongnu.org
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Hello-

attr 2.4.45 is released. You can find it here:
 http://download.savannah.gnu.org/releases/attr/attr-2.4.45.src.tar.gz

The git repo is here and the tag is v2.4.45:
 http://git.savannah.gnu.org/cgit/attr.git/

Here comes the shortlog:

Andreas Gruenbacher (4):
      Introduce new WALK_TREE_DEREFERENCE_TOPLEVEL flag
      Ugly hack to convert the man pages into html
      Merge branch 'master' of ssh://git.sv.gnu.org/srv/git/attr
      OPTIONS in man pages should be a section heading, not a subsection heading

Brandon Philips (3):
      libattr: fix memory leak in attr_copy_action()
      Merge branch 'misc'
      VERSION: 2.4.44 -> 2.4.45

Kamil Dudka (5):
      attr_parse_attr_conf: eliminate a memory leak
      attr_parse_attr_conf: eliminate a double free
      setfattr.c: fix thinko in restore()
      setfattr.1: document supported encodings of values
      getfattr: encode NULs properly with --encoding=text

Mike Frysinger (2):
      quote: pull in string.h for strchr prototype
      improve AC_PATH_PROG usage

Cheers,

	Brandon

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
