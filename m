Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Aug 2006 08:30:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k77FUPDW024590
	for <xfs@oss.sgi.com>; Mon, 7 Aug 2006 08:30:27 -0700
Message-ID: <44D75C87.8050402@thebarn.com>
Date: Mon, 07 Aug 2006 10:30:15 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: review: Simple patch to remove the dmapi support from xfsdump
References: <44D10F9B.8090904@thebarn.com> <44D2CA85.3040208@sgi.com> <20060804141012.GA26@kickball-mn.Central.Sun.COM> <44D36985.1090006@thebarn.com> <20060804155850.GA3338@kickball-mn.Central.Sun.COM> <44D379A6.9040200@sgi.com> <44D38D34.1010503@thebarn.com> <44D3C351.7060109@sgi.com> <20060807150324.GA8421@kickball-mn.Central.Sun.COM>
In-Reply-To: <20060807150324.GA8421@kickball-mn.Central.Sun.COM>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dean Roehrich <dean.roehrich@sun.com>
Cc: Bill Kendall <wkendall@sgi.com>, Vlad Apostolov <vapo@sgi.com>, xfs@oss.sgi.com

Dean Roehrich wrote:
> On Fri, Aug 04, 2006 at 04:59:45PM -0500, Bill Kendall wrote:
>
>   
>> -#define DMF_EV_BITS	( (1<<DM_EVENT_DESTROY) | \
>> -			  (1<<DM_EVENT_READ)    | \
>> -			  (1<<DM_EVENT_WRITE)   | \
>> -			  (1<<DM_EVENT_TRUNCATE) )
>> +#define DMF_EV_BITS	( (1<<16) | (1<<17) | (1<<18) | (1<<20) )
>>     
>
> Don't do that.
>
> Granted, those bits can never be changed else all of your customers will start
> a lynch mob and come after you.
>
> At the very least, don't allow those bits to be anonymous--copy that whole
> enum from the dmapi header.  Even that I object to, but at least the bits will
> _be_ something.
>   
I'll second that.
It seems rather dangerous to have a #define floating around that could
potentially get out of sync with the original, especially if you 
transport the
number and not the enum table. (It make it really hard for cscope to 
find :-)

Other than that the rest of the patch seem reasonable, it satisfies the goal
of not  requiring libdmapi.

> Dean
>
>   
