Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E26F77F37
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2016 04:29:05 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CC4738F8033
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2016 02:29:02 -0800 (PST)
Received: from resqmta-ch2-01v.sys.comcast.net
	(resqmta-ch2-01v.sys.comcast.net [69.252.207.33]) by
	cuda.sgi.com with ESMTP id GCyMhSohqDBQk1LE (version=TLSv1.2
	cipher=DHE-RSA-AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 18 Jan 2016 02:28:59 -0800 (PST)
From: Joshua Kinard <kumba@gentoo.org>
Subject: [PATCH 0/3] xfsprogs: misc uClibc patches
Message-ID: <569CBE4F.6000306@gentoo.org>
Date: Mon, 18 Jan 2016 05:28:31 -0500
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

I'm sending these three patches upstream that allow xfsprogs to compile and
work on uclibc-based userlands.  Two of them were sent upstream a few years ago
(2012), and one was rejected, but I don't know what the status was on the other.

Patches were contributed to Gentoo in our Bug #477758:
https://bugs.gentoo.org/show_bug.cgi?id=477758

xfsprogs-4.3.0-remove-aio-check.patch
Removes the configure check for aio.h, which is not provided by uClibc.  It
appears xfsprogs has no logic (that I can find) to compile against or utilize
AIO capabilities.

xfsprogs-4.3.0-use-sigprocmask.patch
uClibc doesn't provide the sigrelse or sighold calls, so this patch replaces
them with POSIX signal API calls (sigprocmask(2), etc).  This was previously
submitted in the below thread, but I don't see a status update on whether it
was accepted or rejected:
http://oss.sgi.com/archives/xfs/2012-03/msg00015.html

xfsprogs-4.3.0-use-statfs.patch
uClibc doesn't provide the ustat() call and (apparently) statfs() should be
used instead.  This patch was sent upstream before, but rejected because
xfsprogs apparently relies on ustat() reporting if a block device is mounted
anywhere.  I don't know if that's still the case now, but the attached patch
was re-written by another Gentoo user after the first one got rejected, so
resubmitting seems prudent.  The newer patch looks for mounted block devices by
checking mounts and/or mtab.

Thanks!

-- 
Joshua Kinard
Gentoo/MIPS
kumba@gentoo.org
6144R/F5C6C943 2015-04-27
177C 1972 1FB8 F254 BAD0 3E72 5C63 F4E3 F5C6 C943

"The past tempts us, the present confuses us, the future frightens us.  And our
lives slip away, moment by moment, lost in that vast, terrible in-between."

--Emperor Turhan, Centauri Republic

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
