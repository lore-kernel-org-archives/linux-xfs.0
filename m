Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3164BC47089
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Dec 2022 03:13:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbiLFDNQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Dec 2022 22:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbiLFDNQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Dec 2022 22:13:16 -0500
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD541A203;
        Mon,  5 Dec 2022 19:13:14 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=ziyangzhang@linux.alibaba.com;NM=0;PH=DS;RN=5;SR=0;TI=SMTPD_---0VWd6U-R_1670296391;
Received: from 30.97.56.248(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VWd6U-R_1670296391)
          by smtp.aliyun-inc.com;
          Tue, 06 Dec 2022 11:13:12 +0800
Message-ID: <4096c6d3-f88f-82a1-4d5c-7c162c179483@linux.alibaba.com>
Date:   Tue, 6 Dec 2022 11:13:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [RESEND PATCH V2] common/populate: Ensure that S_IFDIR.FMT_BTREE
 is in btree format
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "hsiangkao@linux.alibaba.com" <hsiangkao@linux.alibaba.com>,
        Allison Henderson <allison.henderson@oracle.com>
References: <20221202112740.1233028-1-ZiyangZhang@linux.alibaba.com>
 <030e253f14fcdff29d43bafa690435be06abacb4.camel@oracle.com>
 <Y45n8Xy+j3fV/TtG@magnolia>
Content-Language: en-US
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
In-Reply-To: <Y45n8Xy+j3fV/TtG@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2022/12/6 05:51, Darrick J. Wong wrote:
> On Sat, Dec 03, 2022 at 12:26:57AM +0000, Allison Henderson wrote:
>> On Fri, 2022-12-02 at 19:27 +0800, Ziyang Zhang wrote:
>>> Sometimes "$((128 * dblksz / 40))" dirents cannot make sure that
>>> S_IFDIR.FMT_BTREE could become btree format for its DATA fork.
>>>
>>> Actually we just observed it can fail after apply our inode
>>> extent-to-btree workaround. The root cause is that the kernel may be
>>> too good at allocating consecutive blocks so that the data fork is
>>> still in extents format.
>>>
>>> Therefore instead of using a fixed number, let's make sure the number
>>> of extents is large enough than (inode size - inode core size) /
>>> sizeof(xfs_bmbt_rec_t).
>>>
>>> Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
>>> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
>>> Signed-off-by: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
>>
>> New version looks much cleaner.  
>> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
>>
>>> ---
>>> V2: take Darrick's advice to cleanup code
>>>  common/populate | 28 +++++++++++++++++++++++++++-
>>>  common/xfs      | 17 +++++++++++++++++
>>>  2 files changed, 44 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/common/populate b/common/populate
>>> index 6e004997..1ca76459 100644
>>> --- a/common/populate
>>> +++ b/common/populate
>>> @@ -71,6 +71,31 @@ __populate_create_dir() {
>>>         done
>>>  }
>>>  
>>> +# Create a large directory and ensure that it's a btree format
>>> +__populate_xfs_create_btree_dir() {
>>> +       local name="$1"
>>> +       local isize="$2"
>>> +       local icore_size="$(_xfs_inode_core_bytes)"
>>> +       # We need enough extents to guarantee that the data fork is
>>> in
>>> +       # btree format.  Cycling the mount to use xfs_db is too slow,
>>> so
>>> +       # watch for when the extent count exceeds the space after the
>>> +       # inode core.
>>> +       local max_nextents="$(((isize - icore_size) / 16))"
>>> +
>>> +       mkdir -p "${name}"
>>> +       d=0
>>> +       while true; do
>>> +               creat=mkdir
>>> +               test "$((d % 20))" -eq 0 && creat=touch
>>> +               $creat "${name}/$(printf "%.08d" "$d")"
>>> +               if [ "$((d % 40))" -eq 0 ]; then
>>> +                       nextents="$(_xfs_get_fsxattr nextents $name)"
>>> +                       [ $nextents -gt $max_nextents ] && break
>>> +               fi
>>> +               d=$((d+1))
>>> +       done
>>> +}
>>> +
>>>  # Add a bunch of attrs to a file
>>>  __populate_create_attr() {
>>>         name="$1"
>>> @@ -176,6 +201,7 @@ _scratch_xfs_populate() {
>>>  
>>>         blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
>>>         dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
>>> +       isize="$(_xfs_inode_size "$SCRATCH_MNT")"
>>>         crc="$(_xfs_has_feature "$SCRATCH_MNT" crc -v)"
>>>         if [ $crc -eq 1 ]; then
>>>                 leaf_hdr_size=64
>>> @@ -226,7 +252,7 @@ _scratch_xfs_populate() {
>>>  
>>>         # - BTREE
>>>         echo "+ btree dir"
>>> -       __populate_create_dir "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE"
>>> "$((128 * dblksz / 40))" true
>>> +       __populate_xfs_create_btree_dir
>>> "${SCRATCH_MNT}/S_IFDIR.FMT_BTREE" "$isize"
>>>  
>>>         # Symlinks
>>>         # - FMT_LOCAL
>>> diff --git a/common/xfs b/common/xfs
>>> index 8ac1964e..0359e422 100644
>>> --- a/common/xfs
>>> +++ b/common/xfs
>>> @@ -1486,3 +1486,20 @@ _require_xfsrestore_xflag()
>>>         $XFSRESTORE_PROG -h 2>&1 | grep -q -e '-x' || \
>>>                         _notrun 'xfsrestore does not support -x
>>> flag.'
>>>  }
>>> +
>>> +
>>> +# Number of bytes reserved for a full inode record, which includes
>>> the
>>> +# immediate fork areas.
>>> +_xfs_inode_size()
>>> +{
>>> +       local mntpoint="$1"
>>> +
>>> +       $XFS_INFO_PROG "$mntpoint" | grep 'meta-data=.*isize' | sed -
>>> e 's/^.*isize=\([0-9]*\).*$/\1/g'
>>> +}
>>> +
>>> +# Number of bytes reserved for only the inode record, excluding the
>>> +# immediate fork areas.
>>> +_xfs_inode_core_bytes()
>>> +{
>>> +       echo 176
>>> +}
> 
> Please refactor all the other users:
> 
> $ git grep -w isize.*176
> tests/xfs/335:34:i_ptrs=$(( (isize - 176) / 56 ))
> tests/xfs/336:45:i_ptrs=$(( (isize - 176) / 56 ))
> tests/xfs/337:36:i_ptrs=$(( (isize - 176) / 56 ))
> tests/xfs/341:36:i_ptrs=$(( (isize - 176) / 48 ))
> tests/xfs/342:33:i_ptrs=$(( (isize - 176) / 56 ))
> 
> (I'll test out this patch and try to do the same for ATTR.FMT_BTREE in
> the meantime)

Hi, Darrick

Should I create a new patch to refactor these test cases
or refactor them just in this patch?

Looks like these test cases just need _xfs_inode_core_bytes()
and commit message of this patch is not written for them.

Regards,
Zhang
