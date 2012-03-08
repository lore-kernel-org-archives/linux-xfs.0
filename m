Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q28MdsrM090373 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 16:39:54 -0600
Message-ID: <4F593538.50800@sgi.com>
Date: Thu, 08 Mar 2012 16:39:52 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_io: allow -F in open args
References: <4F2AC948.1050909@redhat.com> <4F592728.9060706@sgi.com>
	<4F5930BC.7040106@redhat.com> <4F593493.6010106@sgi.com>
	<4F5934BF.9060808@redhat.com>
In-Reply-To: <4F5934BF.9060808@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On 03/08/12 16:37, Eric Sandeen wrote:
> On 3/8/12 4:37 PM, Mark Tinguely wrote:
>> On 03/08/12 16:20, Eric Sandeen wrote:
>>> Now that -F ("foreign") is automagic, we should no longer list
>>> it in the help output for open, but we should still accept
>>> it for compatibility; esp. as it is still in the case statement.
>>> Oops.
>>>
>>> Reported-by: Mark Tinguely<tinguely@sgi.com>
>>> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
>>> ---
>>>
>>> diff --git a/io/open.c b/io/open.c
>>> index ac39ccc..46538ba 100644
>>> --- a/io/open.c
>>> +++ b/io/open.c
>>> @@ -240,7 +240,6 @@ open_help(void)
>>>    "\n"
>>>    " Opens a file for subsequent use by all of the other xfs_io commands.\n"
>>>    " With no arguments, open uses the stat command to show the current file.\n"
>>> -" -F -- foreign filesystem file, disallow XFS-specific commands\n"
>>>    " -a -- open with the O_APPEND flag (append-only mode)\n"
>>>    " -d -- open with O_DIRECT (non-buffered IO, note alignment constraints)\n"
>>>    " -f -- open with O_CREAT (create the file if it doesn't exist)\n"
>>> @@ -274,7 +273,7 @@ open_f(
>>>            return 0;
>>>        }
>>>
>>> -    while ((c = getopt(argc, argv, "Racdfm:nrstx")) != EOF) {
>>> +    while ((c = getopt(argc, argv, "FRacdfm:nrstx")) != EOF) {
>>>            switch (c) {
>>>            case 'F':
>>>                /* Ignored / deprecated now, handled automatically */
>>>
>>>
>>
>> Thank-you. Probably could take it out of the man page under the open I/O command now too.
>
> Gah.  With your blessing I'll commit that as well?
>
>> Reviewed-by: Mark Tinguely
>>
>>
>

Yes, and I should have saw it before too. Good idea to remove the flag.

--Mark Tinguely

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
