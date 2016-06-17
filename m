Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A6A1A7CEE
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 07:01:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 306FBAC002
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 05:01:48 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id otNConbVD6cQeX22 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 17 Jun 2016 05:01:46 -0700 (PDT)
Date: Fri, 17 Jun 2016 14:01:44 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/14] fs: introduce iomap infrastructure
Message-ID: <20160617120144.GA333@lst.de>
References: <1464792297-13185-1-git-send-email-hch@lst.de>
	<1464792297-13185-3-git-send-email-hch@lst.de>
	<20160616161242.GB2106@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160616161242.GB2106@quack2.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: rpeterso@redhat.com, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Jun 16, 2016 at 06:12:42PM +0200, Jan Kara wrote:
> This is actually in 512-byte units, not in fs blocks as the comment
> suggests, right?

Indeed, thanks for spotting this!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
