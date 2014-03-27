Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5910329DF7
	for <xfs@oss.sgi.com>; Thu, 27 Mar 2014 11:08:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3E7E08F804C
	for <xfs@oss.sgi.com>; Thu, 27 Mar 2014 09:08:01 -0700 (PDT)
Received: from cobra.newdream.net (cobra.newdream.net [66.33.216.30]) by
	cuda.sgi.com with ESMTP id iFRrkrJMEPjcQvY8 for
	<xfs@oss.sgi.com>; Thu, 27 Mar 2014 09:07:59 -0700 (PDT)
Date: Thu, 27 Mar 2014 09:07:58 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
Subject: Re: E2BIG from listxattr
In-Reply-To: <20140326213548.GB4128@laptop.bfoster>
Message-ID: <alpine.DEB.2.00.1403270856450.20589@cobra.newdream.net>
References: <alpine.DEB.2.00.1403252242220.893@cobra.newdream.net>
	<20140326213548.GB4128@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, 26 Mar 2014, Brian Foster wrote:
> On Tue, Mar 25, 2014 at 10:48:08PM -0700, Sage Weil wrote:
> > Hi,
> > 
> > If you create a bunch of xattrs on an inode, you can get into a sitation 
> > where you can no longer list them.  The reproducer below just does 
> > setxattr until it gets an error or listxattr starts returning E2BIG.  Once 
> > you're in this state you can getxattr attrs you know the name of, but you 
> > can't list them, which is a bit inconvenient.
> > 
> > Presumably the fix is for setxattr to verify that the list of all xattr 
> > names will fit into a 64K buffer or else return ENOSPC...
> > 
> 
> Hi Sage,
> 
> I think doing something like this would be an artificial restriction on
> XFS. The listxattr() function in the vfs actually caps the provided
> buffer to 64k. This in turn causes an error in XFS, which is capable of
> filling a larger buffer, and the VFS converts that error into E2BIG.
> 
> I ran a quick experiment to remove that bit of code from listxattr() and
> modified your program to use a 128k buffer. Everything still seems to
> work Ok until I exhaust that buffer. Given that and the fact that
> listxattr() does an allocation of the user-provided size, I suspect the
> 64k restriction here is some kind of policy based on memory allocation,
> but that's a guess. The right fix might be something more involved, such
> as fixing the interface to handle larger sets of data (e.g., copy direct
> to a user buffer, or introduce an iterative interface, etc.).

Hi Brian,

I don't have a real preference whether the solution is to allow larger 
buffers or to error out of setxattr even though XFS could handle it, as 
long as it is no longer possible for an XFS user to get into this state 
where there is no (easy) way to recover.  I think we've hard-coded Ceph to 
only try up to 64 KB here, but I don't see that limitation documented 
anywhere and a savvy user can pass in a NULL buffer to get an 
appropriate length back.

In our case, we only hit this limit when something else has already gone 
a bit off the rails, so getting ENOSPC is just fine.

sage



> 
> Brian
> 
> > sage
> > 
> > 
> > #include <stdio.h>
> > #include <unistd.h>
> > #include <sys/types.h>
> > #include <sys/xattr.h>
> > #include <string.h>
> > #include <errno.h>
> > 
> > int main(int argc, char **argv)
> > {
> > 	char *fn = argv[1];
> > 	char buf[655360];
> > 	int buflen = sizeof(buf);
> > 	int i;
> > 
> > 	for (i = 0; i < 10000; ++i) {
> > 		int r = listxattr(fn, buf, buflen);
> > 		if (r < 0) {
> > 			perror("listxattr");
> > 			return 1;
> > 		}
> > 		char n[100];
> > 		sprintf(n, "user.foooooooooooooooooooooooooooooooooooooo%d", i);
> > 		r = setxattr(fn, n, "", 0, 0);
> > 		if (r < 0) {
> > 			perror("setxattr");
> > 			return 1;
> > 		}
> > 		printf("set %d\n", i);
> > 	}
> > 	return 0;
> > }
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
