Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A2FB47F54
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 05:10:56 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 933158F8040
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 03:10:50 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id RA4ur66A9PqA3m7E (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 03:10:40 -0800 (PST)
Date: Fri, 13 Dec 2013 03:10:39 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/12] run more generic tests on TEST_DIR
Message-ID: <20131213111039.GD14884@infradead.org>
References: <20131211073445.353655850@bombadil.infradead.org>
	<20131211225012.GL10988@dastard>
	<20131212180312.GC19422@infradead.org>
	<20131213010934.GN10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131213010934.GN10988@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>, xfs@oss.sgi.com

On Fri, Dec 13, 2013 at 12:09:34PM +1100, Dave Chinner wrote:
> > You can have different test devices, or simply not bother with aging
> > it for every run.  You're missing the coverage of all the test dir
> > using tests, which are a lot with the above version anyway.
> 
> IOWs, you're saying that you don't consider MKFS_OPTIONS as a first
> class citizen. I've been using it for 7 or 8 years for exactly this
> purpose - iterating testing of a change quickly across multiple
> configurations without perturbing the long term aging of the test
> device.

But you're limiting yourself to the tests only using the scratch
device for that testing, leaving out all the ones using the TEST
directory.

> I'm not opposed to making the change, just pointing out that
> reducing the usage of the scratch device has a fairly significant
> impact on test coverage for anyone who uses MKFS_OPTIONS in their
> workflow...

It does have an impact for that particular workload, but I think that
workload is broken as you only test your specific config for those
tests using the scratch device, and do not get the coverage for the
tests using the test device.

git-grep -l TEST_DIR tests/generic/ | grep -v out | wc -l
65
git-grep -l TEST_DIR tests/xfs/ | grep -v out | wc -l 
23


hch@brick:~/work/xfstests$ git-grep -l _require_scratch tests/generic/ | wc -l
58
hch@brick:~/work/xfstests$ git-grep -l _require_scratch tests/xfs/ | wc -l
128

So you're missing close to 2/3s of the tests already.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
