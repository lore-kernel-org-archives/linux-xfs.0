Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4PFl6Fv003924 for <xfs@oss.sgi.com>; Tue, 25 May 2010 10:47:08 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CAB5F36F29F
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 08:49:29 -0700 (PDT)
Received: from bombadil.infradead.org ([18.85.46.34]) by cuda.sgi.com with
	ESMTP id 4G8gs9Qx8ZG3kvp3 for <xfs@oss.sgi.com>;
	Tue, 25 May 2010 08:49:29 -0700 (PDT)
Date: Tue, 25 May 2010 11:49:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: LVM snapshot not mountable
Message-ID: <20100525154927.GA25353@infradead.org>
References: <201005251725.48452@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201005251725.48452@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Tue, May 25, 2010 at 05:25:44PM +0200, Michael Monnerie wrote:
> This might be LVM specific, please apologize. For the first time I play 
> around with LVM snapshots. I tried this:
> lvcreate -s -n dbsnap -L 4G -v /dev/db/mysql
> mount /dev/db/dbnap /mnt
> but the mount fails, dmesg says:
> [  598.440324] XFS: Filesystem dm-1 has duplicate UUID - can't mount
> 
> How could I mount it?

mount -o ro,norecovery,nouuid /dev/db/dbnap /mnt

or use

 xfs_admin -U generate /dev/db/dbnap

to give it a different uuid first in case you're dealing with a
writeable snapshot.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
