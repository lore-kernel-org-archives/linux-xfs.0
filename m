Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D68C87F3F
	for <xfs@oss.sgi.com>; Fri, 16 May 2014 20:01:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5CF26AC001
	for <xfs@oss.sgi.com>; Fri, 16 May 2014 18:01:09 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id mVbZWT7WKqFCAPkq for <xfs@oss.sgi.com>;
	Fri, 16 May 2014 18:01:07 -0700 (PDT)
Message-ID: <5376B4D7.1000006@sandeen.net>
Date: Fri, 16 May 2014 20:01:11 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [ANNOUNCE] xfsprogs: v3.2.0 released!
References: <20140516055650.GF26353@dastard>	<y2a8uq11g5k.fsf@cartman.at.offog.org>
	<20140517002309.GA18954@dastard>
In-Reply-To: <20140517002309.GA18954@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Adam Sampson <ats@offog.org>
Cc: xfs@oss.sgi.com

On 5/16/14, 7:23 PM, Dave Chinner wrote:
> On Sat, May 17, 2014 at 12:02:15AM +0100, Adam Sampson wrote:
>> Dave Chinner <david@fromorbit.com> writes:
>>
>>> It is my pleasure to announce the release of v3.2.0 of the xfsprogs
>>> package.
>>
>> If this is built with DEBUG= (i.e. not defaulting to DEBUG=-NDEBUG),
>> several source files fail to compile -- it looks like there are a number
>> of assertions that haven't been updated for changes in the code:
> 
> Can't say I've ever built xfsprogs with "DEBUG=". I'm not sure
> there's really any benefit in doing so - it's preferable to have
> things like xfs_repair abort when it comes across an inconsistency
> it can't handle than to continue blindly along and making a bigger
> mess of the filesystem it's supposed to be fixing...
> 
> Anyway, we'll look to fix it for 3.2.1.

-NDEBUG is only default for libxfs/ AFAIK:

# grep -B1 NDEBUG libxfs/Makefile 
# don't try linking xfs_repair with a debug libxfs.
DEBUG = -DNDEBUG

For everything else, default should be -DDEBUG:

configure:    DEBUG=${DEBUG:-'-DDEBUG'}		    debug_build="$DEBUG"

so default is -DDEBUG for everything except libxfs, with -NDEBUG;
I'm not sure what '' does - break, apparently.  Seems like maybe just
a bit of a makefile mess and maybe old crufty code.
Patches accepted and all that.  :)

But maybe it's time to remove it as an option, and just DTRT everywhere.

>> (Errors from current Git, built with GCC 4.9. You also get a good crop
>> of warnings if you build it with clang 3.4.1's scan-build, which'd be
>> worth checking out in case there's anything serious there.)
> 
> ISTR that was done recently by Eric, and I've run clang recently,
> too.

Some, yeah.  I don't claim to have gotten it all cleaned up yet,
though.  We also keep track of what Coverity finds, chipping away
at a backlog of potential defects...

Thanks for the report, though, there's always more to do...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
