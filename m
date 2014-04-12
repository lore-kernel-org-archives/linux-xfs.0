Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CF7827F59
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 10:21:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A897F8F8035
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 08:21:22 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 76XmcJQqeuaFmyHH (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 12 Apr 2014 08:21:17 -0700 (PDT)
Date: Sat, 12 Apr 2014 08:21:17 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] fs: Remove i_size check from do_fallocate
Message-ID: <20140412152117.GB18047@infradead.org>
References: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
	<1397242665-2183-3-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397242665-2183-3-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

Looks good, but the subject line is misleading, it should read something
like:

"fs: move falloc collapse range check into the filesystem methods"

Might also be worth mentioning that size checks for the other modes
are in the filesystems in the the long description.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
