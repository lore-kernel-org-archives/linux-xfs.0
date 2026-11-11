Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794362043;
	b=fui28UVR7CFru0guYDFAqZNcerdMfvNrENWXwUDZkfEHi+Cs0P2QTBHgDCDut2PkRa61
	 Lz0/raTdmsnU/G94qY1gQotZCvMg1tiEfxZ2jBJBRdlJyW+CwDZSLQ07MdZwPE4k92ePm
	 CgAKZsv5YWOJ2osNa/j90qDe0FGmlG5yuvmDPL2pnBTW3/BYLlD7AtdNIYCCNC2vEM2SP
	 nACDW9VbRISmO5HCZSmZ+iQmD+/aI4HiG2xfdNkuVPeIC9BY1525HzAC3TzHlp/e6inHj
	 yn5NiPhUPxtYmuAbTxyiFxeHTy9n6i1+1hUS01eWDAvf2iNGRZ3gvrlrPt0u+uMTBMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794362043;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Subject:To:CC:
	 References:From:Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=3j8i2RMfXjq7ikEdRoC0M7EhfQxRKXJ1iTD8fT2y+DU=;
	b=iHK0V/XvWhL/ZVMFgZ40mrR7HTiddEufLIDlAUma3ZC1qixbd7YwR2yoogUBc3bNOWFM
	 knqSWEYaVJaU5r3W4sxhzct9ZhvjKnL8gCT5qFIvyJyoVNUJYzyiHLxeY0zfRxBvA2pQU
	 T69QZollDyTqpcozk65Nao+lhTVeVhv4qPfLgcEU+AkfD6H8epJQf3NZU1MCVnTC3Rw+v
	 RS/PMXpdwqfBC6PasDMqZpB8cQX5CewdcF6YBrm3REPkxc1blgHSR/pp2hE09oVU0nsep
	 u24w7vkXF6s6Rbi/lKqPLry1GTbP/LnSQGf31R1Jmpp29ulrT/OCeGclmNkKTfHvolw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=u8WJaF3q;
	arc=none smtp.remote-ip=113.46.200.226
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740CA606A326;
	Wed, 11 Nov 2026 01:54:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 740CA606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=u8WJaF3q
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3j8i2RMfXjq7ikEdRoC0M7EhfQxRKXJ1iTD8fT2y+DU=;
	b=u8WJaF3qwa/K+ecI0wenMsNXgYb0HrhprmHkE4QJODjrBSe4+EjL0OlYwiEG9frJzY+4PPxby
	qRrA9VhuhNZ4ggwJdtZrkD6d3YGfwh7W6Pdcao/OwZASKxUTbOa+r99DHhX+1mx0w7PHC/IOtLO
	utdxMg8JLCv/gqi4hb5i1Kc=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4jPRQ61DyGzKm6m;
	Wed, 11 Nov 2026 09:53:50 +0800 (CST)
Received: from whupemo200011.china.huawei.com (unknown [7.152.185.179])
	by mail.maildlp.com (Postfix) with ESMTPS id F100C4055B;
	Wed, 11 Nov 2026 09:53:59 +0800 (CST)
Received: from [10.174.178.46] (10.174.178.46) by
 whupemo200011.china.huawei.com (7.152.185.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 11 Nov 2026 09:53:57 +0800
Subject: Re: [PATCH v2 28/34] ubifs: don't set SB_RDONLY after errors
To: Christian Brauner <brauner@kernel.org>, <linux-fsdevel@vger.kernel.org>,
	Jan Kara <jack@suse.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, <ecryptfs@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <jfs-discussion@lists.sourceforge.net>,
	<linux-nilfs@vger.kernel.org>, <exfat@lists.linux.dev>, <linux-mm@kvack.org>,
	<ntfs@lists.linux.dev>, <ocfs2-devel@lists.linux.dev>,
	<linux-btrfs@vger.kernel.org>, <gfs2@lists.linux.dev>,
	<linux-efi@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
	<linux-xfs@vger.kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-28-2f44f64f0b66@kernel.org>
 <0d472865-6cbb-cbb5-b361-1f2bf71dd528@huawei.com>
 <20261110-erfanden-dossier-zahntechnik-efcb7a6439b0@brauner>
From: Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <7cc1871c-9209-51ee-9d0e-c46e5adfaf1e@huawei.com>
Date: Wed, 11 Nov 2026 09:53:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261110-erfanden-dossier-zahntechnik-efcb7a6439b0@brauner>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 whupemo200011.china.huawei.com (7.152.185.179)

在 2026/11/11 5:54, Christian Brauner 写道:
> On Fri, Oct 30, 2026 at 11:42:15AM +0800, Zhihao Cheng wrote:
>> If we remove the c->ro_error check, ubifs_remount_ro->ubifs_wbuf_sync
>> will return EROFS and trigger ubifs_ro_mode() again, I think we can
>> retain the pre-check placement to trigger more error printing.
> 
> ubifs_ro_mode() doesn't do anything once c->ro_error is set so that
> won't print anything again. But there's no point in syncing the
> write-buffers and writing the master node after an error.
> 
Agreed
> So I'll skip both in ubifs_remount_ro() when c->ro_error is set like
> ubifs_put_super() does and only cancel the write-buffer timers. The
> remount to read-only itself has to keep working because the error
> doesn't set SB_RDONLY anymore.
Agreed.

> 
>> BTW, a remount to read-write after an error is refused too.
> 
> Only if c->ro_mount is set. ubifs_ro_mode() sets SB_RDONLY but never
> c->ro_mount. So after an error on a read-write mount ubifs_reconfigure()
> takes neither branch and reconfigure_super() clears SB_RDONLY again.
Oh, I understand now, you mean the SB_RDONLY flag in vfs layer.
> 
>> The sb_rdonly won't affect the sync_fs_one_sb() after an error, and
>> sb_emergency_ro check in not added into sync_fs_one_sb, should we add
>> the c->ro_error check in ubifs_sync_fs() to prevent the failure
>> ubifs_wbuf_sync executing?
> 
> Yes, I'll return -EROFS from ubifs_sync_fs() when c->ro_error is set.
> After the !wait check so sync_filesystem() still gets to sync_inodes_sb().
Great.
> 
> .
> 

