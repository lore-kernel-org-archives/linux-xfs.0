Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D5C867CA4
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 09:29:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 96F1F304032
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 07:29:43 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id BOKybKUkZJYi11oG (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 10 May 2016 07:29:41 -0700 (PDT)
Date: Tue, 10 May 2016 16:29:36 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5 5/5] dax: fix a comment in dax_zero_page_range and
	dax_truncate_page
Message-ID: <20160510142936.GO11897@quack2.suse.cz>
References: <1462571591-3361-1-git-send-email-vishal.l.verma@intel.com>
	<1462571591-3361-6-git-send-email-vishal.l.verma@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1462571591-3361-6-git-send-email-vishal.l.verma@intel.com>
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
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, Jeff Moyer <jmoyer@redhat.com>, Boaz Harrosh <boaz@plexistor.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

On Fri 06-05-16 15:53:11, Vishal Verma wrote:
> The distinction between PAGE_SIZE and PAGE_CACHE_SIZE was removed in
> 
> 09cbfea mm, fs: get rid of PAGE_CACHE_* and page_cache_{get,release}
> macros
> 
> The comments for the above functions described a distinction between
> those, that is now redundant, so remove those paragraphs
> 
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
