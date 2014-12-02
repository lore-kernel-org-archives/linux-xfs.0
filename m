Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9CEBD7F54
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 05:36:28 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7BDD28F80DA
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 03:36:28 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id nDdYxHfBJHZF5TR3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Dec 2014 03:36:27 -0800 (PST)
Date: Tue, 2 Dec 2014 03:36:26 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: move type conversion functions to xfs_dir.h
Message-ID: <20141202113626.GA30327@infradead.org>
References: <1417475883-21881-1-git-send-email-david@fromorbit.com>
	<1417475883-21881-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1417475883-21881-3-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Tue, Dec 02, 2014 at 10:18:03AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> These are currently considered private to libxfs, but they are
> widely used by the userspace code to decode, walk and check
> directory structures. Hence they really form part of the external
> API and as such need to bemoved to xfs_dir2.h.

Lokos good, but why do we need the additional includes in various files?

Signed-off-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
