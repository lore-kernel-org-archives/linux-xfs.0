Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 348297CA2
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 10:18:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EB17830405F
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 08:18:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mxFimEBAQMnZasRC (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2016 08:18:26 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v2 4/5] dax: use sb_issue_zerout instead of calling
	dax_clear_sectors
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	<1459303190-20072-5-git-send-email-vishal.l.verma@intel.com>
Date: Fri, 15 Apr 2016 11:18:22 -0400
In-Reply-To: <1459303190-20072-5-git-send-email-vishal.l.verma@intel.com>
	(Vishal Verma's message of "Tue, 29 Mar 2016 19:59:49 -0600")
Message-ID: <x49y48e6gu9.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, linux-nvdimm@ml01.01.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Jens Axboe <axboe@fb.com>, linux-mm@kvack.org, linux-block@vger.kernel.org, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>

Vishal Verma <vishal.l.verma@intel.com> writes:

> From: Matthew Wilcox <matthew.r.wilcox@intel.com>
>
> dax_clear_sectors() cannot handle poisoned blocks.  These must be
> zeroed using the BIO interface instead.  Convert ext2 and XFS to use
> only sb_issue_zerout().
>
> Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
> [vishal: Also remove the dax_clear_sectors function entirely]
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
