Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p59JI4Im196947 for <xfs@oss.sgi.com>; Thu, 9 Jun 2011 14:18:05 -0500
Received: from e3.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3D522D9725F
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2011 12:18:03 -0700 (PDT)
Received: from e3.ny.us.ibm.com (e3.ny.us.ibm.com [32.97.182.143]) by
	cuda.sgi.com with ESMTP id IigJhRJe2J3HK1J4 for
	<xfs@oss.sgi.com>; Thu, 09 Jun 2011 12:18:03 -0700 (PDT)
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e3.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p59ItaKl003827
	for <xfs@oss.sgi.com>; Thu, 9 Jun 2011 14:55:36 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p59JI1wq116880 for <xfs@oss.sgi.com>; Thu, 9 Jun 2011 15:18:01 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p59JI1QJ027168 for <xfs@oss.sgi.com>; Thu, 9 Jun 2011 16:18:01 -0300
Message-ID: <4DF11C67.8090702@linux.vnet.ibm.com>
Date: Thu, 09 Jun 2011 12:17:59 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: Port xfstests 145, 161, 175, 176, 185?
References: <4DEFC41A.9070701@linux.vnet.ibm.com>
	<20110609110826.GA14899@infradead.org>
In-Reply-To: <20110609110826.GA14899@infradead.org>
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On 06/09/2011 04:08 AM, Christoph Hellwig wrote:
> On Wed, Jun 08, 2011 at 11:48:58AM -0700, Allison Henderson wrote:
>> During one of my reviews for the punch hole tests patch set it was
>> mentioned that it would be helpful to take the xfstests 145, 161,
>> 175, 176, 185 and modify them such that they can run with out
>> requiring the dmapi.  These tests contain some more interesting
>> punch hole tests, but they dont normally run unless there is support
>> for dmapi.
>>
>> I did take a peek at them and I was thinking that if we decide to do
>> this, we would probably need to do something like introduce a new
>> set of source code that is similar to what is seen under the dmapi
>> folder, but modified to use a generic interface instead of the dmapi
>> libraries.  We could try to merge them into a single code path, but
>> I think that may introduce more complexities than would be
>> desirable.
>
> Most of it should be doable using xfs_io.  If it's nessecary to write
> new source files because of e.g. concurrency tests that we can't easily
> do from xfs_io please add new source files to the src/ directory.
>
> Also, please don't rewrite the actual existing dmapi test cases, but
> add new ones testing these patterns using the fallocate interface, as
> the coverage for the dmapi interface still is useful.
>

Alrighty, thx Christoph.  I will keep this work item on my todo list then.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
