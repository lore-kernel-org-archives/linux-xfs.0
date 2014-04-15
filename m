Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2E6B47F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 08:27:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1B7648F8037
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 06:27:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mvWcMCUhz2nNAaik for
	<xfs@oss.sgi.com>; Tue, 15 Apr 2014 06:27:21 -0700 (PDT)
Date: Tue, 15 Apr 2014 15:19:47 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 4/4] fs: Disallow all fallocate operation on active
	swapfile
In-Reply-To: <20140412152225.GC18047@infradead.org>
Message-ID: <alpine.LFD.2.00.1404151510560.2146@localhost.localdomain>
References: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
	<1397242665-2183-4-git-send-email-lczerner@redhat.com>
	<20140412152225.GC18047@infradead.org>
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

> Date: Sat, 12 Apr 2014 08:22:25 -0700
> From: Christoph Hellwig <hch@infradead.org>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
>     linux-ext4@vger.kernel.org, xfs@oss.sgi.com
> Subject: Re: [PATCH 4/4] fs: Disallow all fallocate operation on active
>     swapfile
> 
> Given that the earlier patches were about races - what protects us
> from swapon racing with the check outside the filesystem locks?
> 

That would be fairies :) This patch is obviously wrong so I'll drop
it and try to think about better way of dealing with this.

Thanks!
-Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
