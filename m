Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 03 Oct 2008 17:21:27 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m940LOTv015794
	for <xfs@oss.sgi.com>; Fri, 3 Oct 2008 17:21:24 -0700
Message-ID: <48E6B731.8020806@sgi.com>
Date: Sat, 04 Oct 2008 10:22:09 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: what is the FS size limit for xfs_repair ?
References: <20081003170452.50a7ec78@harpe.intellique.com>	<25446eb90810030823g70506145o9aef9ed3832abfe@mail.gmail.com> <20081003223920.107aeb43@galadriel.home>
In-Reply-To: <20081003223920.107aeb43@galadriel.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: James Braid <jamesb@loreland.org>, xfs@oss.sgi.com



Emmanuel Florac wrote:
> Le Fri, 3 Oct 2008 16:23:41 +0100 vous écriviez:
> 
>> The limit is how much memory a 32-bit process can allocate - it's not
>> a limit of xfs_repair itself.
> 
> OK, that makes sense. I'll keep my 64 bits xfs_repair at hand :)
> 

As a rule of thumb with a fairly recent xfs_repair, you need approx
128MB RAM per TB filesystem size (but it also depends on number of
inodes too).

Cheers
-- Mark
