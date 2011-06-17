Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5HKKV0R143168 for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 15:20:32 -0500
Received: from e38.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F26DADD420D
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 13:20:30 -0700 (PDT)
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159]) by
	cuda.sgi.com with ESMTP id pe6ucSELMfc4fnvb for
	<xfs@oss.sgi.com>; Fri, 17 Jun 2011 13:20:30 -0700 (PDT)
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by e38.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5HKC1Tj029242
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 14:12:01 -0600
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id
	p5HKKKOE177880 for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 14:20:21 -0600
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p5HKKGOm031170
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2011 14:20:17 -0600
Message-ID: <4DFBB6FF.8080208@linux.vnet.ibm.com>
Date: Fri, 17 Jun 2011 13:20:15 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3 v5] XFS TESTS: Add ENOSPC Hole Punch Test
References: <4DED6405.7020104@vnet.ibm.com>
	<20110617120838.GA20714@infradead.org>
In-Reply-To: <20110617120838.GA20714@infradead.org>
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Allison Henderson <achender@vnet.ibm.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On 06/17/2011 05:08 AM, Christoph Hellwig wrote:
> This one fails for me because my test system doesn't have sudo
> installed.  I can't see any reason why a simple su wouldn't be enough.
>
> We already have a helper to make su usable on both IRIX and Linux in
> test 123, and it might be a good idea to add this to the common routines
> and use it.
>
> I'd also suggest to split this test off 252 into a new test case, as
> unlike the other tests it actually requires a scratch devices, and in
> general is pretty different from the simple xfs_io exercises in 252.
>
> I'd also move the newly added helpers directly into the new testcase
> as they really aren't common.
>

Hi Christoph,

Thanks for the review, I will make those adjustments then and submit 
them in a separate patch set since it sounds like 1/3 and 2/3 are moving 
forward.  Thanks again!  :)

Allison Henderson

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
