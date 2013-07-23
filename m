Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6EA047F50
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 22:37:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EA0E5AC004
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 20:37:07 -0700 (PDT)
Received: from mail-gh0-f176.google.com (mail-gh0-f176.google.com
	[209.85.160.176]) by cuda.sgi.com with ESMTP id
	tqCOnN6fvjZfSPAW (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 22 Jul 2013 20:37:06 -0700 (PDT)
Received: by mail-gh0-f176.google.com with SMTP id z17so2362210ghb.35
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 20:37:06 -0700 (PDT)
Message-ID: <51EDFA5A.7070402@gmail.com>
Date: Mon, 22 Jul 2013 23:36:58 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 00/49] xfsprogs: patches for crc-dev branch
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<51EB80DB.80602@gmail.com> <20130722233240.GC19986@dastard>
In-Reply-To: <20130722233240.GC19986@dastard>
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
Cc: xfs@oss.sgi.com

On 07/22/2013 07:32 PM, Dave Chinner wrote:
> On Sun, Jul 21, 2013 at 02:34:03AM -0400, Michael L. Semon wrote:
>> On 07/19/2013 02:44 AM, Dave Chinner wrote:
>>
>>> Comments, thoughts, flames?
>>
>> I was hoping that I could use this 3.12 patchset with a 3.11.0-rc 
>> kernel, but the xfstests look like a disaster by going that way.  
> 
> We'll, if you don't have all the filtering patches that I posted a
> while back it'll make quite a mess with all the experimental
> warnings mkfs and repair emit, and the xfs_db tests that modify
> filesystem structures will all also fail...

I've been slacking on xfstests updates.  The problem may exist 
between keyboard and chair, though:  I was trying to copy a merged 
xfsprogs from one PC to another, then build everything from `make 
distclean` after deleting /usr/include/xfs.  Something must have 
gone wrong...won't be the first time...

> I'll repost them later today...

I'll take this patchset home and see if any of them were not 
committed to the xfsprogs git:

http://oss.sgi.com/archives/xfs/2013-06/msg00217.html

Is this the correct patchset?

Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
