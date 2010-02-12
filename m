Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CMQaOR038785
	for <linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 16:26:36 -0600
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F299B1CC939A
	for <linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 14:27:51 -0800 (PST)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id coSKkrz2yQBEhGLo for <linux-xfs@oss.sgi.com>;
	Fri, 12 Feb 2010 14:27:51 -0800 (PST)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1Ng3zK-0003R4-GD
	for linux-xfs@oss.sgi.com; Fri, 12 Feb 2010 23:27:50 +0100
Received: from vm15c-113.broadinstitute.org ([69.173.114.122])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 23:27:50 +0100
Received: from nico by vm15c-113.broadinstitute.org with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 23:27:50 +0100
From: Nicolas Stransky <nico@stransky.cx>
Subject: Re: xfs_repair on a 1.5 TiB image has been hanging for about an hour,
	now
Date: Fri, 12 Feb 2010 17:27:30 -0500
Message-ID: <hl4kkg$7rg$1@ger.gmane.org>
References: <2d460de71002120607g763afc2bt2167fcfbf4664b56@mail.gmail.com>	<4B75738D.80108@sandeen.net>	<2d460de71002120845ue5b127ex1033b37ae5ff6ba2@mail.gmail.com>	<2d460de71002120902g3bda548t4e202dfe43a0c742@mail.gmail.com>	<hl438l$bhm$1@ger.gmane.org>	<4B7594D3.6040304@sandeen.net>	<hl45te$kjs$1@ger.gmane.org>	<hl4dpt$fq2$1@ger.gmane.org>
	<4B75BEA6.70403@sandeen.net>
Mime-Version: 1.0
In-Reply-To: <4B75BEA6.70403@sandeen.net>
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
To: linux-xfs@oss.sgi.com

On 2/12/10 3:48 PM, Eric Sandeen wrote:
> Nicolas Stransky wrote:
>> The -P option allowed me to complete xfs_repair successfully, but it
>> also deleted almost everything on the filesystem... A directory that I
>> could mount -o ro,norecovery before, with tens of GB of data in it, is
>> now empty... That is really too bad.
> 
> Any idea what happened to the fs - what prompted the repair?

Yes, it's a RAID 5 array that failed pretty bad due to multiple reboots
of the machine. Some disks failed and at some point, the RAID card did
stopped to detect some of the disks, or failed to assemble the RAID
array correctly. 3ware (LSI) issued a fix that allowed to start the
array in degraded mode, but the xfs filesystem seemed in a pretty bad
shape at that point. xfs_repair was failing right at the beginning and I
had to xfs_repair -L. Then xfs_repair was hanging forever. It's only
today, by using -P, that I got it to complete.

> Did you save the logs, or a preliminary metadump?

No I did not.

> I wonder what it found.  The files aren't in lost+found/ ?

There are tons of gigs of files in lost+found but I can't really sort
them and figure out which one is which at this point...

Thanks,
-- 
Nico

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
