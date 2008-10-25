Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 25 Oct 2008 13:19:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9PKJ9B6028814
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:19:09 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A307F12A9745
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:19:09 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id LefSKGr3AmtW2wEM for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:19:09 -0700 (PDT)
Message-ID: <49037F3C.6030007@sandeen.net>
Date: Sat, 25 Oct 2008 15:19:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix nr of args in open calls
References: <49036961.8070100@sandeen.net> <20081025201715.GA28002@infradead.org>
In-Reply-To: <20081025201715.GA28002@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Sat, Oct 25, 2008 at 01:45:53PM -0500, Eric Sandeen wrote:
>> --- xfstests.orig/ltp/iogen.c
>> +++ xfstests/ltp/iogen.c
>> @@ -1060,7 +1060,11 @@ int 	nbytes;
>>  
>>      Oflags |= O_CREAT | O_WRONLY;
>>  
>> +#ifdef CRAY
>>      if ((fd = open(path, Oflags, 0666, Ocbits, Ocblks)) == -1) {
>> +#else
>> +    if ((fd = open(path, Oflags, 0666)) == -1) {
>> +#endif
> 
> Do we really need that ifdef cray here?

Not sure; Ocbits etc are set under the same #ifdef, xfsqa runs on irix,
and I'm not sure what all gets set on that build ...

-Eric
