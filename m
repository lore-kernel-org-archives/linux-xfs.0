Return-Path: <SRS0=4PMG=ZG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A07C0C432C3
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 17:59:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 691B72071B
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 17:59:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kTVUhG9c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbfKNR7E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Nov 2019 12:59:04 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33910 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727137AbfKNR7D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Nov 2019 12:59:03 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAEHsPEP070249;
        Thu, 14 Nov 2019 17:59:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=fE+IAT7FOPtnNN63zk1jrOpqstfA/6tZXX6pd62W1ik=;
 b=kTVUhG9ceCAgPdbpTBPQrydD2mn3mTghjyETCzZWOcJgGwpW9yA0LUk3aAtUfmctF85X
 gddwvkqelbLnrV1UmFGKFa2jdlIBltJoOCcEXq6F3dgvgcMH/JbkKY25OtqGldX2fs4r
 KSUbTOdgwMCohRnRDjCGo8Ef7Mb9OWN7ucmxJtjN+spVAJWpg/Hre0CR0Ok84nGFyDqx
 IqMRYxZfzrpYa0TBFdAg7TpakkGnJN334p5KTeXEa9YKXkPwguhd2g36mDw4M/5Sgkxx
 kZTepdCoXpAwMFOj/usej0VPHspAzv6+C1etgn3Kc6pghbtPIQGezOeaexG1oafIVl2v qg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2w5ndqmw37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 17:59:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAEHx0nD100815;
        Thu, 14 Nov 2019 17:59:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2w8nga1jwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 17:58:59 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAEHwHsp017506;
        Thu, 14 Nov 2019 17:58:17 GMT
Received: from [192.168.1.9] (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 Nov 2019 09:58:17 -0800
Subject: Re: [PATCH v4 16/17] xfs: Add delay ready attr remove routines
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-17-allison.henderson@oracle.com>
 <20191112133702.GA46980@bfoster>
 <a90fd70a-9c5c-d82e-e889-be489b33b330@oracle.com>
 <20191113115416.GA54921@bfoster>
 <c2e5f4ab-b8a2-8d41-468d-e3debb87b6bf@oracle.com>
 <20191114124833.GA2859@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <acbb3648-c6d5-bf89-3380-79e1c35378c6@oracle.com>
Date:   Thu, 14 Nov 2019 10:58:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191114124833.GA2859@bfoster>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911140154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911140154
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/14/19 5:48 AM, Brian Foster wrote:
> On Wed, Nov 13, 2019 at 04:39:18PM -0700, Allison Collins wrote:
>>
>>
>> On 11/13/19 4:54 AM, Brian Foster wrote:

<snip>

>> Yes, as it is, it doesn't really have any way of detecting a corrupt state.
>> Really though, if we want to do that what we need is another layer of
>> modeling where we enforce the sequence of the states.  So for example, some
>> sort of mapping or tree that defines: XFS_DC_LEAF_TO_NODE and
>> XFS_DC_FOUND_LBLK as being children (or mappings) of XFS_DC_SF_TO_LEAF.
>>
>> In other words, if the state is XFS_DC_SF_TO_LEAF, you can change it to
>> XFS_DC_FOUND_LBLK or XFS_DC_LEAF_TO_NODE, but you can't go to say
>> XFS_DC_RM_SHRINK, that would generate an error.  And then we have some sort
>> of set_state() routine to enforce these rules.
>>
>> That's a lot of extra overhead though, and could be more of a burden than a
>> help.  But it's something we could explore if people think it's worth the
>> pursuit.
>>
> 
> Yeah, I don't think it's necessary to go so far as to create a complex
> set of rules and whatnot purely for the purpose of validating state
> management. I'm just handwaving about potentially structuring the code
> such that the state management is clear and easy to follow. :)
> 
> Brian

Yeah, that's kinda how I felt too.  Maybe later we could come back and 
reconsider it depending on how the refactoring goes.  I've done a little 
research online around about state machine designs, and usually what I 
see is some sort of mapping of state codes to function pointers.  So if 
it's possible to modularize everything into helpers, then an extra layer 
of abstraction starts to make a lot more sense.  But what we wouldn't 
want is so much refactoring that we have a bunch of little helpers so 
small and fragmented that the code flow is a headache to follow.  So I 
figure maybe for now we could just stick to refactoring snippets under 
the switch approach, and if it starts to look like something that could 
really benefit from a fully formed state machine model, we can consider 
it then :-)

Allison

