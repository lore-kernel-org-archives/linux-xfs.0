Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 03 Sep 2008 05:17:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m83CHIU8023319
	for <xfs@oss.sgi.com>; Wed, 3 Sep 2008 05:17:18 -0700
Date: Wed, 3 Sep 2008 08:18:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: REVIEW: Zero rest of superblock sector always
Message-ID: <20080903121844.GB5980@infradead.org>
References: <op.ugv7zt013jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.ugv7zt013jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Sep 03, 2008 at 04:51:19PM +1000, Barry Naujok wrote:
> I found that zeroing the "garbage" beyond the end of the superblock in
> the first sector of each AG rather inconsistant. It depended on some
> obscure combination of version bits to be set.
>
> The following code zeroes the unused portion of all superblocks if
> there is any garbage at all in them.

Looks good.  And we'll always need the rest of the sector zeroed once
the superblock grows a crc field.
