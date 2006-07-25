Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Jul 2006 10:01:54 -0700 (PDT)
Received: from imr2.americas.sgi.com (imr2.americas.sgi.com [198.149.16.18])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6PH1RDW015616
	for <xfs@oss.sgi.com>; Tue, 25 Jul 2006 10:01:39 -0700
Message-ID: <44C64E42.3090502@sgi.com>
Date: Tue, 25 Jul 2006 12:00:50 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: chattr +d dir
References: <Pine.LNX.4.64.0607231515530.30844@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0607231515530.30844@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

On 07/23/06 14:16, Justin Piszcz wrote:
> I used the chattr +d option for no_dump for a certain directory, but it 
> still appears xfsdump dumped the directory anyway?
> 
> Is there some special usage/way to make xfsdump NOT dump a certain 
> directory?

Perhaps you have an older xfsdump. This was recently added to the
xfsdump man page:

        ticular  size.   Additionally,  when xfsdump is run with the -e option,
        files that are tagged with the "no dump" file  attribute  will  not  be
        included  in  the  dump.  The chattr(1) command can be used to set this
        attribute on individual files or entire subtrees.

        To tag an individual file for exclusion from the dump:

             $ chattr +d file

        To tag all files in a subtree for exclusion from the dump:

             $ chattr -R +d directory

        Note that any new files or directories created in a directory which has
        the  "no dump" attribute set will automatically inherit this attribute.
        Also note that xfsdump does not check directories  for  the  "no  dump"
        attribute.

Bill
