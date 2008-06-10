Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Jun 2008 15:59:12 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5AMx9kF022396
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 15:59:10 -0700
Received: from smtp.sauce.co.nz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E4FFEC7154D
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 16:00:03 -0700 (PDT)
Received: from smtp.sauce.co.nz (smtp.sauce.co.nz [210.48.49.72]) by cuda.sgi.com with ESMTP id lorknRtkVkyDQh5h for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 16:00:03 -0700 (PDT)
Message-ID: <484F0998.90306@sauce.co.nz>
Date: Wed, 11 Jun 2008 11:09:12 +1200
From: Richard Scobie <richard@sauce.co.nz>
MIME-Version: 1.0
Subject: Re: Filestreams (and 64bit inodes)
References: <484B15A3.4030505@sauce.co.nz> <484CA425.3080606@sandeen.net> <484DDDB3.70000@sgi.com>
In-Reply-To: <484DDDB3.70000@sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs@oss.sgi.com

Timothy Shimmin wrote:

> BTW, Sam Vaughan wrote some tutorial notes on the allocator and in particular
> filestreams which I've pasted below:
> (I thought it might be here:
>  http://oss.sgi.com/projects/xfs/training/ but I can't see it
>  in the allocator lab and slides).

I did actually find an entry for filestreams in slide 6.

While there I also found the information on 64bit inodes.

My filesystem is 9.6TB and could well end up with a large quantity of 
1-15MB files stored and the statement:

  "Operating system interfaces and legacy software products often 
mandate the use of 32 bit inode numbers even on systems that support 64 
bit inode numbers."

makes me wonder how common this still is in practice - the slide was 
written in 2006)?

My initial preference would be to go with 64 bit inodes for performance 
reasons, but as one cannot revert the fs back to 32 bit inodes once 
committed, I am somewhat hesitant.

Or am I worrying unecessarily about the negative impact of 32 bit 
inodes, given 9.6TB full of 1 to 15MB files?

Regards,

Richard
