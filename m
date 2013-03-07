Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C909A7FC8
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 09:48:55 -0600 (CST)
Message-ID: <5138B6E3.5010903@sgi.com>
Date: Thu, 7 Mar 2013 09:48:51 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Fix typo from commit 0c5e67e4 "xfstests 273: fix a typo"
References: <20130307124102.821208303@sgi.com>
	<20130307124125.435047948@sgi.com> <5138AAA2.70308@sgi.com>
In-Reply-To: <5138AAA2.70308@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: shhuiw@gmail.com, dsterba@suse.cz, xfs@oss.sgi.com

On 03/07/2013 08:56 AM, Mark Tinguely wrote:
> On 03/07/13 06:41, rjohnston@sgi.com wrote:
>> When updating the patch, the redirect was incorrect.
>>
>> Reported-by: Wang Sheng-Hui<shhuiw@gmail.com>
>> Signed-off-by: Rich Johnston<rjohnston@sgi.com>
>>
>> ---
>>
>>   273 |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> Index: b/273
>> ===================================================================
>> --- a/273
>> +++ b/273
>> @@ -92,7 +92,7 @@ _porter()
>>           exit
>>       fi
>>
>> -    cp -r $SCRATCH_MNT/origin $SCRATCH_MNT/sub_$_suffix>$seq.full 2>>&1
>> +    cp -r $SCRATCH_MNT/origin $SCRATCH_MNT/sub_$_suffix>>$seq.full 2>&1
>>       if [ $? -ne 0 ]
>>       then
>>           echo "_porter $_suffix not complete"
>>
>
>
> The original patch looked okay:
>
>     http://oss.sgi.com/archives/xfs/2013-02/msg00518.html
>
> Should the bad patch be reverted and the original one put in?
>
> --Mark.
Yes the patch would not apply to top of tree and I placed the redirect 
in the incorrect position when I updated the and committed the patch.

I have reverted and applied the patch correctly this time. :)


commit a1f6dd481218cd95c8d48ed684070cc2b0f62db2
Author: Wang Sheng-Hui <shhuiw@gmail.com>
Date:   Wed Feb 27 06:47:54 2013 +0000

     xfstests 273: fix a typo

     Make the porter log cp failure into $seq.full by appending, not 
overwriting,
     which can help debug.

     Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
     Reviewed-by: Dave Chinner <dchinner@redhat.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

diff --git a/273 b/273
index 67f3d6b..639e280 100755
--- a/273
+++ b/273
@@ -92,7 +92,7 @@ _porter()
                 exit
         fi

-       cp -r $SCRATCH_MNT/origin $SCRATCH_MNT/sub_$_suffix >$seq.full 2>&1
+       cp -r $SCRATCH_MNT/origin $SCRATCH_MNT/sub_$_suffix >>$seq.full 2>&1
         if [ $? -ne 0 ]
         then
                 echo "_porter $_suffix not complete"

commit 2a599a54aba600c299b8209d802f97c51a164dcb
Author: Rich Johnston <rjohnston@sgi.com>
Date:   Thu Mar 7 09:21:30 2013 -0600

     Revert "xfstests 273: fix a typo"

     This reverts commit 0c5e67e46e476b70290033efc7feb784f7ecbab1.
     Will re-apply the correct patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
