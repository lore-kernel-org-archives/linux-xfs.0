Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.89.141.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795065850;
	b=WVcoqzNjdtF171AniYQPhukiXAmZ0zmxrJyA+UgMeVYQzDD1brHJgjqKd9vk+TRpjHMz
	 yyC2gRnRtCdTK8JIGeOYGZNvBylY+chXpg+JGCJQS4NtzEY+y4c6l9JnP6i6cZ3Klskk+
	 6vtdnam3h5HqFQWKjr1OA7j8/FaJ+WTff56e66BkxXz1Eo/Up1bitufgf6FGNRQU0MZFS
	 9/kjA8YWQQ+uwWj8sa+mcOvN25OcTTBsZwyuJEcLBhQBrWOMP8xWgVhQH7bicNvj+zlXj
	 pNzGZVce1dwfoltaicWKOpHn63ZZHtMmPHduN/IcgoZYakZabRvYijAoS7X1a7Fex2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795065850;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:Sender;
	bh=4wIPBSNjEoWaDOrCHG3/HEZVU2V/dMehfnugzAp7piY=;
	b=gUOzS6gIvkvy/YE9lSFm9kAtiIU9DUh+mNYp0EJOM+zJE16NyXY137SOBf0QsvchVxEb
	 UnpccoEDHV7lms5WNroJw1k7OboDkzRdUBKwfH2pDu0Qi6OzkH3WDTTInx53l0OBayhT+
	 r3eoE2bq1fuLIeO2EmpSR7sVjPKmenVrPXBtiFB6s3xt3qGZbiWyNQXkhLKiYuECnaW9D
	 ODmOzB2F2RxxQPFNMtzGD4kwJyR4khAV1nAP/IiqYeiQMpKUMEKqgbb9cttc1T54UnwQo
	 59FUboI5gc7/GDJ8CTf58UeHTEZqS7VZ+UCnqrszGTqLClle/xtEKP7KB0WCEoaDCkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zeniv.linux.org.uk;
	spf=none smtp.mailfrom=ftp.linux.org.uk;
	dkim=pass header.d=linux.org.uk header.i=@linux.org.uk header.a=rsa-sha256 header.s=zeniv-20220401 header.b=XTj4OJNT;
	arc=none smtp.remote-ip=62.89.141.173
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E7D606A325;
	Thu, 19 Nov 2026 05:24:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1E7D606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linux.org.uk header.i=@linux.org.uk header.a=rsa-sha256 header.s=zeniv-20220401 header.b=XTj4OJNT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4wIPBSNjEoWaDOrCHG3/HEZVU2V/dMehfnugzAp7piY=; b=XTj4OJNT5IuDqV/yIcnzKva4nx
	pocorNO75aqnFm9/1Ze9bHSwKOfz5CS4qaLbAtUnG13eC9jQJed2MGMyOeWGA3C4Zb6Es3Dg8EZqJ
	8O3GXDLjd7n4E+68EzDacDIjDIC/pXlb2rpz3kkFNt2pdRMiuDG5jFCy5tJJZRMrQJ1g1Supi6ilv
	8jzkSvOLaf4yvqj1FdnScIn03dupGsH/g5ozR/EgMqAQZbnhAFd/n0pmpOM26Qp1zPMkmnHeOTQlm
	l5+iRyWJ8N1Wbkl9GJhAZqkw141ykK1gb1FM1Wk9sFq85ig69qtmoNp6dFkz8syOpiUBbRIX/NHR9
	Z1CRIKfQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTucV-00000005d11-45eR;
	Thu, 19 Nov 2026 05:23:40 +0000
