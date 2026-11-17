Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.89.141.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794940487;
	b=J0cHa47DTqp3i522I0T++g1NWOIUjECmzzXle5gQE8F7nXBB+1CMeutgBXEN/Kkhl2iW
	 LTFfQWA3Or9Q/MKJBvcIio/46QtA9yM0yVXt4yszVQKrnFuAn2lytfi6F7fpUAZ0YRTK9
	 FM2HyB/49vGkEDzp56hdXBcjV6ab4sQDMm+4YYN955QGXMeVK2X9zhnAwo4GDDN8cl9bC
	 /vhBECA7NEm0wwIgtG4NpzTe9ESfqjVdMlb9i3b5BVGLPmsAn3cs11RathtPcWvBoRz6P
	 1cSNOb+L4XHuOJEFQipHSQtez29ti72kkGZEv9Mltv0jrt2+6CFKXpEGyEOe+dVqidw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794940487;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:Sender;
	bh=bCqN24fhlU/vFMOwXW3CAsd4iYMzraL5WEN3Qxc6Tj0=;
	b=ClK8Z7wjZ+3PzTokwV0IE6KdhBxJ293fT0Q/AMQXbbZvn9RB7XF0eHvvoqIl5uadFE0c
	 fRyJmc6nuIQuxWP9T2LBX7Mmp7s/qRZ1SMqFuhB2lmXK6RIbKFr8pEWJNu0SisaBG6D7g
	 G7Zc3zE+neMfmbaYVnR32xsIBPzfaUgq8zPvGMxC+ti4Zh6g9bSok/PB44KA9d8Azvjz/
	 PA4bNm9RxhylZbdeptOljsU7xLGrpYD8qvfTomAJzdjK2J1gwClxdxihDH/K0p/r61mlh
	 iUqxOA0ZKqn4PbnWtQry4k6vZHcLqJt7c6/Gt4QiKgcq3dbWQ1H4JqdkvC+6dU+6TBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zeniv.linux.org.uk;
	spf=none smtp.mailfrom=ftp.linux.org.uk;
	dkim=pass header.d=linux.org.uk header.i=@linux.org.uk header.a=rsa-sha256 header.s=zeniv-20220401 header.b="b4xkjYo/";
	arc=none smtp.remote-ip=62.89.141.173
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E3E606A32C;
	Tue, 17 Nov 2026 18:34:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75E3E606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.a=rsa-sha256 header.s=zeniv-20220401 header.b=b4xkjYo/
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bCqN24fhlU/vFMOwXW3CAsd4iYMzraL5WEN3Qxc6Tj0=; b=b4xkjYo/irgxqXEeyvuS6RET2Q
	Whn8EonVLrp0V9ItlQ0voD1HDID1cvVEpP7A3CfJTg6G51OusAOucbJ9vMuC+hwavs9aqumbwV1z6
	uJCyMBPN4/7baj9nmdxiHNVKPt3jZOckq5vWJ+ySpASrwVz868UZS2e41eOZNnw1goYX5RDcNyRPP
	rTVU/SAULfsU7iich6yV29MIYYq+nZApu6guoXj8p4xIjatJ2U6mzBQmkx8xbXMRyf4N7JaVOLGCI
	E/e2O0QyfWY/guzEqwfbYXpbbPJldSiQm8KAz4X+FlxeHQW6Crnmj63J9lAWOshzxFC3oZeKQshJ8
	4NuPWfgw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xTO0u-00000002MNT-3B2S;
	Tue, 17 Nov 2026 18:34:40 +0000
Date: Tue, 17 Nov 2026 18:34:40 +0000
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
Message-ID: <20261117183440.GQ989762@ZenIV>
References: <20261117150542.1169451-1-caixinchen1@huawei.com>
 <20261117150542.1169451-2-caixinchen1@huawei.com>
 <20261117183059.GP989762@ZenIV>
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
In-Reply-To: <20261117183059.GP989762@ZenIV>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Tue, Nov 17, 2026 at 06:30:59PM +0000, Al Viro wrote:
> On Tue, Nov 17, 2026 at 11:05:26PM +0800, Cai Xinchen wrote:
> 
> > +notify_change() and do_truncate() now take a const struct path * instead
> > +of a struct dentry *.  They use path->dentry, so callers that only have a
> > +dentry must provide a struct path.  struct iattr has a new ia_path member,
> > +which notify_change() sets for the duration of the call; it must not be
> > +stored beyond that.  Filesystems that forward a change to another inode
> > +can use notify_change_target() to update the target dentry while keeping
> > +the caller-supplied path in ia_path.
> 
> That needs a bit along the lines of "path MUST be consistent - don't combine
> a dentry from one filesystem with mount of another".  All in-kernel callers
> might have appropriate struct mount references on hand, but for out-of-tree
> code that might be not true and we'd better be upfront about the headache
> we are inflicting.
> 
> I'm not sure we really want to provide those mount references, TBH - it does
> add a constraint not just on out-of-tree callers, but upon the future uses
> in the kernel.  If NTFS is the only reason... ugh.

Incidentally, will the mount reference you are supplying in case of overlayfs
upper layer be any good for LSM users?
