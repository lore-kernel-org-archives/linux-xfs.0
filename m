Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3UGkwRB174215 for <xfs@oss.sgi.com>; Fri, 30 Apr 2010 11:47:00 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 801C8903B11
	for <xfs@oss.sgi.com>; Fri, 30 Apr 2010 09:49:04 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id I0cnZKzGBO79ee94 for
	<xfs@oss.sgi.com>; Fri, 30 Apr 2010 09:49:04 -0700 (PDT)
Message-ID: <4BDB09FF.8020901@sandeen.net>
Date: Fri, 30 Apr 2010 11:49:03 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Building XFSDump but missing uuid development package
References: <53964.41414.qm@web180401.mail.gq1.yahoo.com>
In-Reply-To: <53964.41414.qm@web180401.mail.gq1.yahoo.com>
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
To: Peter Shuere <petershuere@yahoo.com>
Cc: xfs@oss.sgi.com

Peter Shuere wrote:
> Hi,
> 
> I am trying to build the XFS utility, but during the build-process, I
> ran into a problem saying that I need the UUID development package to
> make the build complete. I am using OpenSUSE 11.2, where should I get
> the copy of the uuid-devel source (or binary, whichever one that
> works).

e2fsprogs-devel might contain it; fedora recently split this out into a
separate uuid-devel package which then moved to a sub-package of util-linux-ng.

So you'll need one of those packages, whatever contains the uuid headers.

(FWIW opensuse probably already has xfsprogs packaged, but I assume
you have a reason to build it yourself...)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
