Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:9979 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752376AbdKHNjr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2017 08:39:47 -0500
Subject: Re: [PATCH v2 2/4] common/rc: support checking the version of
 dm-target in _require_dm_target()
References: <20171108080250.5662-1-houtao1@huawei.com>
 <20171108080250.5662-3-houtao1@huawei.com>
 <20171108094914.GP17339@eguan.usersys.redhat.com>
From: Hou Tao <houtao1@huawei.com>
Message-ID: <b479dd14-200b-25b8-54ec-2564e26616c8@huawei.com>
Date: Wed, 8 Nov 2017 21:39:30 +0800
MIME-Version: 1.0
In-Reply-To: <20171108094914.GP17339@eguan.usersys.redhat.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, guaneryu@gmail.com, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, cmaiolino@redhat.com

Hi,

On 2017/11/8 17:49, Eryu Guan wrote:
> On Wed, Nov 08, 2017 at 04:02:48PM +0800, Hou Tao wrote:
>> Some features of dm-target are not available on the old linux kernel,
>> and we can use the version of dm-target to check the availability.
> 
> We don't check version numbers in fstests, but actually try what is
> requested and _notrun if the test run failed.

OK.

> I think we can keep _require_dm_target unchanged and add a new
> _require_dmflakey_error_writes in common/dmflakey, e.g.
> 
> _require_dmflakey_error_writes()
> {
> 	_require_dm_targets flakey
> 
> 	<try creating flakey table with error_writes option here and
> 	_notrun if failed>
> }
> 
> And call this new _require rule in the test.

Will do it.

Thanks.
Tao

> Thanks,
> Eryu
> 
> .
> 

