Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A80097F6D
	for <xfs@oss.sgi.com>; Fri, 24 Oct 2014 10:41:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9640C8F804B
	for <xfs@oss.sgi.com>; Fri, 24 Oct 2014 08:41:02 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id U28FtAperywSuX7I (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 24 Oct 2014 08:41:01 -0700 (PDT)
Date: Fri, 24 Oct 2014 08:40:58 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: enable sparse checking
Message-ID: <20141024154058.GA10788@infradead.org>
References: <54498F4A.9030207@redhat.com>
	<20141024061718.GA15341@infradead.org>
	<544A59F7.4070601@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <544A59F7.4070601@sandeen.net>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Oct 24, 2014 at 08:53:59AM -0500, Eric Sandeen wrote:
> Hm, so you can.
> 
> Ok, so maybe this is dumb, or is it convenient (to work like it does
> in the kernel tree?)

The cgcc way seems easier for userspace, but I don't really have a
strong opinion.  It's not like your patch prevents me from using CC=cgcc

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
