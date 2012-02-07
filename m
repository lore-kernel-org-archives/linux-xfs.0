Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q17EHCXa232415 for <xfs@oss.sgi.com>; Tue, 7 Feb 2012 08:17:12 -0600
Message-ID: <4F313265.10904@sgi.com>
Date: Tue, 07 Feb 2012 08:17:09 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/2] xfstests: introduce 280 for SEEK_DATA/SEEK_HOLE
	copy check
References: <4F2FE410.2040508@oracle.com> <4F305472.8070509@sgi.com>
	<4F30D563.8030807@oracle.com>
In-Reply-To: <4F30D563.8030807@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: jeff.liu@oracle.com
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On 02/07/12 01:40, Jeff Liu wrote:
> Hi Mark,
>
> On 02/07/2012 06:30 AM, Mark Tinguely wrote:
>
>> On 02/06/12 08:30, Jeff Liu wrote:
>>> Introduce 280 for SEEK_DATA/SEEK_HOLE copy check.
>>>
>>> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>>>
>>> ---
>>
>>>
>>> diff --git a/src/seek_copy_tester.c b/src/seek_copy_tester.c
>>> new file mode 100644
>>> index 0000000..ddf683f
>>> --- /dev/null
>>> +++ b/src/seek_copy_tester.c
>>
>>> +static size_t
>>> +full_write(int fd, const void *buf, size_t count)
>>> +{
>>> +    size_t total = 0;
>>> +    const char *ptr = (const char *) buf;
>>> +
>>> +    while (count>   0) {
>>> +        ssize_t n = write(fd, ptr, count);
>>> +        if (n<   0) {
>>> +            if (errno == EINTR)
>>> +                continue;
>>
>> Wouldn't you want to stop the write loop if interrupted?
>
> As this routine was called "full_write" which means it is expect to write as much as it can.
> So I would keep retrying if the process was interrupted by EINTR.
> Would you please give some opinions whether this approach is not suitable in this circumstance?

Maybe I was thinking wrong. I was thinking if someone had killed the 
test and the write was interrupted by the signal, then you would give up 
the write loop.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
