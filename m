Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:10036 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751716AbdKIEai (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2017 23:30:38 -0500
Subject: Re: [PATCH v2 4/4] common/rc: factor out
 _get|set_xfs_scratch_sb_field()
References: <20171108080250.5662-1-houtao1@huawei.com>
 <20171108080250.5662-5-houtao1@huawei.com> <20171108164908.GA6299@magnolia>
 <20171109035325.GR17339@eguan.usersys.redhat.com>
From: Hou Tao <houtao1@huawei.com>
Message-ID: <103f2a85-8acb-39c5-eea3-387d69e15593@huawei.com>
Date: Thu, 9 Nov 2017 12:30:12 +0800
MIME-Version: 1.0
In-Reply-To: <20171109035325.GR17339@eguan.usersys.redhat.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, guaneryu@gmail.com, linux-xfs@vger.kernel.org, cmaiolino@redhat.com

Hi,

On 2017/11/9 11:53, Eryu Guan wrote:
> On Wed, Nov 08, 2017 at 08:49:08AM -0800, Darrick J. Wong wrote:
>> On Wed, Nov 08, 2017 at 04:02:50PM +0800, Hou Tao wrote:
>>> It's common to get and set the values of fields in XFS super block,
>>> so factor them out as _get|set_xfs_scratch_sb_field() and update the
>>> related test cases accordingly.
>>>
>>> Signed-off-by: Hou Tao <houtao1@huawei.com>
>>> ---
>>>  common/xfs    | 20 ++++++++++++++++++++
>>>  tests/xfs/007 |  6 ++----
>>>  tests/xfs/098 |  4 ++--
>>>  tests/xfs/186 |  3 +--
>>>  tests/xfs/199 | 13 ++++---------
>>>  tests/xfs/307 | 11 ++---------
>>>  tests/xfs/308 | 11 ++---------
>>>  tests/xfs/339 |  6 +++---
>>>  tests/xfs/340 |  2 +-
>>>  tests/xfs/999 |  8 --------
>>>  10 files changed, 37 insertions(+), 47 deletions(-)
>>>
>>> diff --git a/common/xfs b/common/xfs
>>> index d4fef94..82ddc24 100644
>>> --- a/common/xfs
>>> +++ b/common/xfs
>>> @@ -599,3 +599,23 @@ _require_no_xfs_debug()
>>>  		_notrun "Require XFS built without CONFIG_XFS_DEBUG"
>>>  	fi
>>>  }
>>> +
>>> +_get_xfs_scratch_sb_field()
>>> +{
>>> +	local field=$1
>>> +
>>> +	shift
>>> +
>>> +	_scratch_xfs_db -r -c 'sb 0' "$@" -c "print $field" | \
>>> +	awk -v field=$field '$0 ~ field {print $3}'
>>> +}
>>> +
>>> +_set_xfs_scratch_sb_field()
>>> +{
>>> +	local field=$1
>>> +	local value=$2
>>> +
>>> +	shift 2
>>> +
>>> +	_scratch_xfs_db -x -c 'sb 0' "$@" -c "write $field -- $value"
>>> +}
>>
>> FWIW we already have _scratch_xfs_[gs]et_metadata_field in common/fuzzy.
> 
> Ah, thanks for the reminder! I forgot about them.. Tao, are the existing
> helpers in common/fuzzy something you can use? And perhaps we should
> move them to common/xfs then.

Yes, _scratch_xfs_[gs]et_metadata_field can be used to implement _get|set_xfs_scratch_sb_field().
So we can move _scratch_xfs_[gs]et_metadata_field to common/xfs and implement wrappers for getting
and setting fields of XFS super block.

Regards,
Tao

> Thanks,
> Eryu
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> .
> 

