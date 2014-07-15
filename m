Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E2EAF7F85
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 05:19:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CC225304043
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 03:19:33 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 5rBMkMwhIPZJ8XDN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Jul 2014 03:19:31 -0700 (PDT)
Date: Tue, 15 Jul 2014 03:19:31 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] logprint: Fix printing of AGF buffers
Message-ID: <20140715101931.GC30363@infradead.org>
References: <1405349100-19734-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1405349100-19734-1-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

On Mon, Jul 14, 2014 at 04:45:00PM +0200, Jan Kara wrote:
> Currently xfs_logprint doesn't show detailed data about AGF buffers and
> instead always shows "Out of space". This is because xfs_agf_t has
> additional fields and padding which we never read from disk and thus
> buffer length is always smaller than the size of xfs_agf_t.
> 
> Fix the problem by only making sure we have enough data in the buffer
> to contain all the information we want to print.

The fix looks correct to me, but te explanation should be more verbose:
the reason why we don't read agf_uuid and above is because you're
probably dumping a v4 filesystems which doesn't even have those fields.

Its seems like various other fields have the same issue in logprint,
and I also suspect we want some defines for the v4 size instead of using
the offsetoff tricks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
