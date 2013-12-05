Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 664937F57
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 14:53:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 410CF8F8035
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 12:53:47 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id VvnNumTRkBPFr8Ku (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Dec 2013 12:53:46 -0800 (PST)
Date: Thu, 5 Dec 2013 12:53:45 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] xfs: use xfs_ilock_map_shared in xfs_qm_dqtobp
Message-ID: <20131205205345.GA12393@infradead.org>
References: <20131205155830.620826868@bombadil.infradead.org>
	<20131205155951.330689967@bombadil.infradead.org>
	<20131205204108.GB29897@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131205204108.GB29897@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Dec 06, 2013 at 07:41:08AM +1100, Dave Chinner wrote:
> However, it raises a bigger question about dquot allocation sanity
> to me: what makes the map returned valid after we've unlocked the
> extent list?
> 
> We then use it to determine whether to allocate a
> dquot or not, and xfs_qm_dqalloc() then does this after calling
> xfs_bmapi_write():
> 
> 	ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
> 	       (map.br_startblock != HOLESTARTBLOCK));
> 
> What's to prevent someone coming in between the xfs_bmapi_read()
> and *write() calls and allocating a different dquot in the same
> cluster and therefore beating the first thread to the allocation?
> 
> This read/write race exists elsewhere - e.g. xfs_iomap_write_allocate
> documents it for the data path - and it has to be specifically
> handled to prevent corruption.....

Yeah, we'll need to read-read the extent map in xfs_qm_dqalloc. I  I
think this is efficiently paper over by the buffer lock - we take
it right after the xfs_bmapi_write over the period of initialization
the on-disk dquots and copying the one we were called for into the
in-memory one.  So while we might have been corrupting dquots all
over no one has noticed because we had a non-corrupted version
in-memory that overwrote the corrupted one again later.  Uhh..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
