Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1E5277FB0
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 18:31:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E0A4F8F8052
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 16:31:00 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	3NGt9DKFPPCgAByL for <xfs@oss.sgi.com>;
	Tue, 09 Apr 2013 16:30:56 -0700 (PDT)
Date: Wed, 10 Apr 2013 09:30:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: need help how to debug xfs crash issue xfs_iunlink_remove:
	xfs_inotobp() returned error 22
Message-ID: <20130409233053.GP17758@dastard>
References: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
	<CADFMGu+=MM2yc=_peboV7JTNJ8F05TJfexmEErzcf0D8mAWFRg@mail.gmail.com>
	<CAJzLF9k3f7ix7GD==26+JDg=5=AQWnJe3aopAHnQxXmzNPRkOw@mail.gmail.com>
	<516493B3.5030106@sandeen.net> <20130409224852.GF22182@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130409224852.GF22182@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: =?utf-8?B?56ym5rC45rab?= <yongtaofu@gmail.com>, "Michael L. Semon" <mlsemon35@gmail.com>, Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Apr 09, 2013 at 05:48:52PM -0500, Ben Myers wrote:
> Hey,
> 
> On Tue, Apr 09, 2013 at 05:18:27PM -0500, Eric Sandeen wrote:
> > On 4/9/13 5:16 PM, Michael L. Semon wrote:
> > > A meager non-expert user question with full ignorance of glusterfs:
> > > Why are you having I/O errors once every two weeks?
> > 
> > It's runtime errors or corruption, followed by fs shutdown, which then
> > results in IO errors, because all IOs are rejected on the shutdown FS.
> > 
> > But that's not always immediately obvious from the stream of resulting
> > "I/O Error" messages ;)
> 
> The IO errors are maybe a bit excessive and scary.

That's entirely the point. If we stay silent we get complaints about
not telling people that there's something wrong. If the error
messages are not excessive and scary, then people don't report them
and so we never hear about problems that are occurring.

> I can understand why some
> people might misinterpret those messages and assume it's a hardware problem.

Quite frankly, the biggest problem we have *always* had is that
people don't bother to read their log files when something has gone
wrong or selectively quote the logs when reporting the bug.  This
is the primary reason for the "how to report a bug" FAQ entry asking
for the *full logs* to be posted in a bug report.

Removing error messages because they are "noisy" is not the answer.
Verbose error messages (especially corruption reports) are there
mainly for the benefit of the developers, not the user. The user
needs to know when a corruption has occurred, but we need to
understand the what, how and why of the issue.

It's far better to scare users by dumping all the relevant info into
the log when an error occurs than to be sitting around scratching
our heads going "WTF?" like we are right now because there isn't
enough information in the logs to have even a basic clue of what is
going wrong...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
