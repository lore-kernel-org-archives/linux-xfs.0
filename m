Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CC4507F3F
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 11:27:39 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 56DB5AC006
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 09:27:36 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QFzn1Vq4ClmGCdXr for
	<xfs@oss.sgi.com>; Wed, 11 Dec 2013 09:27:35 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rBBHRXju031250
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 12:27:34 -0500
Received: from gelk.kernelslacker.org (ovpn-113-210.phx2.redhat.com
	[10.3.113.210])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id rBBHRSDd007524
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 12:27:33 -0500
Received: from gelk.kernelslacker.org (localhost [127.0.0.1])
	by gelk.kernelslacker.org (8.14.7/8.14.7) with ESMTP id rBBHRRbn005181
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 12:27:27 -0500
Received: (from davej@localhost)
	by gelk.kernelslacker.org (8.14.7/8.14.7/Submit) id rBBHRPK7005180
	for xfs@oss.sgi.com; Wed, 11 Dec 2013 12:27:25 -0500
Date: Wed, 11 Dec 2013 12:27:25 -0500
From: Dave Jones <davej@redhat.com>
Subject: XFS: Internal error XFS_WANT_CORRUPTED_RETURN
Message-ID: <20131211172725.GA4606@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Powered up my desktop this morning and noticed I couldn't cd into ~/Mail
dmesg didn't look good.  "XFS: Internal error XFS_WANT_CORRUPTED_RETURN"
http://codemonkey.org.uk/junk/xfs-1.txt

I rebooted into single user mode, and ran xfs_repair on /dev/sda3 (/home).
It fixed up a bunch of stuff, but ended up eating ~/.procmailrc entirely
(no sign of it in lost & found), and a bunch of filenames got garbled
'december' became 'decemcer' for eg.  Looks like a couple kernel trees ended
up in lost & found.

After rebooting back into multi-user mode, I looked in dmesg again to be sure
and this time sda2 was complaining..

http://codemonkey.org.uk/junk/xfs-2.txt

Same drill, reboot, xfs_repair. Looks like a bunch of man pages ended up in lost & found.

Thoughts ? Could sda be dying ? (It is a fairly old crappy ssd)

	Dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
