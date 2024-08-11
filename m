Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE402E3FE;
	Sun, 11 Aug 2024 08:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723364277; cv=none; b=J054njSLe7QKfKfG8rbKYnOIEY03hQ1DRWJ2Cxsnb9HkfG5BqBU9mh96Fc6K5RG3St+yZ0HJHw8qSg7VEqJjocf4E9BZyIgoSzKmFDJQIokcGfCryuu6NKiDVo4yATdJhcizHugvs5scNv5htU//weh8UM7OlMy5q4+2Vux3XFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723364277; c=relaxed/simple;
	bh=dYmk/v4GcwMNGyJcnCZCnhULAdndPcrBuDC//BgL4zA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AMXVXYdemyJpuihE17N3E2ufkHkscfmPsDFc5Ls3pHLuxOL7i68sMlB+9Wnun9yS4LYPd+I43gXCz+8F1G3kgtpl37P5+JDuGbw+vQK9qt2NGUTMps/0jJuqo0Ehwu8H9XX8c7MwysL9ScCW3CzVQ/2tu36AG8Pg9e5t8aHLWyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iXnyscKj; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iXnyscKj"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-52f025ab3a7so4315616e87.2;
        Sun, 11 Aug 2024 01:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723364274; x=1723969074; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/0ChP9IwL7YQBex/oGiDrTwaSzIWU+Wsc1zQ50EPWhk=;
        b=iXnyscKjwry3FefxvFAE0ZaH4Q1Dfx3EhDyaVinnenOYJaR3qh/J5e72iA+tOSigBU
         gzj+7fdRV4+b2MV7OVkv6BWd/wp7gUZc8saLJ3fVS4wXZr305wmcdfb8bM1mLQMnK5sL
         7bjHZj2Z90cbpaUkcJRlcwCAgCNz6bzI+d3aA5oMJNdse2kcyXrc0nPxEmH6QJikQa+C
         K+kgtpxG3A+yn8R7Rq6n710sH0TsHuasQebE8cOjD0F2BZ8WMBqk9+Qt+287QsC/oCyk
         uzsznSEynwPT93lLZ7xgbzZ6oQHz9vdEFhjA3fykLwq+v+sXS1TKQdUg7G27+ff1rLf7
         bruA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723364274; x=1723969074;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/0ChP9IwL7YQBex/oGiDrTwaSzIWU+Wsc1zQ50EPWhk=;
        b=P4+JoVTTq0cDd/terWLNSTRLHgj4hozl+NOUZ7nAWV6eMAh9YZo3MeCBvRcAY8Cgbb
         wr6Vhg8DJYvezhBULbsoy9wq4Bw7++Lvh9l9LCT0ZcZBz4c/Kt68/wz7JDauDoq/DIv9
         O1xuyykXG0/dKBSMM1q/KCIXT+4Tf4by/AP7UTjjbNNtfU8lUOB3gU2EmpTCx+ZQx5sO
         1rv9qCCPzyuzvHeakkqxQl5Ww0YkJtXBANpP5WJWOjmyTd+35KkpYFKDC1zWwGkazGoU
         R7qvkaYR0yCJ5KCdcTyA/YS5JjTX6Q9bPB1ZWwBVHSE5SrC23h99uYRU2fmaYrRnCK7S
         Sv/A==
X-Forwarded-Encrypted: i=1; AJvYcCXL0BTyYKaVwarRR3f9AAbMFU0bteF5ZAinvPn99shkIWueukxGiuXmAbf9xHzN8Ghtr7fpIV932NrMEIjlaq4FBDeOAjbq6rl8cy4m
X-Gm-Message-State: AOJu0YwcunuKkdySX7x5lBORyqhtoQWi0U22iv35k/9YNaOBs5w/qmNy
	6YLDy/6rIwpweBQXfyVu/8YMwZLkXx9E38IWqQVLz3ndCrsUOlpW7FHvnVxb
X-Google-Smtp-Source: AGHT+IFGpsASx6mXYu4SJ4KXMoaYKFNh+VL8MvgLhj8Qz3PgNJRLJKj81wmZTSIVlaf3cg4s65Nxjw==
X-Received: by 2002:a05:6512:3095:b0:52f:ccb0:9ea7 with SMTP id 2adb3069b0e04-530eea144e0mr3662492e87.60.1723364273051;
        Sun, 11 Aug 2024 01:17:53 -0700 (PDT)
Received: from [192.168.68.110] (c83-253-44-175.bredband.tele2.se. [83.253.44.175])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53200eb3ebcsm402417e87.11.2024.08.11.01.17.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Aug 2024 01:17:52 -0700 (PDT)
Message-ID: <4697de37-a630-402f-a547-cc4b70de9dc3@gmail.com>
Date: Sun, 11 Aug 2024 10:17:50 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: XFS mount timeout in linux-6.9.11
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Chandan Babu R <chandan.babu@oracle.com>, "Darrick J. Wong"
 <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>
