Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 844EE7F56
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 04:45:16 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6DB638F8033
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 02:45:16 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id xLP0vUEmJvPgUGE4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Feb 2014 02:45:14 -0800 (PST)
Date: Mon, 10 Feb 2014 02:45:14 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs/189: noattr2 invalid for CRC enabled filesystems
Message-ID: <20140210104514.GB9840@infradead.org>
References: <1391590000-7171-1-git-send-email-david@fromorbit.com>
	<20140207174754.GA31464@infradead.org>
	<20140210015200.GO13647@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140210015200.GO13647@dastard>
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

On Mon, Feb 10, 2014 at 12:52:00PM +1100, Dave Chinner wrote:
> > I really don't like opencoding this.  Shouldn't we instead simplfy
> > pass a nocrc argument to _scratch_mkfs_xfs?
> 
> No, that simply breaks old mkfs binaries.

Well, we couldn't pass it unconditionally - the main idea is to hide
the magic and allow tests to easily create a noncrc filesystem.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
