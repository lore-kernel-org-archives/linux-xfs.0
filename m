Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 84CB07F52
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 14:20:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 517E28F8040
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 12:20:55 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id gcYKKQDRPYS1eAw8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Apr 2014 12:20:53 -0700 (PDT)
Date: Thu, 24 Apr 2014 12:20:52 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: test pipe resizing
Message-ID: <20140424192052.GA32696@infradead.org>
References: <5359625B.3090001@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5359625B.3090001@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, xfs-oss <xfs@oss.sgi.com>

On Thu, Apr 24, 2014 at 02:13:31PM -0500, Eric Sandeen wrote:
> Add a simple test to exercise the pipe resize fcntls,
> F_SETPIPE_SZ and F_GETPIPE_SZ.
> 
> This doesn't do a whole lot, but does some pipe reading
> and writing, some pipe resizing and checking, validates
> that we get EBUSY if we try to resize below the current
> size of buffers in the pipe, that the minimum is limited
> to PAGE_SIZE, etc.

How is this a filesystem issue?  I think this belongs into ltp.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
