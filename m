Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C26357CB0
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 01:54:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 81A9F8F8037
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 23:54:43 -0700 (PDT)
Received: from mail.kernel.org ([198.145.29.136]) by cuda.sgi.com with ESMTP
	id dH7qtPPb2CBiNcmv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 29 Mar 2016 23:54:41 -0700 (PDT)
Message-ID: <1459320877.4102.3.camel@kernel.org>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
From: Vishal Verma <vishal@kernel.org>
Date: Wed, 30 Mar 2016 00:54:37 -0600
In-Reply-To: <20160330063415.GA2132@infradead.org>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	<1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
	<20160330063415.GA2132@infradead.org>
Mime-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>, Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-block@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-nvdimm@ml01.01.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Jens Axboe <axboe@fb.com>, linux-mm@kvack.org, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>

On Tue, 2016-03-29 at 23:34 -0700, Christoph Hellwig wrote:
> Hi Vishal,
> 
> still NAK to calling the direct I/O code directly from the dax code.

Hm, I thought this was what you meant -- do the fallback/retry attempts
at the callers of dax_do_io instead of the new dax wrapper function..
Did I misunderstand you?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
