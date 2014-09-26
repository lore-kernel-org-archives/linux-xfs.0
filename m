Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C3BE57FEE
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 06:42:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A347B8F8035
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 04:42:40 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id OIxeoqsaAkSJ1Q40 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Sep 2014 04:42:39 -0700 (PDT)
Date: Fri, 26 Sep 2014 04:42:38 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] xfs: refactor xlog_recover_process_data()
Message-ID: <20140926114238.GA16576@infradead.org>
References: <1411697952-24741-1-git-send-email-david@fromorbit.com>
	<1411697952-24741-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1411697952-24741-2-git-send-email-david@fromorbit.com>
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

On Fri, Sep 26, 2014 at 12:19:08PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Clean up xlog_recover_process_data() structure in preparation for
> fixing the allocation and freeing context of the transaction being
> recovered.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.  The only behavior change I could spot was that we now
validate the length of an ophdr even when starting a new transaction,
which seems sensible.

Nipick: maybe the lp argument to xlog_recover_process_ophdr should
be called end to make it more obvious?

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
