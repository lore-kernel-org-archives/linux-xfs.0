Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Jul 2006 10:02:33 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [66.45.37.187])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6PH2BDW015785
	for <xfs@oss.sgi.com>; Tue, 25 Jul 2006 10:02:11 -0700
Date: Tue, 25 Jul 2006 13:01:45 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: chattr +d dir
In-Reply-To: <44C64E42.3090502@sgi.com>
Message-ID: <Pine.LNX.4.64.0607251301430.31045@p34.internal.lan>
References: <Pine.LNX.4.64.0607231515530.30844@p34.internal.lan>
 <44C64E42.3090502@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

Thanks for the update.

On Tue, 25 Jul 2006, Bill Kendall wrote:

> On 07/23/06 14:16, Justin Piszcz wrote:
>> I used the chattr +d option for no_dump for a certain directory, but it 
>> still appears xfsdump dumped the directory anyway?
>> 
>> Is there some special usage/way to make xfsdump NOT dump a certain 
>> directory?
>
> Perhaps you have an older xfsdump. This was recently added to the
> xfsdump man page:
>
>       ticular  size.   Additionally,  when xfsdump is run with the -e 
> option,
>       files that are tagged with the "no dump" file  attribute  will  not 
> be
>       included  in  the  dump.  The chattr(1) command can be used to set 
> this
>       attribute on individual files or entire subtrees.
>
>       To tag an individual file for exclusion from the dump:
>
>            $ chattr +d file
>
>       To tag all files in a subtree for exclusion from the dump:
>
>            $ chattr -R +d directory
>
>       Note that any new files or directories created in a directory which 
> has
>       the  "no dump" attribute set will automatically inherit this 
> attribute.
>       Also note that xfsdump does not check directories  for  the  "no 
> dump"
>       attribute.
>
> Bill
>
