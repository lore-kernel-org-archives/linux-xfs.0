Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9C6B27CA1
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2016 09:44:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 600238F8040
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2016 07:44:30 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id T9FBsiA9JTUyz78q (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 30 Aug 2016 07:44:28 -0700 (PDT)
Date: Tue, 30 Aug 2016 16:44:26 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/4] xfs: rewrite and optimize the delalloc write path
Message-ID: <20160830144426.GB14504@lst.de>
References: <1471816273-28940-1-git-send-email-hch@lst.de>
	<1471816273-28940-5-git-send-email-hch@lst.de>
	<20160825143708.GD25041@bfoster.bfoster>
	<20160826143344.GB21535@lst.de>
	<20160826160339.GC17728@bfoster.bfoster>
	<20160826160753.GD17728@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160826160753.GD17728@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, Aug 26, 2016 at 12:07:53PM -0400, Brian Foster wrote:
> > Not quite sure I follow the last bit, but I don't necessarily think the
> > whole thing has to be boxed into a helper to clean it up. E.g., I'd do
> > something like the appended diff (compile tested only).
> > 
> 
> ... and if the function signature is really an issue, trade off idx &
> prev for a conditional base preallocation size (applies on top of the
> previous diff):

These two patches together look pretty reasonable.  I'll retest with
it include and will pick it up for the next version if it works.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
