Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n97NNBAh219063 for <xfs@oss.sgi.com>; Wed, 7 Oct 2009 18:23:11 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2AEE21759C22
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2009 16:24:37 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id H9awe2Kgq6uc9ffz for
	<xfs@oss.sgi.com>; Wed, 07 Oct 2009 16:24:37 -0700 (PDT)
Message-ID: <4ACD2334.3070403@sandeen.net>
Date: Wed, 07 Oct 2009 18:24:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfsprogs: update configure defaults
References: <20091006151458.GA2560@infradead.org>
	<20091007220629.GA23523@infradead.org>
In-Reply-To: <20091007220629.GA23523@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Updated version with two changes:
> 
>  - use basename to propagate the lib64 vs lib difference to both
>    library directories
>  - disable our implicit addition of the lib64 prefix if the user
>    specified library directory already ends in lib64.
> 
> Eric, can you check if this works for the fedora build without having
> to specify --disable-lib64?

Yep, it does, thanks.

Looks good as far as I'm concerned (i.e. my stuff builds) ;)

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
