Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A3A797CAE
	for <xfs@oss.sgi.com>; Wed, 28 Sep 2016 20:16:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 74EC8304048
	for <xfs@oss.sgi.com>; Wed, 28 Sep 2016 18:16:31 -0700 (PDT)
Received: from NAM01-BN3-obe.outbound.protection.outlook.com
	(mail-bn3nam01on0047.outbound.protection.outlook.com
	[104.47.33.47]) by cuda.sgi.com with ESMTP id cRLTDcu7URkNtYz7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 28 Sep 2016 18:16:29 -0700 (PDT)
Subject: Re: [PATCH 1/3] block: invalidate the page cache when issuing
	BLKZEROOUT.
References: <147510957066.8940.13803086684642725401.stgit@birch.djwong.org>
	<147510957761.8940.14476876584539116975.stgit@birch.djwong.org>
From: Bart Van Assche <bart.vanassche@sandisk.com>
Message-ID: <58a6bc29-42d5-92f2-30bf-89168faa8eb0@sandisk.com>
Date: Wed, 28 Sep 2016 18:16:13 -0700
MIME-Version: 1.0
In-Reply-To: <147510957761.8940.14476876584539116975.stgit@birch.djwong.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>, axboe@kernel.dk, akpm@linux-foundation.org
Cc: hch@infradead.org, tytso@mit.edu, martin.petersen@oracle.com, snitzer@redhat.com, linux-api@vger.kernel.org, bfoster@redhat.com, xfs@oss.sgi.com, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On 09/28/16 17:39, Darrick J. Wong wrote:
> Invalidate the page cache (as a regular O_DIRECT write would do) to avoid
> returning stale cache contents at a later time.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
