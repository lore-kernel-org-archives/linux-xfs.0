Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Dec 2006 16:41:16 -0800 (PST)
Received: from omx1.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBC0f4qw022399
	for <linux-xfs@oss.sgi.com>; Mon, 11 Dec 2006 16:41:05 -0800
Received: from internal-mail-relay1.corp.sgi.com (internal-mail-relay1.corp.sgi.com [198.149.32.52])
	by omx1.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with ESMTP id kBC0eEDW026110
	for <linux-xfs@oss.sgi.com>; Mon, 11 Dec 2006 18:40:14 -0600
Message-ID: <457DFA6A.9050200@sgi.com>
Date: Tue, 12 Dec 2006 00:40:10 +0000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: invalid directory entry - bad magic number on inode
References: <200612082100.00395.Martin@lichtvoll.de> <457D65A1.8030609@sgi.com> <200612112111.08209.Martin@lichtvoll.de>
In-Reply-To: <200612112111.08209.Martin@lichtvoll.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-xfs@oss.sgi.com, xfs-dev@sgi.com

Martin Steigerwald wrote:
> Am Montag 11 Dezember 2006 15:05 schrieb Lachlan McIlroy:
> 
> 
>>>Any hints on what I could try if it ever happens again? Suppose I can
>>>save out the bad inode contents before I let xfs_repair fix it...
>>
>>If you see it again could you run xfs_check in verbose mode (ie
>>xfs_check -v /dev/hda5 and xfs_check -v -i <inode number> /dev/hda5)?
> 
> 
> Hello Lachlan,
> 
> thanks for the hints. So far it didn't occur again (at least not that I am 
> aware of) - well I don't expect it to happen often and am not really sure 
> whether it will happen again at all.
> 
> 
>>Thanks for reporting this problem.
> 
> 
> You are welcome. Without further info reporting it to the bugtracker 
> doesn't make much sense to me. I will keep an eye on it. If it happens 
> again, I  will try the hints you gave me. I run xfs_check anyway and thus 
> can easily give it a "-v >xfs_check.txt". I thought I would have to use 
> xfs_db stuff to get further info.

Now that you mention it, printing out the inode in xfs_db might be useful.

> 
> Regards,
