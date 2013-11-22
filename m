Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CC7F07F50
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 09:36:23 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 42D54AC009
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 07:36:23 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id H57wpYArBwRCCvcd (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 22 Nov 2013 07:36:22 -0800 (PST)
Date: Fri, 22 Nov 2013 07:36:18 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: bio_add_page rw mode check by merge_bvec_fn
Message-ID: <20131122153618.GB15143@infradead.org>
References: <528E4A50.7040609@itwm.fraunhofer.de>
	<528E4C19.70507@itwm.fraunhofer.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <528E4C19.70507@itwm.fraunhofer.de>
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
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>, xfs@oss.sgi.com, Kent Overstreet <kmo@daterainc.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org

While this is trivial to fix it's also fairly unexpected and easy
to get wrong for new callers.  Neil, can you explain why you
desperately need it?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
