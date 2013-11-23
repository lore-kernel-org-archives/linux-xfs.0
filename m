Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 111D27F3F
	for <xfs@oss.sgi.com>; Sat, 23 Nov 2013 02:41:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D7D388F8035
	for <xfs@oss.sgi.com>; Sat, 23 Nov 2013 00:41:14 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 9vlwaaM4DaKj5ymf (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 23 Nov 2013 00:41:10 -0800 (PST)
Date: Sat, 23 Nov 2013 00:41:06 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Filesystem writes on RAID5 too slow
Message-ID: <20131123084106.GA19088@infradead.org>
References: <CACtJ3HZxp6xEjY_wOucCcqX4scNzEGuiAsovQYObJS9whtYJsQ@mail.gmail.com>
	<528A5C45.4080906@redhat.com> <20131119005740.GY6188@dastard>
	<CACtJ3Ha3C7JNi5VZRnNMn+-okNheygmbj=j9AnUMvfzfZjNwug@mail.gmail.com>
	<20131121092606.GU11434@dastard>
	<CACtJ3HZAsOtmLArMWraygfQxpGymtZjr+a_reXv8o6LJzoMbvw@mail.gmail.com>
	<CACtJ3Ha5P2Heu4qiEEk6c4g+tKyR=RrD-4E-Cqj+bP8YDjKQ6w@mail.gmail.com>
	<20131121234116.GD6502@dastard>
	<20131122092136.GD32568@infradead.org>
	<20131122224038.GH6502@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131122224038.GH6502@dastard>
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
Cc: Martin Boutin <martboutin@gmail.com>, "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, "Kernel.org-Linux-EXT4" <linux-ext4@vger.kernel.org>

On Sat, Nov 23, 2013 at 09:40:38AM +1100, Dave Chinner wrote:
> > geometry, and we already have it wired to to large sector size
> > testing in xfstests.
> 
> We don't need to screw around with the sector size - that is
> irrelevant to the problem, and we have an allocation alignment
> test that is supposed to catch these issues: generic/223.

It didn't imply we need large sector sizes, but the same mechanism
to expodse a large sector size can also be used to present large
stripe units/width.

> As I said, I have seen occasional failures of that test (once a
> month, on average) as a result of this bug. It was simply not often
> enough - running in a hard loop didn't increase the frequency of
> failures - to be able debug it or to reach my "there's a regression
> I need to look at" threshold. Perhaps we need to revisit that test
> and see if we can make it more likely to trigger failures...

Seems like 233 should have cought it regularly with the explicit
alignment options on mkfs time.  Maybe we also need a test mirroring
the plain dd more closely?

I've not seen 233 fail for a long time..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
