Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 43F097F50
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 02:26:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0ED128F8033
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 00:26:39 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id d9RlGTB8vTCslOC1 (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Aug 2015 00:26:35 -0700 (PDT)
Date: Wed, 12 Aug 2015 00:26:35 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/8] xfs: Introduce writeback context for writepages
Message-ID: <20150812072635.GA32399@infradead.org>
References: <1439333388-16452-1-git-send-email-david@fromorbit.com>
	<1439333388-16452-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1439333388-16452-2-git-send-email-david@fromorbit.com>
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

Introducing this separate from the actual users is a bit odd to follow.
Compare to my patch from a few years ago:

http://thread.gmane.org/gmane.comp.file-systems.xfs.general/39030/focus=39009

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
