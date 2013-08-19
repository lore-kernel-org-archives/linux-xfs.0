Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0B6A27F98
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 14:37:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CF9AE304043
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 12:36:56 -0700 (PDT)
Received: from mail-qa0-f45.google.com (mail-qa0-f45.google.com
	[209.85.216.45]) by cuda.sgi.com with ESMTP id aeilQMyA4ZVCltGF
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 19 Aug 2013 12:36:52 -0700 (PDT)
Received: by mail-qa0-f45.google.com with SMTP id l18so2030544qak.4
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 12:36:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <52126391.8050800@sgi.com>
References: <1376277303-29455-1-git-send-email-zwu.kernel@gmail.com>
	<1376277303-29455-7-git-send-email-zwu.kernel@gmail.com>
	<52126391.8050800@sgi.com>
Date: Tue, 20 Aug 2013 03:36:51 +0800
Message-ID: <CAEH94LhPii3r06=Sn54L4z=3Vhz0=LZDamV685D0ti2Rg5vt_g@mail.gmail.com>
Subject: Re: [PATCH 06/12] xfs: fix the comment of
	xfs_extent_busy_update_extent()
From: Zhi Yong Wu <zwu.kernel@gmail.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, xfstests <xfs@oss.sgi.com>

On Tue, Aug 20, 2013 at 2:27 AM, Mark Tinguely <tinguely@sgi.com> wrote:
> On 08/11/13 22:14, zwu.kernel@gmail.com wrote:
>>
>> From: Zhi Yong Wu<wuzhy@linux.vnet.ibm.com>
>>
>> Signed-off-by: Zhi Yong Wu<wuzhy@linux.vnet.ibm.com>
>> ---
>>   fs/xfs/xfs_extent_busy.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
>> index 85e9f87..4ad8fee 100644
>> --- a/fs/xfs/xfs_extent_busy.c
>> +++ b/fs/xfs/xfs_extent_busy.c
>> @@ -147,7 +147,7 @@ xfs_extent_busy_search(
>>    * extent.  If the overlap covers the beginning, the end, or all of the
>> busy
>>    * extent, the overlapping portion can be made unbusy and used for the
>>    * allocation.  We can't split a busy extent because we can't modify a
>> - * transaction/CIL context busy list, but we can update an entries block
>> + * transaction/CIL context busy list, but we can update an entrie's block
>
>
>                                                               ^^^^^^
>                                                  changed that to entry's
Good catch, thanks.
>
>>    * number or length.
>>    *
>>    * Returns true if the extent can safely be reused, or false if the
>> search
>
>



-- 
Regards,

Zhi Yong Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
