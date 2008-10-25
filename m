Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 25 Oct 2008 13:27:27 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9PKRKmt030762
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:27:20 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BB3ED12A97C6
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:27:20 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id sJjoKxFTt42GXciE for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 13:27:20 -0700 (PDT)
Message-ID: <49038127.8010608@sandeen.net>
Date: Sat, 25 Oct 2008 15:27:19 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] clean up printk formats with DMAPI_DEBUG
References: <49031BB1.7080609@sandeen.net> <20081025202005.GC28002@infradead.org>
In-Reply-To: <20081025202005.GC28002@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Sat, Oct 25, 2008 at 08:14:25AM -0500, Eric Sandeen wrote:
>>  #ifdef CONFIG_DMAPI_DEBUG
>> -	printk("xfs_dm_round_hole: off %lu, len %ld, align %lu, "
>> -	       "filesize %llu, roff %ld, rlen %ld\n",
>> +	printk("xfs_dm_round_hole: off %lld, len %llu, align %llu, "
>> +	       "filesize %lld, roff %lld, rlen %llu\n",
>>  	       offset, length, align, filesize, *roff, *rlen);
> 
> We'd still need casts to (unsigned) long long because the 64 bit
> types may be either variant on 64 bit platforms.
> 

Ah crud you're right, I forgot that s64 was sometimes just a "long"

Bah; is there no format that does this cleanly? :)

-Eric
