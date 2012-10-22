Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9MDJls8091170 for <xfs@oss.sgi.com>; Mon, 22 Oct 2012 08:19:47 -0500
Message-ID: <508548BF.9090103@redhat.com>
Date: Mon, 22 Oct 2012 09:23:11 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v5 06/10] xfs: add XFS_IOC_FREE_EOFBLOCKS ioctl
References: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
	<1349446636-8611-7-git-send-email-bfoster@redhat.com>
	<20121011141335.GY13214@sgi.com> <507749A2.4020206@redhat.com>
	<20121015224626.GU24986@sgi.com>
	<20121015234902.GH2739@dastard> <20121016013901.GI2739@dastard>
	<20121017224004.GG1377@sgi.com> <507FF339.8020208@redhat.com>
	<20121022073422.GC2739@dastard>
In-Reply-To: <20121022073422.GC2739@dastard>
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
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On 10/22/2012 03:34 AM, Dave Chinner wrote:
> On Thu, Oct 18, 2012 at 08:16:57AM -0400, Brian Foster wrote:
>> On 10/17/2012 06:40 PM, Ben Myers wrote:
>>>>> FWIW, given the background cleanup code can be trivially verified to
>>>>> work (open, apend, close, repeat, wait 5 minutes) and is the
>>>>> functionality that is needed in mainline, having something to test
>>>>> the ioctls should not stop the patchset from being merged.
>>>
>>> Can we be assured that we'll get an xfstest for it eventually?
>>
>> Absolutely. Getting a command into xfs_io to support such a test is now
>> the top of my todo list with regard to XFS. :)
> 
> Here's a patch to the new xfs_spaceman program I'm writing that adds
> control for these ioctls.
> 

Very cool, thanks. Catchy name for the tool as well, btw ;).

For some reason my mailer is stripping out the patch, but my only
comment is with regard to minlen. Shouldn't that variable be handled as
an unsigned? Now that I think of it, that makes me wonder if I should
make that a 64-bit unsigned in xfs_eofblocks..?

Brian

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
