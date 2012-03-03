Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q23J3wXU071976 for <xfs@oss.sgi.com>; Sat, 3 Mar 2012 13:03:59 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id E66w9bMdm30MaxXv for <xfs@oss.sgi.com>;
	Sat, 03 Mar 2012 11:03:57 -0800 (PST)
Message-ID: <4F526B1C.4000304@sandeen.net>
Date: Sat, 03 Mar 2012 13:03:56 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [xfstests patch] 113: add testing for O_DIRECT + O_SYNC
References: <x49ipim7r19.fsf@segfault.boston.devel.redhat.com>
	<20120303093332.GA8417@infradead.org>
In-Reply-To: <20120303093332.GA8417@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, xfs@oss.sgi.com

On 3/3/12 3:33 AM, Christoph Hellwig wrote:
> On Fri, Mar 02, 2012 at 02:15:46PM -0500, Jeff Moyer wrote:
>> Hi,
>>
>> This patch adds a couple more aio-stress runs to test 113.  The first
>> simply adds -S, to test out AIO+DIO+O_SYNC.  The second adds -S and -o
>> 2, which directs aio-stress to only perform the random write test.
>> These two tests helped identify several bugs in ext4.
> 
> I'd rather make this a separate testcase, maybe moving the _do_test into
> common code.
> 
> Rationale:  newly added tests shouldn't make old testcases fail, as that
> would be rather confusing.

Well, phooey, I committed it already.

I can do another patch to revert & add to a new test if you really want.

-Eric

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
