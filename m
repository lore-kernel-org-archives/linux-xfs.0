Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0OHwTko060219
	for <linux-xfs@oss.sgi.com>; Tue, 24 Jan 2012 11:58:29 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	VQajdH3YfENOJUP5 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <linux-xfs@oss.sgi.com>;
	Tue, 24 Jan 2012 09:58:29 -0800 (PST)
Date: Tue, 24 Jan 2012 12:58:26 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs: validate inode numbers in file handles correctly--NFS Stale
	File Handle Again
Message-ID: <20120124175826.GA23671@infradead.org>
References: <1276846374-23916-1-git-send-email-david@fromorbit.com>
	<loom.20111123T134243-580@post.gmane.org>
	<20111123143045.GA20892@infradead.org>
	<20111128111947.GA26454@infradead.org>
	<SNT135-W2217EB3D3B80A8433A1FA4A4B70@phx.gbl>
	<SNT135-W13E443B8D7BE73D5955314A4AD0@phx.gbl>
	<20120102150201.GB31110@infradead.org>
	<SNT135-W48F0EBD0BBCFF1CAFBF2BEA4970@phx.gbl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <SNT135-W48F0EBD0BBCFF1CAFBF2BEA4970@phx.gbl>
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

On Wed, Jan 04, 2012 at 10:20:31AM +0800, yangguoquan wrote:
> 
> Yes, They are mount points.
>  
> /dev/mapper/storage_pool-testnfs00 on /mnt/storage_pool/testnfs00 type xfs (rw)

In that case I really have no idea.  Did you make sure you no
outstanding "old" filehandles before the fix on clients?  How do the
handles look in wireshark traces?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
