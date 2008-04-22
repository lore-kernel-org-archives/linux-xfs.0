Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 21:52:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3M4pjUW001939
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 21:51:46 -0700
Date: Tue, 22 Apr 2008 00:52:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] XFS: Return case-insensitive match for dentry cache
Message-ID: <20080422045222.GA11321@infradead.org>
References: <20080421083103.433280025@chook.melbourne.sgi.com> <20080421083644.809426871@chook.melbourne.sgi.com> <20080421085947.GA10399@infradead.org> <20080421094641.GA5191@infradead.org> <op.t9zug2dn3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.t9zug2dn3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Tue, Apr 22, 2008 at 01:54:28PM +1000, Barry Naujok wrote:
> There's already a "flags" field in xfs_da_args and only the low 16 bits
> are currently used for attr operations.
>
> We could use 5 of the high bits for these flags, or just add another
> flags field (which are used for things other than lookup).

Either way is fine for me.  The problem with the flags field is
that the values in there seem to be passed down from higher up, e.g.
the attr code so we'd have to be careful not to use any value twice.
