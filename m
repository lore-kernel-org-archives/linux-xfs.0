Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8CNEB18055650 for <xfs@oss.sgi.com>; Wed, 12 Sep 2012 18:14:11 -0500
Received: from youngberry.canonical.com (youngberry.canonical.com
	[91.189.89.112]) by cuda.sgi.com with ESMTP id igH7HAERYlrtZqeY
	for <xfs@oss.sgi.com>; Wed, 12 Sep 2012 16:15:16 -0700 (PDT)
Message-ID: <5051177E.6000903@canonical.com>
Date: Wed, 12 Sep 2012 16:15:10 -0700
From: Brad Figg <brad.figg@canonical.com>
MIME-Version: 1.0
Subject: Re: Ubuntu Ext4 regression testing
References: <50511241.2090603@canonical.com> <5051142D.1050603@redhat.com>
In-Reply-To: <5051142D.1050603@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-ext4@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>

On 09/12/2012 04:01 PM, Eric Sandeen wrote:
> Hi Brad -
> 
> (cc: xfs list too)
> 
> On 9/12/12 5:52 PM, Brad Figg wrote:
>>
>> The Ubuntu kernel team has been putting some automated testing
>> infrastructure in place. We are very interested in engaging with
>> the appropriate upstream developers. We have been running the
>> xfstests that come as part of the autotest testing framework.
>> Some of these tests fail or never complete when run against an
>> Ext4 file-system. 
> 
> Which ones?  Feel free to file bugs or send mail.  Tests should pass.
> Sometimes it's a test bug, though, of course ;)
> 
>> Our initial questions are:
>>
>> 1. Is this an appropriate set of tests to be run as regression
>>    tests?
> 
> Yes, that's what it's for!
> 
>> 2. Is there a list of the xfstests that are appropriate for
>>    Ext4?
> 
> Any test which says
> 
> _supported_fs generic
> or
> _supported_fs ext4
> 
> can run on ext4, and should in theory pass.  I think there are
> about 100 of them by now.
> 
> There is a "dangerous" group (see groups file) which contains test nrs that
> might stop testing via a hang or panic.  But don't skip those by
> default; newer kernels with those bugs fixed _should_ pass them too.
> 
>> 3. Are there additional regression tests that would be beneficial
>>    to the Linux community for us to be running?
> 
> We've been encouraging new tests to be written for xfstests lately,
> and it's gotten a good amount of traction.  There certainly may be
> other things out there, though.
> 
> -Eric
> 
> 
>> Test results can be found at:
>>     http://kernel.ubuntu.com/testing/index.html
>>
>>
>> Thanks
>> Brad
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

I'm going to be doing some new runs so anything I find will be reported.

Thanks,
Brad
-- 
Brad Figg brad.figg@canonical.com http://www.canonical.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
