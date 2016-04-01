Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A2E367CA3
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 19:31:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 69A0B8F8050
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 17:31:12 -0700 (PDT)
Received: from youngberry.canonical.com (youngberry.canonical.com
	[91.189.89.112]) by cuda.sgi.com with ESMTP id UHw5o2f7Q9rpQg0U
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 31 Mar 2016 17:31:09 -0700 (PDT)
Received: from mail-yw0-f182.google.com ([209.85.161.182])
	by youngberry.canonical.com with esmtpsa
	(TLS1.0:RSA_AES_128_CBC_SHA1:16) (Exim 4.76)
	(envelope-from <ming.lei@canonical.com>) id 1almzT-0004qd-OW
	for xfs@oss.sgi.com; Fri, 01 Apr 2016 00:31:07 +0000
Received: by mail-yw0-f182.google.com with SMTP id h129so123336872ywb.1
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 17:31:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160331075228.GA2491@infradead.org>
References: <1459354637-17415-1-git-send-email-ming.lei@canonical.com>
	<1459354637-17415-3-git-send-email-ming.lei@canonical.com>
	<20160330171927.GA13320@infradead.org>
	<CACVXFVNtphY8bWrdMKcR7jYn5hD=H5H6jXrY111K0kZ8jJQHWw@mail.gmail.com>
	<20160331075228.GA2491@infradead.org>
Date: Fri, 1 Apr 2016 08:31:06 +0800
Message-ID: <CACVXFVPOiH4pEW7J0-Nimoj6thoUtY_A+A9PaaisLwibKP1DHg@mail.gmail.com>
Subject: Re: [PATCH v1 2/8] block: make 'struct bvec_iter' not depend on
	CONFIG_BLOCK
From: Ming Lei <ming.lei@canonical.com>
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
Cc: Boaz Harrosh <boaz@plexistor.com>, Jens Axboe <axboe@fb.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-block@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Lars Ellenberg <lars.ellenberg@linbit.com>, Philipp Reisner <philipp.reisner@linbit.com>, Anton Altaparmakov <anton@tuxera.com>, drbd-dev@lists.linbit.com

On Thu, Mar 31, 2016 at 3:52 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Mar 31, 2016 at 09:02:59AM +0800, Ming Lei wrote:
>> That way may cause trouble to blk_type.h because it needs bvec_iter,
>> then looks not good to always include bvec_iter.h into blk_type.h.
>
> I'd expect bvec.h to be always included in blk_types.h, and replace

That should be fine, but blk_types.h will become more fat.

> the inclusion of blk_types.h in fs.h eventually.

I guess it can't be done because fs.h need 'struct bio'.

thanks,
Ming

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
