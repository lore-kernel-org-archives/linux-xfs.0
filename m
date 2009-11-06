Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA68vXt7198731 for <xfs@oss.sgi.com>; Fri, 6 Nov 2009 02:57:34 -0600
Received: from mail.in-medias-res.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 946BA1BF4562
	for <xfs@oss.sgi.com>; Fri,  6 Nov 2009 00:57:47 -0800 (PST)
Received: from mail.in-medias-res.com (mail.in-medias-res.com [78.47.10.114])
	by cuda.sgi.com with ESMTP id 4HIi84BBoSZVpyw6 for
	<xfs@oss.sgi.com>; Fri, 06 Nov 2009 00:57:47 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by mail.in-medias-res.com (Postfix) with ESMTP id B0E822071A1
	for <xfs@oss.sgi.com>; Fri,  6 Nov 2009 09:57:46 +0100 (CET)
Received: from mail.in-medias-res.com ([127.0.0.1])
	by localhost (imr-web.in-medias-res.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id zYh6xbsr88wy for <xfs@oss.sgi.com>;
	Fri,  6 Nov 2009 09:57:40 +0100 (CET)
Received: from imr-mail.services.in-medias-res.com
	(port-212-202-160-2.static.qsc.de [212.202.160.2])
	by mail.in-medias-res.com (Postfix) with ESMTP id D8303164148
	for <xfs@oss.sgi.com>; Fri,  6 Nov 2009 09:57:40 +0100 (CET)
Received: from mytux.intra.in-medias-res.com ([192.168.2.128])
	by imr-mail.services.in-medias-res.com with esmtp (Exim 4.69)
	(envelope-from <mill@in-medias-res.com>) id 1N6KdY-0000n2-Ot
	for xfs@oss.sgi.com; Fri, 06 Nov 2009 09:57:40 +0100
Date: Fri, 6 Nov 2009 09:57:40 +0100
From: mill / in-medias-res <mill@in-medias-res.com>
Subject: Re: xfs_repair breaks; xfs_metadump hangs
Message-ID: <20091106085740.GA3492@mytux.intra.in-medias-res.com>
References: <20091104152022.GA21347@mytux.intra.in-medias-res.com>
	<alpine.DEB.1.10.0911052122230.25757@capella.opentrend.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0911052122230.25757@capella.opentrend.net>
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

* Robert Brockway <robert@timetraveller.org> [091106 03:28]:
> On Wed, 4 Nov 2009, mill / in-medias-res wrote:
>
>> Hello XFS-Community,
>>
>> i have some real trouble with restoring/repairing my two XFS Partion's. These
>> Partion's are on a RAID-5 Array which "was broken". The first xfs_repair run
>> on /dev/sdc1 did restore 80 GB from ca. 300-400 GB. The Problem was that 99,9%
>> of the million files are in lost+found.
>
> Time to invoke the disaster recovery plan and restore from backups?
Yeah, i did had an full backup of /dev/sdc1 one day old. Restoring was no problem.
The problem is that i don't have any backup from /dev/sdc2. Only 10-20 GB on DVD's

I have an slower server which serve's the clients, so i can try to get the rest
of the data.
Are there any other working repair tools for xfs ?
> At some point the effort required to recover a badly corrupt FS exceeds  
> the loss from simply restoring from a known good backup.
>
> You can still review the corrupt filesystem offline in order to pick up  
> lost data, if it is worth doing so.
>
> Rob

Max
> -- 
> I tried to change the world but they had a no-return policy
> http://www.practicalsysadmin.com
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
