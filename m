Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.217
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795699673;
	b=1gKlcKlbH+JCJk2jPi4oXQQ3zb72vdBHvr8psUp/tGDYO25Nf+wE5e6xnpQei98GklmV
	 VTWW2d04yxpT0uEAAWHZsz4JM6MNyCGw8t22TNF+M2iojjfHkXC+ziaRbtK7q+4SpPUno
	 f8BDhpfn5qjW62FrK12Vu1yebWnbQmplbaXxa28zMi0l5DZ23cH/x2xX0gofxSDtO8pVj
	 NtQ7MBQUe2kY6npZIIp9zTU94BT3n899/zWU7HfmLFhy4Kly0Zlcce5yL3yLZ/oV/7eyJ
	 aaUxYU5nTsi7nalNsL3QnqDGJcqoMeEshwfoO8EWoBBDYqBLCXd5IqhOky1PhTEKzuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795699673;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
	bh=gzzgXOgo3+SNm0ByCjOvIm/1n5ybZt8er0jBZ3680yc=;
	b=eXdF9XV9OPiJgW1PhtOjNpnxNGH5pNtLUQ4L0OufmplxHKc9h38LgojsIOCyoVJrUqMM
	 GIIdCdRnm/yT/p7Aw55oTMSpvio+Wt+Bbcg+GOwvmwjQ/jAJEhPJzbLHmJmTs4y/l+CmP
	 9OcST+yVfgLhlxUYST7ttrqTpb5U51UVCvuilm9TXBUdkYprBVhJdJj1tMbOjKGCFaOeP
	 ZMMok8in4HNHOwNtevIkjBgaNiUnUOy6FIzv6twHy/JHbyZA1LCF9L1n/9cb8SUBTqT87
	 oMyv1sY9278/6EybPKiu+FiLE+DXcrIO6+c1nfYUoQ0K/YYRkOkY+s9IqPRvOsZ4WRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=11fuKA0Q;
	arc=none smtp.remote-ip=113.46.200.217
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDEA606A31C;
	Thu, 26 Nov 2026 13:27:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9EDEA606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=11fuKA0Q
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=gzzgXOgo3+SNm0ByCjOvIm/1n5ybZt8er0jBZ3680yc=;
	b=11fuKA0QNmqBcJC+Z7+EDBDEdopqwlPjiHPaNdUAff+L4Rfg5ecopOB7c41g4dYkKVWnsOz+7
	diR70qy0hMLD9NrzKzTwcexrrEJpSqnu718+skXXx/Va432+IohJ+HmaImsfXw3HGXjPhG8bwg/
	N0Q+ahJUMGyTnAubGLSqDU0=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4jZy4b4NSrzcZxn;
	Thu, 26 Nov 2026 21:26:39 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id 2EF9B4058C;
	Thu, 26 Nov 2026 21:27:47 +0800 (CST)
