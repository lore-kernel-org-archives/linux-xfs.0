Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DC40A7F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 08:11:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BD4B28F8037
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 06:11:07 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id W0TY8SE0BjsAbcvN for
	<xfs@oss.sgi.com>; Tue, 15 Apr 2014 06:11:03 -0700 (PDT)
Date: Tue, 15 Apr 2014 15:10:38 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 3/4] fs: Remove i_size check from do_fallocate
In-Reply-To: <20140412152117.GB18047@infradead.org>
Message-ID: <alpine.LFD.2.00.1404151510150.2146@localhost.localdomain>
References: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
	<1397242665-2183-3-git-send-email-lczerner@redhat.com>
	<20140412152117.GB18047@infradead.org>
MIME-Version: 1.0
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
Cc: linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Sat, 12 Apr 2014, Christoph Hellwig wrote:

> Date: Sat, 12 Apr 2014 08:21:17 -0700
> From: Christoph Hellwig <hch@infradead.org>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
>     linux-ext4@vger.kernel.org, xfs@oss.sgi.com
> Subject: Re: [PATCH 3/4] fs: Remove i_size check from do_fallocate
> 
> Looks good, but the subject line is misleading, it should read something
> like:
> 
> "fs: move falloc collapse range check into the filesystem methods"
> 
> Might also be worth mentioning that size checks for the other modes
> are in the filesystems in the the long description.

I'll update the description and the subject.

Thanks!
-Lukas

> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
