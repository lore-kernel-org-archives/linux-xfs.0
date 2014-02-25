Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E56E67F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 16:09:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B6014304071
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 14:09:12 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id lN8bTe3DRhJXT5Un (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 14:09:11 -0800 (PST)
Date: Tue, 25 Feb 2014 14:09:11 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] shared/051: CRC enabled filesystems handle more than
	25 ACLs
Message-ID: <20140225220911.GE5450@infradead.org>
References: <1393211175-30016-1-git-send-email-david@fromorbit.com>
	<1393211175-30016-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1393211175-30016-5-git-send-email-david@fromorbit.com>
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

On Mon, Feb 24, 2014 at 02:06:13PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> shared/051 fails on CRC enabled filesystems because it doesn't get
> an erro on setting the 26th ACL on a file. CRC enabled filesystems
> support more than 25, so there shoul dbe no error.
> 
> Allow the test to pass on both non-CRC and CRC enabled filesystems
> by detecting the type of filesystem configuration and using that
> information to fake the error message so that the golden output
> match does not fail. We also need to filter the 26th ACL from the
> output otherwise that will cause failures, too.

I don't really like this - we'd better of defining a function saying how
many ACEs a filesystem supports and use that.  Also I think the test for
these large ACLs should be a separate test from the other tests
currently in 051 as it's been causing a fair amount of issues in the
past with various filesystems.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
