Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Oct 2006 06:50:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9NDolaG014712
	for <xfs@oss.sgi.com>; Mon, 23 Oct 2006 06:50:48 -0700
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DAC664C85E4
	for <xfs@oss.sgi.com>; Mon, 23 Oct 2006 06:50:02 -0700 (PDT)
Received: from [10.0.0.4] (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id E74D818CF9858
	for <xfs@oss.sgi.com>; Mon, 23 Oct 2006 08:50:00 -0500 (CDT)
Message-ID: <453CC888.2070806@sandeen.net>
Date: Mon, 23 Oct 2006 08:50:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: mount problem with xfs
References: <20061023072613.33372.qmail@web8512.mail.in.yahoo.com> <20061023094634.GA8449@jdc>
In-Reply-To: <20061023094634.GA8449@jdc>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Jason White wrote:
> On Mon, Oct 23, 2006 at 08:26:13AM +0100, satish kumar wrote:
>> I formatted a partition of size 5GB with xfs block size=16K
>> I am not able to mount
> 
> Block size must be <= page size under Linux (see the XFS FAQ).
> 
> The page size is 4k for x86, 8k for ia64; the FAQ explains further.

Looking at system messages would probably have yielded something like this:

"filesystem with block size 16384 bytes.  only pagesize (4096) or less will 
currently work."

looking at kernel messages after a failed mount is always a good idea.

-Eric
