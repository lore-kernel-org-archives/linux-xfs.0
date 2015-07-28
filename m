Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8E89E7F9E
	for <xfs@oss.sgi.com>; Tue, 28 Jul 2015 14:52:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 26D77AC008
	for <xfs@oss.sgi.com>; Tue, 28 Jul 2015 12:52:48 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id dmVqcCHRsnUaEUkN for
	<xfs@oss.sgi.com>; Tue, 28 Jul 2015 12:52:47 -0700 (PDT)
From: Martin Steigerwald <martin@lichtvoll.de>
Subject: Re: XFS File system in trouble
Date: Tue, 28 Jul 2015 21:52:45 +0200
Message-ID: <1632167.gHuGj7l2Oo@merkaba>
In-Reply-To: <55B7D400.50202@gmail.com>
References: <03864DDC681E664EBF5D47682BE7D7CF0D3574DF@USADCWVEMBX07.corp.global.level3.com>
	<55B7B390.1050206@sandeen.net> <55B7D400.50202@gmail.com>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Martin Papik <mp6058@gmail.com>

Am Dienstag, 28. Juli 2015, 22:12:00 schrieb Martin Papik:
> >>> Hmm, I guess the file size exceeds the capabilities of the root
> >>> fs, even if there might ultimately be enough space to restore
> >>> the metadump.
> >> 
> >> I wouldn't think so, at least not fundamentally. It's ext4. It's
> >> certainly not big enough to hold an 18T file system, though, and
> >> perhaps that is what xfs_restore is checking.
> > 
> > No, it's just failing to write any data at an 18T offset.
> > 
> > The ext4 filesystem (with 4k blocks) is limited to a 16T maximum
> > file offset; you won't be able to restore a (sparse) 18T
> > filesystem image onto an ext4 filesystem.

> How about this?
> 
> qemu-img create -f qcow2 test 32T
> qemu-nbd -c /dev/nbd0 test
> xfs_mdrestore -g md0.metadump /dev/nbd0

I used an XFS filesystem with truncate command to create an 1 EiB XFS 
filesystem in a sparse file for testing a year or two ago. It took about 18 
GiB for writing metadata and journal at mkfs.xfs time.

With df -h you get "1E" and with df without option you get an really large 
number :)

Thanks,
-- 
Martin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
