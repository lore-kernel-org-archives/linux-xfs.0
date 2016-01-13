Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 176C97F37
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 01:55:04 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E917D8F804B
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 23:55:03 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id lisMjiJANYFX0vyb (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2016 23:55:02 -0800 (PST)
Date: Tue, 12 Jan 2016 23:55:01 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] libxfs/linux.c: Replace use of ustat by stat
Message-ID: <20160113075501.GC21939@infradead.org>
References: <cover.1452627740.git.felix.janda@posteo.de>
	<20160112195945.GC568@nyan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160112195945.GC568@nyan>
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

On Tue, Jan 12, 2016 at 08:59:45PM +0100, Felix Janda wrote:
> ustat has been used to check whether a device file is mounted.
> The function is deprecated and not supported by uclibc and musl.
> Now do the check using the *mntent functions.
> 
> Based on patch by Natanael Copa <ncopa@alpinelinux.org>.
> 
> Signed-off-by: Felix Janda <felix.janda@posteo.de>

ustat is a lot more efficient in checking for the mountedness
than this loop, so I'd really prefer not to do this unconditionally.

As far as Linux is concerned the best thing we could do is to use
O_EXCL for any open of a device file, as Linux overloadds O_EXCL
behavior for block devices so that any other O_EXCL open will
be rejected if one has the file open.

But that might be a major pain to find into the cross platform
framework..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
