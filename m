Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54182 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751408AbdKHJtS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Nov 2017 04:49:18 -0500
Date: Wed, 8 Nov 2017 17:49:14 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 2/4] common/rc: support checking the version of
 dm-target in _require_dm_target()
Message-ID: <20171108094914.GP17339@eguan.usersys.redhat.com>
References: <20171108080250.5662-1-houtao1@huawei.com>
 <20171108080250.5662-3-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171108080250.5662-3-houtao1@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>
Cc: fstests@vger.kernel.org, guaneryu@gmail.com, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, cmaiolino@redhat.com

On Wed, Nov 08, 2017 at 04:02:48PM +0800, Hou Tao wrote:
> Some features of dm-target are not available on the old linux kernel,
> and we can use the version of dm-target to check the availability.

We don't check version numbers in fstests, but actually try what is
requested and _notrun if the test run failed.

I think we can keep _require_dm_target unchanged and add a new
_require_dmflakey_error_writes in common/dmflakey, e.g.

_require_dmflakey_error_writes()
{
	_require_dm_targets flakey

	<try creating flakey table with error_writes option here and
	_notrun if failed>
}

And call this new _require rule in the test.

Thanks,
Eryu
