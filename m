Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E9D857F3F
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 02:01:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7120DAC006
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 00:01:26 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id lwxHqwk61vkez2T9 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Mar 2015 00:01:21 -0700 (PDT)
Date: Tue, 24 Mar 2015 00:01:19 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] xfs: add DAX file operations support
Message-ID: <20150324070119.GA20893@infradead.org>
References: <1425425427-16283-1-git-send-email-david@fromorbit.com>
	<1425425427-16283-4-git-send-email-david@fromorbit.com>
	<54F6D9E4.9050803@gmail.com> <20150304130100.GU18360@dastard>
	<54F71CBA.2@gmail.com> <20150304220348.GW18360@dastard>
	<20150324042727.GR28621@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150324042727.GR28621@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz, Boaz Harrosh <openosd@gmail.com>, willy@linux.intel.com, xfs@oss.sgi.com

On Tue, Mar 24, 2015 at 03:27:27PM +1100, Dave Chinner wrote:
> Turns out there's no great need to write splice tests for xfstests -
> the current loopback device uses splice, and so all of the tests
> that run on loopback are exercising the splice path through the
> filesystem.

FYI, we're getting rid of the splice read (ab-)use in loop, so this
won't last forever.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
