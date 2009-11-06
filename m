Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA62RVKH165632 for <xfs@oss.sgi.com>; Thu, 5 Nov 2009 20:27:31 -0600
Received: from capella.opentrend.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4E108CCEC8A
	for <xfs@oss.sgi.com>; Thu,  5 Nov 2009 18:27:44 -0800 (PST)
Received: from capella.opentrend.net (capella.opentrend.net [64.22.125.103])
	by cuda.sgi.com with ESMTP id 42ti7leEDT0HK8je for
	<xfs@oss.sgi.com>; Thu, 05 Nov 2009 18:27:44 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by capella.opentrend.net (Postfix) with ESMTP id 7FC8A13CBED
	for <xfs@oss.sgi.com>; Thu,  5 Nov 2009 21:27:43 -0500 (EST)
Date: Thu, 5 Nov 2009 21:27:43 -0500 (EST)
From: Robert Brockway <robert@timetraveller.org>
Subject: Re: xfs_repair breaks; xfs_metadump hangs
In-Reply-To: <20091104152022.GA21347@mytux.intra.in-medias-res.com>
Message-ID: <alpine.DEB.1.10.0911052122230.25757@capella.opentrend.net>
References: <20091104152022.GA21347@mytux.intra.in-medias-res.com>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

On Wed, 4 Nov 2009, mill / in-medias-res wrote:

> Hello XFS-Community,
>
> i have some real trouble with restoring/repairing my two XFS Partion's. These
> Partion's are on a RAID-5 Array which "was broken". The first xfs_repair run
> on /dev/sdc1 did restore 80 GB from ca. 300-400 GB. The Problem was that 99,9%
> of the million files are in lost+found.

Time to invoke the disaster recovery plan and restore from backups?

At some point the effort required to recover a badly corrupt FS exceeds 
the loss from simply restoring from a known good backup.

You can still review the corrupt filesystem offline in order to pick up 
lost data, if it is worth doing so.

Rob

-- 
I tried to change the world but they had a no-return policy
http://www.practicalsysadmin.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
