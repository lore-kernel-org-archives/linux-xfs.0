Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8NGXuTJ124346 for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 11:33:58 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3CA4A1413EB8
	for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 09:39:30 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	N0Fu7F8neQcjys3g for <xfs@oss.sgi.com>;
	Fri, 23 Sep 2011 09:39:30 -0700 (PDT)
Date: Fri, 23 Sep 2011 12:33:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Directory fsync
Message-ID: <20110923163354.GA24319@infradead.org>
References: <CAF7KpS8h2KDsLVzwAj=5ig-yuuiCwjQSVk0Nfy9UJ0qiyAqeCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAF7KpS8h2KDsLVzwAj=5ig-yuuiCwjQSVk0Nfy9UJ0qiyAqeCQ@mail.gmail.com>
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
To: Zhu Han <schumi.han@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Sep 23, 2011 at 11:12:02PM +0800, Zhu Han wrote:
> I note below words in the manual of fsync:
>        Calling  fsync()  does  not  necessarily  ensure  that  the entry in
> the directory containing the file has also reached disk.  For that an
> explicit fsync() on a file
>        descriptor for the directory is also needed.
> 
> I am wondering is directory sync is essential after below steps if I want to
> assure the file can be retrieved after system crash?
> 
> 1) create file A
> 2) write file A
> 3) fsync(file A)
> 
> --------------------------------> fsync(parent directory) [Is it essential
> to make the inode linked to parent directory?]

As far as standards are concerned it is.  As far as the current XFS
implementation is concerned you don't need it as the file fsync will
also force out all transactions that belong to the create.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
