Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CF9F67CA0
	for <xfs@oss.sgi.com>; Thu, 18 Aug 2016 12:37:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 92A0B8F8033
	for <xfs@oss.sgi.com>; Thu, 18 Aug 2016 10:37:31 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id xzQLoLS7Q40fA8bW (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 18 Aug 2016 10:37:29 -0700 (PDT)
Date: Thu, 18 Aug 2016 10:37:27 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHv2 xfsprogs 01/14] configure: use AC_SYS_LARGEFILE
Message-ID: <20160818173727.GA27799@infradead.org>
References: <cover.1471107858.git.felix.janda@posteo.de>
	<bd011b1c8a9f0f17626d36c8c9868355dc6182a9.1471107858.git.felix.janda@posteo.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <bd011b1c8a9f0f17626d36c8c9868355dc6182a9.1471107858.git.felix.janda@posteo.de>
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

On Sun, Aug 07, 2016 at 07:21:20AM +0200, Felix Janda wrote:
> The autoconf macro AC_SYS_LARGEFILE defines _FILE_OFFSET_BITS=64
> where necessary to ensure that off_t and all interfaces using off_t
> are 64bit, even on 32bit systems.
> 
> Signed-off-by: Felix Janda <felix.janda@posteo.de>

Thanks, this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
