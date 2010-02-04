Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o14JgGsv086471 for <xfs@oss.sgi.com>; Thu, 4 Feb 2010 13:42:17 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 08457137C1DF
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2010 11:43:26 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id o0wdCG5IOO4qKR84 for
	<xfs@oss.sgi.com>; Thu, 04 Feb 2010 11:43:26 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o14JhQoE014427
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 4 Feb 2010 14:43:26 -0500
Message-ID: <4B6B235D.5060903@sandeen.net>
Date: Thu, 04 Feb 2010 13:43:25 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V2] mkfs: don't try to detect filesystems on regular files
	via	blkid
References: <4B6AF6FC.6030101@redhat.com> <4B6B087F.80901@sandeen.net>
In-Reply-To: <4B6B087F.80901@sandeen.net>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Jim Meyering <meyering@redhat.com>, xfs mailing list <xfs@oss.sgi.com>

Eric Sandeen wrote:
> from RH bug 
> https://bugzilla.redhat.com/show_bug.cgi?id=561870
> 
> # dd if=/dev/zero of=k bs=1MB count=2 seek=20; mkfs.xfs k 
> # mkfs.xfs: probe of k failed, cannot detect existing filesystem.
> # mkfs.xfs: Use the -f option to force overwrite.
> 
> blkid fails to do a probe of a regular file.
> 
> I wish blkid would cope with this, but for now it might
> be better to just turn it off.
> 
> I kept the size==0 check just in case we stumble on a 0-sized
> device, blkid doesn't like that either...
> 
> Reported-by: Jim Meyering <meyering@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

OK NAK on that, hch has a better patch, we were driving blkid wrong.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
