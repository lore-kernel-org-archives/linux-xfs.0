Return-Path: <SRS0=Wl19=BE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F2FEC433EA
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jul 2020 02:53:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46103206EB
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jul 2020 02:53:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ypKywqES"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgGYCx1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 22:53:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47986 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbgGYCx1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 22:53:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2liXX049079;
        Sat, 25 Jul 2020 02:53:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=svxOGGITmh9IDi6/wBB9YKL6M5toFeNB+ek80TkiKYc=;
 b=ypKywqESEqbIDHgPgctqf1qH/CflltJeWphrUK2gkijYEQU9NZiVQkBXlwYs9Edq/zFk
 jPzsb0xmkXBFLm+SupIj16stAEEO/Yk0vKHTHsPFrKPVGkmlbt15vMh/NrhU27o9Wafh
 jg+zQh3wTKFIofFAKnlE/Voz3VHH1TnxSykG3LCLPqtQSW2MZQhPVaJ9wHFTxjzuvaFA
 0OyyrjVYE5XKCXapRzsfgz2lx/8dS9GPN4UVqfxw3Z9inubuNLzNI1db7lyDvrVxHyYW
 YqZRWZCozyYWBXMrT02dQw+PUX3kTOGkgq1yCyPiuaaD1A9PI3ZCPVNDZpkRrO7JeKo6 WQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32d6kt646s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 25 Jul 2020 02:53:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2pI6o125714;
        Sat, 25 Jul 2020 02:51:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 32gc2h0jnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Jul 2020 02:51:18 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06P2nq5i009679;
        Sat, 25 Jul 2020 02:49:52 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Jul 2020 19:49:51 -0700
Subject: Re: [PATCH v11 00/25] xfs: Delay Ready Attributes
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200721001606.10781-1-allison.henderson@oracle.com>
 <20200724034100.GN2005@dread.disaster.area>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <388db4ab-3b40-2bf7-5872-1c3fed0a8441@oracle.com>
