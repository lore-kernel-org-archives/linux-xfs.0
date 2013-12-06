Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AB2B57F3F
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 10:07:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 487B6AC008
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 08:07:02 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id iGxG9MxAYC4kBXAJ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Dec 2013 08:06:59 -0800 (PST)
Date: Fri, 6 Dec 2013 08:06:58 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: stop special casing nfs and udf
Message-ID: <20131206160658.GA27329@infradead.org>
References: <20131107204635.GA22954@infradead.org>
	<52A175DD.5050908@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52A175DD.5050908@oracle.com>
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
To: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
Cc: xfs@oss.sgi.com

On Fri, Dec 06, 2013 at 10:59:41AM +0400, Stanislav Kholmanskikh wrote:
> Sorry for my post-commit "review".
> 
> But for what purposes did you delete this scratch device handling for nfs?
> Now each test case that uses _require_scratch returns [not run].
> 
> It means most of the generic/ test cases.
> 
> I think we should revert this part of code. How do you think?

Tests really requiring a scratch device don't make sense for XFS,
as the scratch device is supposed to get recreated for every test.

However it seems like a lot of tests should simply run on the test
device. I'll take care of moving them over to use the test device.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
