Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n44EsOXH179271 for <xfs@oss.sgi.com>; Mon, 4 May 2009 09:54:24 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E73A1AC00E
	for <xfs@oss.sgi.com>; Mon,  4 May 2009 07:54:22 -0700 (PDT)
Message-ID: <49FF019B.5050207@sgi.com>
Date: Mon, 04 May 2009 09:54:19 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump: add .gitignore
References: <20090429135050.GC30808@infradead.org>	<d38e348a0905031635s3b7a812cl3e46d13069572d97@mail.gmail.com>
	<20090504074021.GA29449@infradead.org>
In-Reply-To: <20090504074021.GA29449@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, Timothy Shimmin <timothy.shimmin@gmail.com>

Christoph Hellwig wrote:
> On Mon, May 04, 2009 at 09:35:39AM +1000, Timothy Shimmin wrote:
>> Get rid of the symlinked files by creating a local library for the
>> commonality? ;-)Probably easier said than done - I haven't looked at the
>> code in a while - but I
>> I think the traditional library model is better than a heap of symlinks :)
> 
> It probably is.  I'll put it on my todo list..

Not sure how well if fits the library model, unfortunately. The
symlinked files need to be compiled for dump and then recompiled
for restore as there's a bunch of #ifdef DUMP and #ifdef RESTORE
sections. I guess two libraries could be created, if separate
build dirs were used under common.

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
