Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7Q9VDJi043291 for <xfs@oss.sgi.com>; Sun, 26 Aug 2012 04:31:13 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	1NDNyvilMfyTpMLv (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 26 Aug 2012 02:32:02 -0700 (PDT)
Received: by obbwd18 with SMTP id wd18so3991316obb.26
	for <xfs@oss.sgi.com>; Sun, 26 Aug 2012 02:32:01 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 26 Aug 2012 11:32:01 +0200
Message-ID: <CAAxjCEwdYbcDoUvcAV1n8281HCCvrCvReaG2oM5+h+WV5yDZvA@mail.gmail.com>
Subject: umount doesn't seem to really unmount
From: Stefan Ring <stefanrin@gmail.com>
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
To: Linux fs XFS <xfs@oss.sgi.com>

Today I had some data loss with an XFS filesystem, apparently because
it does not write everything to disk during unmount. Yesterday, I shut
down my machine for the night. My XFS lives on an iSCSI volume which I
shut down shortly, but not instantly, after unmounting the XFS
filesystem. There has been no noticable disk activity after the
umount. Today, some recently written files all had size zero.
Additional indicators that something is amiss is, that during startup,
when mounting the XFS filesystem, it would often claim that it has
done log recovery, which should not be the case if it had been
unmounted correctly. Also, when I just mount and unmount the
filesystem repeatedly, I would at least expect "ending clean mount"
messages in dmesg, like I get on CentOS 6. Not so on my system.

This is with kernel 3.5.2-3.fc17 from Fedora. Is there a known problem?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
