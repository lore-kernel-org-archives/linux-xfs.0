Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:46368 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750917AbeABW3f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jan 2018 17:29:35 -0500
MIME-Version: 1.0
In-Reply-To: <20180102203819.GF4857@magnolia>
References: <20171224123447.2998-1-sxwjean@gmail.com> <20180102203819.GF4857@magnolia>
From: Xiongwei Song <sxwjean@gmail.com>
Date: Wed, 3 Jan 2018 06:29:34 +0800
Message-ID: <CAEVVKH8koEUA6CWA0DuPMqmuQ3+MNY+9ZE1Cm2UU2KJ1PabK5w@mail.gmail.com>
Subject: Re: [PATCH] xfs: destroy mutex qi_tree_lock before free
 xfs_quotainfo_t object
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

2018-01-03 4:38 GMT+08:00 Darrick J. Wong <darrick.wong@oracle.com>:
> On Sun, Dec 24, 2017 at 08:34:47PM +0800, Xiongwei Song wrote:
>> The mutex qi_tree_lock of xfs_quotainfo_t object was initialized when
>> calling xfs_qm_init_quotainfo, but it was not destroyed before free
>> xfs_quotainfo_t object when calling xfs_qm_destroy_quotainfo, this was
>> incorrect, so destroy it in function xfs_qm_destroy_quotainfo.
>
> Already in for-next, but thank you for catching this.
>
> https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/commit/?h=for-next&id=2196881566225f3c3428d1a5f847a992944daa5b


Apologies for the noise.


Yours sincerely,
Xiongwei


> --D
>
>> Signed-off-by: Xiongwei Song <sxwjean@gmail.com>
>> ---
>>  fs/xfs/xfs_qm.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
>> index ec952dfad359..deceef5cbbf3 100644
>> --- a/fs/xfs/xfs_qm.c
>> +++ b/fs/xfs/xfs_qm.c
>> @@ -737,6 +737,7 @@ xfs_qm_destroy_quotainfo(
>>               qi->qi_pquotaip = NULL;
>>       }
>>       mutex_destroy(&qi->qi_quotaofflock);
>> +     mutex_destroy(&qi->qi_tree_lock);
>>       kmem_free(qi);
>>       mp->m_quotainfo = NULL;
>>  }
>> --
>> 2.15.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
