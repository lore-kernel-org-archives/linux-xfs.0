Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B97D47CA6
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 08:51:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 798D68F8040
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 06:51:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FojY5S34nEdNoVcY (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 01 Jun 2016 06:51:53 -0700 (PDT)
Date: Wed, 1 Jun 2016 09:51:51 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v6 0/8] block: prepare for multipage bvecs
Message-ID: <20160601135150.GA30759@redhat.com>
References: <1464615294-9946-1-git-send-email-ming.lei@canonical.com>
	<20160531155348.GA24840@redhat.com>
	<CACVXFVM9FqZFkMat_4ysJ8_vFd1FFnf6Bd9sHDDoCK=v93wViQ@mail.gmail.com>
	<20160601134427.GA15888@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160601134427.GA15888@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>, Steven Whitehouse <swhiteho@redhat.com>, Ming Lei <ming.lei@canonical.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, NeilBrown <neilb@suse.com>, Jens Axboe <axboe@fb.com>, Joe Thornber <ejt@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Shaohua Li <shli@fb.com>, Tejun Heo <tj@kernel.org>, Keith Busch <keith.busch@intel.com>, "open list:XFS FILESYSTEM" <xfs@oss.sgi.com>, Kent Overstreet <kent.overstreet@gmail.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, "open list:DRBD DRIVER" <drbd-dev@lists.linbit.com>

On Wed, Jun 01 2016 at  9:44am -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, Jun 01, 2016 at 08:38:41PM +0800, Ming Lei wrote:
> > > be dm-crypt.c.  Maybe you've identified some indirect use of
> > > BIO_MAX_SIZE?
> > 
> > I mean the recently introduced BIO_MAX_SIZE in -next tree:
> > 
> > https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/drivers/md/dm-crypt.c?id=4ed89c97b0706477b822ea2182827640c0cec486
> 
> The crazy bcache bios striking back once again.  I really think it's
> harmful having a _MAX value and then having a minor driver
> reinterpreting it and sending larger ones.  Until we can lift the
> maximum limit in general nad have common code exercise it we really need
> to stop bcache from sending these instead of littering the tree with
> workarounds.

So should I not push this type of fix to Linus now?  I was going to send
the above commit and this one to him this week:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.7&id=57b3001b240629ecc5266d28c845e23ca5f11719

Instead, should bcache be made to not do what it is doing?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
