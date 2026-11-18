Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.223
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794992392;
	b=e0YMyep6eJwCCQBU9a/9LeYja2WYaSPNUnD2B3aTOeLnJoWfFvhL4DQLOMSwg1AEMvur
	 lOb4SbTNRdtrBoj+PvMbM+3zEqqrdhTClguw7XofUYf4cQphQs2OJKf/3J8A7f97P4rAx
	 pbneEDxV1vtDZB3pWa/9sC5aMpd+PYEoaTgNElPxhSo3CzBFCcGPEQ5e+ELp+ZIl0S/aW
	 pbGkO9VP/gFYbOIHupiy2ShQsMlQWGXp+xdkaHsP8kUQlS/JsScP5Drypdxi51rdm+SjR
	 BmwnXEtXyXyj/XV8hXYWP4a7g+/hgwULRg/UXWaDcqHj/xl4Rz2FGBan4+/CpvX4K7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794992392;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
	bh=zDjwPIFBALJRu9G1JpFQxNCh37Ku2FGitfdnf5CWttU=;
	b=XgtlHz/XhptJpgOSFRInWECSMvdZl2+AsM95Yj11y7A/b29Js3+A70h6tddO2mtfo8um
	 R9zx/Jq1jk9rr1ypLrv0bQEMrNXP561sqk5wX/y75rrEmoImIzSyBp0T/wBsmXPqOBNCF
	 zWqa9yIPAeofnsjmowFhgyxBrPmj8oDvYgbZ8SnIvataqnpPdw7sCvVQd3NJtMI42F5cE
	 JPjKROiod3fvkkwgVA9CvDFq0Y6azPmrokS0JIYgMJL54uTbKg6hYFVOmrrbkOkObfVDP
	 p5SRbMEz4e8sWZqkXufYtwyskJOATRENeejQgrNUfi3oaq4dk6tPjjNSMqSIj9lE8TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=YG0f5s+2;
	arc=none smtp.remote-ip=113.46.200.223
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70493606A325;
	Wed, 18 Nov 2026 08:59:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70493606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=YG0f5s+2
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=zDjwPIFBALJRu9G1JpFQxNCh37Ku2FGitfdnf5CWttU=;
	b=YG0f5s+2kvHrKlKCN7CB4HY4p0LT+CaaaGw+BSvo7+/ssB/SQ9sM0FXb1MTh9BFkL9Mv7Wn3S
	BNOqmdVJd6x1gk7TjCfNf3D3ZpPYsdFv+Yf8GC5xj0argsiNrvpyQ++8NgtWzUN+FazgOOGwEZ0
	m7pnB1IrMWzbaj4bmorQi1I=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4jTwWs2RMwzmV6N;
	Wed, 18 Nov 2026 16:59:21 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id B45424048B;
	Wed, 18 Nov 2026 16:59:40 +0800 (CST)
Received: from [10.67.110.140] (10.67.110.140) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 18 Nov 2026 16:59:31 +0800
Message-ID: <bdc22808-9f22-46f7-b42d-e6bd8e1eeaca@huawei.com>
Date: Wed, 18 Nov 2026 16:59:29 +0800
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
 <20261117150542.1169451-3-caixinchen1@huawei.com>
 <20261117184342.GR989762@ZenIV> <20261118001641.GA1669148@ZenIV>
Content-Language: en-US
From: Cai Xinchen <caixinchen1@huawei.com>
In-Reply-To: <20261118001641.GA1669148@ZenIV>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 whupemk100010.china.huawei.com (7.152.184.41)

Sorry, this is a major issue. I checked the current state of the patchset

- fs/attr.c, fs/open.c, fs/inode.c, fs/utimes.c, fs/namei.c,
fs/coredump.c, drivers/block/loop.c: nd->path or file->f_path (in loop.c:
the f_path of the backing file, where file == NULL is intentional).

- drivers/base/devtmpfs.c: the mount point of the parent directory, 
which contains a directory entry that was just created or is about to be 
deleted.

- fs/cachefiles/xattr.c: cache->mnt, under which a directory entry is 
searched.

- fs/ecryptfs: ecryptfs_lower_path(), which is the mount point of the 
lower-level directory entry itself.

- fs/nfsd: exp->ex_path.mnt, which contains fh_dentry, a value decoded via
exportfs_decode_fh_raw(exp->ex_path.mnt,...), or exp->ex_path.dentry.

- fs/overlayfs: ovl_upper_mnt(ofs), which contains the actual 
upper-level directory entry.

There are two places that violate (1), both introduced by this series of 
patches in ksmbd:

smb2_parent_compressed() and smb_inherit_dacl() pair the directory entry 
returned by dget_parent()

with path->mnt, and problems arise once that directory entry becomes the 
root of its mount point.

I will fix these issues in v5 and ensure this invariant.

If you find any place where (1) still does not hold, please point it 
out, and I
will fix it.

On 11/18/2026 8:16 AM, Al Viro wrote:
> On Tue, Nov 17, 2026 at 06:43:42PM +0000, Al Viro wrote:
>> On Tue, Nov 17, 2026 at 11:05:27PM +0800, Cai Xinchen wrote:
>>> The inode_setsecctx hook and its security_inode_setsecctx() caller in
>>> fs/nfsd operate on a dentry even though both have a struct path
>>> available.  Pass a const struct path so that the coming conversion of the
>>> xattr helpers can be reflected in the implementations; for now SELinux
>>> and Smack keep passing path->dentry and &nop_mnt_idmap to
>>> __vfs_setxattr_locked().
>>>
>>> Also document in lsm_hook_defs.h what a struct path argument may be used
>>> for: it can be passed to VFS helpers taking a struct path, but nothing is
>>> guaranteed about path->mnt.
>> No, with the side of Hell, No.
>>
>>> + * Hooks that take a struct path argument: the VFS only sanctions passing
>>> + * the path to VFS helpers that take a struct path (e.g. notify_change());
>>> + * it makes no guarantees with regard to path->mnt, whose layout and
>>> + * implementation details are subject to change.  Implementations must
>>> + * not rely on its properties.
>> NAKed-by: Al Viro <viro@zeniv.linux.org.uk>
>>
>> If that kind of stuff actually does get passed to any existing hooks, we need
>> to fix that ASAP.  If not, consider that a blanket NAK on any patch series
>> that would introduce such.
>>
>> We are not going there.  At all.  "Must not rely on its properties" ==
>> "must make sure that no existing functions with struct path * arguments
>> ever have such malformed instances passed to them".  Which is not going
>> to be feasible to enforce.  And yes, that very much includes any VFS helpers.
> To elaborate a bit: correctness of quite a few places does depend upon the
> following invaraint:
> 	path->mnt->mnt_sb == path->dentry->d_sb		(1)
> for all struct path pointers they might possibly run into.  _Some_
> functions might _currently_ be safe to call with that constraint violated;
> there's neither a list of such functions nor any promise whatsoever that
> call that is currently safe in such conditions will remain safe at any
> later point.
>
> _IF_ you can guarantee that (1) is not violated, we have something to
> talk about; otherwise, don't call your object struct path and don't
> pass it to anything that expects to deal with struct path.
