Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0C88E7F37
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 01:58:58 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DC663304062
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 23:58:57 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id pzQhdEGUx07nc3z5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2016 23:58:56 -0800 (PST)
Date: Tue, 12 Jan 2016 23:58:55 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] Add configure check for members of dirent for use in
	io/readdir.c
Message-ID: <20160113075855.GG21939@infradead.org>
References: <cover.1452627740.git.felix.janda@posteo.de>
	<20160112200022.GG568@nyan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160112200022.GG568@nyan>
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

I think we're having a deeper issue here.  For an LFS build we
absolutely should have these values as the kernel dirent64 has them.

Either we manage to not pull in the LFS version of readdir/getdents
or musl is doing something inredibly stupid.  Can you investigate if
and why we're not using the LFS getdents64 here?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
