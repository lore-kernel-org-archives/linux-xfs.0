Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6DF917F50
	for <xfs@oss.sgi.com>; Sun, 14 Apr 2013 22:29:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5BFEB8F8033
	for <xfs@oss.sgi.com>; Sun, 14 Apr 2013 20:29:22 -0700 (PDT)
Received: from mail-ye0-f173.google.com (mail-ye0-f173.google.com
	[209.85.213.173]) by cuda.sgi.com with ESMTP id
	TeDITa4Gj5OcS5WN (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 14 Apr 2013 20:29:21 -0700 (PDT)
Received: by mail-ye0-f173.google.com with SMTP id q5so675174yen.18
	for <xfs@oss.sgi.com>; Sun, 14 Apr 2013 20:29:21 -0700 (PDT)
Message-ID: <516B740A.1050607@gmail.com>
Date: Sun, 14 Apr 2013 23:29:14 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: xfstests: kludge patch for per-dir test number sorting by ./check
References: <5169C4FE.4030209@gmail.com> <20130414232600.GA5117@destitution>
In-Reply-To: <20130414232600.GA5117@destitution>
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
Cc: xfstests <xfs@oss.sgi.com>

On 04/14/2013 07:26 PM, Dave Chinner wrote:
> On Sat, Apr 13, 2013 at 04:50:06PM -0400, Michael L. Semon wrote:
>> I'm trying to get the new xfstests to run the XFS tests first, then
>
> The question is why do you want to do this? Is there any specific
> reason for running the tests in that order?
>
> FWIW, if all you want to do is run the xfs tests, run:
>
> $ sudo ./check xfs[0-9][0-9][0-9]
>
> Cheers,
>
> Dave.
>

Personal preference.  I'd like to run both series of tests, sometimes 
attended, sometimes unattended.  It's fine if a generic/ test crashes 
the PC while running unattended, but I'd much rather the xfs/ tests have 
first crack at that.

My version of the syntax was `./check xfs/[0-9][0-9][0-9]`, but that 
becomes rough when skipping tests.  I'll still try your version, but 
irrationality and frustration have driven me to simply adding a "mls" 
group to all of the tests/<fsgroup>/group files, then hoping that a 
`./check -g mls` would run everything in the correct order.  That led to 
trying to figure out why the generic/ tests were running first, and so 
on and so forth...

Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
