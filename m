Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B2BDA7CB7
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 06:09:16 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 30F93AC001
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 04:09:13 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id CjXhi7NJBiIKZeLj (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Mar 2016 04:09:11 -0800 (PST)
Date: Tue, 1 Mar 2016 04:09:11 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_io: Prevent devide by zero from {pread, pwrite}_random
Message-ID: <20160301120911.GB5217@infradead.org>
References: <8760xc3jfu.fsf@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8760xc3jfu.fsf@openvz.org>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: xfs@oss.sgi.com

On Thu, Feb 25, 2016 at 07:20:53PM +0400, Dmitry Monakhov wrote:
> 
> Math is wrong if range requested is less or equals to block size
> 
> xfs_io -c 'pwrite -b 4k 8k 4k -R' \
>        -c 'pread -b 4k  4k 4k -R' -f file
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Are we going to see a new testcase that relies on this soon? :)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
