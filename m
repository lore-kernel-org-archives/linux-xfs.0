Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7V4mHvs177962 for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 23:48:17 -0500
Received: from mail-pz0-f46.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 554A11962ECA
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 21:48:16 -0700 (PDT)
Received: from mail-pz0-f46.google.com (mail-pz0-f46.google.com
	[209.85.210.46]) by cuda.sgi.com with ESMTP id YBrOw4hAi4IZiXKd
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 21:48:16 -0700 (PDT)
Received: by pzk32 with SMTP id 32so742671pzk.33
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 21:48:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110831032932.GI32358@dastard>
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
	<1309275199-10801-5-git-send-email-josef@redhat.com>
	<20110825060632.GA9933@infradead.org>
	<20110825064039.GO3162@dastard>
	<0A267E55-7772-438D-B6A7-89B73020F311@dilger.ca>
	<20110826013528.GW3162@dastard> <4E5D8B8E.8030401@oracle.com>
	<20110831032932.GI32358@dastard>
Date: Wed, 31 Aug 2011 00:48:15 -0400
Message-ID: <CAPL5yKfC2-4zh26+ApAzLTOqg43rhn18TTo8vwQuDDHV5iaPhw@mail.gmail.com>
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
From: Dan Merillat <dan.merillat@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Sunil Mushran <sunil.mushran@oracle.com>, Andreas Dilger <adilger@dilger.ca>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org, dchinner@redhat.com, linux-fsdevel@vger.kernel.org, Josef Bacik <josef@redhat.com>, viro@zeniv.linux.org.uk

On Tue, Aug 30, 2011 at 11:29 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Aug 30, 2011 at 06:17:02PM -0700, Sunil Mushran wrote:
>> Instead
>> we should let the fs weigh the cost of providing accurate information
>> with the possible gain in performance.
>>
>> Data:
>> A range in a file that could contain something other than nulls.
>> If in doubt, it is data.
>>
>> Hole:
>> A range in a file that only contains nulls.
>
> And that's -exactly- the ambiguous, vague definition that has raised
> all these questions in the first place. I was in doubt about whether
> unwritten extents can be considered a hole, and by your definition
> that means it should be data. But Andreas seems to be in no doubt it
> should be considered a hole.

That's fine, though.   Different filesystems have different abilities
to recognize a data hole - FAT can't do it at all.   Perhaps the
requirements would be better stated in reverse:  If the filesystem
knows that a read() will return nulls (for whatever reason based on
it's internal knowledge), it can report a hole.  If it can't guarantee
that, it's data.   It's an absolute requirement that SEEK_DATA never
miss data.  SEEK_HOLE working is a nicety that userspace would
appreciate - remember that the consumer here is cp(1), using it to
skip empty portions of files and create sparse destination files.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
