Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0B08329DF8
	for <xfs@oss.sgi.com>; Tue, 29 Apr 2014 13:16:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D47C8304062
	for <xfs@oss.sgi.com>; Tue, 29 Apr 2014 11:16:57 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id O4uNZxBV32NI2sce (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 29 Apr 2014 11:16:56 -0700 (PDT)
Date: Tue, 29 Apr 2014 11:16:56 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/9] repair: detect CRC errors in AG headers
Message-ID: <20140429181656.GB9267@infradead.org>
References: <1398719099-19194-1-git-send-email-david@fromorbit.com>
	<1398719099-19194-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1398719099-19194-6-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 29, 2014 at 07:04:55AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> repair doesn't currently detect verifier errors in AG header
> blocks - apart from the primary superblock they are not detected.
> They are, fortunately, corrected in the important cases (AGF, AGI
> and AGFL) because these structures are rebuilt in phase 5, but if
> you run xfs_repair in checking mode it won't report them as bad.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
