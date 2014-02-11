Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3BFC27F50
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 19:23:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 276408F8050
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 17:23:43 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id Unpi9NEp8oQCTjME for
	<xfs@oss.sgi.com>; Mon, 10 Feb 2014 17:23:41 -0800 (PST)
Message-ID: <52F97B3E.9060608@cn.fujitsu.com>
Date: Tue, 11 Feb 2014 09:22:06 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: btrfs/004: fix to make test really work
References: <1392034256-2412-1-git-send-email-wangshilong1991@gmail.com>
	<52F925EA.20600@fb.com>
In-Reply-To: <52F925EA.20600@fb.com>
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
To: Josef Bacik <jbacik@fb.com>
Cc: Wang Shilong <wangshilong1991@gmail.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Hi Josef,

On 02/11/2014 03:18 AM, Josef Bacik wrote:
>
>
> On 02/10/2014 07:10 AM, Wang Shilong wrote:
>> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>
>> So i was wandering why test 004 could pass my previous wrong
>> kernel patch while it defenitely should not.
>>
>> By some debugging, i found here perl script is wrong, we did not
>> filter out anything and this unit test did not work acutally.so
>> it came out we will never fail this test.
>>
>
> So now with this patch I'm failing it, is there some btrfs patch I 
> need to make it not fail or is it still not supposed to fail normally 
> and is this patch broken?  Thanks,
You should not have updated my previous patch(Btrfs: switch to 
btrfs_previous_extent_item()) when you fail this test.
I update your latest btrfs-next which has updated my previous patch and 
it can pass this case, did you miss that?

Thanks,
Wang
>
> Josef
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
