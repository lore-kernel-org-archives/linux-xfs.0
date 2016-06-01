Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A966E7CA6
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 08:44:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1720FAC003
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 06:44:39 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id N7PB9t1akNiRs0BW (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 01 Jun 2016 06:44:37 -0700 (PDT)
Date: Wed, 1 Jun 2016 06:44:27 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 0/8] block: prepare for multipage bvecs
Message-ID: <20160601134427.GA15888@infradead.org>
References: <1464615294-9946-1-git-send-email-ming.lei@canonical.com>
	<20160531155348.GA24840@redhat.com>
	<CACVXFVM9FqZFkMat_4ysJ8_vFd1FFnf6Bd9sHDDoCK=v93wViQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACVXFVM9FqZFkMat_4ysJ8_vFd1FFnf6Bd9sHDDoCK=v93wViQ@mail.gmail.com>
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
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-block@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, Steven Whitehouse <swhiteho@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, NeilBrown <neilb@suse.com>, Jens Axboe <axboe@fb.com>, Joe Thornber <ejt@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Shaohua Li <shli@fb.com>, Tejun Heo <tj@kernel.org>, Keith Busch <keith.busch@intel.com>, "open list:XFS FILESYSTEM" <xfs@oss.sgi.com>, Kent Overstreet <kent.overstreet@gmail.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, "open list:DRBD DRIVER" <drbd-dev@lists.linbit.com>

On Wed, Jun 01, 2016 at 08:38:41PM +0800, Ming Lei wrote:
> > be dm-crypt.c.  Maybe you've identified some indirect use of
> > BIO_MAX_SIZE?
> 
> I mean the recently introduced BIO_MAX_SIZE in -next tree:
> 
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/drivers/md/dm-crypt.c?id=4ed89c97b0706477b822ea2182827640c0cec486

The crazy bcache bios striking back once again.  I really think it's
harmful having a _MAX value and then having a minor driver
reinterpreting it and sending larger ones.  Until we can lift the
maximum limit in general nad have common code exercise it we really need
to stop bcache from sending these instead of littering the tree with
workarounds.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
