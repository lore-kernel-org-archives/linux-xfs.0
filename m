Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7FDD27F37
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 13:25:22 -0500 (CDT)
Message-ID: <51758099.9030302@sgi.com>
Date: Mon, 22 Apr 2013 13:25:29 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: xfstests: kludge patch for per-dir test number sorting by ./check
References: <5169C4FE.4030209@gmail.com> <20130414232600.GA5117@destitution>
	<516B740A.1050607@gmail.com>
In-Reply-To: <516B740A.1050607@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfstests <xfs@oss.sgi.com>

On 04/14/2013 10:29 PM, Michael L. Semon wrote:
> On 04/14/2013 07:26 PM, Dave Chinner wrote:
>> On Sat, Apr 13, 2013 at 04:50:06PM -0400, Michael L. Semon wrote:
>>> I'm trying to get the new xfstests to run the XFS tests first, then
>>
>> The question is why do you want to do this? Is there any specific
>> reason for running the tests in that order?
>>
>> FWIW, if all you want to do is run the xfs tests, run:
>>
>> $ sudo ./check xfs[0-9][0-9][0-9]
>>
>> Cheers,
>>
>> Dave.
>>
>
> Personal preference.  I'd like to run both series of tests, sometimes
> attended, sometimes unattended.  It's fine if a generic/ test crashes
> the PC while running unattended, but I'd much rather the xfs/ tests have
> first crack at that.
>
> My version of the syntax was `./check xfs/[0-9][0-9][0-9]`, but that
> becomes rough when skipping tests.  I'll still try your version, but

I think this is a reasonable change request and I can see how this would 
be very rough if you wanted to skip tests. Anyone have a reason why not 
to do this?

Regards,
--Rich

> irrationality and frustration have driven me to simply adding a "mls"
> group to all of the tests/<fsgroup>/group files, then hoping that a
> `./check -g mls` would run everything in the correct order.  That led to
> trying to figure out why the generic/ tests were running first, and so
> on and so forth...
>
> Thanks!
>
> Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