Date:   Fri, 24 Jul 2020 19:49:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200724034100.GN2005@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 spamscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250020
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/23/20 8:41 PM, Dave Chinner wrote:
> On Mon, Jul 20, 2020 at 05:15:41PM -0700, Allison Collins wrote:
>> Hi all,
>>
>> This set is a subset of a larger series for delayed attributes. Which is a
>> subset of an even larger series, parent pointers. Delayed attributes allow
>> attribute operations (set and remove) to be logged and committed in the same
>> way that other delayed operations do. This allows more complex operations (like
>> parent pointers) to be broken up into multiple smaller transactions. To do
>> this, the existing attr operations must be modified to operate as either a
>> delayed operation or a inline operation since older filesystems will not be
>> able to use the new log entries.  This means that they cannot roll, commit, or
>> finish transactions.  Instead, they return -EAGAIN to allow the calling
>> function to handle the transaction. In this series, we focus on only the clean
>> up and refactoring needed to accomplish this. We will introduce delayed attrs
>> and parent pointers in a later set.
>>
>> At the moment, I would like people to focus their review efforts on just this
>> "delay ready" subseries, as I think that is a more conservative use of peoples
>> review time.  I also think the set is a bit much to manage all at once, and we
>> need to get the infrastructure ironed out before we focus too much anything
>> that depends on it. But I do have the extended series for folks that want to
>> see the bigger picture of where this is going.
>>
>> To help organize the set, I've arranged the patches to make sort of mini sets.
>> I thought it would help reviewers break down the reviewing some. For reviewing
>> purposes, the set could be broken up into 4 different phases:
>>
>> Error code filtering (patches 1-2):
>> These two patches are all about finding and catching error codes that need to
>> be sent back up to user space before starting delayed operations.  Errors that
>> happen during a delayed operation are treated like internal errors that cause a
>> shutdown.  But we wouldnt want that for example: when the user tries to rename
>> a non existent attr.  So the idea is that we need to find all such conditions,
>> and take care of them before starting a delayed operation.
>>     xfs: Add xfs_has_attr and subroutines
>>     xfs: Check for -ENOATTR or -EEXIST
>>
>> Move transactions upwards (patches 3-12):
>> The goal of this subset is to try and move all the transaction specific code up
>> the call stack much as possible.  The idea being that once we get them to the
>> top, we can introduce the statemachine to handle the -EAGAIN logic where ever
>> the transactions used to be.
>>    xfs: Factor out new helper functions xfs_attr_rmtval_set
>>    xfs: Pull up trans handling in xfs_attr3_leaf_flipflags
>>    xfs: Split apart xfs_attr_leaf_addname
>>    xfs: Refactor xfs_attr_try_sf_addname
>>    xfs: Pull up trans roll from xfs_attr3_leaf_setflag
>>    xfs: Factor out xfs_attr_rmtval_invalidate
>>    xfs: Pull up trans roll in xfs_attr3_leaf_clearflag
>>    xfs: Refactor xfs_attr_rmtval_remove
>>    xfs: Pull up xfs_attr_rmtval_invalidate
>>    xfs: Add helper function xfs_attr_node_shrink
>>
>> Modularizing and cleanups (patches 13-22):
>> Now that we have pulled the transactions up to where we need them, it's time to
>> start breaking down the top level functions into new subfunctions. The goal
>> being to work towards a top level function that deals mostly with the
>> statemachine, and helpers for those states
>>    xfs: Remove unneeded xfs_trans_roll_inode calls
>>    xfs: Remove xfs_trans_roll in xfs_attr_node_removename
>>    xfs: Add helpers xfs_attr_is_shortform and xfs_attr_set_shortform
>>    xfs: Add helper function xfs_attr_leaf_mark_incomplete
>>    xfs: Add remote block helper functions
>>    xfs: Add helper function xfs_attr_node_removename_setup
>>    xfs: Add helper function xfs_attr_node_removename_rmt
>>    xfs: Simplify xfs_attr_leaf_addname
>>    xfs: Simplify xfs_attr_node_addname
>>    xfs: Lift -ENOSPC handler from xfs_attr_leaf_addname
> 
> I'm happy to see everything up to here merged.
> 
>> Introduce statemachine (patches 23-25):
>> Now that we have re-arranged the code such that we can remove the transaction
>> handling, we proceed to do so.  The behavior of the attr set/remove routines
>> are now also compatible as a .finish_item callback
>>    xfs: Add delay ready attr remove routines
>>    xfs: Add delay ready attr set routines
>>    xfs: Rename __xfs_attr_rmtval_remove
> 
> However, I think these still need work. The state machine mechanism
> needs more factoring so that there is a function per state/action
> that moves the state forwards one step, rather than the current
> setup where a single function might handle 3-5 different states by
> jumping to different parts of the code.
> 
> I started thinking that this was largely just code re-arrangement,
> but as I started to to do a bit of cleanup onit as an example, I
> think there's some bugs in the code that might be leading to leaking
> buffers and other such stuff. So I think this code really needs a
> good cleanup and going over before it will be ready to merge.
> 
> I've attached an untested, uncompiled patch below to demonstrate
> how I think we should start flattening this out. It takes
> xfs_attr_set_iter() and flattens it into a switch statement which
> calls fine grained functions. There are a couple of new states to
> efficiently jump into the state machine based on initial attr fork
> format, and xfs_attr_set_iter() goes away entirely.
> 
> Note that I haven't flattened the second level of function calls out
> into a function per state, which is where it's like to see this end
> up. i.e. we don't need to call through xfs_attr_leaf_addname() to
> just get to another switch statement to jump to the code that flips
> the flags.
> 
> The factoring and flattening process is the same, though: isolate
> the code that needs to run to a single function, call it from the
> state machine switch. That function then selects the next state to
> run, whether a transaction roll is necessary, etc, and the main loop
> then takes care of it from there.
> 
> Allison, if you want I can put together another couple of patches
> like the one below that flatten it right out into fine grained
> states and functions. I think having all the state machien
> transitions in one spot makes the code much easier to understand
> and, later, to simplify and optimise.

Sure, I am not opposed to alternate propositions as long as people are 
generally in agreement with the direction that its moving.  I think this 
was kind of a tough series for people to grok and review, so I certainly 
want to be mindful of everyone's feelings on it moving forward.  You are 
certainly welcome to send out some more ideas.  Let me see if I can get 
the below code compiled and getting through the test case.  Lots of 
times ideas can end up looking different in practice and it tends to 
shape opinions about how to move forward with it.  Thanks for the reviews!

Allison

> 
> Cheers,
> 
> Dave.
> 
