Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9508929DF8
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2014 12:18:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8A2928F8033
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2014 10:18:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id S24gqh08EfEf5CBN for
	<xfs@oss.sgi.com>; Mon, 28 Apr 2014 10:18:55 -0700 (PDT)
Message-ID: <535E8D67.3010504@redhat.com>
Date: Mon, 28 Apr 2014 12:18:31 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: test for shut down fs in xfs_dir_fsync()
References: <535E8344.2070209@redhat.com>
	<20140428164754.GA17472@infradead.org>
In-Reply-To: <20140428164754.GA17472@infradead.org>
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
Cc: Boris Ranto <branto@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 4/28/14, 11:47 AM, Christoph Hellwig wrote:
> On Mon, Apr 28, 2014 at 11:35:16AM -0500, Eric Sandeen wrote:
>> Similar to xfs_file_fsync(), I think xfs_dir_fsync() needs
>> to test for a shut down fs,
> 
> It probably should.
> 
>> lest we go down paths we'll
>> never be able to complete; Boris reported that during some
>> stress tests he had threads stuck in xlog_cil_force_lsn
>> via xfs_dir_fsync().
> 
> But this could still happen if we get a shutdown coming in after that
> test.

True... that looked a bit hairier to sort out.  :(

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
