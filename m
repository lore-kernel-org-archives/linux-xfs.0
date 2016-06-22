Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9243B7CA1
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 07:45:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1C20AAC001
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 05:45:47 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id EkFxfBekEh4A1LWT (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 22 Jun 2016 05:45:42 -0700 (PDT)
Date: Wed, 22 Jun 2016 05:45:40 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] Simplify workaround for old glibc getsubopt()
Message-ID: <20160622124540.GA6293@infradead.org>
References: <20160618145253.GB17768@nyan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160618145253.GB17768@nyan>
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

I think we should simply kill that workaround.  I even have vague
memories of killing it, but maybe I didn't end up sending out the patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
