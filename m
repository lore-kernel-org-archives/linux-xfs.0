Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Aug 2006 17:00:38 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7700BDW001133
	for <xfs@oss.sgi.com>; Sun, 6 Aug 2006 17:00:22 -0700
Message-ID: <44D68290.6020703@sgi.com>
Date: Mon, 07 Aug 2006 10:00:16 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: review: Simple patch to remove the dmapi support from xfsdump
References: <44D10F9B.8090904@thebarn.com> <44D2CA85.3040208@sgi.com> <20060804141012.GA26@kickball-mn.Central.Sun.COM>
In-Reply-To: <20060804141012.GA26@kickball-mn.Central.Sun.COM>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dean Roehrich <dean.roehrich@sun.com>
Cc: Russell Cattelan <cattelan@thebarn.com>, xfs@oss.sgi.com

Dean Roehrich wrote:
> On Fri, Aug 04, 2006 at 02:18:13PM +1000, Vlad Apostolov wrote:
>   
>> Hi Russel,
>>
>> I don't understand in details the build changes but they seam to be fine.
>>     
>
> Vlad, why do they seem fine?
>   
Well, I patiently waited with the hope that someone  more knowledgeable 
on the topic would
do the review.  No one responded in time and I thought that either no 
one cares  about the
change or no one fully understands it. As I am supposed to support 
DMAPI, I had to take
the review and after consulting locally with xfs developers I did the 
review. Now I see
that there are people interested and knowing better than me what needs 
to be done.
>> In summary if the build system can find the DMAPI lib installed it will
>> use hsmapi_noop.c otherwise hsmapi.c.
>> The return code of HsmInitFileContext() stub probably should be non zero.
>>
>> It is looking good.
>>     
>
> So this is determined at build time...so when you're using a version of
> xfsdump/xfsrestore how do you know you're _not_ using one that is DMAPI-aware
> _before_ you get into trouble with an invalid dump?
>
> Assuming that issue is addressed, here's another:  The libdm is a shared
> object, so why not take advantage of that and load it with dlopen?  Then the
> issue is determined at runtime rather than build time.  This is easy, and even
> DMF does it this way.
>
> Dean
>   
