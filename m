Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 14E347CA3
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 02:40:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D9B788F8035
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 00:40:12 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id WSOQA0YT3ZQwiWFM (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Aug 2016 00:40:11 -0700 (PDT)
Date: Tue, 9 Aug 2016 00:40:10 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH xfsprogs 11/14] replace statvfs64 by equivalent statvfs
Message-ID: <20160809074010.GM25647@infradead.org>
References: <cover.1470555003.git.felix.janda@posteo.de>
	<f4fc0b97ae8cdb30f1e0b0d55521f136877b33f5.1470555003.git.felix.janda@posteo.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f4fc0b97ae8cdb30f1e0b0d55521f136877b33f5.1470555003.git.felix.janda@posteo.de>
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

On Sun, Aug 07, 2016 at 08:24:40AM +0200, Felix Janda wrote:
> For this it was necessary to change a workaround for missing
> f_brsize on Mac OS X.

If we can get rid of that it'd be fine, but can you explain a bit
more why we can get rid of it?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
