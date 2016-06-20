Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 483FA7CB3
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 07:37:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1BB3F8F8049
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 05:37:16 -0700 (PDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com
	[74.125.82.47]) by cuda.sgi.com with ESMTP id OjAwSwF3ADyGVdzn
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 20 Jun 2016 05:37:14 -0700 (PDT)
Received: by mail-wm0-f47.google.com with SMTP id r201so59819488wme.1
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 05:37:14 -0700 (PDT)
From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 2/3] block: require write_same and discard requests align
	to logical block size
References: <146612624734.12764.4316680863289411106.stgit@birch.djwong.org>
	<146612626092.12764.773833541076937471.stgit@birch.djwong.org>
Message-ID: <3470c511-59f5-ff7d-b4b0-22d7d8a2a6e7@acm.org>
Date: Mon, 20 Jun 2016 14:37:06 +0200
MIME-Version: 1.0
In-Reply-To: <146612626092.12764.773833541076937471.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "hch@infradead.org" <hch@infradead.org>, "tytso@mit.edu" <tytso@mit.edu>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "bfoster@redhat.com" <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Christoph Hellwig <hch@lst.de>

On 06/17/2016 03:19 AM, Darrick J. Wong wrote:
> Make sure that the offset and length arguments that we're using to
> construct WRITE SAME and DISCARD requests are actually aligned to the
> logical block size.  Failure to do this causes other errors in other
> parts of the block layer or the SCSI layer because disks don't support
> partial logical block writes.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
