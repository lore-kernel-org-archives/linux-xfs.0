Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D755EC7618E
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Apr 2023 07:02:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbjDUHB7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Apr 2023 03:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbjDUHBw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2023 03:01:52 -0400
Received: from frasgout13.his.huawei.com (frasgout13.his.huawei.com [14.137.139.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858631BF6
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 00:01:49 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.18.147.229])
        by frasgout13.his.huawei.com (SkyGuard) with ESMTP id 4Q2lZR19Pbz9xFGP
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 14:52:15 +0800 (CST)
Received: from [10.174.177.238] (unknown [10.174.177.238])
        by APP2 (Coremail) with SMTP id BqC_BwBnloDKNEJkw3UABg--.55162S2;
        Fri, 21 Apr 2023 07:01:35 +0000 (GMT)
Message-ID: <28628d1f-fa90-9f48-801d-4bcccb88ef48@huaweicloud.com>
Date:   Fri, 21 Apr 2023 15:01:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 2/3] xfs: fix xfs print level wrong parsing
To:     Dave Chinner <david@fromorbit.com>
Cc:     djwong@kernel.org, dchinner@redhat.com, linux-xfs@vger.kernel.org,
        sandeen@redhat.com, guoxuenan@huaweicloud.com, houtao1@huawei.com,
        fangwei1@huawei.com, jack.qiu@huawei.com, yi.zhang@huawei.com
References: <20230421033142.1656296-1-guoxuenan@huawei.com>
 <20230421033142.1656296-3-guoxuenan@huawei.com>
 <20230421061701.GB3223426@dread.disaster.area>
Content-Language: en-US
From:   Guo Xuenan <guoxuenan@huaweicloud.com>
In-Reply-To: <20230421061701.GB3223426@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: BqC_BwBnloDKNEJkw3UABg--.55162S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGr4xKr4xGrWrJw13Kw18Grg_yoWrWw1xpw
        n3Ja4FkrZ5Ar1F93Z7KF10vw43Xw1UCr18ArZ3Aw43Aa4jywn7Wa4kKw1YvF93Kr4jg3yx
        XFyYvry3uas7ua7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r1j
        6r4UM28EF7xvwVC2z280aVAFwI0_Jr0_Gr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4j6r
        4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
        c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
        AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
        17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
        IF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq
        3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
        nIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: xjxr53hhqd0q5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave，

