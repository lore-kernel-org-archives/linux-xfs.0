Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 15:22:53 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RMMISM012335
	for <linux-xfs@oss.sgi.com>; Mon, 27 Oct 2008 15:22:18 -0700
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by netops-testserver-3.corp.sgi.com (Postfix) with ESMTP id B50D2908A8
	for <linux-xfs@oss.sgi.com>; Mon, 27 Oct 2008 15:22:14 -0700 (PDT)
Message-ID: <49063F75.7000604@sgi.com>
Date: Mon, 27 Oct 2008 17:23:49 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: Bad day with xfsrestore, what went wrong?
References: <gde1k2$gkp$1@ger.gmane.org> <ge38k5$qf$1@ger.gmane.org>
In-Reply-To: <ge38k5$qf$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: mlueck@lueckdatasystems.com
Cc: linux-xfs@oss.sgi.com

Michael Lueck wrote:
> No suggestions / possible answers anyone for my question...
> 
> Michael Lueck wrote:
>> Greetings-
>>
>> I hope this is the NNTP equiv of the email list found on this web page:
>> http://oss.sgi.com/projects/xfs/
>>
>> I have been using XFS with Debian for a number of years with great 
>> success. Today, xfsrestore really threw me a curve ball. I am 
>> wondering what went wrong.
>>
>> I had wanted to restore from an old backup some directories that I 
>> discovered I had need of. I used the following syntax to get the 
>> restore started:
>>
>> xfsrestore -J -E -f /mnt/ext_backup/ldslnx01/20061220/data -s 
>> shares/data -i -v verbose /srv
>>
>> I selected some directories to restore through the interactive 
>> interface, then allowed it to restore the specified files.
>>
>> What it ended up doing, HOWEVER, was to restore every file present in 
>> that old backup that was no longer on disk!
>>
>> Thus, what went wrong?
>>
>> Thanks!
> 

Hi Michael,

I tried to reproduce this using the command line you supplied, but
everything worked as expected for me. Perhaps try it without the -i
(so that only subtrees given with -s are restored), just to rule out
the possibility that you inadvertently added all files to the restore
list.

Bill
