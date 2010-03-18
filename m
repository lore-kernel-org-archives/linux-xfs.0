Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2II8oVb158102 for <xfs@oss.sgi.com>; Thu, 18 Mar 2010 13:08:57 -0500
Received: from mail.phy.duke.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DE5F325E829
	for <xfs@oss.sgi.com>; Thu, 18 Mar 2010 11:10:20 -0700 (PDT)
Received: from mail.phy.duke.edu (mail.phy.duke.edu [152.3.182.2]) by
	cuda.sgi.com with ESMTP id z86BQ0GxniWQvihC for
	<xfs@oss.sgi.com>; Thu, 18 Mar 2010 11:10:20 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.phy.duke.edu (Postfix) with ESMTP id 977B8780B6
	for <xfs@oss.sgi.com>; Thu, 18 Mar 2010 14:10:00 -0400 (EDT)
Received: from mail.phy.duke.edu ([127.0.0.1])
	by localhost (mail.phy.duke.edu [127.0.0.1]) (amavisd-new, port 10026)
	with LMTP id Mdvzg6uefCpu for <xfs@oss.sgi.com>;
	Thu, 18 Mar 2010 14:10:00 -0400 (EDT)
Received: from [152.3.182.165] (grads-74.phy.duke.edu [152.3.182.165])
	by mail.phy.duke.edu (Postfix) with ESMTP id 7ACEE780B5
	for <xfs@oss.sgi.com>; Thu, 18 Mar 2010 14:10:00 -0400 (EDT)
Subject: xfsrestore very slow
From: Jimmy Dorff <jdorff@phy.duke.edu>
Date: Thu, 18 Mar 2010 14:10:20 -0400
Message-ID: <1268935820.3074.16.camel@grads-74.phy.duke.edu>
Mime-Version: 1.0
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

Hi Folks,

I have a xfsdump on a hard drive. I would like to restore some files
from the dump, but it seems to take a very long time to get past the
"xfsrestore: reading directories" step.

I'm currently running:
xfsrestore -i -p 15 -J -f /mnt/external/xfsdumpfile /home/restore/
...
xfsrestore: session time: Mon Feb 22 07:24:37 2010
xfsrestore: level: 0
xfsrestore: session label: "FEB222010"
xfsrestore: media label: "TAPE1"
xfsrestore: file system id: 7f1772b4-b84f-4dda-9aaa-50171958e3be
xfsrestore: session id: 2e475d74-ea50-415b-8ac4-0d1aa1755a08
xfsrestore: media id: 30f4a884-0986-4720-b1cc-5f4b9429ec09
xfsrestore: searching media for directory dump
xfsrestore: reading directories
xfsrestore: status at 13:38:19: 24390/137035 directories reconstructed,
17.8% complete, 250561 directory entries processed, 7348 seconds elapsed

The dump file isn't that big (132G) and didn't take this long to create.
Is this normal or is something wrong ?

Thanks,
Jimmy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
