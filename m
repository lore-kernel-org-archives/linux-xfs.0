Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ECA207CBF
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 12:03:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7BDEDAC005
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 10:03:33 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id mpblBxpJZsZ8MtJx for <xfs@oss.sgi.com>;
	Thu, 19 Sep 2013 10:03:32 -0700 (PDT)
Message-ID: <523B2E62.7030801@sandeen.net>
Date: Thu, 19 Sep 2013 12:03:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: unify apostrophes in output files
References: <1379536166-19232-1-git-send-email-jbacik@fusionio.com>
	<20130918211325.GB4330@dastard> <523B2455.4000609@redhat.com>
	<CAOi1vP_w25B7Lui3CYPXvbvSFdO1-xdjxJySHfi3x1164W1+Eg@mail.gmail.com>
In-Reply-To: <CAOi1vP_w25B7Lui3CYPXvbvSFdO1-xdjxJySHfi3x1164W1+Eg@mail.gmail.com>
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
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 9/19/13 11:54 AM, Ilya Dryomov wrote:

...

>> diff --git a/check b/check
>> index 4085eae..ba7fd21 100755
>> --- a/check
>> +++ b/check
>> @@ -478,6 +478,10 @@ do
>>                 echo " - no qualified output"
>>                 err=true
>>             else
>> +
>> +               # coreutils 2.16+ changed quote formats in error messages from
> 
> Should that be 8.16+?

probably so!

> Thanks,
> 
>                 Ilya
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
