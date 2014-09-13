Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 75F517F3F
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2014 15:12:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5C5F9304048
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2014 13:12:10 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id HQYAWNwwS7QINpAm for <xfs@oss.sgi.com>;
	Sat, 13 Sep 2014 13:12:08 -0700 (PDT)
Message-ID: <5414A517.1080102@sandeen.net>
Date: Sat, 13 Sep 2014 15:12:07 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V3] xfs_io: add mremap command
References: <54111610.4080604@redhat.com> <54132553.9090202@sandeen.net>
	<20140913194559.GA28479@infradead.org>
In-Reply-To: <20140913194559.GA28479@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 9/13/14 2:45 PM, Christoph Hellwig wrote:
> On Fri, Sep 12, 2014 at 11:54:43AM -0500, Eric Sandeen wrote:
>> This adds a simple mremap command to xfs_io.
>>
>> It does not take a start address; it uses the existing
>> start address, so the sized passed will be the new total
>> size of the mapping.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Looks good to me, but I'd feel much more comfortable about merging it
> if we had an xfstests test case that actually exercises it.
> 

I did it for a crazy mremap failure we saw, I'll probably end up
writing a testcase for that which uses it.

I could easily enough write a test to exercise this directly too,
I'll look into it.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