On 2023/4/21 14:17, Dave Chinner wrote:
> On Fri, Apr 21, 2023 at 11:31:41AM +0800, Guo Xuenan wrote:
>> Recently, during my xfs bugfix work, notice a bug that makes
>> xfs_stack_trace never take effect. This has been around here at xfs
>> debug framework for a long time.
>>
>> The root cause is misuse of `kstrtoint` which always return -EINVAL
>> because KERN_<LEVEL> with KERN_SOH prefix unable to parse correctly by
>> it. By skipping the prefix KERN_SOH we can get correct printk level.
>>
>> Fixes: 847f9f6875fb ("xfs: more info from kmem deadlocks and high-level error msgs")
>> Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
>> ---
>>   fs/xfs/xfs_message.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
>> index 8f495cc23903..bda4c0a0ca42 100644
>> --- a/fs/xfs/xfs_message.c
>> +++ b/fs/xfs/xfs_message.c
>> @@ -45,7 +45,7 @@ xfs_printk_level(
>>   
>>   	va_end(args);
>>   
>> -	if (!kstrtoint(kern_level, 0, &level) &&
>> +	if (!kstrtoint(kern_level + strlen(KERN_SOH), 0, &level) &&
>>   	    level <= LOGLEVEL_ERR &&
>>   	    xfs_error_level >= XFS_ERRLEVEL_HIGH)
>>   		xfs_stack_trace();
> Ugh. KERN_* is a string with a special character as a header, not
> just an stringified number. Ok, I see how this fixes the bug, but
> let's have a look at where kern_level comes from. i.e.
> xfs_message.h:
>
> extern __printf(3, 4)
> void xfs_printk_level(const char *kern_level, const struct xfs_mount *mp,
>                          const char *fmt, ...);
>
> define xfs_printk_index_wrap(kern_level, mp, fmt, ...)         \
> ({                                                              \
>          printk_index_subsys_emit("%sXFS%s: ", kern_level, fmt); \
>          xfs_printk_level(kern_level, mp, fmt, ##__VA_ARGS__);   \
> })
> #define xfs_emerg(mp, fmt, ...) \
>          xfs_printk_index_wrap(KERN_EMERG, mp, fmt, ##__VA_ARGS__)
> #define xfs_alert(mp, fmt, ...) \
>          xfs_printk_index_wrap(KERN_ALERT, mp, fmt, ##__VA_ARGS__)
> #define xfs_crit(mp, fmt, ...) \
>          xfs_printk_index_wrap(KERN_CRIT, mp, fmt, ##__VA_ARGS__)
> #define xfs_err(mp, fmt, ...) \
>          xfs_printk_index_wrap(KERN_ERR, mp, fmt, ##__VA_ARGS__)
> .....
>
> IOWs, we define the level value directly in these macros, they
> aren't spread throughout the code. Hence we should be able to use
> some preprocessor string concatenation magic here to get rid of the
> kstrtoint() call altogether.
Yes，I adopted a simple but not intuitive way to fix it,
your suggestion is more clear :). v2 will be send after
got your review opinion of the first patch.

Have a good day :)
Xuenan
>   extern __printf(3, 4)
> -void xfs_printk_level(const char *kern_level, const struct xfs_mount *mp,
> -                        const char *fmt, ...);
> +void xfs_printk_level(const char *kern_level, const int log_level,
> +			const struct xfs_mount *mp, const char *fmt, ...);
>
>   define xfs_printk_index_wrap(level, mp, fmt, ...)         \
>   ({                                                              \
> -        printk_index_subsys_emit("%sXFS%s: ", kern_level, fmt); \
> -        xfs_printk_level(kern_level, mp, fmt, ##__VA_ARGS__);   \
> +        printk_index_subsys_emit("%sXFS%s: ", KERN_##level, fmt); \
> +        xfs_printk_level(KERN_##level, LOGLEVEL_##level mp, fmt, ##__VA_ARGS__);   \
>   })
>   #define xfs_emerg(mp, fmt, ...) \
> -        xfs_printk_index_wrap(KERN_EMERG, mp, fmt, ##__VA_ARGS__)
> +        xfs_printk_index_wrap(EMERG, mp, fmt, ##__VA_ARGS__)
>   #define xfs_alert(mp, fmt, ...) \
> -        xfs_printk_index_wrap(KERN_ALERT, mp, fmt, ##__VA_ARGS__)
> -        xfs_printk_index_wrap(ALERT, mp, fmt, ##__VA_ARGS__)
>   #define xfs_crit(mp, fmt, ...) \
> -        xfs_printk_index_wrap(KERN_CRIT, mp, fmt, ##__VA_ARGS__)
> -        xfs_printk_index_wrap(CRIT, mp, fmt, ##__VA_ARGS__)
>   #define xfs_err(mp, fmt, ...) \
> -       xfs_printk_index_wrap(KERN_ERR, mp, fmt, ##__VA_ARGS__)
> -       xfs_printk_index_wrap(ERR, mp, fmt, ##__VA_ARGS__)
> ....
>
> Then xfs_printk_level() is passed the log level as an integer value
> at runtime - the compiler does is all for us - and the code
> is then simply:
>
> 	if (log_level < LOGLEVEL_ERR &&
> 	    xfs_error_level >= XFS_ERRLEVEL_HIGH)
> 		xfs_stack_trace();
>
> Cheers,
>
> Dave.

