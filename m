Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3FCF87F62
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 03:57:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2AEA18F8035
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 01:57:45 -0800 (PST)
Received: from mx6-phx2.redhat.com (mx6-phx2.redhat.com [209.132.183.39]) by
	cuda.sgi.com with ESMTP id UWM2HNNDrjdKXSFF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Nov 2014 01:57:44 -0800 (PST)
Date: Mon, 10 Nov 2014 04:57:43 -0500 (EST)
From: Nathan Scott <nathans@debian.org>
Message-ID: <1329810397.11003116.1415613463138.JavaMail.zimbra@redhat.com>
In-Reply-To: <242895341.10993728.1415612766093.JavaMail.zimbra@redhat.com>
Subject: xfsprogs updates: deb updates for 3.2.2
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
To: Dave Chinner <dchinner@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Changes committed to git://oss.sgi.com/nathans/xfsprogs master

 debian/changelog |    8 ++++++++
 debian/control   |    2 +-
 debian/copyright |    4 ++--
 debian/rules     |    4 ++--
 4 files changed, 13 insertions(+), 5 deletions(-)

commit d55fa71e95b5dacfe342cfd073f4835f5b1822ce
Author: Nathan Scott <nathans@debian.org>
Date:   Mon Nov 10 20:52:31 2014 +1100

    packaging: update deb changelog for upcoming release
    
    Add list of resolved issues from merged patches into the
    debian/changelog for processing with the next release.
    
    Signed-off-by: Nathan Scott <nathans@debian.org>

commit 1293cdbcb76a271a809b38e8e583df09a03f6950
Author: Nathan Scott <nathans@debian.org>
Date:   Mon Nov 10 20:52:18 2014 +1100

    packaging: clarify xfs header licensing within deb builds
    
    Tackles bug #751511 - ensuring the licensing information in
    the debian/copyright file matches reality.  Use explanation
    that Christoph Hellwig came up with, pretty much verbatim.
    
    Signed-off-by: Nathan Scott <nathans@debian.org>

commit 67c88e33106a035ef51e1f8280c3526d56e08fe3
Author: Nathan Scott <nathans@debian.org>
Date:   Mon Nov 10 20:51:52 2014 +1100

    packaging: rework dh_autoreconf invocation for deb builds
    
    Reviewed, tested and merged the final iteration of proposed
    solutions to #757455 - resolving configure-script-generation
    for clean ppc64le builds, originally.  Many thanks to Andreas
    Barth and Matthias Klose for coming up with this solution.
    
    Signed-off-by: Nathan Scott <nathans@debian.org>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
