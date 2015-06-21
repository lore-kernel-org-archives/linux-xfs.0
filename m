Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A1DFA7F51
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 04:20:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3B661AC003
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 02:20:49 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id pGbEHpqIjDp2BMsF (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 21 Jun 2015 02:20:47 -0700 (PDT)
Date: Sun, 21 Jun 2015 02:20:47 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 2/3] xfs_repair: clear new memory after realloc
Message-ID: <20150621092047.GC26833@infradead.org>
References: <1434726241-11606-1-git-send-email-mggr@pml.ac.uk>
	<1434726241-11606-3-git-send-email-mggr@pml.ac.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1434726241-11606-3-git-send-email-mggr@pml.ac.uk>
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
To: Mike Grant <mggr@pml.ac.uk>
Cc: xfs@oss.sgi.com

Can you add a new realloc_zeroed helper?, e.g.

void *
realloc_zeroed(void *ptr, size_t old_size, size_t new_size)
{
	ptr = realloc(ptr, new_size);
	if (ptr)
		memset(ptr + old_size, 0, new_size - old_size);
	return ptr;
}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
