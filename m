Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3IIviVA001027 for <xfs@oss.sgi.com>; Mon, 18 Apr 2011 13:57:44 -0500
Received: from ifup.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E87D7BF62EE
	for <xfs@oss.sgi.com>; Mon, 18 Apr 2011 12:01:08 -0700 (PDT)
Received: from ifup.org (ifup.org [198.145.64.140]) by cuda.sgi.com with ESMTP
	id HBqrGijAfEA0yfm1 for <xfs@oss.sgi.com>;
	Mon, 18 Apr 2011 12:01:08 -0700 (PDT)
Date: Mon, 18 Apr 2011 11:59:46 -0700
From: Brandon Philips <brandon@ifup.org>
Subject: [ANNOUNCE] acl: 2.2.50 release
Message-ID: <20110418185946.GC335@Maya.local>
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

acl 2.2.50 is released. You can find it here:
 http://download.savannah.gnu.org/releases/acl/acl-2.2.50.src.tar.gz

The git repo is here and the tag is v2.2.50:
 http://git.savannah.gnu.org/cgit/acl.git/

Here comes the shortlog:

Andreas Gruenbacher (4):
      setfacl: Clarify that removing a non-existent acl entry is not an error
      Fix a typo in the setfacl man page
      OPTIONS in man pages should be a section heading, not a subsection heading
      Minor fixes to the previous commit

Brandon Philips (5):
      setfacl: changing owner and when S_ISUID should be set --restore fix
      setfacl: print useful error from read_acl_comments
      libacl: fix potential null pointer dereference
      libacl/Makefile: add __acl_extended_file.h to HFILES
      VERSION: v2.2.49 -> v2.2.50

Kamil Dudka (2):
      Prevent setfacl --restore from SIGSEGV on malformed restore file
      libacl: Add acl_extended_file_nofollow()

M. Steinborn (1):
      setfacl: make sure that -R only calls stat(2) on symlinks when it needs to

Markus Steinborn (1):
      setfacl: fix restore crash on malformed input

Mike Frysinger (1):
      improve AC_PATH_PROG usage

Cheers,

	Brandon

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