References: <71864473-f0f7-41c3-95f2-c78f6edcfab9@gmail.com>
 <ZraeRdPmGXpbRM7V@dread.disaster.area>
 <252d91e2-282e-4af4-b99b-3b8147d98bc3@gmail.com>
 <ZrfzsIcTX1Qi+IUi@dread.disaster.area>
Content-Language: en-US
From: Anders Blomdell <anders.blomdell@gmail.com>
In-Reply-To: <ZrfzsIcTX1Qi+IUi@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2024-08-11 01:11, Dave Chinner wrote:
> On Sat, Aug 10, 2024 at 10:29:38AM +0200, Anders Blomdell wrote:
>>
>>
>> On 2024-08-10 00:55, Dave Chinner wrote:
>>> On Fri, Aug 09, 2024 at 07:08:41PM +0200, Anders Blomdell wrote:
>>>> With a filesystem that contains a very large amount of hardlinks
>>>> the time to mount the filesystem skyrockets to around 15 minutes
>>>> on 6.9.11-200.fc40.x86_64 as compared to around 1 second on
>>>> 6.8.10-300.fc40.x86_64,
>>>
>>> That sounds like the filesystem is not being cleanly unmounted on
>>> 6.9.11-200.fc40.x86_64 and so is having to run log recovery on the
>>> next mount and so is recovering lots of hardlink operations that
>>> weren't written back at unmount.
>>>
>>> Hence this smells like an unmount or OS shutdown process issue, not
>>> a mount issue. e.g. if something in the shutdown scripts hangs,
>>> systemd may time out the shutdown and power off/reboot the machine
>>> wihtout completing the full shutdown process. The result of this is
>>> the filesystem has to perform recovery on the next mount and so you
>>> see a long mount time because of some other unrelated issue.
>>>
>>> What is the dmesg output for the mount operations? That will tell us
>>> if journal recovery is the difference for certain.  Have you also
>>> checked to see what is happening in the shutdown/unmount process
>>> before the long mount times occur?
>> echo $(uname -r) $(date +%H:%M:%S) > /dev/kmsg
>> mount /dev/vg1/test /test
>> echo $(uname -r) $(date +%H:%M:%S) > /dev/kmsg
>> umount /test
>> echo $(uname -r) $(date +%H:%M:%S) > /dev/kmsg
>> mount /dev/vg1/test /test
>> echo $(uname -r) $(date +%H:%M:%S) > /dev/kmsg
>>
>> [55581.470484] 6.8.0-rc4-00129-g14dd46cf31f4 09:17:20
>> [55581.492733] XFS (dm-7): Mounting V5 Filesystem e2159bbc-18fb-4d4b-a6c5-14c97b8e5380
>> [56048.292804] XFS (dm-7): Ending clean mount
>> [56516.433008] 6.8.0-rc4-00129-g14dd46cf31f4 09:32:55
> 
> So it took ~450s to determine that the mount was clean, then another
> 450s to return to userspace?
Yeah, that aligns with my userspace view that the mount takes 15 minutes.
> 
>> [56516.434695] XFS (dm-7): Unmounting Filesystem e2159bbc-18fb-4d4b-a6c5-14c97b8e5380
>> [56516.925145] 6.8.0-rc4-00129-g14dd46cf31f4 09:32:56
>> [56517.039873] XFS (dm-7): Mounting V5 Filesystem e2159bbc-18fb-4d4b-a6c5-14c97b8e5380
>> [56986.017144] XFS (dm-7): Ending clean mount
>> [57454.876371] 6.8.0-rc4-00129-g14dd46cf31f4 09:48:34
> 
> Same again.
> 
> Can you post the 'xfs_info /mnt/pt' for that filesystem?
# uname -r ; xfs_info /test
6.8.0-rc4-00128-g8541a7d9da2d
meta-data=/dev/mapper/vg1-test isize=512    agcount=8, agsize=268435455 blks
          =                       sectsz=4096  attr=2, projid32bit=1
          =                       crc=1        finobt=1, sparse=0, rmapbt=0
          =                       reflink=1    bigtime=0 inobtcount=0 nrext64=0
data     =                       bsize=4096   blocks=2147483640, imaxpct=20
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
          =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
>> And rebooting to the kernel before the offending commit:
>>
>> [   60.177951] 6.8.0-rc4-00128-g8541a7d9da2d 10:23:00
>> [   61.009283] SGI XFS with ACLs, security attributes, realtime, scrub, quota, no debug enabled
>> [   61.017422] XFS (dm-7): Mounting V5 Filesystem e2159bbc-18fb-4d4b-a6c5-14c97b8e5380
>> [   61.351100] XFS (dm-7): Ending clean mount
>> [   61.366359] 6.8.0-rc4-00128-g8541a7d9da2d 10:23:01
>> [   61.367673] XFS (dm-7): Unmounting Filesystem e2159bbc-18fb-4d4b-a6c5-14c97b8e5380
>> [   61.444552] 6.8.0-rc4-00128-g8541a7d9da2d 10:23:01
>> [   61.459358] XFS (dm-7): Mounting V5 Filesystem e2159bbc-18fb-4d4b-a6c5-14c97b8e5380
>> [   61.513938] XFS (dm-7): Ending clean mount
>> [   61.524056] 6.8.0-rc4-00128-g8541a7d9da2d 10:23:01
> 
> Yeah, that's what I'd expect to see.
> 
> But, hold on, the kernel version you are testing is apparently is in
> the middle of 6.8-rc4. This commit wasn't merged until 6.9-rc1 and
> there were no XFS changes merged in the between 6.8-rc3 and 6.8-rc6.
If I read the logs correctly, these commited xfs changes were based on the
6.8-rc4, and not rebased to 6.8.0 (which is totally OK, but confusing at
times, after doing some kernel bisects I have stopped thinking about it).

