Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 270677CA0
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2016 06:29:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DC6208F8035
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2016 04:29:28 -0700 (PDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70]) by cuda.sgi.com
	with ESMTP id Q7u9FQQBe7uwxoLG for <xfs@oss.sgi.com>;
	Fri, 22 Jul 2016 04:29:26 -0700 (PDT)
Subject: Re: next-20160722 build: 1 failures 5 warnings (next-20160722)
References: <E1bQXSf-0008Uu-Ej@optimist> <20160722103829.GY6509@sirena.org.uk>
From: Robin Murphy <robin.murphy@arm.com>
Message-ID: <57920392.5070009@arm.com>
Date: Fri, 22 Jul 2016 12:29:22 +0100
MIME-Version: 1.0
In-Reply-To: <20160722103829.GY6509@sirena.org.uk>
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
To: Mark Brown <broonie@kernel.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>
Cc: kernel-build-reports@lists.linaro.org, linaro-kernel@lists.linaro.org, linux-next@vger.kernel.org, linux-arm-kernel@lists.infradead.org, xfs@oss.sgi.com

On 22/07/16 11:38, Mark Brown wrote:
[...]
> DAX is explicitly disabled on
> 32 bit ARM due to problems with virtual aliasing caches (it's not clear
> to me that it shouldn't also be disabled for arm64 for the same reason).

>From ARMv7 onwards, data caches have to behave as if PIPT, so I wouldn't
expect there to be a problem for arm64.

Robin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
