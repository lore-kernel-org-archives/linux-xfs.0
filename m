Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D63167CA4
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 09:15:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8ED8B8F804B
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 07:15:53 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id BHs5ZcCqH3WA3KgB (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 10 May 2016 07:15:50 -0700 (PDT)
Date: Tue, 10 May 2016 16:15:44 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5 1/5] dax: fallback from pmd to pte on error
Message-ID: <20160510141544.GL11897@quack2.suse.cz>
References: <1462571591-3361-1-git-send-email-vishal.l.verma@intel.com>
	<1462571591-3361-2-git-send-email-vishal.l.verma@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1462571591-3361-2-git-send-email-vishal.l.verma@intel.com>
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, Jeff Moyer <jmoyer@redhat.com>, Boaz Harrosh <boaz@plexistor.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-ext4@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>

On Fri 06-05-16 15:53:07, Vishal Verma wrote:
> From: Dan Williams <dan.j.williams@intel.com>
> 
> In preparation for consulting a badblocks list in pmem_direct_access(),
> teach dax_pmd_fault() to fallback rather than fail immediately upon
> encountering an error.  The thought being that reducing the span of the
> dax request may avoid the error region.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

The patch looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
