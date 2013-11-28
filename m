Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9BFA57F51
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 04:35:55 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 31E75AC003
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 02:35:52 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id fHgDXfjEEQ9jGbEL (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 02:35:50 -0800 (PST)
Date: Thu, 28 Nov 2013 02:35:49 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 0/4] xfs: add O_TMPFILE support
Message-ID: <20131128103549.GA26927@infradead.org>
References: <1385379154-3802-1-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1385379154-3802-1-git-send-email-zwu.kernel@gmail.com>
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
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, xfs@oss.sgi.com

On Mon, Nov 25, 2013 at 07:32:30PM +0800, Zhi Yong Wu wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
> HI, folks
> 
> The patchset is trying to add O_TMPFILE support to xfs. To make sure
> that it is going ahead in the right direction, although it is only one
> code draft, and hasn't strictly been tested, it is still post out ASAP.

Btw, for the real submission we need proper xfstests coverage, I can't
really believe how the other filesystems added it without QA coverage :(

Besides the obvious test programs there's a reproducer for a a simple
bug already in commit dda5690defe4af62ee120f055e98e40d97e4c760 in the
kernel tree.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
