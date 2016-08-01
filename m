Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C924C7CF4
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 01:54:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8B93E304051
	for <xfs@oss.sgi.com>; Sun, 31 Jul 2016 23:54:40 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id fCQMXCWxNPQQwuaJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 31 Jul 2016 23:54:37 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id 8F0F920900
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 08:54:35 +0200 (CEST)
Date: Mon, 1 Aug 2016 08:54:10 +0200
From: Felix Janda <felix.janda@posteo.de>
Subject: Re: [PATCH xfsprogs 2/2] linux.h: Define xfs_off_t as int64_t
Message-ID: <20160801065410.GA341@nyan>
References: <20160730133737.GB5895@nyan> <20160801062449.GB596@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160801062449.GB596@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Sat, Jul 30, 2016 at 03:37:37PM +0200, Felix Janda wrote:
> > int64_t is guaranteed to have the correct size and signedness and is
> > always avaible because linux.h has a <inttypes.h> include.
> > 
> > Fixes compilation error "unkown type name 'off64_t'" on linux when the
> > public header <xfs.h> is included without _LARGEFILE64_SOURCE or
> > _GNU_SOURCE defined. This bug was introduced in commit
> > cb898f157f8410a03cf5f3400baa1df9e5eecd33.
> 
> I would much prefer to just define _LARGEFILE64_SOURCE in linux.h..

Thanks for the suggestion, but that does not work if the system header
defining (or not) off64_t is included before the xfs headers.

---
Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
