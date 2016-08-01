Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6C6A77CBD
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 01:24:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D6823AC002
	for <xfs@oss.sgi.com>; Sun, 31 Jul 2016 23:24:51 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id PAqrAYPhH29feObL (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 31 Jul 2016 23:24:50 -0700 (PDT)
Date: Sun, 31 Jul 2016 23:24:49 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH xfsprogs 2/2] linux.h: Define xfs_off_t as int64_t
Message-ID: <20160801062449.GB596@infradead.org>
References: <20160730133737.GB5895@nyan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160730133737.GB5895@nyan>
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

On Sat, Jul 30, 2016 at 03:37:37PM +0200, Felix Janda wrote:
> int64_t is guaranteed to have the correct size and signedness and is
> always avaible because linux.h has a <inttypes.h> include.
> 
> Fixes compilation error "unkown type name 'off64_t'" on linux when the
> public header <xfs.h> is included without _LARGEFILE64_SOURCE or
> _GNU_SOURCE defined. This bug was introduced in commit
> cb898f157f8410a03cf5f3400baa1df9e5eecd33.

I would much prefer to just define _LARGEFILE64_SOURCE in linux.h..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
