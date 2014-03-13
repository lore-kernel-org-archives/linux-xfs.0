Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9BD217F4E
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 10:03:37 -0500 (CDT)
Message-ID: <5321C8C5.2020506@sgi.com>
Date: Thu, 13 Mar 2014 10:03:33 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: Possible XFS bug encountered in 3.14.0-rc3+
References: <33A0129EBFD46748804DE81B354CA1B21C0DC77A@SACEXCMBX06-PRD.hq.netapp.com>
	<5320D4FE.3070002@sgi.com> <20140312230631.GF6851@dastard>
In-Reply-To: <20140312230631.GF6851@dastard>
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
Cc: "Mears, Morgan" <Morgan.Mears@netapp.com>, Jie Liu <jeff.liu@oracle.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 03/12/14 18:06, Dave Chinner wrote:
> On Wed, Mar 12, 2014 at 04:43:26PM -0500, Mark Tinguely wrote:
>> On 03/12/14 15:14, Mears, Morgan wrote:
>>> I was unable to umount, even with -f; failed with EBUSY and couldn't unbusy
>>> as the fs was unresponsive (and happens to contain the Oracle management
>>> tools necessary to close all open descriptors).  Accordingly I rebooted.
>>
>> You are the second person in 2-3 weeks to hit this unmount issue.
>> Unmatched EFI in the AIL keeps the unmount from completing.
>>
>> Jeff are you still looking at this?
>
> I'd say the answer is no. Last time you pointed out this problem I
> last asked you to provide patches to fix the problem, mark. Can
> you please provide patches to fix this, Mark?
>
> Cheers,
>
> Dave.

Ah, you wanted me to fix the cil_push error issue that leaks ctx and 
does not wake up the waiters. This is only a side issue to that.

We can easily patch the xfs_bmap_finish() and 
xlog_recover_process_efis() code. I have that patch and tested it. But 
it does not cover the cases of a cil push error nor the successful 
xfs_bmap_finish() and the EFI is in the AIL but the EFD is discarded.

The most correct thing to do is clear the EFI from the AIL in the abort 
paths of xfs_efd_item_committed() and xfs_efd_item_unlock(), but those 
will be called many times and would be overkill.

A less correct but easier would be clear the EFIs from the AIL once in 
xfs_unmountfs() after the last force of the log and before the 
xfs_ail_push_all_sync(). Since the EFI are removed very late, then we 
don't have to special case the removal in xfs_bmap_finish() and the 
xlog_recover_process_efis(). This is why I was waiting to see what Jeff 
wanted to do.

If I hear no strong objection, I intend to put the clearing EFI on the 
AIL for each situation: the abort cases of the efd iop routines, in 
xfs_bmap_finish() and the xlog_recover_process_efis().

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
