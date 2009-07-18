Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6IGW7Cr161879 for <xfs@oss.sgi.com>; Sat, 18 Jul 2009 11:32:08 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C6D4712A5337
	for <xfs@oss.sgi.com>; Sat, 18 Jul 2009 09:40:40 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id A38DBQ5hz3cFiqBA for
	<xfs@oss.sgi.com>; Sat, 18 Jul 2009 09:40:40 -0700 (PDT)
Message-ID: <4A61F92D.7090708@sandeen.net>
Date: Sat, 18 Jul 2009 11:32:45 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 219: test fiemap
References: <4A5F82D8.8080709@sandeen.net>
	<20090718142339.GA20905@infradead.org>
In-Reply-To: <20090718142339.GA20905@infradead.org>
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
Cc: Josef Bacik <jbacik@redhat.com>, xfs mailing list <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Thu, Jul 16, 2009 at 02:43:20PM -0500, Eric Sandeen wrote:
>> Preliminary fiemap testing support based on a test util
>> written by Josef Bacik.
>>
>> For now it's only run with preallocation disabled, because
>> xfs has a tendency to fill in holes with data blocks
>> (EOF prealloc stuff I think) and similar for explicit 
>> preallocation, so this is breaking the preallocation 
>> tests for now, when it finds a "data" block where it expects
>> a preallocated block.
> 
> Wouldn't we be better off to add an fiemap command to xfs_io so that
> we can re-use it instead of having a special test program in xfstests?

I suppose it'd be nice to have, though in this case the test program
also generates all the random patterns and does the checking ... the
fiemap calls are a relatively simple part of it ...

Using xfs_io would be a bit like saying "xfs_io can already generate all
the calls that fsx generates, why not use it instead of a special test
program...." IMHO.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