> 
>> Allison
>>>
>>>> Thoughts?
>>>>
>>>>>
>>>>>> +	}
>>>>>>     	error = xfs_attr_node_hasname(args, &state);
>>>>>>     	if (error != -EEXIST)
>>>>>>     		goto out;
>>>>>> +	else
>>>>>> +		error = 0;
>>>>>>     	/*
>>>>>>     	 * If there is an out-of-line value, de-allocate the blocks.
>>>>>> @@ -1237,6 +1303,14 @@ xfs_attr_node_removename(
>>>>>>     	blk = &state->path.blk[ state->path.active-1 ];
>>>>>>     	ASSERT(blk->bp != NULL);
>>>>>>     	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>>>>>> +
>>>>>> +	/*
>>>>>> +	 * Store blk and state in the context incase we need to cycle out the
>>>>>> +	 * transaction
>>>>>> +	 */
>>>>>> +	args->dc.blk = blk;
>>>>>> +	args->dc.da_state = state;
>>>>>> +
>>>>>>     	if (args->rmtblkno > 0) {
>>>>>>     		/*
>>>>>>     		 * Fill in disk block numbers in the state structure
>>>>>> @@ -1255,13 +1329,30 @@ xfs_attr_node_removename(
>>>>>>     		if (error)
>>>>>>     			goto out;
>>>>>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>>>>>> +		args->dc.dc_state = XFS_DC_RM_INVALIDATE;
>>>>>> +		return -EAGAIN;
>>>>>> +rm_invalidate:
>>>>>> +		error = xfs_attr_rmtval_invalidate(args);
>>>>>>     		if (error)
>>>>>>     			goto out;
>>>>>> +rm_node_blks:
>>>>>
>>>>> While I think the design is the right idea, jumping down into a function
>>>>> like this is pretty hairy. I think we should try to further break this
>>>>> function down into smaller elements one way or another that model the
>>>>> steps defined by the state structure. There's probably multiple ways to
>>>>> do that. For example, the remote attr bits could be broken down into
>>>>> a subfunction that processes the couple of states associated with remote
>>>>> blocks. That said, ISTM it might be wiser to try and keep the state
>>>>> processing in one place if possible. That would imply to break the
>>>>> remote processing loop down into a couple functions. All in all, this
>>>>> function might end up looking something like:
>>>>>
>>>>> xfs_attr_node_removename()
>>>>> {
>>>>> 	/* switch statement and comment to document each state */
>>>>>
>>>>> 	error = xfs_attr_node_hasname(args, &state);
>>>>> 	...
>>>>>
>>>>> 	if (remote) {
>>>>> 		error = do_setflag();
>>>>> 		if (error)
>>>>> 			return error;
>>>>>
>>>>> 		/* roll */
>>>>> 		state = INVALIDATE;
>>>>> 		return -EAGAIN;
>>>>> 	}
>>>>>
>>>>> rmt_invalidate:
>>>>> 	state = INVALIDATE;
>>>>> 	if (remote)
>>>>> 		do_invalidate();
>>>>> 	/* fallthru */
>>>>>
>>>>> rmt_rm_blks:
>>>>> 	state = RM_NODE_BLKS;
>>>>> 	if (remote) {
>>>>> 		/* loops and returns -EAGAIN until we fallthru */
>>>>> 		error = rmt_remove_step();
>>>>> 		if (error)
>>>>> 			return error;
>>>>>
>>>>> 		xfs_attr_refillstate();
>>>>> 	}
>>>>>
>>>>> /* maybe worth a new state here? */
>>>>> removename:
>>>>> 	state = REMOVENAME;
>>>>> 	xfs_attr3_leaf_remove();
>>>>> 	...
>>>>> 	if (...) {
>>>>> 		state = SHRINK;
>>>>> 		return -EAGAIN;
>>>>> 	}
>>>>>
>>>>> shrink:
>>>>> 	state = SHRINK;
>>>>> 	error = do_shrink();
>>>>>
>>>>> 	return 0;
>>>>> }
>>>> Ok, I had to go over this a few times, but I think I understand what you're
>>>> describing.  Will update in the next version
>>>>>
>>>>> I'm not totally sold on the idea of rolling the state forward explicitly
>>>>> like this, but it seems like it could be a bit more maintainable.
>>>> I think it is.  Having a dedicated struct just for this purpose alleviates a
>>>> lot of struggle with trying to grab onto things like the fork or the
>>>> incomplete flags to represent what we're trying to do here. Doing so also
>>>> overloads their original intent in that if these structures ever change in
>>>> the future, it may break something that the state machine depends on.  In
>>>> this solution, they remain disjoint concepts dedicated to their purpose.
>>>> And anyway, I couldn't completely escape the state machine in the previous
>>>> set.  I still had to add the extra flag space which functioned more or less
>>>> like "i was here" tick marks.  If we have to have it, we may as well
>>>> leverage what it can do. For example I can drop patch 11 from this set
>>>> because I don't need the extra isset helpers to see if it's already been
>>>> done.
>>>>
>>>
>>> Right.. I agree that the "bookmark" like approach in the current scheme
>>> makes the state implementation (and not necessarily the operational
>>> implementation) a little hard to follow and review. Note again that what
>>> I wrote up here was just a quick example for that higher level feedback
>>> of somehow or another trying to isolate state updates from state
>>> implementation, so I'm not necessarily tied to that specific approach if
>>> there are other ways to similarly simplify things.
>>>
>>> I do think fixing up the code to avoid jumping into loops and whatnot is
>>> more important. It could also be that just continuing to break things
>>> down into as small functions as possible (i.e. with a goal of 1 function
>>> per state) kind of forces a natural separation.
>>>
>>> Brian
>>>
>>>>    All in
>>>>> all this is still fairly ugly, but this is mostly a mechanical attempt
>>>>> to keep state management isolated and we can polish it up from there.
>>>>> Thoughts?
>>>>
>>>> Yes, at this point, I do kind of feel like it's the least of the ugly
>>>> prototypes.  So I'm just kind of proceeding, with caution. :-)
>>>>
>>>> Thanks for the in depths reviews!!  I know its a lot!  Much appreciated!!
>>>>
>>>> Allison
>>>>
>>>>>
>>>>> Brian
>>>>>
>>>>>> +		/*
>>>>>> +		 * Unmap value blocks for this attr.  This is similar to
>>>>>> +		 * xfs_attr_rmtval_remove, but open coded here to return EAGAIN
>>>>>> +		 * for new transactions
>>>>>> +		 */
>>>>>> +		while (!done && !error) {
>>>>>> +			error = xfs_bunmapi(args->trans, args->dp,
>>>>>> +				    args->rmtblkno, args->rmtblkcnt,
>>>>>> +				    XFS_BMAPI_ATTRFORK, 1, &done);
>>>>>> +			if (error)
>>>>>> +				return error;
>>>>>> -		error = xfs_attr_rmtval_remove(args);
>>>>>> -		if (error)
>>>>>> -			goto out;
>>>>>> +			if (!done) {
>>>>>> +				args->dc.dc_state = XFS_DC_RM_NODE_BLKS;
>>>>>> +				return -EAGAIN;
>>>>>> +			}
>>>>>> +		}
>>>>>>     		/*
>>>>>>     		 * Refill the state structure with buffers, the prior calls
>>>>>> @@ -1287,17 +1378,12 @@ xfs_attr_node_removename(
>>>>>>     		error = xfs_da3_join(state);
>>>>>>     		if (error)
>>>>>>     			goto out;
>>>>>> -		error = xfs_defer_finish(&args->trans);
>>>>>> -		if (error)
>>>>>> -			goto out;
>>>>>> -		/*
>>>>>> -		 * Commit the Btree join operation and start a new trans.
>>>>>> -		 */
>>>>>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>>>>>> -		if (error)
>>>>>> -			goto out;
>>>>>> +
>>>>>> +		args->dc.dc_state = XFS_DC_RM_SHRINK;
>>>>>> +		return -EAGAIN;
>>>>>>     	}
>>>>>> +rm_shrink:
>>>>>>     	/*
>>>>>>     	 * If the result is small enough, push it all into the inode.
>>>>>>     	 */
>>>>>> @@ -1319,9 +1405,6 @@ xfs_attr_node_removename(
>>>>>>     			/* bp is gone due to xfs_da_shrink_inode */
>>>>>>     			if (error)
>>>>>>     				goto out;
>>>>>> -			error = xfs_defer_finish(&args->trans);
>>>>>> -			if (error)
>>>>>> -				goto out;
>>>>>>     		} else
>>>>>>     			xfs_trans_brelse(args->trans, bp);
>>>>>>     	}
>>>>>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>>>>>> index 3b5dad4..fb8bf5b 100644
>>>>>> --- a/fs/xfs/libxfs/xfs_attr.h
>>>>>> +++ b/fs/xfs/libxfs/xfs_attr.h
>>>>>> @@ -152,6 +152,7 @@ int xfs_attr_set_args(struct xfs_da_args *args);
>>>>>>     int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int flags);
>>>>>>     int xfs_has_attr(struct xfs_da_args *args);
>>>>>>     int xfs_attr_remove_args(struct xfs_da_args *args);
>>>>>> +int xfs_attr_remove_later(struct xfs_da_args *args);
>>>>>>     int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>>>>>>     		  int flags, struct attrlist_cursor_kern *cursor);
>>>>>>     bool xfs_attr_namecheck(const void *name, size_t length);
>>>>>> -- 
>>>>>> 2.7.4
>>>>>>
>>>>>
>>>>
>>>
>>
> 
