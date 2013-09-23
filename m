Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C1D557F52
	for <linux-xfs@oss.sgi.com>; Mon, 23 Sep 2013 08:36:55 -0500 (CDT)
Message-ID: <524043F4.6000202@sgi.com>
Date: Mon, 23 Sep 2013 08:36:52 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_check: fix test for too-high level in v2 dir node
References: <52322B67.80305@redhat.com> <523A0086.1080000@sgi.com>
	<523A0AF0.3000507@sandeen.net>
In-Reply-To: <523A0AF0.3000507@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>, Eric Sandeen <sandeen@redhat.com>

On 09/18/13 15:20, Eric Sandeen wrote:
> On 9/18/13 2:35 PM, Mark Tinguely wrote:
>> On 09/12/13 16:00, Eric Sandeen wrote:
>>> The test as it stands allows level == XFS_DA_NODE_MAXDEPTH (5),
>>> but a max depth of 5 equates to level values of 0 through 4.
>>>
>>> Level 5 would be a depth of 6.
>>>
>>> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
>>> ---
>>>
>>
>>> diff --git a/db/check.c b/db/check.c
>>> index cbe55ba..d9e3e3f 100644
>>> --- a/db/check.c
>>> +++ b/db/check.c
>>> @@ -3138,7 +3138,7 @@ process_leaf_node_dir_v2_int(
>>>        case XFS_DA_NODE_MAGIC:
>>>            node = iocur_top->data;
>>>            xfs_da3_node_hdr_from_disk(&nodehdr, node);
>>> -        if (nodehdr.level <  1 || nodehdr.level >  XFS_DA_NODE_MAXDEPTH) {
>>> +        if (nodehdr.level <  1 || nodehdr.level >= XFS_DA_NODE_MAXDEPTH) {
>>>                if (!sflag || v)
>>>                    dbprintf(_("bad node block level %d for dir ino "
>>>                         "%lld block %d\n"),
>>
>>
>> I think the current code is correct.
>>
>> 0 is a leaf. levels 1-XFS_DA_NODE_MAXDEPTH are nodes.
>> Subtract 1 when used as an index.
>
>          case XFS_DA_NODE_MAGIC:
>                  node = iocur_top->data;
>                  xfs_da3_node_hdr_from_disk(&nodehdr, node);
> 			to->level = be16_to_cpu(from->hdr.__level);
>                  if (nodehdr.level < 1 || nodehdr.level > XFS_DA_NODE_MAXDEPTH) {
>
> so nodehdr.level comes directly off the disk.
>
> Hm, ok, let's look at the verifier, xfs_da3_node_verify:
>
> xfs_da3_node_hdr_from_disk /* sets to->level = be16_to_cpu(from->hdr.__level) */
>
> ...
>
>          if (ichdr.level == 0)
>                  return false;
>          if (ichdr.level > XFS_DA_NODE_MAXDEPTH)
>                  return false;
>
> ok, so 1 through XFS_DA_NODE_MAXDEPTH is valid for a generic node.  *shrug* ok
> fine, I agree.  It's only xfs_check anyway.  ;)
>
> Feel free to drop this patch then.
>
> But now I'm trying to reconcile it w/ the code in repair,
>
>   			i = da_cursor->active = nodehdr.level;
> 			if (i < 1 || i >= XFS_DA_NODE_MAXDEPTH) {
>
> which considers nodehdr.level == XFS_DA_NODE_MAXDEPTH to be problematic, because
> i (== nodehdr.level) is used directly as an index into a level[XFS_DA_NODE_MAXDEPTH]-sized
> array.
>
> So confused.  :/  (Maybe the cursor array needs to be 1 bigger?)
>
> -Eric

Strange, the kernel attribute asserts use XFS_DA_NODE_MAXDEPTH-1 as the 
maximum good value.

Looks like the repair code uses the cursor level[0], so we cannot index 
with (i - 1). I agree that the array in the da_bt_cursor should be one 
greater.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
