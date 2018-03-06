Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36334 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754035AbeCFXZR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Mar 2018 18:25:17 -0500
Subject: Re: [PATCH 4/5] libxfs: Catch non-empty zones on destroy
References: <d81cf576-6082-008b-761e-82c487e6a87a@redhat.com>
 <c2dd15a8-a048-6373-2fad-3ffd28a606e0@sandeen.net>
 <20180306230625.GN18989@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <99164755-34c7-7c5a-7d4d-97e0210b2078@sandeen.net>
Date: Tue, 6 Mar 2018 17:25:15 -0600
MIME-Version: 1.0
In-Reply-To: <20180306230625.GN18989@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>



On 3/6/18 5:06 PM, Darrick J. Wong wrote:
>> @@ -887,11 +893,15 @@ libxfs_umount(xfs_mount_t *mp)
>>  void
>>  libxfs_destroy(void)
>>  {
>> +	int	leaked;
>> +
>>  	/* Free everything from the buffer cache before freeing buffer zone */
>>  	libxfs_bcache_purge();
>>  	libxfs_bcache_free();
>>  	cache_destroy(libxfs_bcache);
>> -	manage_zones(1);
>> +	leaked = manage_zones(1);
>> +	if (getenv("LIBXFS_LEAK_CHECK") && leaked)
>> +		exit(1);
> What do you think of assert(getenv() == NULL || !leaked); here?
> LIBXFS_LEAK_CHECK is a debugging option, so we might as well dump core
> right where we violate the assumptions.
> 
> (OTOH I guess this probably happens at program exit anyway...)

I don't think a core dump will be that useful, we already print out
which zone leaked & how much - I don't think a core would tell us more...?

-Eric
