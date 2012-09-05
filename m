Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q85CMcMC044473 for <xfs@oss.sgi.com>; Wed, 5 Sep 2012 07:22:38 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UizVgI7HwApTgTgT for
	<xfs@oss.sgi.com>; Wed, 05 Sep 2012 05:23:36 -0700 (PDT)
Message-ID: <504743F0.1050802@redhat.com>
Date: Wed, 05 Sep 2012 08:22:08 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH 3/4] xfs: add FREE_EOFBLOCKS ioctl
References: <1346097111-4476-1-git-send-email-bfoster@redhat.com>
	<1346097111-4476-4-git-send-email-bfoster@redhat.com>
	<20120903051742.GS15292@dastard> <50460BDB.40806@redhat.com>
	<20120905064944.GH15292@dastard>
In-Reply-To: <20120905064944.GH15292@dastard>
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
Cc: xfs@oss.sgi.com

On 09/05/2012 02:49 AM, Dave Chinner wrote:
> On Tue, Sep 04, 2012 at 10:10:35AM -0400, Brian Foster wrote:
>> On 09/03/2012 01:17 AM, Dave Chinner wrote:
>>> On Mon, Aug 27, 2012 at 03:51:50PM -0400, Brian Foster wrote:
...
>> This is something I see throughout the code that I haven't quite
>> followed (i.e., using the _t typedefs vs. not). Is the general consensus
>> to move away from typedefs when possible?
> 
> Yes. The Irix code that XFS came from was full of typedefs - part
> of it was to try to strictly type check things that were the same
> storage size or on-disk vs in-memory. We've got other ways of doing
> that better (e.g. the endian checking sparse does), and typedefs
> are generally frowned upon in the main kernel code because they
> often obfuscate the code rather than improve it, so we're
> removing them as we modify code or write new code.
> 

Good to know.

...
>> Ok. I was thinking that we could support the ability to scan by uid/gid
>> regardless of whether quota is enabled, but perhaps there's no purpose
>> to that if a quota isn't enabled.
> 
> I can't really think of a use case for doing this. Making the API
> more expansive in future if someone needs this can be done - it's
> removing stuff that is really hard to do. Hence, don't add it if it
> is not going to be used immediately. :)
> 

Ok.

Brian

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
