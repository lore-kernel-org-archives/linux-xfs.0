Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0D2l71g060045 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 20:47:07 -0600
Message-ID: <4F0F9B1C.3050206@hitachi.com>
Date: Fri, 13 Jan 2012 11:46:52 +0900
From: HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH] xfs: show uuid when mount fails due to duplicate uuid
References: <20120112024720.3952.73517.stgit@ltc219.sdl.hitachi.co.jp>
	<20120112161410.GA3810@infradead.org>
In-Reply-To: <20120112161410.GA3810@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Alex Elder <elder@kernel.org>, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Ben Myers <bpm@sgi.com>, Alex Elder <aelder@sgi.com>

Hi Christoph,

Thank you for your comment.

(2012/01/13 1:14), Christoph Hellwig wrote:
> On Thu, Jan 12, 2012 at 11:47:20AM +0900, Mitsuo Hayasaka wrote:
>> When a system tries to mount a filesystem (FS) using UUID, the xfs
>> returns -EINVAL and shows a message if a FS with the same UUID has
>> been already mounted. It is useful to output the duplicate UUID
>> with it.
> 
> Looks good to me,
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
>> -	xfs_warn(mp, "Filesystem has duplicate UUID - can't mount");
>> +	xfs_warn(mp,
>> +		"Filesystem has duplicate UUID - can't mount: uuid = %pU",
>> +		uuid);
> 
> Maybe we could write this a bit nicer as:
> 
> 	xfs_warn(mp, "Filesystem has duplicate UUID %p - can't mount", uuid);
> 

It looks nice.
I will send the revised patch soon.

Thanks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
