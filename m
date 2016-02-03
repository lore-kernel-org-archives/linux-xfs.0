Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2E8037CA1
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 09:02:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ADDFBAC001
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 07:02:46 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id zSBZLRMl9KfQmIFr for <xfs@oss.sgi.com>;
	Wed, 03 Feb 2016 07:02:41 -0800 (PST)
Subject: Re: Request for information on bloated writes using Swift
References: <CAFHL4X1JU02LFYntkqhYg1N++ZU46ML3v5higo1nRsPyoZxL5A@mail.gmail.com>
	<56B16A3C.1030207@sandeen.net>
	<CAFHL4X0QBtFpz3=HMVMrp6NoaW5BRkDSoTE1yJQvQ=0JrW5+YQ@mail.gmail.com>
	<20160203063705.GB459@dastard>
	<CAFHL4X0m8Ov+zJxteUJJxzEHVXpJsfe=9mtapRmWkhT6VRkDxg@mail.gmail.com>
	<20160203083016.GD459@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56B21690.2070304@sandeen.net>
Date: Wed, 3 Feb 2016 09:02:40 -0600
MIME-Version: 1.0
In-Reply-To: <20160203083016.GD459@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, Dilip Simha <nmdilipsimha@gmail.com>
Cc: xfs@oss.sgi.com



On 2/3/16 2:30 AM, Dave Chinner wrote:
> On Tue, Feb 02, 2016 at 11:09:15PM -0800, Dilip Simha wrote:
>> Hi Dave,
>>
>> On Tue, Feb 2, 2016 at 10:37 PM, Dave Chinner <david@fromorbit.com> wrote:
>>
>>> On Tue, Feb 02, 2016 at 07:40:34PM -0800, Dilip Simha wrote:
>>>> Hi Eric,
>>>>
>>>> Thank you for your quick reply.
>>>>
>>>> Using xfs_io as per your suggestion, I am able to reproduce the issue.
>>>> However, I need to falloc for 256K and write for 257K to see this issue.
>>>>
>>>> # xfs_io -f -c "falloc 0 256k" -c "pwrite 0 257k" /srv/node/r1/t1.txt
>>>> # stat /srv/node/r1/t4.txt | grep Blocks
>>>>   Size: 263168     Blocks: 1536       IO Block: 4096   regular file
>>>
>>> Fallocate sets the XFS_DIFLAG_PREALLOC on the inode.
>>>
>>> When you writing *past the preallocated area* and do delayed
>>> allocation, the speculative preallocation beyond EOF is double the
>>> size of the extent at EOF. i.e. 512k, leading to 768k being
>>> allocated to the file (1536 blocks, exactly).
>>>
>>
>> Thank you for the details.
>> This is exactly where I am a bit perplexed. Since the reclamation logic
>> skips inodes that have the XFS_DIFLAG_PREALLOC flag set, why did the
>> allocation logic allot more blocks on such an inode?
> 
> To store the data you wrote outside the preallocated region, of
> course.

I think what Dilip meant was, why does it do preallocation, not
why does it allocate blocks for the data.  That part is obvious
of course.  ;)

IOWS, if XFS_DIFLAG_PREALLOC prevents speculative preallocation
from being reclaimed, why is speculative preallocation added to files
with that flag set?

Seems like a fair question, even if Swift's use of preallocation is
ill-advised.

I don't have all the speculative preallocation heuristics in my
head like you do Dave, but if I have it right, and it's i.e.:

1) preallocate 256k
2) inode gets XFS_DIFLAG_PREALLOC
3) write 257k
4) inode gets speculative preallocation added due to write past EOF
5) inode never gets preallocation trimmed due to XFS_DIFLAG_PREALLOC

that seems suboptimal.

Never doing speculative preallocation on files with XFS_DIFLAG_PREALLOC
set, regardless of file offset, would seem sane to me.  App asked
to take control via prealloc; let it have it, and leave it at that.

(Of course now I'll go read the code to see if I understand it
properly...)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
