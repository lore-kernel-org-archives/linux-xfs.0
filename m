Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6821D7F37
	for <xfs@oss.sgi.com>; Wed,  7 Aug 2013 09:41:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 46D818F80C4
	for <xfs@oss.sgi.com>; Wed,  7 Aug 2013 07:41:55 -0700 (PDT)
Received: from mail-qa0-f53.google.com (mail-qa0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id 4V7FcSWvxZxKbP0e
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 07 Aug 2013 07:41:53 -0700 (PDT)
Received: by mail-qa0-f53.google.com with SMTP id hu14so1083948qab.19
	for <xfs@oss.sgi.com>; Wed, 07 Aug 2013 07:41:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <520259EA.1050801@sgi.com>
References: <1375870269-13157-1-git-send-email-zwu.kernel@gmail.com>
	<1375870269-13157-8-git-send-email-zwu.kernel@gmail.com>
	<52024BB4.5060109@sgi.com>
	<CAEH94LixsQOOGpcuyMNOxi+_FscL5sE8Q2KoPYgdf0JESnPaSA@mail.gmail.com>
	<520259EA.1050801@sgi.com>
Date: Wed, 7 Aug 2013 22:41:53 +0800
Message-ID: <CAEH94Lh+QR5uHWB5HBpCf7UJShisfiHxDGex663gyvnWTj16Hg@mail.gmail.com>
Subject: Re: [PATCH 07/12] xfs: fix the comment of xfs_iroot_realloc()
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

On Wed, Aug 7, 2013 at 10:30 PM, Mark Tinguely <tinguely@sgi.com> wrote:
> On 08/07/13 09:01, Zhi Yong Wu wrote:
>>
>> On Wed, Aug 7, 2013 at 9:29 PM, Mark Tinguely<tinguely@sgi.com>  wrote:
>>>
>>> On 08/07/13 05:11, zwu.kernel@gmail.com wrote:
>>>>
>>>>
>>>> From: Zhi Yong Wu<wuzhy@linux.vnet.ibm.com>
>>>>
>>>> Signed-off-by: Zhi Yong Wu<wuzhy@linux.vnet.ibm.com>
>>>> ---
>>>>    fs/xfs/xfs_inode.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>>>> index bb262c2..ccca9cd 100644
>>>> --- a/fs/xfs/xfs_inode.c
>>>> +++ b/fs/xfs/xfs_inode.c
>>>> @@ -2103,7 +2103,7 @@ xfs_ifree(
>>>>     *
>>>>     * The caller must not request to add more records than would fit in
>>>>     * the on-disk inode root.  If the if_broot is currently NULL, then
>>>> - * if we adding records one will be allocated.  The caller must also
>>>> + * if we are adding records, one will be allocated.  The caller must
>>>> also
>>>>     * not request that the number of records go below zero, although
>>>>     * it can go to zero.
>>>>     *
>>>
>>>
>>>
>>>
>>> Change this to xfs_inode_fork.c and the series will apply on top of
>>> Dave's
>>> "current patch queue for Linux 3.12":
>>
>> Do you mean that you have done this or i need to do this? If i need to do
>> this,
>> can you let me know where i can get xfs git repo which has applied
>> Dave's patchset?
>>
>>>
>>>    http://oss.sgi.com/archives/xfs/2013-07/msg00411.html
>
>
>
> If approved, we can make the change on commit.
Please feel free to do it, thanks a lot.
>
> The patches look okay to me.
>
> --Mark.
>



-- 
Regards,

Zhi Yong Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
