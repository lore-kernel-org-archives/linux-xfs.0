Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DEF297FB3
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 22:56:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C4BB6304039
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 20:56:22 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id hD5GXb8EuZ8lunJL for
	<xfs@oss.sgi.com>; Tue, 15 Jul 2014 20:56:20 -0700 (PDT)
Date: Tue, 15 Jul 2014 23:56:13 -0400 (EDT)
From: Nathan Scott <nathans@debian.org>
Message-ID: <709922250.10972745.1405482973400.JavaMail.zimbra@redhat.com>
In-Reply-To: <369317103.10971454.1405482000035.JavaMail.zimbra@redhat.com>
References: <53C3FFED.5080301@sandeen.net>
	<369317103.10971454.1405482000035.JavaMail.zimbra@redhat.com>
Subject: Re: time for an xfsdump release?
MIME-Version: 1.0
Reply-To: Nathan Scott <nathans@debian.org>
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
To: Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>



----- Original Message -----
> ----- Original Message -----
> > There aren't a lot of changes since v3.1.3, but with the rate of change of
> > xfsdump (slow), I wonder if it's worth cutting a point release to get these
> > bugfixes out there:
> 
> I've verified and pushed a few Debian packaging updates folks have sent
> through to the git tree below.  Please include these odds & ends too...
> 

And some similar changes for xfsprogs... thanks.


Changes committed to git://oss.sgi.com/nathans/xfsprogs.git master

 debian/Makefile  |    2 +-
 debian/changelog |    7 +++++++
 debian/watch     |    3 +++
 3 files changed, 11 insertions(+), 1 deletion(-)

commit b6ad8545923aaa0bcc6ec7f7d3edea00382ef3a1
Author: Nathan Scott <nathans@redhat.com>
Date:   Wed Jul 16 13:50:47 2014 +1000

    xfsprogs: update debian packaging for next release
    
    Make a note of each of the Debian bugs resolved in this release,
    so that they'll be automatically closed during next upload.
    
    Signed-off-by: Nathan Scott <nathans@debian.org>

commit 1a05f9188b1a151fa6dcdec61880699d2acf53cd
Author: Nathan Scott <nathans@redhat.com>
Date:   Wed Jul 16 13:49:16 2014 +1000

    xfsprogs: add a watch file into the debian packaging
    
    Apparently it can improve some Debian tools that check it (e.g. UDD).
    Resolves Debian bug #748483.
    
    Signed-off-by: Nathan Scott <nathans@debian.org>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
