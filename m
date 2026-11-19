Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.224
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059983;
	b=QYt4A8VEMNU2nDiWBjzUQ7PEbKtbfaSd2D4AekzpAzCU4GvL+3+YoXkX6+g0vEvwzx9+
	 Gf6lw0N0abtxb2Sid24/YKLVoBglkGEbv2POOON+Q7aAVGSfKg9ipmcJmRbOpm3XJ2CtY
	 t++GrXGtHF4cXHxc0FSsPR+SYj1HwhQ9QbTjrgYGKPh4UOOADFtTAxrvZ3u0Rb9QqfgkB
	 PfGCHwT1lM5PNwto0BLkoJcmgRqw9v4/4dgdihNEnKQlnpVfInOiyXrfzhDgCMhbWGDkC
	 AUG0icYznYOT6p0xUdjrgX3PLZmeYtfAHEC8bVZkqoTmtiItMDEItwmMfXs2Bz9Xj0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059983;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
	bh=OAbbp57riKGI1fZlq88CcOSg3koPqPRG3juTd/UX3uo=;
	b=QaeNr5+xsg9u+Rf7J/e/9IDeo3uOfhzzOj8w1nwr4kfUk9+lX7pcWpnvwf4ki60o2Vxp
	 waauT8pMaEmjFG6oMJwkIKgMuSK4SEPEIM8f5tBySDtSu/BZkC8dN9tQKto/F2a/WhWkQ
	 puw01L5uYn+S3+hb4TM5Teq86DtGgKLpSqcsSIYtXIBD5Q+qNJAHTIUqiDB4DSXkfuKyu
	 5xn8Z8hc3h6miOabyk83/zB8L5KNR1CbXYBK28HyMVCaAazkHH4TkK7kTzGv9MwsvfIMh
	 o4flW/mnYDnxoiEyKn+x5Hu2XrwY2rwjlIabDzSvd5ZVIdlZDgBmE6N2ArXhodyDHeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b="V/52GJjf";
	arc=none smtp.remote-ip=113.46.200.224
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA36606A325;
	Thu, 19 Nov 2026 03:46:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3CA36606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=V/52GJjf
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=OAbbp57riKGI1fZlq88CcOSg3koPqPRG3juTd/UX3uo=;
	b=V/52GJjfwvVK8DnDIvM5IQVRHWD6bWwP9aQgdIQW3zyiANrSaj0DY2j7nFjPaV7CdoJkRPEs9
	j5P3307aBbCQKc9UtkmeUFvURRjxT+IUgrgDq+974N8dU9cb6StPqSQAXioAda0lAeeDVSXW/cF
	zoa53Mrhki2F1QPx2mEV1j0=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4jVPWm3pc4z1cyPH;
	Thu, 19 Nov 2026 11:45:56 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id C65134058E;
	Thu, 19 Nov 2026 11:46:16 +0800 (CST)
Received: from [10.67.110.140] (10.67.110.140) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 19 Nov 2026 11:46:09 +0800
Message-ID: <9787bc85-5b1c-4f13-9b0c-cd027548efa0@huawei.com>
Date: Thu, 19 Nov 2026 11:46:07 +0800
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
Subject: Re: [PATCH -next -v4 02/17] LSM: pass struct path to the
 inode_setsecctx hook
To: Christian Brauner <brauner@kernel.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, <mic@digikod.net>, <gnoack@google.com>,
	<paul@paul-moore.com>, <jack@suse.cz>, <amir73il@gmail.com>,
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
 <20261117150542.1169451-3-caixinchen1@huawei.com>
 <20261117184342.GR989762@ZenIV> <20261118001641.GA1669148@ZenIV>
 <bdc22808-9f22-46f7-b42d-e6bd8e1eeaca@huawei.com>
 <20261118-nordlicht-badeort-daumen-813a1e9fd0b3@brauner>
Content-Language: en-US
From: Cai Xinchen <caixinchen1@huawei.com>
In-Reply-To: <20261118-nordlicht-badeort-daumen-813a1e9fd0b3@brauner>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 whupemk100010.china.huawei.com (7.152.184.41)

o, you are right, dentry is borned *self-parented*, and 
d_alloc()/d_alloc_parallel allocate
from parent->d_sb, __d_move only re-parent withon on sb. So 
dget_parent() cannot
leave the sb.

On 11/18/2026 5:35 PM, Christian Brauner wrote:
> On Wed, Nov 18, 2026 at 04:59:29PM +0800, Cai Xinchen wrote:
>> There are two places that violate (1), both introduced by this series of
>> patches in ksmbd:
>>
>> smb2_parent_compressed() and smb_inherit_dacl() pair the directory entry
>> returned by dget_parent()
>>
>> with path->mnt, and problems arise once that directory entry becomes the
>> root of its mount point.
> No, (1) holds there. dget_parent() never leaves the superblock so the
> parent has the same ->d_sb as path->dentry.
>
> What happens at the root of a mount is that the parent isn't below
> path->mnt->mnt_root anymore. That's a different property and struct path
> doesn't guarantee that (open_by_handle_at(), nfsd with
> no_subtree_check). So there's nothing to fix for (1) in those two.