Date: Thu, 19 Nov 2026 05:23:39 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Cai Xinchen <caixinchen1@huawei.com>
Cc: mic@digikod.net, gnoack@google.com, paul@paul-moore.com,
	brauner@kernel.org, jack@suse.cz, amir73il@gmail.com,
	andrii@kernel.org, apparmor@lists.ubuntu.com, ast@kernel.org,
	axboe@kernel.dk, bpf@vger.kernel.org, casey@schaufler-ca.com,
	cel@kernel.org, cem@kernel.org, chenxiaosong@chenxiaosong.com,
	code@tyhicks.com, corbet@lwn.net, Dai.Ngo@oracle.com,
	dakr@kernel.org, daniel@iogearbox.net, dhowells@redhat.com,
	dlemoal@kernel.org, dmitry.kasatkin@gmail.com,
	driver-core@lists.linux.dev, dsterba@suse.com,
	ecryptfs@vger.kernel.org, eddyz87@gmail.com, emil@etsalapatis.com,
	eric.snowberg@oracle.com, exfat@lists.linux.dev,
	georgia.garcia@canonical.com, gregkh@linuxfoundation.org,
	hch@lst.de, hirofumi@mail.parknet.co.jp, hyc.lee@gmail.com,
	ihor.solodrai@linux.dev, jlayton@kernel.org, jmorris@namei.org,
	johan@kernel.org, john.fastabend@gmail.com,
	john.johansen@canonical.com, jolsa@kernel.org, kpsingh@kernel.org,
	linkinjeon@kernel.org, linux-api@vger.kernel.org,
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-cifs@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
	linux-xfs@vger.kernel.org, liubaolin12138@163.com,
	martin.lau@linux.dev, mason@kernel.org,
	mathieu.desnoyers@efficios.com, matt@bobrowski.net,
	memxor@gmail.com, mhiramat@kernel.org, miklos@szeredi.hu,
	neil@brown.name, netfs@lists.linux.dev, ntfs@lists.linux.dev,
	okorniev@redhat.com, omosnacek@gmail.com,
	penguin-kernel@i-love.sakura.ne.jp, rafael@kernel.org,
	rdunlap@infradead.org, roberto.sassu@huawei.com,
	rostedt@goodmis.org, selinux@vger.kernel.org,
	senozhatsky@chromium.org, serge@hallyn.com, sj1557.seo@samsung.com,
	skhan@linuxfoundation.org, song@kernel.org,
	stephen.smalley.work@gmail.com, takedakn@nttdata.co.jp,
	tom@talpey.com, yonghong.song@linux.dev, yuezhang.mo@sony.com,
	zohar@linux.ibm.com, utilityemal77@gmail.com, lujialin4@huawei.com
Subject: Re: [PATCH -next -v4 01/17] fs: pass struct path to notify_change()
Message-ID: <20261119052339.GT989762@ZenIV>
References: <20261117150542.1169451-1-caixinchen1@huawei.com>
 <20261117150542.1169451-2-caixinchen1@huawei.com>
 <20261117183059.GP989762@ZenIV>
 <32b8d9c9-27d2-4da9-8618-ccfc44dee7a3@huawei.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32b8d9c9-27d2-4da9-8618-ccfc44dee7a3@huawei.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Wed, Nov 18, 2026 at 05:13:31PM +0800, Cai Xinchen wrote:
> On whether we want the mount references at all: they are not for NTFS.
> The path-based LSM hooks need them - Landlock's check walks the hierarchy
> up from the object with path->mnt->mnt_root and follow_up(), for every
> layer, and the idmap we pass has to be the one of the mount the path was
> checked in.

Then it won't be happy with overlayfs ones:
        upper_mnt = clone_private_mount(upperpath);
...
        upper_layer->mnt = upper_mnt;
in ovl_get_upper(),
                err = ovl_get_upper(sb, ofs, &layers[0], &ctx->upper);
in ovl_fill_super_creds()
combined with
static inline struct vfsmount *ovl_upper_mnt(struct ovl_fs *ofs)
{
        return ofs->layers[0].mnt;
}

mean that the mount you get won't be attached to anything.  How (un)happy
would landlock be with that?
