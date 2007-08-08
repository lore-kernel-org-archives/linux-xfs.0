Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Aug 2007 21:54:35 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l784sPbm030830
	for <xfs@oss.sgi.com>; Tue, 7 Aug 2007 21:54:28 -0700
Subject: Re: qa 166 failure on f8 kernel
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <46B91EBA.10407@sandeen.net> <20070808025615.GH52011508@sgi.com> <46B9316A.40508@sandeen.net> <20070808040804.GJ52011508@sgi.com> <46B94259.6060309@sandeen.net> <20070808041920.GK52011508@sgi.com> <46B94680.3070405@sandeen.net>
Content-Transfer-Encoding: 7bit
Date: Wed, 08 Aug 2007 14:57:55 +1000
Message-ID: <op.twp5etpa3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <46B94680.3070405@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, David Chinner <dgc@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, 08 Aug 2007 14:28:48 +1000, Eric Sandeen <sandeen@sandeen.net>  
wrote:

> David Chinner wrote:
>
>> That could be done, but will break on 64k page size machines ;)
>>
>> Perhaps the filter needs to use `getconf PAGE_SIZE` to filter the
>> output down:
>>
>> ia64:
>>
>> % getconf PAGE_SIZE
>> 16384
>>
>> x86_64:
>>
>> % getconf PAGE_SIZE
>> 4096
>>
>> So the written extent sizes are output as a multiple of
>> page size rather than basic blocks....
>
>
> yeah, computing all the numbers for the filter seemed nasty.
>
> Maybe just a dumbed-down filter that expects
>
> written
> unwritten
> written
> unwritten
> written
>
> would be sufficient for this test.
>
> --- 166.orig    2007-08-07 23:19:33.391317217 -0500
> +++ 166 2007-08-07 23:21:11.111409407 -0500
> @@ -31,9 +31,9 @@
>  {
>         $AWK_PROG '/[0-9]/ {
>                 if ($7)
> -                       print $1, $2, "XX..YY", "AG", "(AA..BB)", $6, $7;
> +                       print $7
>                 else
> -                       print $1, $2, "XX..YY", "AG", "(AA..BB)", $6;
> +                       print "no flags"
>         }'
>  }
>
> --- 166.out.orig        2007-08-07 23:21:25.299244961 -0500
> +++ 166.out     2007-08-07 23:21:45.706131763 -0500
> @@ -1,6 +1,6 @@
>  QA output created by 166
> -0: [0..31]: XX..YY AG (AA..BB) 32
> -1: [32..127]: XX..YY AG (AA..BB) 96 10000
> -2: [128..159]: XX..YY AG (AA..BB) 32
> -3: [160..223]: XX..YY AG (AA..BB) 64 10000
> -4: [224..255]: XX..YY AG (AA..BB) 32
> +no flags
> +10000
> +no flags
> +10000
> +no flags
>
>
> -Eric
>

Instead of "no flags", how about "00000" so the test doesn't break
with xfsprogs 2.9.x and later.
>
