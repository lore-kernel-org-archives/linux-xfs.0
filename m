Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B5A647CBF
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 08:05:00 -0500 (CDT)
Message-ID: <521CA3F8.7070805@sgi.com>
Date: Tue, 27 Aug 2013 08:04:56 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Re: XFS: Assertion failed: first <= last && last <
	BBTOB(bp->b_length), file: fs/xfs/xfs_trans_buf.c, line: 568
References: <52165830.8050006@redhat.com> <20130826041330.GU6023@dastard>
	<521B59C7.1080803@redhat.com> <521B6D88.30608@sgi.com>
	<20130826210445.GW6023@dastard> <521BC64A.6040005@sgi.com>
In-Reply-To: <521BC64A.6040005@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On 08/26/13 16:19, Mark Tinguely wrote:
> On 08/26/13 16:04, Dave Chinner wrote:
>> On Mon, Aug 26, 2013 at 10:00:24AM -0500, Mark Tinguely wrote:
>>> On 08/26/13 08:36, Brian Foster wrote:
>>>> On 08/26/2013 12:13 AM, Dave Chinner wrote:
>>>>> On Thu, Aug 22, 2013 at 02:28:00PM -0400, Brian Foster wrote:
>>>>>> Hi all,
>>>>>>
>>>>>> I hit an assert on a debug kernel while beating on some finobt
>>>>>> work and
>>>>>> eventually reproduced it on unmodified/TOT xfs/xfsprogs as of
>>>>>> today. I
>>>>>> hit it through a couple different paths, first while running
>>>>>> fsstress on
>>>>>> a CRC enabled filesystem (with otherwise default mkfs options):
>>>>>>
>>>>>> (These tests are running on a 4p, 4GB VM against a 100GB virtio disk,
>>>>>> hosted on a single spindle desktop box).
>>>>>>
>>>>>> crc=1
>>>>>> fsstress -z -fsymlink=1 -n99999999 -p4 -d /mnt/test
>>>>>>
>>>>>> XFS: Assertion failed: first<= last&& last< BBTOB(bp->b_length),
>>>>>
>>>>> Directory buffer overrun.

> A full test still asserts on the remove with the patched Linux 3.10 - I
> am about 50% into the retest of Linux 3.10 and then I was planning to
> move back to Linux 3.9.
>
> kdump did not work, so I have no vmcore and therefore no productive
> information.
>

Confirmed the Linux 3.10 asserts. Linux 3.9 does not assert.

I will fix the kdump and try to catch a Linux 3.10 assert.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
