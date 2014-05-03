Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A64FD7F37
	for <xfs@oss.sgi.com>; Sat,  3 May 2014 09:36:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3165CAC002
	for <xfs@oss.sgi.com>; Sat,  3 May 2014 07:36:06 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id q2IPOGSy3DAyoYFC for <xfs@oss.sgi.com>;
	Sat, 03 May 2014 07:36:03 -0700 (PDT)
Message-ID: <5364FED5.1050203@sandeen.net>
Date: Sat, 03 May 2014 09:36:05 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix Q_XQUOTARM ioctl
References: <535580A1.20806@redhat.com> <20140503114816.GA31191@infradead.org>
In-Reply-To: <20140503114816.GA31191@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Whoops, missed reply-all.

Yes, it will fail this way w/o the kernel patch.

User quota gets removed OK because flags accidentally line up;
group quota remains, so you'd see exactly this.

-Eric

On 5/3/14, 6:48 AM, Christoph Hellwig wrote:
> Can I assumes that xfs/007 failing with:
> 
> --- tests/xfs/007.out	2014-05-03 08:58:08.000000000 +0000
> +++ /root/xfstests/results//xfs/007.out.bad	2014-05-03
> 11:48:05.000000000 +0000
> @@ -7,4 +7,4 @@
>  *** umount
>  *** Usage after quotarm ***
>  core.nblocks = 0
> -core.nblocks = 0
> +core.nblocks = 1
> 
> is because this patch didn't get picked up yet?
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
