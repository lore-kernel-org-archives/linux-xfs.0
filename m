Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o14GqFIO076425 for <xfs@oss.sgi.com>; Thu, 4 Feb 2010 10:52:16 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8AF491AF3FA
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2010 08:53:24 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id SjwTRvTSRXe0K8t8 for
	<xfs@oss.sgi.com>; Thu, 04 Feb 2010 08:53:24 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o14GrOfx013591
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 4 Feb 2010 11:53:24 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o14GrNue020255
	for <xfs@oss.sgi.com>; Thu, 4 Feb 2010 11:53:23 -0500
Message-ID: <4B6AFB83.1070309@sandeen.net>
Date: Thu, 04 Feb 2010 10:53:23 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: xfsprogs: to -DDEBUG or not to -DDEBUG?
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
To: xfs mailing list <xfs@oss.sgi.com>

Fedora, long ago, disabled debug in the xfsprogs specfile:

http://cvs.fedoraproject.org/viewvc/F-12/xfsprogs/xfsprogs.spec?r1=1.5&r2=1.6

* Wed Apr 20 2005 Dave Jones <davej@redhat.com>
- Disable debug. (#151438)

per this bug:  https://bugzilla.redhat.com/show_bug.cgi?id=151438

referencing this email thread:

http://oss.sgi.com/archives/linux-xfs/2005-03/msg00038.html
which no longer exists (grrrr) but is probably now here:

http://oss.sgi.com/archives/xfs/2005-03/msg00416.html

Fedora still builds with -DNDEBUG, but the upstream tarball has
it on by default.  I have seen several occasions where other
distros had failing xfs_repairs which were "fixed" by disabling
debug.  I'd like to make a decision on whether DEBUG should be
on or off by default for upstream releases.  Any thoughts?

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
