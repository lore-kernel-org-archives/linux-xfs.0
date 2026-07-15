Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD3C317170
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2026 01:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784077986; cv=none; b=Ojlpzn7u/5ll52nQuPW9qB2Rmhq7td5ZI6O7IrU4x/qDZwtAc1xrvb2lqajA0ZxPewV2CtjYcWec1nfJaLpwRpDqI6DHG/35wLkdCaIRniMIPJ7SPa6puRZC3mHeVVDh1t8gUp9VuBNCR9SZ1GahMn4xCkHYxXlRzvwEhC4zWk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784077986; c=relaxed/simple;
	bh=rGthIpKCASynYRL9qBQQEN06FmO92yBWKnlJXjcWvRs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rDh8avLxiUa5Rv2c5o8+87NJTR+O5Q2blQDydqdSvAja0wmJy2Ht9Li2mh+0zlvsEBn4uwEuLFSTZMeZNteml4C7ss4TEpcVFKhv9ORW602cTF8srszKv5Dt2bt/M3WOAVIy5XlS+7RflLWCO0XDOhPA2P++5dvwtBYvOeYXgPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4h0J7b2ttgzYQtmg
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2026 09:12:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 96A1B40590
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2026 09:12:59 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgAHZHCZ3lZqed0PBQ--.29010S3;
	Wed, 15 Jul 2026 09:12:59 +0800 (CST)
Message-ID: <3300e6fc-6390-46b9-8ac4-d15bea64f35c@huaweicloud.com>
Date: Wed, 15 Jul 2026 09:12:57 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] fiemap: add a nosync option
To: Pankaj Raghav <p.raghav@samsung.com>, aalbersh@kernel.org
Cc: pankaj.raghav@linux.dev, hch@lst.de, gost.dev@samsung.com,
 linux-xfs@vger.kernel.org, djwong@kernel.org
References: <20260714203206.520348-1-p.raghav@samsung.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260714203206.520348-1-p.raghav@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgAHZHCZ3lZqed0PBQ--.29010S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXr1xtFyfAF4DAw4xKFy8Zrb_yoW5WF17pr
	s8uw1Yka13tF4IgFs7J3yxK3WrKw1UKF40kr98Xw13ZF98tFn7GFnYk3W0qw17Wr93XFZ8
	XrWYv3W3Ga1qyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6x
	kF7I0E14v26F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAq
	x4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6x
	CaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI
	7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
	Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY
	6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6x
	AIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
	1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 7/15/2026 4:32 AM, Pankaj Raghav wrote:
> io/fiemap adds FIEMAP_FLAG_SYNC by default. There are some test cases
> where adding this flag might have an undesired side effect on the
> results [1].
> 
> Add an option that does not pass FIEMAP_FLAG_SYNC flag.
> 
> [1] https://lore.kernel.org/linux-xfs/ca21b3c4-e1df-4ba7-8e9c-5d221337c86b@huaweicloud.com/
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>

Thanks for the patch, this looks good to me!

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
> Changes since v2:
> - Add this option to the man page (Darrick)
> - Add more information about this flag in the help.
> Changes since v1:
> - Change '-s' to '-e' to match xfs_bmap (Christoph).
> 
>  io/fiemap.c       | 9 +++++++--
>  man/man8/xfs_io.8 | 2 +-
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/io/fiemap.c b/io/fiemap.c
> index b41f71bf..cf3a1b3e 100644
> --- a/io/fiemap.c
> +++ b/io/fiemap.c
> @@ -36,6 +36,7 @@ fiemap_help(void)
>  " -a -- prints the attribute fork map instead of the data fork.\n"
>  " -l -- also displays the length of each extent in 512-byte blocks.\n"
>  " -n -- query n extents.\n"
> +" -e -- obtains also delayed allocation extents by not using FIEMAP_FLAG_SYNC.\n"
>  " -v -- Verbose information\n"
>  " offset is the starting offset to map, and is optional.  If offset is\n"
>  " specified, mapping length may (optionally) be specified as well."
> @@ -242,7 +243,7 @@ fiemap_f(
>  
>  	init_cvtnum(&fsblocksize, &fssectsize);
>  
> -	while ((c = getopt(argc, argv, "aln:v")) != EOF) {
> +	while ((c = getopt(argc, argv, "aln:ev")) != EOF) {
>  		switch (c) {
>  		case 'a':
>  			fiemap_flags |= FIEMAP_FLAG_XATTR;
> @@ -253,6 +254,10 @@ fiemap_f(
>  		case 'n':
>  			max_extents = atoi(optarg);
>  			break;
> +		case 'e':
> +			/* nosync */
> +			fiemap_flags &= ~(FIEMAP_FLAG_SYNC);
> +			break;
>  		case 'v':
>  			vflag++;
>  			break;
> @@ -393,7 +398,7 @@ fiemap_init(void)
>  	fiemap_cmd.argmin = 0;
>  	fiemap_cmd.argmax = -1;
>  	fiemap_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> -	fiemap_cmd.args = _("[-alv] [-n nx] [offset [len]]");
> +	fiemap_cmd.args = _("[-alev] [-n nx] [offset [len]]");
>  	fiemap_cmd.oneline = _("print block mapping for a file");
>  	fiemap_cmd.help = fiemap_help;
>  
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 61defcc3..a3ddab02 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -353,7 +353,7 @@ Prints the block mapping for the current open file. Refer to the
>  .BR xfs_bmap (8)
>  manual page for complete documentation.
>  .TP
> -.BI "fiemap [ \-alv ] [ \-n " nx " ] [ " offset " [ " len " ]]"
> +.BI "fiemap [ \-alev ] [ \-n " nx " ] [ " offset " [ " len " ]]"
>  Prints the block mapping for the current open file using the fiemap
>  ioctl.  Options behave as described in the
>  .BR xfs_bmap (8)
> 
> base-commit: e80b048d87fdc5735e0d03ae29b497b402ea8bbe

