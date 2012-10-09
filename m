Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q99LqKl7111870 for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 16:52:20 -0500
Message-ID: <50749CED.2070200@sgi.com>
Date: Tue, 09 Oct 2012 16:53:49 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/3] xfs_io: new functions
References: <1343255450-28559-1-git-send-email-david@fromorbit.com>
	<5060D5D5.80602@sgi.com> <5074760D.7000300@sandeen.net>
	<50748D54.4000702@sgi.com> <50748E38.4030303@sandeen.net>
In-Reply-To: <50748E38.4030303@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 10/09/12 15:51, Eric Sandeen wrote:
> On 10/9/12 3:47 PM, Mark Tinguely wrote:
>> On 10/09/12 14:07, Eric Sandeen wrote:
>>> On 9/24/12 4:51 PM, Mark Tinguely wrote:
>>>> On 07/25/12 17:30, Dave Chinner wrote:
>>>>> This is just a couple of additional functions for xfs_io I have had
>>>>> sitting around for a while. The first is an interface to
>>>>> sync_file_range() for better control of file writeback.  The second
>>>>> and third introduce vectored pread/pwrite so that I could simulate
>>>>> the same style of vectored IO that KVM does via direct IO (hint -
>>>>> tracing indicated that the generic direct IO code doesn't handle
>>>>> this particularly efficiently).
>>>>>
>>>>> _____________________________________________
>>>>
>>>> This series has been committed to
>>>>      git://oss.sgi.com/xfs/cmds/xfsprogs.git
>>>>
>>>> -Mark.
>>>>
>>>> _______________________________________________
>>>> xfs mailing list
>>>> xfs@oss.sgi.com
>>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>>
>>>
>>> Looks like this might need some config-fu:
>>>
>>> pread.o: In function `do_pread':
>>> /src/git/xfsprogs/io/pread.c:198: undefined reference to `preadv'
>>> /src/git/xfsprogs/io/pread.c:198: undefined reference to `preadv'
>>> pwrite.o: In function `do_pwrite':
>>> /src/git/xfsprogs/io/pwrite.c:85: undefined reference to `pwritev'
>>> /src/git/xfsprogs/io/pwrite.c:85: undefined reference to `pwritev'
>>> sync_file_range.o: In function `sync_range_f':
>>> /src/git/xfsprogs/io/sync_file_range.c:87: undefined reference to `sync_file_range'
>>>
>>>
>>> (on a Centos5 box)
>>
>>
>> Thanks Eric, I will take a look at it.
>
> I actually started (sorry, should have just done it before sending the mail)
>
> I'll take care of it, I'm halfway there.
>
> -Eric
>
>> --Mark.
>>
>

Excellent. That is easy!

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
