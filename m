Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E92C97F53
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 14:54:31 -0600 (CST)
Message-ID: <52FE8287.2090606@sgi.com>
Date: Fri, 14 Feb 2014 14:54:31 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/5] metadump: sanitise write_buf/index return values
References: <1390472635-17225-1-git-send-email-david@fromorbit.com>
	<1390472635-17225-2-git-send-email-david@fromorbit.com>
	<52FD1D38.1010006@sgi.com> <20140214022053.GQ13997@dastard>
	<52FE73B3.1020804@sgi.com>
In-Reply-To: <52FE73B3.1020804@sgi.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 02/14/14 13:51, Mark Tinguely wrote:
> On 02/13/14 20:20, Dave Chinner wrote:
>> On Thu, Feb 13, 2014 at 01:30:00PM -0600, Mark Tinguely wrote:
>>> On 01/23/14 04:23, Dave Chinner wrote:
>>>> From: Dave Chinner<dchinner@redhat.com>
>>>>
>>>> Write_buf/write_index use confusing boolean values for return,
>>>> meaning that it's hard to tell what the correct error return is
>>>> supposed to be. Convert them to return zero on success or a
>>>> negative errno otherwise so that it's clear what the error case is.
>>>>
>>>> Signed-off-by: Dave Chinner<dchinner@redhat.com>
>>>> ---
>>>
>>> Looks like this patch broke metadumps on some corrupted filesystems.
>>> This is a legacy filesystem that has zeroes overwriting the
>>> SB/AGF/AGI on AG 1/2/3:
>>>
>>>
>>> # xfs_metadump -wgo /dev/sda8 myfile.metadata
>>> xfs_agf_read_verify: XFS_CORRUPTION_ERROR
>>> xfs_metadump: cannot init perag data (117). Continuing anyway.
>>> Copied 64 of 64 inodes (0 of 4 AGs) xfs_agf_write_verify: XF
>>> S_CORRUPTION_ERROR
>>> write_buf: write verifer failed on bno 0x1100919/0x200
>>> (no output)
>>
>> Where did it crash? Can you post the stack trace from gdb? Even
>> better, can you send a patch to fix the problem? ;)
>>
>> Cheers,
>>
>> Dave.
>
> No crash, just exits without performing the dump.
>
> --Mark.
>

The error from the verifier prevents the metadump from completing.
You will want to fix it another way...

--Mark.

---
  db/metadump.c |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/db/metadump.c
===================================================================
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -209,7 +209,7 @@ write_buf(
  	_("%s: write verifer failed on bno 0x%llx/0x%x\n"),
  				__func__, (long long)buf->bp->b_bn,
  				buf->bp->b_bcount);
-			return -buf->bp->b_error;
+			return 0;
  		}
  	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
