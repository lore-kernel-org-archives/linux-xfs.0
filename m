Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 21:54:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3M4sj7e002439
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 21:54:46 -0700
Date: Tue, 22 Apr 2008 00:55:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] XFS: Return case-insensitive match for dentry cache
Message-ID: <20080422045526.GC11321@infradead.org>
References: <20080421083103.433280025@chook.melbourne.sgi.com> <20080421083644.809426871@chook.melbourne.sgi.com> <20080421085947.GA10399@infradead.org> <op.t9zphzsa3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.t9zphzsa3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Tue, Apr 22, 2008 at 12:07:01PM +1000, Barry Naujok wrote:
>> What about just using kmalloc here?  We know the length of the name
>> anyway, so there is no point of allocating the maximum possible size.
>
> Not with the CI/NLS, the length could be different.

Well, even then we know the length to allocate because it needs to
be passed up in the nls_name.  For the utf8 case the allocated space
for the string might just be different from the number of characters.
