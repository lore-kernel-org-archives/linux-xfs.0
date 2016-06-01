Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BC81C7CA6
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 09:05:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7FED78F8039
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 07:05:35 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id oNz6eRaVtpm3jdmx (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 01 Jun 2016 07:05:33 -0700 (PDT)
Date: Wed, 1 Jun 2016 07:05:22 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 0/8] block: prepare for multipage bvecs
Message-ID: <20160601140522.GA16228@infradead.org>
References: <1464615294-9946-1-git-send-email-ming.lei@canonical.com>
	<20160531155348.GA24840@redhat.com>
	<CACVXFVM9FqZFkMat_4ysJ8_vFd1FFnf6Bd9sHDDoCK=v93wViQ@mail.gmail.com>
	<20160601134427.GA15888@infradead.org>
	<20160601135150.GA30759@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160601135150.GA30759@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>, Steven Whitehouse <swhiteho@redhat.com>, Ming Lei <ming.lei@canonical.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, NeilBrown <neilb@suse.com>, Christoph Hellwig <hch@infradead.org>, Joe Thornber <ejt@redhat.com>, linux-block@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Shaohua Li <shli@fb.com>, Tejun Heo <tj@kernel.org>, Keith Busch <keith.busch@intel.com>, "open list:XFS FILESYSTEM" <xfs@oss.sgi.com>, Kent Overstreet <kent.overstreet@gmail.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, "open list:DRBD DRIVER" <drbd-dev@lists.linbit.com>

On Wed, Jun 01, 2016 at 09:51:51AM -0400, Mike Snitzer wrote:
> So should I not push this type of fix to Linus now?  I was going to send
> the above commit and this one to him this week:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.7&id=57b3001b240629ecc5266d28c845e23ca5f11719
> 
> Instead, should bcache be made to not do what it is doing?

I think that's much preferably.  Otherwise we'll get a constant trickles
of patches like that whenever someone tries bcache on top of another
stacking driver.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
