Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37978 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932068AbeALAEl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jan 2018 19:04:41 -0500
Subject: Re: [PATCH 06/27] xfs_scrub: create an abstraction for a block device
References: <151520348769.2027.9860697266310422360.stgit@magnolia>
 <151520352472.2027.8375038586822233334.stgit@magnolia>
 <a4228240-76f6-5f43-cecf-5bd7d572bfcb@sandeen.net>
 <20180111235924.GK5602@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <17af7817-cd57-6aeb-b33e-3df76b5c3f4a@sandeen.net>
Date: Thu, 11 Jan 2018 18:04:38 -0600
MIME-Version: 1.0
In-Reply-To: <20180111235924.GK5602@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On 1/11/18 5:59 PM, Darrick J. Wong wrote:
> On Thu, Jan 11, 2018 at 05:24:58PM -0600, Eric Sandeen wrote:
...

>>> +	/* Non-rotational device?  Throw all the CPUs. */
>>> +	rot = 1;
>>> +	error = ioctl(disk->d_fd, BLKROTATIONAL, &rot);
>>> +	if (error == 0 && rot == 0)
>>> +		return nproc;
>>
>> I needed
>>
>> +#ifndef BLKROTATIONAL
>> +#define BLKROTATIONAL _IO(0x12,126)
>> +#endif
>>
>> to make this compile on my not /that/ ancient (?) rhel6 box ;)
> 
> Hmm... well, since I don't see backporting xfs kernel scrub to 2.6.32
> maybe xfsprogs' build system should just turn off xfs_scrub on old
> systems?
> 
> In any case, I #ifdef BLKROTATIONAL'd out the entire clause.

ok.  well, other distros are making noise about using bleeding edge progs
w/ older distro kernels (hence the mkfs config file wishes) so it's probably
good to consider building against older environments.

Thanks,
-Eric
