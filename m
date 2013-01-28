Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1AD647F76
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 17:28:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6AF5AAC006
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 15:28:24 -0800 (PST)
Received: from thunder.skymagik.net (thunder.skymagik.net [76.75.207.68]) by
	cuda.sgi.com with ESMTP id clDmZ9K8yVdjZBKK for
	<xfs@oss.sgi.com>; Mon, 28 Jan 2013 15:28:22 -0800 (PST)
Message-ID: <32271.192.104.24.222.1359415698.squirrel@secure.skymagik.net>
Date: Mon, 28 Jan 2013 18:28:18 -0500 (EST)
Subject: XFS appears to cause strange hang with md raid1 on reboot
From: "Tom" <storm9c1@skymagik.com>
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


Dear XFS folks,

I have been using XFS for many years, starting on IRIX and then on RedHat
7.2, and now on CentOS/RHEL and Ubuntu.  Last time I posted to this
mailing list was 12 years ago.  :-)  I've been a happy customer!

I understand that RedHat does not formally support XFS as a root filesystem
on RHEL.  However, up until now, I've been using it very successfully for
years on both CentOS and Ubuntu.  On CentOS, I've successfully patched
Anaconda since CentOS 5.6 to allow XFS root file system support directly
from Anaconda (on both bare metal and Xen VMs).  Prior to that, I had code
in %post that would simply migrate an ext3 fs to XFS.  And I always run
md raid1 (except with Xen, since I use mirroring on the dom0).  I never use
hardware RAID since I want to keep my provisioning as generic as possible.

I've deployed many servers using XFS this way and it has always been
superior for my workloads....  and superior to ext3, and ext4.

....until CentOS 5.9 came out.  Now any systems that are running the stock
CentOS 5.9 kernel (including 5.X systems upgraded to this kernel) hang
on reboot.  If I downgrade to the 5.8 kernel, the problem is resolved.

I have taken an engineering approach to testing this problem in efforts
to help resolve it.  I filed a bug with CentOS, but it's probably not
going to go anywhere upstream since RedHat probably won't support XFS on
the root filesystem (why I still don't understand, since I fixed the
issues with Anaconda for myself and can Kickstart systems with XFS all
day long).

Therefore I hope anyone here can help.  In fact, I was specifically hoping
to catch Eric Sandeen's attention since this seems like a pretty serious
regression.  It's further aggravated by the fact that RedHat stays behind
with kernel version and backports modern fixes.  I scanned over the
2.6.18-348.el5 (stock 5.9 kernel) changelog, and I see a few suspicious
things, but I'm not sure.

Much more detail is available here (CentOS bug id 0006217) including steps
to reproduce the problem.  Also testing with and without md raid.
http://bugs.centos.org/view.php?id=6217

The one thing I haven't provided is a traceback.  I can provide that if it
would be helpful.

I am not in a big hurry for help, on the contrary I just want to open up
a dialog since perhaps others might be suffering from this.  And I want to
help resolve it if I can.

Any insight is appreciated.

-- Tom


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
