Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p07EYBXI067636 for <xfs@oss.sgi.com>; Fri, 7 Jan 2011 08:34:11 -0600
Received: from mail-pw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 99C6C248F8A
	for <xfs@oss.sgi.com>; Fri,  7 Jan 2011 06:36:21 -0800 (PST)
Received: from mail-pw0-f53.google.com (mail-pw0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id YwauzCYHtD6PTlb0
	for <xfs@oss.sgi.com>; Fri, 07 Jan 2011 06:36:21 -0800 (PST)
Received: by pwj6 with SMTP id 6so3670482pwj.26
	for <xfs@oss.sgi.com>; Fri, 07 Jan 2011 06:36:21 -0800 (PST)
Message-ID: <4D2724E0.9020801@philkarn.net>
Date: Fri, 07 Jan 2011 06:36:16 -0800
From: Phil Karn <karn@philkarn.net>
MIME-Version: 1.0
Subject: realtime partition support?
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

What's the status of the realtime partition feature in XFS? I think I
read somewhere that it wasn't actually implemented and/or working in the
Linux XFS implementation, but I'm not sure. If it is in Linux, how well
tested is it?

It occurred to me that the XFS realtime feature might be a quick and
easy way to make a hybrid of a SSD and a rotating drive. Just create a
XFS file system on the SSD that specifies the rotating drive as its
realtime partition. This would put all the metadata on the SSD where it
can be quickly accessed at random.

Throughput on large files would be almost as fast as if everything were
on the SSD. Small files wouldn't be as fast, but still much faster than
with no SSD at all.

Phil

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
