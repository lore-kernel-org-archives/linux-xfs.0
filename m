Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n91LGYlW123211 for <xfs@oss.sgi.com>; Thu, 1 Oct 2009 16:16:36 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CD5EF1722E62
	for <xfs@oss.sgi.com>; Thu,  1 Oct 2009 14:17:57 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv5.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id UJDjzKBfWjdmiOD0 for
	<xfs@oss.sgi.com>; Thu, 01 Oct 2009 14:17:57 -0700 (PDT)
From: "Michael Monnerie" <michael.monnerie@is.it-management.at>
References: <4AC45B72.9060500@decisionsoft.co.uk>	<200910011244.37489@zmi.at>
	<4AC4B954.9050303@decisionsoft.co.uk>
In-Reply-To: <4AC4B954.9050303@decisionsoft.co.uk>
Subject: RE: Two XFS involving stack traces from Debian's 2.6.26-2-amd64
Date: Thu, 1 Oct 2009 23:17:56 +0200
Message-ID: <000a01ca42dc$a64c7f70$f2e57e50$@monnerie@is.it-management.at>
MIME-Version: 1.0
Content-Language: de-at
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
To: strr-debian@decisionsoft.co.uk
Cc: xfs@oss.sgi.com

> Thanks, I've changed it as you suggested. It's true a second call
> to umount
> does unmount it (well it disappears from /proc/mounts anyway).

I've had the same problem with a backup script to a NAS. It takes a long time until the buffers flush or so, a loop with up to 5 umount retries has to be done. But that works always, at least ;-)
 
> However lvremove still does not succeed because it still believes
> the volume to be open.

Even after umount? Hm, that smells like a bug. Maybe make
umount && sleep 5 && lvremove
if that works a timing problem it is, says Yoda.

mfg zmi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
