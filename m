Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7V4i5Qt177753 for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 23:44:05 -0500
Received: from rcsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1BB9313B108A
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 21:47:27 -0700 (PDT)
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id UCNjqA1xgKosPUDX for
	<xfs@oss.sgi.com>; Tue, 30 Aug 2011 21:47:27 -0700 (PDT)
Message-ID: <4E5DBBFD.5020202@oracle.com>
Date: Tue, 30 Aug 2011 21:43:41 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
	<1309275199-10801-5-git-send-email-josef@redhat.com>
	<20110825060632.GA9933@infradead.org>
	<20110825064039.GO3162@dastard>
	<0A267E55-7772-438D-B6A7-89B73020F311@dilger.ca>
	<20110826013528.GW3162@dastard> <4E5D8B8E.8030401@oracle.com>
	<20110831032932.GI32358@dastard>
In-Reply-To: <20110831032932.GI32358@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Andreas Dilger <adilger@dilger.ca>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Josef Bacik <josef@redhat.com>, dchinner@redhat.com, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, viro@ZenIV.linux.org.uk

On 8/30/2011 8:29 PM, Dave Chinner wrote:
> And that's -exactly- the ambiguous, vague definition that has raised
> all these questions in the first place. I was in doubt about whether
> unwritten extents can be considered a hole, and by your definition
> that means it should be data. But Andreas seems to be in no doubt it
> should be considered a hole.

Fair enough. Let me rephrase.

Data:
A range in a file when read could return something other than nulls.

Hole:
A range in a file when read only returns nulls.

Considering preallocated extents only return null, they should
be considered holes.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
