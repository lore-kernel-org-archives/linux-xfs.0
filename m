Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33838 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726952AbfBTEl7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Feb 2019 23:41:59 -0500
Subject: Re: [PATCH 2/3] xfs_io: fix TOCTOU in openfile()
References: <c4b7eff6-8395-3d01-eaaf-736e32e6e1dc@redhat.com>
 <acf1deea-a637-571b-e501-c7cbcde95c38@redhat.com>
 <20190220015034.GI14116@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6af42461-f96e-9902-1edb-a71f023843a7@sandeen.net>
Date: Tue, 19 Feb 2019 22:41:57 -0600
MIME-Version: 1.0
In-Reply-To: <20190220015034.GI14116@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>



On 2/19/19 7:50 PM, Dave Chinner wrote:
> On Tue, Feb 19, 2019 at 05:23:38PM -0600, Eric Sandeen wrote:
>> openfile() stats a path to determine whether it is a pipe, and then
>> opens it with flags based on the type it saw during the stat.  It's
>> possible that the file at that path changes in between, and Coverity
>> points this out.
>>
>> Instead, always open O_NONBLOCK, stat the fd we got, and turn the
>> flag back off via fcntl() if it's not a pipe.
>>
>> Addresses-Coverity-ID: 1442788 ("Time of check time of use")
> 
> For O_NONBLOCK I think there is zero harm in the code as it stands,
> but I don't really care about it tht much.
> 
> I do wonder what happens if need to conditionally use O_NONBLOCK on
> open(), though....
> 
>> @@ -112,6 +106,22 @@ openfile(
>>  		}
>>  	}
>>  
>> +	if (fstat(fd, &st) < 0) {
>> +		perror("stat");
>> +		close(fd);
>> +		return -1;
>> +	}
>> +
>> +	/* We only want to keep nonblocking behavior for pipes */
>> +	if (!S_ISFIFO(st.st_mode)) {
>> +		oflags &= ~O_NONBLOCK;
>> +		if (fcntl(fd, F_SETFL, oflags) < 0) {
> 
> Don't you need to do oflags = fcntl(fd, F_GETFL, NULL) first?

maybe? We just opened it with oflags, but *shrug* I guess it doesn't
hurt?

> 
>> +			perror("fcntl");
>> +			close(fd);
>> +			return -1;
>> +		}
> 
> can you add a "goto out_close;" error jump to this function now that
> this is the fourth and fifth places that have this same close/return
> on error...

yeah, good point.

> CHeers,
> 
> Dave.
> 
