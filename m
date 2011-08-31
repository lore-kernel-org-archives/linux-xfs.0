Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7V95PTo196170 for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 04:05:25 -0500
Received: from mail3.vodafone.ie (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9615D128D67
	for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 02:05:23 -0700 (PDT)
Received: from mail3.vodafone.ie (mail3.vodafone.ie [213.233.128.45]) by
	cuda.sgi.com with ESMTP id GPXDZsOyu5qhmrW2 for
	<xfs@oss.sgi.com>; Wed, 31 Aug 2011 02:05:23 -0700 (PDT)
Message-ID: <4E5DF951.4010804@draigBrady.com>
Date: Wed, 31 Aug 2011 10:05:21 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
	<1309275199-10801-5-git-send-email-josef@redhat.com>
	<20110825060632.GA9933@infradead.org>
	<20110825064039.GO3162@dastard>
	<0A267E55-7772-438D-B6A7-89B73020F311@dilger.ca>
	<20110826013528.GW3162@dastard> <4E5D8B8E.8030401@oracle.com>
	<20110831032932.GI32358@dastard> <4E5DBBFD.5020202@oracle.com>
In-Reply-To: <4E5DBBFD.5020202@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Sunil Mushran <sunil.mushran@oracle.com>
Cc: Andreas Dilger <adilger@dilger.ca>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org, dchinner@redhat.com, linux-fsdevel@vger.kernel.org, Josef Bacik <josef@redhat.com>, viro@ZenIV.linux.org.uk

On 08/31/2011 05:43 AM, Sunil Mushran wrote:
> On 8/30/2011 8:29 PM, Dave Chinner wrote:
>> And that's -exactly- the ambiguous, vague definition that has raised
>> all these questions in the first place. I was in doubt about whether
>> unwritten extents can be considered a hole, and by your definition
>> that means it should be data. But Andreas seems to be in no doubt it
>> should be considered a hole.
> =

> Fair enough. Let me rephrase.
> =

> Data:
> A range in a file when read could return something other than nulls.
> =

> Hole:
> A range in a file when read only returns nulls.
> =

> Considering preallocated extents only return null, they should
> be considered holes.

I would concur with this.
Treating preallocated extents as holes will allow them to be
processed quickly by `cp` etc.

What we lose is the ability to copy the allocation from src to dst.
But that's less important in comparison, and could probably be done
on a per file rather than per extent basis anyway.
Note preallocation would be good for disk layout and timely ENOSPC.

Note fiemap gives us greater control by distinguishing
holes and empty extents, thus allowing us to both
efficiently copy and maintain allocation.  But that
interface currently requires a sync of the file on some
file systems, which we couldn't enable for performance
reasons in cp.

cheers,
P=E1draig.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
