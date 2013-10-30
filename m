Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B6B2629E05
	for <xfs@oss.sgi.com>; Wed, 30 Oct 2013 11:20:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 96E0630405F
	for <xfs@oss.sgi.com>; Wed, 30 Oct 2013 09:19:58 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id DUBbpAYkH0BrOdJJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 30 Oct 2013 09:19:57 -0700 (PDT)
Date: Wed, 30 Oct 2013 09:19:55 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstests 317
Message-ID: <20131030161955.GA28755@infradead.org>
References: <20131024161235.GA29381@infradead.org>
	<20131024162557.6dd72435@oracle.com>
	<20131025093333.GB24583@infradead.org>
	<20131028114328.4b05e0ee@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131028114328.4b05e0ee@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Oct 28, 2013 at 11:43:28AM -0400, Dwight Engen wrote:
> Hi Cristoph, on my system (where fsgqa is id 501) the one liner the
> test is running is:
> 
> # ./src/nsexec -s -U -M "0 501 1000" -G "0 501 1000" ./src/lstat64
> Usage: lstat64 [-t] filename ...

The id here is 1000 and the following works just fine:

/src/nsexec -s -U -M "0 1000 1000" -G "0 1000 1000" ./src/lstat64
Usage: lstat64 [-t] filename ...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
