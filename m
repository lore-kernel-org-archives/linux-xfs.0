Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4522B7F67
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 11:17:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 25191304043
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 09:17:02 -0800 (PST)
Received: from fieldses.org (fieldses.org [174.143.236.118]) by cuda.sgi.com
	with ESMTP id qA18NiHfFPpoxCpX (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 09:17:00 -0800 (PST)
Date: Tue, 6 Jan 2015 12:16:58 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 14/18] nfsd: pNFS block layout driver
Message-ID: <20150106171658.GD12067@fieldses.org>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<1420561721-9150-15-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1420561721-9150-15-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

On Tue, Jan 06, 2015 at 05:28:37PM +0100, Christoph Hellwig wrote:
> Add a small shim between core nfsd and filesystems to translate the
> somewhat cumbersome pNFS data structures and semantics to something
> more palatable for Linux filesystems.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  .../filesystems/nfs/pnfs-block-server.txt          |  40 +++++
>  fs/nfsd/Makefile                                   |   2 +-
>  fs/nfsd/blocklayout.c                              | 194 +++++++++++++++++++++
>  fs/nfsd/blocklayoutxdr.c                           | 157 +++++++++++++++++
>  fs/nfsd/blocklayoutxdr.h                           |  62 +++++++
>  fs/nfsd/nfs4layouts.c                              |   7 +
>  fs/nfsd/pnfs.h                                     |   1 +
>  7 files changed, 462 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/filesystems/nfs/pnfs-block-server.txt
>  create mode 100644 fs/nfsd/blocklayout.c
>  create mode 100644 fs/nfsd/blocklayoutxdr.c
>  create mode 100644 fs/nfsd/blocklayoutxdr.h
> 
> diff --git a/Documentation/filesystems/nfs/pnfs-block-server.txt b/Documentation/filesystems/nfs/pnfs-block-server.txt
> new file mode 100644
> index 0000000..f45d399
> --- /dev/null
> +++ b/Documentation/filesystems/nfs/pnfs-block-server.txt
> @@ -0,0 +1,40 @@
> +pNFS block layout server user guide
> +
> +The Linux NFS server now supports the pNFS block layout extension.  In this
> +case the NFS server acts as Metadata Server (MDS) for pNFS, which in addition
> +to handling all the metadata access to the NFS export also hands out layouts
> +to the clients to directly access the underlying block devices that is

s/is/are/.

> +shared with the client.  Note that there are no Data Servers (DSs) in the
> +block layout flavor of pNFS.
> +
> +To use pNFS block layouts with with the Linux NFS server the exported file
> +system needs to support the pNFS block layouts (current just XFS), and the
> +file system must sit on shared storage (typically iSCSI) that is accessible
> +to the clients as well as the server.  The file system needs to either sit
> +directly on the exported volume, or on a RAID 0 using the MD software RAID
> +driver with the version 1 superblock format.  If the filesystem uses sits
> +on a RAID 0 device the clients will automatically stripe their I/O over
> +multiple LUNs.
> +
> +On the server pNFS block volume support is automatically if the file system

s/automatically/automatically enabled/.

So there's no server-side configuration required at all?

--b.

> +support its.  On the client make sure the kernel has the CONFIG_PNFS_BLOCK
> +option enabled, the blkmapd daemon from nfs-utils is running, and the
> +file system, is mounted using the NFSv4.1 protocol version (mount -o vers=4.1).
> +
> +If the nfsd server needs to fence a non-responding client it calls
> +/sbin/nfsd-recall-failed with the first argument set to the IP address of
> +the client, and the second argument set to the device node without the /dev
> +prefix for the filesystem to be fenced. Below is an example file that show
> +how to translate the device into a serial number from SCSI EVPD 0x80:
...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
