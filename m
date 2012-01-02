Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q02F25aN194153
	for <linux-xfs@oss.sgi.com>; Mon, 2 Jan 2012 09:02:07 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	I6CfhVgDn7H5HEQJ for <linux-xfs@oss.sgi.com>;
	Mon, 02 Jan 2012 07:02:02 -0800 (PST)
Date: Mon, 2 Jan 2012 10:02:01 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs: validate inode numbers in file handles correctly--NFS Stale
	File Handle Again
Message-ID: <20120102150201.GB31110@infradead.org>
References: <1276846374-23916-1-git-send-email-david@fromorbit.com>
	<loom.20111123T134243-580@post.gmane.org>
	<20111123143045.GA20892@infradead.org>
	<20111128111947.GA26454@infradead.org>
	<SNT135-W2217EB3D3B80A8433A1FA4A4B70@phx.gbl>
	<SNT135-W13E443B8D7BE73D5955314A4AD0@phx.gbl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <SNT135-W13E443B8D7BE73D5955314A4AD0@phx.gbl>
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
To: yangguoquan <ygq51@hotmail.com>
Cc: hch@infradead.org, linux-xfs@oss.sgi.com, pengxihan@gmail.com

On Thu, Dec 29, 2011 at 05:19:55PM +0800, yangguoquan wrote:
> 
> NFS Stale File Handle Again, But this happens when mount operation not during accessing file or directory.
>  
> My /etc/exports file:
>  
> /mnt/storage_pool/testnfs00     *(rw,sync,no_root_squash)
> /mnt/storage_pool/testnfs01     *(rw,sync,no_root_squash)
> /mnt/storage_pool/testnfs02     *(rw,sync,no_root_squash)
> /mnt/storage_pool/testnfs03     *(rw,sync,no_root_squash)
> /mnt/storage_pool/testnfs04     *(rw,sync,no_root_squash)
> /mnt/storage_pool/testnfs05     *(rw,sync,no_root_squash)
> /mnt/storage_pool/testnfs06     *(rw,sync,no_root_squash)
> /mnt/storage_pool/testnfs07     *(rw,sync,no_root_squash)
> /mnt/storage_pool/testnfs08     *(rw,sync,no_root_squash)
> /mnt/storage_pool/testnfs09     *(rw,sync,no_root_squash)

Are these mount points?  If not take a look at

	http://xfs.org/index.php/XFS_FAQ#Q:_Why_doesn.27t_NFS-exporting_subdirectories_of_inode64-mounted_filesystem_work.3F

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
