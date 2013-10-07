Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 835057F37
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 16:00:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0FC4CAC002
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 14:00:08 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id VDxV8GJB4aLgNMzX for <xfs@oss.sgi.com>;
	Mon, 07 Oct 2013 14:00:07 -0700 (PDT)
Message-ID: <525320D6.20208@sandeen.net>
Date: Mon, 07 Oct 2013 16:00:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests XFS: verify extended attributes after
	multi-stream xfsdump/xfsrestore
References: <524AF8AE.5030300@sgi.com> <20131007193912.256265551@sgi.com>
	<52531A72.1060902@sandeen.net> <52531F8F.2030204@sgi.com>
In-Reply-To: <52531F8F.2030204@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs@oss.sgi.com

On 10/7/13 3:54 PM, Rich Johnston wrote:
> 
> 
> On 10/07/2013 03:32 PM, Eric Sandeen wrote:
>> On 10/7/13 2:38 PM, rjohnston@sgi.com wrote:
>>> Verify extended attributes are not lost after multi-stream
>>> xfsdump/xfsrestore of wholly-sparse files.  xfsrestore did not
>>> recognize that if the LAST header was reached with no restoredsz set,
>>> (i.e the LAST header is the only header), the following warning is
>>> displayed:
>>>
>>>    "partial_reg: Out of records. Extend attrs applied early."
>>>
>>> and the extended attributes on the current and following restored
>>> files are lost.
>>
>> and restore segfaults too, IIRC.  ;)
> 
> For test 2 yes you are correct, does not segfault for test 1.


Ah, I had missed that.  Makes sense now.

>>
>> So I'm trying to understand - are attrs not applied because xfs_restore
>> terminates, or is everything fine other than the attrs missing when
>> it completes successfully?
> 
> Everything fine other than the attrs missing when it completes successfully, which is how this bug was originally reported to me.
> In DMF land this meant OFFLINE files were restored as NON-MIGRATABLE (iow Extended attributes removed )
> 
>>
>> iows, I get this when it fails:
>>
>>   QA output created by 350
>>   Silence is golden.
>> +ATTR for /mnt/scratch/restore/dumpsrc/sparse0  DOES NOT match
> 
> This is from the first test, and I purposely just echo the error so I hit the second case too.
>>
>> and never get to the point of seeing if attrs are missing.
> 
> Forgot I changed the echo "restore failed" to _fail "restore failed".
> That's why you don't see the attrs are missing.

ok.

>>
>> Anyway, a few other things below for the record...
>>
>>> Signed-off-by: Rich Johnston <rjohnston@sgi.com>
>>>
>>> ---
>>>   tests/xfs/350     |  134 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>   tests/xfs/350.out |    2
>>>   tests/xfs/group   |    1
>>>   3 files changed, 137 insertions(+)
>>>
>>> Index: b/tests/xfs/350
>>> ===================================================================
>>> --- /dev/null
>>> +++ b/tests/xfs/350
>>> @@ -0,0 +1,134 @@
>>> +#! /bin/bash
>>> +# FS QA Test No. 350
>>
>> Big jump!
> 
> Taken care of at commit time. ;) Big jump as to not interfere with other peoples development.

fine by me!

...

>> Just out of curiosity, is the root (-R) namespace relevant to the problem?
> 
> Don't think so I can remove th -R.

doesn't really matter to me except then you'd need _require_root if you want
to use -R.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
