Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Oct 2008 07:23:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9NEMp2O004649
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 07:22:53 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 90CD310DB0CF
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 07:24:37 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id Mz1Q2pEhiDhd4fKM for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 07:24:37 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id A0BD2AC359B
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 09:24:36 -0500 (CDT)
Message-ID: <49008923.7030208@sandeen.net>
Date: Thu, 23 Oct 2008 09:24:35 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfs_repair: print superblock offsets and why they
 can't	be verified
References: <20081022183636.GE20550@kyra> <20081022234128.GC4395@kyra> <490081C6.1030301@sandeen.net>
In-Reply-To: <490081C6.1030301@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Eric Sandeen wrote:
> KELEMEN Peter wrote:
>> Eric has pointed out that verify_set_primary_sb() will either
>> return 1 or XR_INSUFF_SEC_SB.  Move the check lower into
>> verify_set_primary_sb() by checking the return value of
>> verify_sb().  Example output:
>>
>> found candidate secondary superblock...
>> verifying sb at 31249334272: bad magic number (1)
>> verifying sb at 62498668544: bad magic number (1)
>> verifying sb at 93748002816: bad magic number (1)
>> verifying sb at 124997337088: bad magic number (1)
>> unable to verify superblock, continuing...
>>
> 
> This looks better :)  You may want to add even more info...
> 
> while it's just searching block by block, if it finds a candidate, I'd
> print the sector offset for that candidate (your first output line).
> 
> And rather than "verifying sb at..." you might do something like
> "comparing to sb N at offset X":
> 
> +	} else {
> +		do_warn("comparing with sb %d at sector %Lu failed: %s (%d)\n",
> +			agno, off, err_string(reason), reason);

Sorry, that was a pre-coffee email :)  The units are bytes, not sectors,
aren't they... in any case, printing the (proper) units for the values
would be helpful.

-Eric
