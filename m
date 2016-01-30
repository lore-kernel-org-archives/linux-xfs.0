Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 224C87CA2
	for <xfs@oss.sgi.com>; Fri, 29 Jan 2016 21:11:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 103DB8F8040
	for <xfs@oss.sgi.com>; Fri, 29 Jan 2016 19:11:13 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id FttXGOCa93Bmh45R for <xfs@oss.sgi.com>;
	Fri, 29 Jan 2016 19:11:06 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 0F2D263C6064
	for <xfs@oss.sgi.com>; Fri, 29 Jan 2016 21:11:06 -0600 (CST)
Subject: Re: real-time device BUG
References: <20160129230531.GA29895@linux.intel.com>
	<20160129234036.GA24929@linux.intel.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56AC29CA.30504@sandeen.net>
Date: Fri, 29 Jan 2016 21:11:06 -0600
MIME-Version: 1.0
In-Reply-To: <20160129234036.GA24929@linux.intel.com>
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
To: xfs@oss.sgi.com



On 1/29/16 5:40 PM, Ross Zwisler wrote:
> On Fri, Jan 29, 2016 at 04:05:31PM -0700, Ross Zwisler wrote:
>> Today I was trying to get real-time devices working with XFS, and both a
>> manual pwrite() to a real-time device and xfs_rtcp end up with a lockdep spat
>> followed by a kernel BUG.  This behavior is consistent between kernel versions
>> v4.4 and v4.5-rc1.  I initially found this using some pmem block devices, but
>> it also happens with BRD.
> 
> This also happens with an mmap on the real-time file followed by a write.
> Essentially I think that any path that tries to allocate a block for the real
> time file his this same BUG.

Looks like an oversight from

commit eef334e5776c8ef547ada4cec17549929fe590b4
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Dec 6 12:30:17 2013 -0800

    xfs: assert that we hold the ilock for extent map access
    
    Make sure that xfs_bmapi_read has the ilock held in some way, and that
    xfs_bmapi_write, xfs_bmapi_delay, xfs_bunmapi and xfs_iread_extents are
    called with the ilock held exclusively.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

I think all we have to do is lock it for read here, I'll send a patch and
Dave or Christoph can smack me down if I'm wrong ;)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