Received: from [10.67.110.140] (10.67.110.140) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 26 Nov 2026 21:27:38 +0800
Message-ID: <2e7397bb-14fa-4d29-bfb5-620495a40245@huawei.com>
Date: Thu, 26 Nov 2026 21:27:37 +0800
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next -v4 01/17] fs: pass struct path to notify_change()
To: Al Viro <viro@zeniv.linux.org.uk>
CC: <mic@digikod.net>, <gnoack@google.com>, <paul@paul-moore.com>,
	<brauner@kernel.org>, <jack@suse.cz>, <amir73il@gmail.com>,
	<andrii@kernel.org>, <apparmor@lists.ubuntu.com>, <ast@kernel.org>,
	<axboe@kernel.dk>, <bpf@vger.kernel.org>, <casey@schaufler-ca.com>,
	<cel@kernel.org>, <cem@kernel.org>, <chenxiaosong@chenxiaosong.com>,
	<code@tyhicks.com>, <corbet@lwn.net>, <Dai.Ngo@oracle.com>,
	<dakr@kernel.org>, <daniel@iogearbox.net>, <dhowells@redhat.com>,
	<dlemoal@kernel.org>, <dmitry.kasatkin@gmail.com>,
	<driver-core@lists.linux.dev>, <dsterba@suse.com>,
	<ecryptfs@vger.kernel.org>, <eddyz87@gmail.com>, <emil@etsalapatis.com>,
	<eric.snowberg@oracle.com>, <exfat@lists.linux.dev>,
	<georgia.garcia@canonical.com>, <gregkh@linuxfoundation.org>, <hch@lst.de>,
	<hirofumi@mail.parknet.co.jp>, <hyc.lee@gmail.com>,
	<ihor.solodrai@linux.dev>, <jlayton@kernel.org>, <jmorris@namei.org>,
	<johan@kernel.org>, <john.fastabend@gmail.com>,
	<john.johansen@canonical.com>, <jolsa@kernel.org>, <kpsingh@kernel.org>,
	<linkinjeon@kernel.org>, <linux-api@vger.kernel.org>,
	<linux-block@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
	<linux-cifs@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-integrity@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-nfs@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <linux-unionfs@vger.kernel.org>,
	<linux-xfs@vger.kernel.org>, <liubaolin12138@163.com>,
	<martin.lau@linux.dev>, <mason@kernel.org>, <mathieu.desnoyers@efficios.com>,
	<matt@bobrowski.net>, <memxor@gmail.com>, <mhiramat@kernel.org>,
	<miklos@szeredi.hu>, <neil@brown.name>, <netfs@lists.linux.dev>,
	<ntfs@lists.linux.dev>, <okorniev@redhat.com>, <omosnacek@gmail.com>,
	<penguin-kernel@i-love.sakura.ne.jp>, <rafael@kernel.org>,
	<rdunlap@infradead.org>, <roberto.sassu@huawei.com>, <rostedt@goodmis.org>,
	<selinux@vger.kernel.org>, <senozhatsky@chromium.org>, <serge@hallyn.com>,
	<sj1557.seo@samsung.com>, <skhan@linuxfoundation.org>, <song@kernel.org>,
	<stephen.smalley.work@gmail.com>, <takedakn@nttdata.co.jp>, <tom@talpey.com>,
	<yonghong.song@linux.dev>, <yuezhang.mo@sony.com>, <zohar@linux.ibm.com>,
	<utilityemal77@gmail.com>, <lujialin4@huawei.com>
References: <20261117150542.1169451-1-caixinchen1@huawei.com>
 <20261117150542.1169451-2-caixinchen1@huawei.com>
 <20261117183059.GP989762@ZenIV>
 <32b8d9c9-27d2-4da9-8618-ccfc44dee7a3@huawei.com>
 <20261119052339.GT989762@ZenIV>
Content-Language: en-US
From: Cai Xinchen <caixinchen1@huawei.com>
In-Reply-To: <20261119052339.GT989762@ZenIV>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 whupemk100010.china.huawei.com (7.152.184.41)

oh, I get it.

I think it would be better to use a new function, such as 
notify_change_internal，
to bypass this upperpath check, while retaining the inode check.

ovl_do_notify_change
->notify_change_internal(...)
     ->do_notify_change(..., true)
          ->security_inode_setattr
              if (!internal)
                  security_path_setattr

But this leads me to possibly needing to split the inode LSM hooks and 
the path
LSM hooks.

On 11/19/2026 1:23 PM, Al Viro wrote:
> On Wed, Nov 18, 2026 at 05:13:31PM +0800, Cai Xinchen wrote:
>> On whether we want the mount references at all: they are not for NTFS.
>> The path-based LSM hooks need them - Landlock's check walks the hierarchy
>> up from the object with path->mnt->mnt_root and follow_up(), for every
>> layer, and the idmap we pass has to be the one of the mount the path was
>> checked in.
> Then it won't be happy with overlayfs ones:
>          upper_mnt = clone_private_mount(upperpath);
> ...
>          upper_layer->mnt = upper_mnt;
> in ovl_get_upper(),
>                  err = ovl_get_upper(sb, ofs, &layers[0], &ctx->upper);
> in ovl_fill_super_creds()
> combined with
> static inline struct vfsmount *ovl_upper_mnt(struct ovl_fs *ofs)
> {
>          return ofs->layers[0].mnt;
> }
>
> mean that the mount you get won't be attached to anything.  How (un)happy
> would landlock be with that?
