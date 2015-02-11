Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 176097F54
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 10:17:12 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E018D304066
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 08:17:11 -0800 (PST)
Received: from mail-pa0-f50.google.com (mail-pa0-f50.google.com
	[209.85.220.50]) by cuda.sgi.com with ESMTP id 87wn8MssqSe5YLQV
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Feb 2015 08:17:10 -0800 (PST)
Received: by mail-pa0-f50.google.com with SMTP id hz1so4896263pad.9
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 08:17:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150210221421.GP4251@dastard>
References: <54ca34c6.4696420a.0f32.4513@mx.google.com>
	<20150210221421.GP4251@dastard>
Date: Wed, 11 Feb 2015 21:47:09 +0530
Message-ID: <CALJmpHN8EcMJJdf7Ye_8bbqwBBO9q-H1LmsUcxsCp=VRT3yPnA@mail.gmail.com>
Subject: Re: [PATCH 2/4] xfsprogs: Addition in debug option -d of xfs_spaceman
From: Dhruvesh Rathore <adrscube@gmail.com>
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
To: xfs@oss.sgi.com

On Wed, Feb 11, 2015 at 3:44 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Jan 29, 2015 at 06:55:21PM +0530, Dhruvesh Rathore wrote:
>>
>> The xfs_spaceman utility did not have a a proper title to the content
>> displayed using -d (debug) option.
> .....
>>
>> @@ -332,20 +332,23 @@
>>  static int
>>  freesp_f(
>>       int             argc,
>>       char            **argv)
>>  {
>>       xfs_agnumber_t  agno;
>>
>>       if (!init(argc, argv))
>>               return 0;
>>
>> +     if (dumpflag)
>> +             printf("%8s %8s %8s\n", "agno", "agbno", "len");
>> +
>>       for (agno = 0; agno < file->geom.agcount; agno++)  {
>>               if (inaglist(agno))
>>                       scan_ag(agno);
>>       }
>>       if (histcount)
>>               printhist();
>
> Patch does not apply to the current tree. It's got stray whitespace
> and lines in it that are in the original source file.
>
> I've fixed this up for the moment, but please make sure your
> patches apply to a clean tree.
>

We apologize for the constant stray white space errors and will
make sure to make clean patches from now on.
Thank you for reworking and applying the patch to the current tree :)

Regards,
A-DRS

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
