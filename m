Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D61AF7F3F
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 22:52:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C08DF8F8035
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 20:52:35 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	GBzjO21DziLySzFn for <xfs@oss.sgi.com>;
	Tue, 23 Jul 2013 20:52:34 -0700 (PDT)
Date: Wed, 24 Jul 2013 13:52:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/49] xfsprogs: patches for crc-dev branch
Message-ID: <20130724035229.GP19986@dastard>
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<51EB80DB.80602@gmail.com> <20130722233240.GC19986@dastard>
	<51EDFA5A.7070402@gmail.com> <20130723044450.GG19986@dastard>
	<51EEEF61.40000@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51EEEF61.40000@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 23, 2013 at 05:02:25PM -0400, Michael L. Semon wrote:
> On 07/23/2013 12:44 AM, Dave Chinner wrote:
> > On Mon, Jul 22, 2013 at 11:36:58PM -0400, Michael L. Semon wrote:
> >> On 07/22/2013 07:32 PM, Dave Chinner wrote:
> >>> On Sun, Jul 21, 2013 at 02:34:03AM -0400, Michael L. Semon wrote:
> >>>> On 07/19/2013 02:44 AM, Dave Chinner wrote:
> >>>>
> >>>>> Comments, thoughts, flames?
> >>>>
> >>>> I was hoping that I could use this 3.12 patchset with a 3.11.0-rc 
> >>>> kernel, but the xfstests look like a disaster by going that way.  
> >>>
> >>> We'll, if you don't have all the filtering patches that I posted a
> >>> while back it'll make quite a mess with all the experimental
> >>> warnings mkfs and repair emit, and the xfs_db tests that modify
> >>> filesystem structures will all also fail...
> >>
> >> I've been slacking on xfstests updates.  The problem may exist 
> >> between keyboard and chair, though:  I was trying to copy a merged 
> >> xfsprogs from one PC to another, then build everything from `make 
> >> distclean` after deleting /usr/include/xfs.  Something must have 
> >> gone wrong...won't be the first time...
> >>
> >>> I'll repost them later today...
> >>
> >> I'll take this patchset home and see if any of them were not 
> >> committed to the xfsprogs git:
> >>
> >> http://oss.sgi.com/archives/xfs/2013-06/msg00217.html
> >>
> >> Is this the correct patchset?
> > 
> > Yeah, that's it, thugh I have a more recent version of it locally...
> > 
> > Cheers,
> > 
> > Dave.
> 
> 
> Thanks.  After applying this patchset and compiling dmapi, xfsprogs, 
> xfsdump, and xfstests around in circles several times, it looks 
> rather sane now.  Two issues remain, one reproduced on another PC:
> 
> 1) The earlier worries about dmapi and hole punching comes from the 
> results of xfs/145 being run.  It hasn't been that long, but I've 
> forgotten the last time xfstests gave messages like "[not run] DMAPI 
> modules not loaded."  dmapi is installed as a prerequisite; I have 
> precisely zero knowledge of what happens when it is enabled.

All the tests using dmapi should be detecting that your kernel does
not support dmapi and therefore should not be run....

> 2) There are two PCs: the one being discussed here, and the all-3.12 
> setup that is in mid-bisect.  For CRC filesystems made by the new 
> mkfs.xfs for the 3.11.0-rc and 3.10.0+ mid-bisect kernels, attempts 
> to mount them fail with a dmesg like this (by memory)...
> 
> XFS(sdb6): ... unknown incompatible features (0x1) detected ...
> Filesystem can not be safely mounted by this kernel.

Yes, that's because the new mkfs sets the dirent filetype field
feature bit, and older kernels don't know anything about that.

> Is there an extra flag that can be passed to mkfs.xfs for the sake 
> of older CRC-capable kernels? 

No, I didn't add one because this is all still under the
"experimental" umbrella and still under active development hence
changes in flags and features are expected and there's no real
reason to provide options for features will always be turned on once
non-experimental releases are made.

> FWIW, both PCs could still mount 
> CRC-enabled XFS filesystems made during the kernel 3.10-rc cycle.

Sure - mkfs doesn't enable this flag until patch 49 of this series.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
