Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8LLWcec030695
	for <linux-xfs@oss.sgi.com>; Tue, 21 Sep 2010 16:32:40 -0500
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 39167182EC75
	for <linux-xfs@oss.sgi.com>; Tue, 21 Sep 2010 14:33:30 -0700 (PDT)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id YRGZ9toOq2FEwn5d for <linux-xfs@oss.sgi.com>;
	Tue, 21 Sep 2010 14:33:30 -0700 (PDT)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1OyASo-0004Rr-74
	for linux-xfs@oss.sgi.com; Tue, 21 Sep 2010 23:33:22 +0200
Received: from p4fd4aa0f.dip0.t-ipconnect.de ([79.212.170.15])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 21 Sep 2010 23:33:22 +0200
Received: from Manuel.Spam by p4fd4aa0f.dip0.t-ipconnect.de with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 21 Sep 2010 23:33:22 +0200
From: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Subject: Re: System partially unusable after power loss...
Date: Tue, 21 Sep 2010 23:30:05 +0200
Message-ID: <i7b8ao$erp$1@dough.gmane.org>
References: <i6ttq6$41d$1@dough.gmane.org> <4C928424.1020409@sandeen.net>
Mime-Version: 1.0
In-Reply-To: <4C928424.1020409@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

Eric Sandeen wrote:
>> and two files with ELF header, which may be (a part of) library files, I
>> don't know, as the name wasn't restored.
>
> Having the xfs_repair output would be helpful.

I didn't save this...

> Was there a system software update just prior to the power loss?

The affected files have been updated some days/weeks before.

> Did your storage support IO barriers (i.e. was it lvm or md)?

No lvm, no md. A simple IDE drive.

> Buffered data is always lost on a power loss, but I'm not sure
> why you should see problems with system files unless they had
> just been written out (and not synced).

I fixed this system. The reason was this silly "kbuildsycoca" or better 
a config file, accessible by the user, using this PC. Seems like this 
"non system file" got corrupted in some way. A run of "kbuildsycoca 
--noincremental" fixed the config and the system was up and running again.

But why did xfs_repair restore files... For me it seems like xfs_repair 
restored an *old* version of openssl, which has been replaced by the 
system update process. This would mean: xfs_repair made a deleted file 
visible. Is this possible?

Yours

Manuel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
