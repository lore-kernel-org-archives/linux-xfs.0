Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 279EE7F50
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 02:24:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 08A138F804B
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 00:24:02 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id xRprZVWkTmgDUw3T (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 28 Oct 2013 00:23:57 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r9S7NusB023049
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 07:23:57 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r9S7NtWF012982
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 07:23:55 GMT
Received: from abhmt108.oracle.com (abhmt108.oracle.com [141.146.116.60])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r9S7NtRZ024275 for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 07:23:55 GMT
Message-ID: <526E1108.8070904@oracle.com>
Date: Mon, 28 Oct 2013 11:23:52 +0400
From: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: src/feature.c: print a number of online CPUs
References: <20131023213152.GP2797@dastard>
	<1382604998-11037-1-git-send-email-stanislav.kholmanskikh@oracle.com>
	<20131024104042.GT2797@dastard>
	<20131024131800.GA27701@orion.maiolino.org>
	<20131024212307.GV2797@dastard>
In-Reply-To: <20131024212307.GV2797@dastard>
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
To: xfs@oss.sgi.com


On 10/25/2013 01:23 AM, Dave Chinner wrote:
> [ insert comment about not top-posting on mainling lists ]
>
> On Thu, Oct 24, 2013 at 11:18:01AM -0200, Carlos Maiolino wrote:
>>> Actually, I'd say we shoul default to 1 cpu if we can't get the
>>> number of CPUs. Clearly we have at least one if we can run this
>>> code. :)
>> I'm not sure about setting the default to 1 cpu might me a good behavior. My
>> apologies if I'm saying something wrong, but, if the 'tester' are trying to do
>> some test trusting on the amount of cpus, it might not be a good behavior.
>> I was thinking, how about issue an error message if xfstests can't properly
>> detect the amount of cpus from the system, and add any kind of usage option to
>> specify the numbers of cpus? So in case of a error while detecting the amount of
>> cpus.
> I'd much prefer the test runs with a single CPU as a default rather
> than not run at all. Most systems the tests run on support these
> sysconf parameters, so it's going to do what we expect, but quite
> frankly most tests shoul dnot need to know the number of CPUs.
>
> This one is probably misguided, anyway, in what it's doing - if we
> want to scale the load the test generates, then that's what
> $LOAD_FACTOR is for. Also, it' multiplies the number of CPUs by 50,
> then caps the result at 200, so in reality it's only scaling for up
> to 4 CPUs which doesn't really take into account the range of
> machines that we test on.

Hi!

Carlos, Dave, so what is the final resolution regarding my patch?

Thank you.

> Cheers,
>
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
