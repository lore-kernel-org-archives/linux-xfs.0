Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7779D7F58
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 19:34:58 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4B5D28F8092
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 17:34:55 -0800 (PST)
Received: from mail-yh0-f52.google.com (mail-yh0-f52.google.com
	[209.85.213.52]) by cuda.sgi.com with ESMTP id aLjisERRhP5Oi2yG
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 02 Dec 2013 17:34:54 -0800 (PST)
Received: by mail-yh0-f52.google.com with SMTP id i72so9574917yha.39
	for <xfs@oss.sgi.com>; Mon, 02 Dec 2013 17:34:53 -0800 (PST)
Message-ID: <529D352F.8020306@gmail.com>
Date: Mon, 02 Dec 2013 20:34:39 -0500
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 06/15] mkfs: validate logarithmic parameters sanely
References: <1385689430-10103-1-git-send-email-david@fromorbit.com>	<1385689430-10103-7-git-send-email-david@fromorbit.com>
	<20131202170601.GB14935@infradead.org>
In-Reply-To: <20131202170601.GB14935@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 12/02/2013 12:06 PM, Christoph Hellwig wrote:
> On Fri, Nov 29, 2013 at 12:43:41PM +1100, Dave Chinner wrote:
>> From: Dave Chinner <dchinner@redhat.com>
>>
>> Testing logarithmic paramters like "-n log=<num>" shows that we do a
>> terrible job of validating such input. e.g.:
>>
>> # mkfs.xfs -f -n log=456858480 /dev/vda
>> .....
>> naming   =version 2              bsize=65536  ascii-ci=0 ftype=0
>> ....
>>
>> Yeah, I just asked for a block size of 2^456858480, and it didn't
>> get rejected. Great, isn't it?
>>
>> So, factor out the parsing of logarithmic parameters, and pass in
>> the maximum valid value that they can take. These maximum values
>> might not be completely accurate (e.g. block/sector sizes will
>> affect the eventual valid maximum) but we can get rid of all the
>> overflows and stupidities before we get to fine-grained validity
>> checking later in mkfs once things like block and sector sizes have
>> been finalised.
> 
> Btw, is there any good reason not to deprecate the logarithmic
> parameters?  I can't see why anyone would want to use them, but I see
> lots of potential for confusion (happened to myself in the past).
> 
> The patch itself looks good:

I use log= almost exclusively.  The habit comes from using ntpd for 
many years.  An ntp.conf line like this...

server ntp.example.org minpoll 4 maxpoll 10

...means "poll server 'ntp.example.org' no fewer than once every 16s,
no greater than once every 1024s."  For XFS, I remember the numbers 
9, 10, and 11, dropping the 12 because it's the default.  At least 
for block sizes, v5 XFS has me dropping the 9 as well.  There are 
many places in computers to remember 1024 and 2048, and they're just 
more readily in mind as 10 and 11.  Personal preference.

Feel free to deprecate it, though.  The change back to non-logarithmic 
notation isn't going to be a problem.  I was just putting in my two 
cents on the matter.

Thanks!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
