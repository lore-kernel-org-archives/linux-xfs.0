Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0D3C57CA0
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 14:09:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AF9268F8049
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 12:09:11 -0700 (PDT)
Received: from na01-bn1-obe.outbound.protection.outlook.com
	(mail-bn1on0146.outbound.protection.outlook.com
	[157.56.110.146]) by cuda.sgi.com with ESMTP id
	D2sfCJKEh1WTZ17c (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 14 Jun 2016 12:09:09 -0700 (PDT)
Message-ID: <57605648.6060705@hpe.com>
Date: Tue, 14 Jun 2016 15:08:56 -0400
From: Waiman Long <waiman.long@hpe.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH-tip 6/6] xfs: Enable reader optimistic spinning for
	DAX inodes
References: <1465927959-39719-1-git-send-email-Waiman.Long@hpe.com>
	<1465927959-39719-7-git-send-email-Waiman.Long@hpe.com>
	<20160614182423.GA6330@infradead.org>
In-Reply-To: <20160614182423.GA6330@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>, linux-ia64@vger.kernel.org, Scott J Norton <scott.norton@hpe.com>, Peter Zijlstra <peterz@infradead.org>, x86@kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ingo Molnar <mingo@redhat.com>, linux-alpha@vger.kernel.org, Douglas Hatch <doug.hatch@hpe.com>, Jason Low <jason.low2@hp.com>

On 06/14/2016 02:24 PM, Christoph Hellwig wrote:
> On Tue, Jun 14, 2016 at 02:12:39PM -0400, Waiman Long wrote:
>> This patch enables reader optimistic spinning for inodes that are
>> under a DAX-based mount point.
>>
>> On a 4-socket Haswell machine running on a 4.7-rc1 tip-based kernel,
>> the fio test with multithreaded randrw and randwrite tests on the
>> same file on a XFS partition on top of a NVDIMM with DAX were run,
>> the aggregated bandwidths before and after the patch were as follows:
> And why is this specific to DAX?  Many I/O operations already never
> got out to disk, and ilock is mostly held for operations that have
> nothing to do with disk I/O.

It is just a showcase for the rwsem change. We can certainly have more 
use cases.

Cheers,
Longman

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
