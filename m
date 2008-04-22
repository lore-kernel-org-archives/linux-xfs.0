Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 21:52:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3M4qmMF002069
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 21:52:49 -0700
Date: Tue, 22 Apr 2008 00:53:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] XFS: Return case-insensitive match for dentry cache
Message-ID: <20080422045326.GB11321@infradead.org>
References: <20080421083103.433280025@chook.melbourne.sgi.com> <20080421083644.809426871@chook.melbourne.sgi.com> <20080421085947.GA10399@infradead.org> <20080421211300.GO108924158@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421211300.GO108924158@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Tue, Apr 22, 2008 at 07:13:01AM +1000, David Chinner wrote:
> Perhaps this can be done (moving to dcache.c) as a followup patch
> series that also removes the duplicate code from ntfs and other
> places. Similarly for all the NLS stuff...

It's not like this one is changing core code, just adding a single
function should be fine from the XFS tree without any bigger
implications.  Switching over ntfs should be a separate patch of course.
