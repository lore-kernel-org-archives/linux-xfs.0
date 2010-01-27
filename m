Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0RKK4xf212540 for <xfs@oss.sgi.com>; Wed, 27 Jan 2010 14:20:04 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 97FBF194274
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2010 12:21:09 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id scMurWhVWljnLnXn for
	<xfs@oss.sgi.com>; Wed, 27 Jan 2010 12:21:09 -0800 (PST)
Message-ID: <4B60A026.30905@sandeen.net>
Date: Wed, 27 Jan 2010 14:20:54 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfstests: Automatic build dependency calculations
References: <1264053773-6054-1-git-send-email-david@fromorbit.com>
	<1264053773-6054-3-git-send-email-david@fromorbit.com>
	<4B60932D.7060709@sandeen.net>
	<20100127201733.GA32057@infradead.org>
In-Reply-To: <20100127201733.GA32057@infradead.org>
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
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Wed, Jan 27, 2010 at 01:25:33PM -0600, Eric Sandeen wrote:
>> seems to be some fallout from this at least on my F10 box:
>>
>> /usr/bin/makedepend: warning:  ignoring option -Wall
>> /usr/bin/makedepend: error:  cannot open "no-strict-aliasing"
>>
>> also this change:
>>
>> -       preallo_rw_pattern_reader preallo_rw_pattern_writer ftrunc trunc \
>> -       fs_perms testx looptest locktest unwritten_mmap \
>> +       ftrunc trunc fs_perms testx looptest locktest unwritten_mmap \
>>         bulkstat_unlink_test bulkstat_unlink_test_modified t_dir_offset \
>>
>> ...
>>
>>
>> +PREALLO_TARGETS = preallo_rw_pattern_reader
>>
>> seems to have lost the build of preallo_rw_pattern_reader & writer.
>>
>> Was that stray, or what were you going for there?
> 
> It's stray now that I fixed up the way preallo_rw_pattern_reader/write
> are compiled.  The patch needs a little respin.
> 

ok, whatever is in the repo at this point is busted :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
