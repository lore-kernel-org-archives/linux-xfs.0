Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39386 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725909AbeLEDwt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Dec 2018 22:52:49 -0500
Subject: Re: [PATCH 1/2] io: open pipes in non-blocking mode
References: <20181202205343.7104-1-david@fromorbit.com>
 <20181202205343.7104-2-david@fromorbit.com> <20181203162030.GT8125@magnolia>
 <20181203201633.GF6311@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ae5b9e6a-3dd8-a58d-4225-7a21dccb3969@sandeen.net>
Date: Tue, 4 Dec 2018 21:52:48 -0600
MIME-Version: 1.0
In-Reply-To: <20181203201633.GF6311@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 12/3/18 2:16 PM, Dave Chinner wrote:
> On Mon, Dec 03, 2018 at 08:20:30AM -0800, Darrick J. Wong wrote:
>> On Mon, Dec 03, 2018 at 07:53:42AM +1100, Dave Chinner wrote:
>>> From: Dave Chinner <dchinner@redhat.com>
>>>
>>> So that O_RDONLY open commands (such as from copy_range) do not
>>> block forever waiting on a non-existent writer.
>>>
>>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>>> ---
>>>  io/open.c | 13 +++++++++++++
>>>  1 file changed, 13 insertions(+)
>>>
>>> diff --git a/io/open.c b/io/open.c
>>> index 6ea3e9a2019f..b1d9a0fa317c 100644
>>> --- a/io/open.c
>>> +++ b/io/open.c
>>> @@ -56,6 +56,7 @@ openfile(
>>>  	struct fs_path	*fs_path)
>>>  {
>>>  	struct fs_path	*fsp;
>>> +	struct stat	st;
>>>  	int		fd;
>>>  	int		oflags;
>>>  
>>> @@ -79,6 +80,18 @@ openfile(
>>>  	if (flags & IO_NOFOLLOW)
>>>  		oflags |= O_NOFOLLOW;
>>>  
>>> +	/*
>>> +	 * if we've been passed a pipe to open, don't block waiting for a
>>> +	 * reader or writer to appear. We want to either succeed or error out
>>> +	 * immediately.
>>> +	 */
>>> +	if (stat(path, &st) < 0 && errno != ENOENT) {
>>> +		perror("stat");
>>> +		return -1;
>>> +	}
>>> +	if (S_ISFIFO(st.st_mode))
>>
>> Hmm... does stat() set st.st_mode even if it returns ENOENT?  Or are we
>> possibly branching on an uninitialized st here?
>>
>> struct stat	st = { 0 }; ?
> 
> Yeah, I'll fix that.

I'll just do that on commit.

-Eric
