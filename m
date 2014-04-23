Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A8A857F52
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 10:39:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8E7738F8049
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 08:39:59 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id UsYC4dUNd7R4UTJW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 23 Apr 2014 08:39:58 -0700 (PDT)
Date: Wed, 23 Apr 2014 08:39:56 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] xfs: fix Q_XQUOTARM ioctl
Message-ID: <20140423153956.GA11809@infradead.org>
References: <535580A1.20806@redhat.com> <5356B986.2060906@sandeen.net>
	<20140423152708.GA3326@infradead.org>
	<5357DC3A.6060702@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5357DC3A.6060702@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>, xfs-oss <xfs@oss.sgi.com>

On Wed, Apr 23, 2014 at 10:28:58AM -0500, Eric Sandeen wrote:
> Just out of curiousity, for what reason - just parity w/ the non-xfs
> ops?

Because it's just cleaner to have one methods for one operation instead
of overloading them with different opts like an ioctl.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
