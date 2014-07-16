Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 31A9A7FAA
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 22:40:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9ECB8AC002
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 20:40:08 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id D8HWT85GH5VG3XGx for
	<xfs@oss.sgi.com>; Tue, 15 Jul 2014 20:40:06 -0700 (PDT)
Date: Tue, 15 Jul 2014 23:40:00 -0400 (EDT)
From: Nathan Scott <nathans@debian.org>
Message-ID: <369317103.10971454.1405482000035.JavaMail.zimbra@redhat.com>
In-Reply-To: <53C3FFED.5080301@sandeen.net>
References: <53C3FFED.5080301@sandeen.net>
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

Hi,

----- Original Message -----
> There aren't a lot of changes since v3.1.3, but with the rate of change of
> xfsdump (slow), I wonder if it's worth cutting a point release to get these
> bugfixes out there:

I've verified and pushed a few Debian packaging updates folks have sent
through to the git tree below.  Please include these odds & ends too...

thanks!


Changes committed to git://oss.sgi.com/nathans/xfsdump.git master

 debian/Makefile  |    2 +-
 debian/changelog |    8 ++++++++
 debian/control   |    2 +-
 debian/rules     |    3 +++
 debian/watch     |    3 +++
 5 files changed, 16 insertions(+), 2 deletions(-)

commit 96be05e971e1e23c252f5432fe430cd724a52910
Author: Nathan Scott <nathans@debian.org>
Date:   Wed Jul 16 13:29:12 2014 +1000

    xfsdump: update debian packaging for next release
    
    Make a note of each of the Debian bugs resolved in this release,
    so that they'll be automatically closed during next upload.
    
    Signed-off-by: Nathan Scott <nathans@debian.org>

commit f33aa73b89624feaeb94f4d48b88f2d480798420
Author: Nathan Scott <nathans@debian.org>
Date:   Wed Jul 16 13:25:36 2014 +1000

    xfsdump: add a watch file into the debian packaging
    
    Apparently it can improve some Debian tools that check it (e.g. UDD).
    Resolves Debian bug #748482.
    
    Signed-off-by: Nathan Scott <nathans@debian.org>

commit fae9bcf317ce3a0d919ebdc6fd667993a4dbd484
Author: Nathan Scott <nathans@debian.org>
Date:   Wed Jul 16 13:21:27 2014 +1000

    xfsdump: rebuild configure files during deb package builds
    
    Use the same technique applied to xfsprogs recently to tackle
    out-of-date config.{sub,guess} files in the build.
    
    Resolves Debian bug #746531.
    
    Signed-off-by: Nathan Scott <nathans@debian.org>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
