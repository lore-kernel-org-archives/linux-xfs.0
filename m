Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5E5357F3F
	for <xfs@oss.sgi.com>; Wed, 26 Mar 2014 00:48:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DF6CDAC002
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 22:48:15 -0700 (PDT)
Received: from cobra.newdream.net (cobra.newdream.net [66.33.216.30]) by
	cuda.sgi.com with ESMTP id wKQqSEIIIfDW1r19 for
	<xfs@oss.sgi.com>; Tue, 25 Mar 2014 22:48:10 -0700 (PDT)
Received: from cobra.newdream.net (localhost [127.0.0.1])
	by cobra.newdream.net (Postfix) with ESMTP id 024FE8002D
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 22:48:09 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by cobra.newdream.net (Postfix) with ESMTP id B19FC8002D
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 22:48:08 -0700 (PDT)
Date: Tue, 25 Mar 2014 22:48:08 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
Subject: E2BIG from listxattr
Message-ID: <alpine.DEB.2.00.1403252242220.893@cobra.newdream.net>
MIME-Version: 1.0
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

Hi,

If you create a bunch of xattrs on an inode, you can get into a sitation 
where you can no longer list them.  The reproducer below just does 
setxattr until it gets an error or listxattr starts returning E2BIG.  Once 
you're in this state you can getxattr attrs you know the name of, but you 
can't list them, which is a bit inconvenient.

Presumably the fix is for setxattr to verify that the list of all xattr 
names will fit into a 64K buffer or else return ENOSPC...

sage


#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/xattr.h>
#include <string.h>
#include <errno.h>

int main(int argc, char **argv)
{
	char *fn = argv[1];
	char buf[655360];
	int buflen = sizeof(buf);
	int i;

	for (i = 0; i < 10000; ++i) {
		int r = listxattr(fn, buf, buflen);
		if (r < 0) {
			perror("listxattr");
			return 1;
		}
		char n[100];
		sprintf(n, "user.foooooooooooooooooooooooooooooooooooooo%d", i);
		r = setxattr(fn, n, "", 0, 0);
		if (r < 0) {
			perror("setxattr");
			return 1;
		}
		printf("set %d\n", i);
	}
	return 0;
}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
