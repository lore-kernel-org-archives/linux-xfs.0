Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EE2467CA6
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 03:33:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B172F8F8037
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 01:33:35 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 4Xsu8lWjG0UrsQHJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Aug 2016 01:33:33 -0700 (PDT)
Date: Tue, 9 Aug 2016 01:33:32 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: kill __uint*_t and __int*_t
Message-ID: <20160809083332.GA1489@infradead.org>
References: <20160807173835.GA20839@nyan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160807173835.GA20839@nyan>
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
To: Felix Janda <felix.janda@posteo.de>
Cc: xfs@oss.sgi.com

On Sun, Aug 07, 2016 at 07:38:35PM +0200, Felix Janda wrote:
> Replace them by the more widely used uint*_t and int*_t.
> 
> Signed-off-by: Felix Janda <felix.janda@posteo.de>
> ---
> This patch is essentially a global
> 'sed -i "s/__\(u*\)int\([0-9]*\)_t/\1int\2_t/"'. The only other changes
> are whitespace changes and removing the now unecessary type definitions.
> 
> Running 'sed "s/^.//"' on the patch might be useful for checking that
> I didn't mess up the indentation.

If everyone is fine using (u)int*_t over s*/u* this looks good.  I'd
have a slight preference for s*/u* as in the rest of the kernel, but
either way getting rid of our crazy __ types is a good thing.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
