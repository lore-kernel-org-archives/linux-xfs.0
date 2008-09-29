Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Sep 2008 07:23:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8TEN3v9024372
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 07:23:03 -0700
Date: Mon, 29 Sep 2008 10:24:39 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [REVIEW] Check for valid agf_btreeblks with lazy counters
	enabled
Message-ID: <20080929142438.GB3709@infradead.org>
References: <op.uh2mo3zo3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.uh2mo3zo3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Sep 26, 2008 at 02:28:05PM +1000, Barry Naujok wrote:
> Originally part of the libxfs/kernel sync up, the change to
> xfs_alloc_read_agf() to check the agf_btreeblks value is less than
> or equal to agf_length was unconditionally performed.
>
> But, the actual implementation of maintaining agf_btreeblks
> increments and decrements this regardless of whether lazy
> counters are enabled or not. So, using a pre 2.6.23 filesystem
> or a repaired one, this value could be anything.
>
> So, in xfs_alloc_read_agf(), only validate agf_btreeblks if
> lazy counters are in use.

Looks good, but the patch good mangled by your mailer somehow.
