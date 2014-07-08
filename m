Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7E4657F57
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 07:15:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 56F35304032
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 05:15:08 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Ij3rrLUCEUDQunTf (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 08 Jul 2014 05:15:07 -0700 (PDT)
Date: Tue, 8 Jul 2014 05:15:00 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfs: Add support IOC_MOV_DATA ioctl
Message-ID: <20140708121500.GA518@infradead.org>
References: <003f01cf9aa4$1e9e5240$5bdaf6c0$@samsung.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <003f01cf9aa4$1e9e5240$5bdaf6c0$@samsung.com>
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
To: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, Luk?? Czerner <lczerner@redhat.com>, linux-ext4 <linux-ext4@vger.kernel.org>

On Tue, Jul 08, 2014 at 08:59:49PM +0900, Namjae Jeon wrote:
> This patch implements fs ioctl's IOC_MOV_DATA for XFS.

Shouldn't this share code with the XFS_IOC_SWAPEXT implementation?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
