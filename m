Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2C02F7CA3
	for <xfs@oss.sgi.com>; Sat,  2 Jul 2016 15:13:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 99644AC001
	for <xfs@oss.sgi.com>; Sat,  2 Jul 2016 13:12:57 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id jw1hqSKA7JNmzJZu (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 02 Jul 2016 13:12:54 -0700 (PDT)
Date: Sat, 2 Jul 2016 13:12:49 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: High Fragmentation with XFS and NFS Sync
Message-ID: <20160702201249.GH4917@birch.djwong.org>
References: <CAC5UwBi8Skjx90_XC5Z5B8P+CadawBZ3iUabKtm-2ZvrkgocZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAC5UwBi8Skjx90_XC5Z5B8P+CadawBZ3iUabKtm-2ZvrkgocZQ@mail.gmail.com>
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
To: Nick Fisk <friskyfisk10@googlemail.com>
Cc: xfs@oss.sgi.com

On Sat, Jul 02, 2016 at 09:52:40AM +0100, Nick Fisk wrote:
> Hi, hope someone can help me here.
> 
> I'm exporting some XFS fs's to ESX via NFS with the sync option enabled. I'm
> seeing really heavy fragmentation when multiple VM's are copied onto the
> share at the same time. I'm also seeing kmem_alloc failures, which is
> probably the biggest problem as this effectively takes everything down.

(Probably a result of loading the millions of bmbt extents into memory?)

> Underlying storage is a Ceph RBD, the server the FS is running on, is
> running kernel 4.5.7. Mount options are currently default. I'm seeing
> Millions of extents, where the ideal is listed as a couple of thousand when
> running xfs_db, there is only a couple of 100 files on the FS. It looks
> like roughly the extent sizes roughly match the IO size that the VM's were
> written to XFS with. So it looks like each parallel IO thread is being
> allocated next to each other rather than at spaced out regions of the disk.
> 
> From what I understand, this is because each NFS write opens and closes the
> file which throws off any chance that XFS will be able to use its allocation
> features to stop parallel write streams from interleaving with each other.
> 
> Is there anything I can tune to try and give each write to each file a
> little bit of space, so that it at least gives readahead a chance when
> reading, that it might hit at least a few MB of sequential data?

/me wonders if setting an extent size hint on the rootdir before copying
the files over would help here...

--D

> 
> I have read that inode32 allocates more randomly compared to inode64, so I'm
> not sure if it's worth trying this as there will likely be less than a 1000
> files per FS.
> 
> Or am I best just to run fsr after everything has been copied on?
> 
> Thanks for any advice
> Nick

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