> So as the bisect is walking back in time through the XFS commits,
> the base kernel is also changing. Hence there's a lot more change
> in the kernel being tested by each bisect step than just the XFS
> commits, right?
Yes, it's a binary search through the highly convoluted graph of commits.
It always suprises me how few of these "random" points fails miserably
during a bisect (in this particular case none), so kudos to all linux
maintainers to keep things so sane!

> 
> This smells like a bisect jumping randomly backwards in time as it
> lands inside merges rather than bisecting the order in which commits
> were merged into the main tree. Can you post the full bisect log?
git bisect start
# status: waiting for both good and bad commits
# bad: [73f3c33036904bada1b9b6476a883b1a966440cc] Linux 6.9.11
git bisect bad 73f3c33036904bada1b9b6476a883b1a966440cc
# status: waiting for good commit(s), bad commit known
# good: [a0c69a570e420e86c7569b8c052913213eef2b45] Linux 6.8.10
git bisect good a0c69a570e420e86c7569b8c052913213eef2b45
# good: [e8f897f4afef0031fe618a8e94127a0934896aba] Linux 6.8
git bisect good e8f897f4afef0031fe618a8e94127a0934896aba
# bad: [fe46a7dd189e25604716c03576d05ac8a5209743] Merge tag 'sound-6.9-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
git bisect bad fe46a7dd189e25604716c03576d05ac8a5209743
# good: [9187210eee7d87eea37b45ea93454a88681894a4] Merge tag 'net-next-6.9' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next
git bisect good 9187210eee7d87eea37b45ea93454a88681894a4
# good: [119b225f01e4d3ce974cd3b4d982c76a380c796d] Merge tag 'amd-drm-next-6.9-2024-03-08-1' of https://gitlab.freedesktop.org/agd5f/linux into drm-next
git bisect good 119b225f01e4d3ce974cd3b4d982c76a380c796d
# good: [70ef654469b371d0a71bcf967fa3dcbca05d4b25] Merge tag 'efi-next-for-v6.9' of git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi
git bisect good 70ef654469b371d0a71bcf967fa3dcbca05d4b25
# bad: [8403ce70be339d462892a2b935ae30ee52416f92] Merge tag 'mfd-next-6.9' of git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd
git bisect bad 8403ce70be339d462892a2b935ae30ee52416f92
# bad: [480e035fc4c714fb5536e64ab9db04fedc89e910] Merge tag 'drm-next-2024-03-13' of https://gitlab.freedesktop.org/drm/kernel
git bisect bad 480e035fc4c714fb5536e64ab9db04fedc89e910
# bad: [57982d6c835a71da5c66e6090680de1adf6e736a] xfs: consolidate btree ptr checking
git bisect bad 57982d6c835a71da5c66e6090680de1adf6e736a
# good: [0b8686f19879d896bbe2d3e893f433a08160452d] xfs: separate the marking of sick and checked metadata
git bisect good 0b8686f19879d896bbe2d3e893f433a08160452d
# good: [1a9d26291c68fbb8f8d24f9f694b32223a072745] xfs: store the btree pointer length in struct xfs_btree_ops
git bisect good 1a9d26291c68fbb8f8d24f9f694b32223a072745
# good: [802f91f7b1d535ac975e2d696bf5b5dea82816e7] xfs: fold xfs_bmbt_init_common into xfs_bmbt_init_cursor
git bisect good 802f91f7b1d535ac975e2d696bf5b5dea82816e7
# good: [4bfb028a4c00d0a079a625d7867325efb3c37de2] xfs: remove the btnum argument to xfs_inobt_count_blocks
git bisect good 4bfb028a4c00d0a079a625d7867325efb3c37de2
# bad: [fbeef4e061ab28bf556af4ee2a5a9848dc4616c5] xfs: pass a 'bool is_finobt' to xfs_inobt_insert
git bisect bad fbeef4e061ab28bf556af4ee2a5a9848dc4616c5
# good: [8541a7d9da2dd6e44f401f2363b21749b7413fc9] xfs: split xfs_inobt_insert_sprec
git bisect good 8541a7d9da2dd6e44f401f2363b21749b7413fc9
# bad: [14dd46cf31f4aaffcf26b00de9af39d01ec8d547] xfs: split xfs_inobt_init_cursor
git bisect bad 14dd46cf31f4aaffcf26b00de9af39d01ec8d547
# first bad commit: [14dd46cf31f4aaffcf26b00de9af39d01ec8d547] xfs: split xfs_inobt_init_cursor

/Anders

