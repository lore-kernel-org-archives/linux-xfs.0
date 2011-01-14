Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0EIGllr066121 for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 12:16:48 -0600
Received: from mail-pz0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 87CA712FF1E8
	for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 10:19:01 -0800 (PST)
Received: from mail-pz0-f53.google.com (mail-pz0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id QGkwjwB0qVcMPa2d
	for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 10:19:01 -0800 (PST)
Received: by pzk37 with SMTP id 37so625190pzk.26
	for <xfs@oss.sgi.com>; Fri, 14 Jan 2011 10:19:01 -0800 (PST)
Message-ID: <4D309390.4060009@philkarn.net>
Date: Fri, 14 Jan 2011 10:18:56 -0800
From: Phil Karn <karn@philkarn.net>
MIME-Version: 1.0
Subject: fallocate everywhere?
Reply-To: karn@ka9q.net
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
To: xfs@oss.sgi.com

Can anyone think of a good reason *not* to sprinkle fallocate() calls
through as many Linux utilities as possible? E.g., programs like rsync,
tar, cpio, pax, ftp, mv, cp -- anything and everything that creates a
file with a size known in advance.

As far as I can tell, calling fallocate() when it's not supported
quickly returns an error and does no harm. So I can't even think of a
reason to only make it optional. If it's implemented as an
off-by-default option, most people would probably not know about it so
it would rarely get used. Those who do know about it would frequently
forget to use it, and choosing and learning a separate option for every
command would be painful.

Besides xfs, ext4 supports fallocate so I expect that most Linux systems
will be able to benefit from it fairly soon.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
