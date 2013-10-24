Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D0C477F37
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 09:33:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 57F1DAC007
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 07:33:25 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id PeKKwHGFRBB5hK4u (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Oct 2013 07:33:21 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r9OEXJTp005877
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 14:33:20 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r9OEXI7x021143
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 14:33:18 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r9OEXI3E021138 for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 14:33:18 GMT
Message-ID: <52692FAC.8090904@oracle.com>
Date: Thu, 24 Oct 2013 18:33:16 +0400
From: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: src/feature.c: print a number of online CPUs
References: <20131023213152.GP2797@dastard>
	<1382604998-11037-1-git-send-email-stanislav.kholmanskikh@oracle.com>
	<20131024104042.GT2797@dastard>
	<20131024131800.GA27701@orion.maiolino.org>
In-Reply-To: <20131024131800.GA27701@orion.maiolino.org>
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


On 10/24/2013 05:18 PM, Carlos Maiolino wrote:
> Hi Dave,
>
> I'm not sure about setting the default to 1 cpu might me a good behavior. My
> apologies if I'm saying something wrong, but, if the 'tester' are trying to do
> some test trusting on the amount of cpus, it might not be a good behavior.
> I was thinking, how about issue an error message if xfstests can't properly
> detect the amount of cpus from the system, and add any kind of usage option to
> specify the numbers of cpus? So in case of a error while detecting the amount of
> cpus.
What about this:

If we can not determine the number of available cpus we just
print '-1' (as sysconf() returns in that case) and exit with non-zero 
status.
And verify the exit status in the test cases.

What do you mean by:
"and add any kind of usage option to specify the numbers of cpus"
?

Thanks.

>
>
>> Actually, I'd say we shoul default to 1 cpu if we can't get the
>> number of CPUs. Clearly we have at least one if we can run this
>> code. :)
>>
>> Cheers,
>>
>> Dave.
>> -- 
>> Dave Chinner
>> david@fromorbit.com
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
