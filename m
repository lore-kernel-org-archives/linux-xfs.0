Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D3FCD7F37
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 03:51:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 97FD88F8033
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 01:51:27 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id TdrijXEVMcQSzhaN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 01 Aug 2013 01:51:26 -0700 (PDT)
Date: Thu, 1 Aug 2013 01:51:26 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/49] xfs: separate dquot on disk format definitions out
	of xfs_quota.h
Message-ID: <20130801085126.GB13494@infradead.org>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1374215120-7271-6-git-send-email-david@fromorbit.com>
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

> + * This header file defines all the on-disk format definitions for 
> + * general XFS objects. Directory and attribute related objects are defined in
> + * xfs_da_format.h, which log and log item formats are defined in

As of this patch (and the whole series) we still seem to have
xfs_dir2_format.h and not xfs_da_format.h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
