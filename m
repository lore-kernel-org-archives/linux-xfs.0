Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 909A77CA6
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 08:57:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 623948F8040
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 06:57:28 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rzkQ0qctO1HKKNuA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 01 Jun 2016 06:57:27 -0700 (PDT)
Date: Wed, 1 Jun 2016 09:57:25 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v6 0/8] block: prepare for multipage bvecs
Message-ID: <20160601135725.GB30759@redhat.com>
References: <1464615294-9946-1-git-send-email-ming.lei@canonical.com>
	<20160601134300.GA15656@infradead.org> <574EE8F7.4050509@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <574EE8F7.4050509@suse.de>
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
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@fb.com>, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>, Steven Whitehouse <swhiteho@redhat.com>, Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org, Sagi Grimberg <sagig@mellanox.com>, NeilBrown <neilb@suse.com>, Christoph Hellwig <hch@infradead.org>, Joe Thornber <ejt@redhat.com>, linux-block@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Shaohua Li <shli@fb.com>, Tejun Heo <tj@kernel.org>, Keith Busch <keith.busch@intel.com>, "open list:XFS FILESYSTEM" <xfs@oss.sgi.com>, Kent Overstreet <kent.overstreet@gmail.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, "open list:DRBD DRIVER" <drbd-dev@lists.linbit.com>

On Wed, Jun 01 2016 at  9:53am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> On 06/01/2016 03:43 PM, Christoph Hellwig wrote:
> > These patches look good on their own.  They might be an easier sell
> > just as bio cleanups :)
> 
> Fully agree. I've seen (some) improvements with those patches, so
> I'd prefer to have them.

Can you be more specific on what improvements you've seen?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
