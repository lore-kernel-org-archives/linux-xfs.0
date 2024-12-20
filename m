Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E57C1C549D
	for <linux-xfs@vger.kernel.org>; Fri, 20 Dec 2024 14:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734705450; cv=none; b=fE0BgDVTg2BJH1R5iadd4ZZnfrhuKRLE559IOJYZVafN8k1cg7xnemhedBKYieojkdWbPboVkEMdafnNep2OZhe+UoyzJ+xcCL/igHNZGe3qOqKpm29oTAtjdsxxTGbu5BwV2oS83N9E4sfMAQ7DJLmLf1aM7rlQLKs1n9QUfqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734705450; c=relaxed/simple;
	bh=kwFNps93CAD+DZ4GwpbxUPomqjA1dK2/xbcNkk/1gUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ET7gAWtQhCOGJstWYGVjV4HNzvcOqJSm5yPqWfliomDbTI46mKSDIKCZJYaofE856UKuNfnFbl6+QEmXYus/mhei7sfHVkS0EtA0uZnchpsWqhA9DLbc1kghi+JvLTb4ZP8RNm3V5I3xwGHHp8Of2obSx8kYUK5gaVZMbrAaVPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=APibjlu0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="APibjlu0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734705447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pvZlGO3+oQdbaoKX5NPU1zXcvnJhWGV9nRWj8mzv4Zk=;
	b=APibjlu0JaFMTvIKjgNyXSZHXXyo0osMCdXbXfc8Hnjs8mLtfHb6XhFjDv+Ao1jTlYC1DE
	Z1ff1HvMvbAKpmcL078SmJMqv90XGsSWTzLrXqrhgwcJuIPfaiu+P/hxMxoo8xIHjGf8GY
	tKWQUWnrZJhPA8xZDI4N8GDwu7jTGpI=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-694-z5uJhU13NT21Sx3tlrPUKg-1; Fri, 20 Dec 2024 09:37:26 -0500
X-MC-Unique: z5uJhU13NT21Sx3tlrPUKg-1
X-Mimecast-MFC-AGG-ID: z5uJhU13NT21Sx3tlrPUKg
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-aa680c6aa0eso47326266b.0
        for <linux-xfs@vger.kernel.org>; Fri, 20 Dec 2024 06:37:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734705444; x=1735310244;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pvZlGO3+oQdbaoKX5NPU1zXcvnJhWGV9nRWj8mzv4Zk=;
        b=Bwx2CkhJdbd0cKkhT1ygc2ggouA/wDAsM5RUXM54BUYl6AR3rRlE9wgxrDNyKVvwwi
         88uPskedrM4r5EfmwkksALWm04uHQ4Kq/Tt+eeJdLq12LnduYdZRcBCr+pXlXwj9NoDk
         jEpWP7dL2jqDTcQfDbXhmnJDY+2UshoxlThC1wgUNsG6YA/HWJ+oH6llQAWJinVcM8Q3
         SXHYyH0pv68nW1KXdr0zCB7kTx2HBskiU8Ky9MfpTLhkooRl6XCBRVtes99yMx30zy/m
         cmjt7VQ2TAn/vTRZRc9bM8lFgn/6a1Z0OHeNyOIEGjqW+QBKqBA7jO2N6z5Iow6coooF
         UacA==
X-Forwarded-Encrypted: i=1; AJvYcCVF/cyuat8k5/8vABYGr+v/6RUF18L3v9P/UlDY2c4LbUehoUofC3Lrmrt6VT86N2ZnigDagxbRDBU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy22riPW3oblpgujO2GtnbGH2vk78jO/8/P07MUuZ48GKZ/hoUH
	kxaufgV/O9YgC8Ee2khRadTvVgNMeKuN/KZRxEb1ub+uyqoTVnMOBsxCZ9K+ffnHSRW6bZJX3iR
	7Mf/Semg/sPHokGKLevHABjGYhpwK9QDNyBSjibZSaJvK6H7szb16jQ4dVPj18sbA
X-Gm-Gg: ASbGncvVbv9JynmGcgj7HoQrvGXtlNwoxgE0nUdlJh+isyQJsRrEv9LgV3IHNw9/pFD
	/vdTIMSj1kU3+u4UZT7HX9VDB7N0CoDO3dnJLkkLUmmYVMvUwM+d13YNnqKU6sF1ptZp8k4YEnS
	ejuAr8fzRut7ot6V4aH52YYmrfwiBTmtyI1NxHFxO8DXtvXUUg5lMfRZ3WhBX4TfPstZDfJQWj7
	04zDVMi9/GA25P4mncUxLqpHxXOi0KREIWg5Le7x/F/sZAPMXYWA5X8nRw/F1sWzA3mIItG2c3Y
X-Received: by 2002:a17:907:7fa9:b0:aa6:61b7:938f with SMTP id a640c23a62f3a-aac2874b192mr254851366b.6.1734705444578;
        Fri, 20 Dec 2024 06:37:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGA/2ob21mMB234kxIVGeDjFqm+kXsm1WG/cdF3L7cr6Op1snbSXRETdC7QsFnKTeJbcl4sKQ==
X-Received: by 2002:a17:907:7fa9:b0:aa6:61b7:938f with SMTP id a640c23a62f3a-aac2874b192mr254841066b.6.1734705442668;
        Fri, 20 Dec 2024 06:37:22 -0800 (PST)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f014c94sm180774466b.158.2024.12.20.06.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2024 06:37:22 -0800 (PST)
Date: Fri, 20 Dec 2024 15:37:20 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 34/50] xfs_mdrestore: refactor open-coded fd/is_file into
 a structure
Message-ID: <o7r6ijutpvhwoswsgrazrsisf4ztoxd3nw7o75znqeb3wsptgw@ilit2u6thawo>
References: <173405323136.1228937.15295934936342173452.stgit@frogsfrogsfrogs>
 <173405323705.1228937.13659584501492804544.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405323705.1228937.13659584501492804544.stgit@frogsfrogsfrogs>

On 2024-12-12 17:29:06, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create an explicit object to track the fd and flags associated with a
> device onto which we are restoring metadata, and use it to reduce the
> amount of open-coded arguments to ->restore.  This avoids some grossness
> in the next patch.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

LGTM
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

> ---
>  mdrestore/xfs_mdrestore.c |  123 +++++++++++++++++++++++----------------------
>  1 file changed, 63 insertions(+), 60 deletions(-)
> 
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index c6c00270234442..c5584fec68813e 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -15,12 +15,20 @@ union mdrestore_headers {
>  	struct xfs_metadump_header	v2;
>  };
>  
> +struct mdrestore_dev {
> +	int		fd;
> +	bool		is_file;
> +};
> +
> +#define DEFINE_MDRESTORE_DEV(name) \
> +	struct mdrestore_dev name = { .fd = -1 }
> +
>  struct mdrestore_ops {
>  	void (*read_header)(union mdrestore_headers *header, FILE *md_fp);
>  	void (*show_info)(union mdrestore_headers *header, const char *md_file);
>  	void (*restore)(union mdrestore_headers *header, FILE *md_fp,
> -			int ddev_fd, bool is_data_target_file, int logdev_fd,
> -			bool is_log_target_file);
> +			const struct mdrestore_dev *ddev,
> +			const struct mdrestore_dev *logdev);
>  };
>  
>  static struct mdrestore {
> @@ -108,25 +116,24 @@ fixup_superblock(
>  		fatal("error writing primary superblock: %s\n", strerror(errno));
>  }
>  
> -static int
> +static void
>  open_device(
> -	char		*path,
> -	bool		*is_file)
> +	struct mdrestore_dev	*dev,
> +	char			*path)
>  {
> -	struct stat	statbuf;
> -	int		open_flags;
> -	int		fd;
> +	struct stat		statbuf;
> +	int			open_flags;
>  
>  	open_flags = O_RDWR;
> -	*is_file = false;
> +	dev->is_file = false;
>  
>  	if (stat(path, &statbuf) < 0)  {
>  		/* ok, assume it's a file and create it */
>  		open_flags |= O_CREAT;
> -		*is_file = true;
> +		dev->is_file = true;
>  	} else if (S_ISREG(statbuf.st_mode))  {
>  		open_flags |= O_TRUNC;
> -		*is_file = true;
> +		dev->is_file = true;
>  	} else if (platform_check_ismounted(path, NULL, &statbuf, 0)) {
>  		/*
>  		 * check to make sure a filesystem isn't mounted on the device
> @@ -136,23 +143,30 @@ open_device(
>  				path);
>  	}
>  
> -	fd = open(path, open_flags, 0644);
> -	if (fd < 0)
> +	dev->fd = open(path, open_flags, 0644);
> +	if (dev->fd < 0)
>  		fatal("couldn't open \"%s\"\n", path);
> +}
>  
> -	return fd;
> +static void
> +close_device(
> +	struct mdrestore_dev	*dev)
> +{
> +	if (dev->fd >= 0)
> +		close(dev->fd);
> +	dev->fd = -1;
> +	dev->is_file = false;
>  }
>  
>  static void
>  verify_device_size(
> -	int		dev_fd,
> -	bool		is_file,
> -	xfs_rfsblock_t	nr_blocks,
> -	uint32_t	blocksize)
> +	const struct mdrestore_dev	*dev,
> +	xfs_rfsblock_t			nr_blocks,
> +	uint32_t			blocksize)
>  {
> -	if (is_file) {
> +	if (dev->is_file) {
>  		/* ensure regular files are correctly sized */
> -		if (ftruncate(dev_fd, nr_blocks * blocksize))
> +		if (ftruncate(dev->fd, nr_blocks * blocksize))
>  			fatal("cannot set filesystem image size: %s\n",
>  				strerror(errno));
>  	} else {
> @@ -161,7 +175,7 @@ verify_device_size(
>  		off_t		off;
>  
>  		off = nr_blocks * blocksize - sizeof(lb);
> -		if (pwrite(dev_fd, lb, sizeof(lb), off) < 0)
> +		if (pwrite(dev->fd, lb, sizeof(lb), off) < 0)
>  			fatal("failed to write last block, is target too "
>  				"small? (error: %s)\n", strerror(errno));
>  	}
> @@ -195,12 +209,10 @@ show_info_v1(
>  
>  static void
>  restore_v1(
> -	union mdrestore_headers *h,
> -	FILE			*md_fp,
> -	int			ddev_fd,
> -	bool			is_data_target_file,
> -	int			logdev_fd,
> -	bool			is_log_target_file)
> +	union mdrestore_headers		*h,
> +	FILE				*md_fp,
> +	const struct mdrestore_dev	*ddev,
> +	const struct mdrestore_dev	*logdev)
>  {
>  	struct xfs_metablock	*metablock;	/* header + index + blocks */
>  	__be64			*block_index;
> @@ -254,8 +266,7 @@ restore_v1(
>  
>  	((struct xfs_dsb*)block_buffer)->sb_inprogress = 1;
>  
> -	verify_device_size(ddev_fd, is_data_target_file, sb.sb_dblocks,
> -			sb.sb_blocksize);
> +	verify_device_size(ddev, sb.sb_dblocks, sb.sb_blocksize);
>  
>  	bytes_read = 0;
>  
> @@ -263,7 +274,7 @@ restore_v1(
>  		maybe_print_progress(&mb_read, bytes_read);
>  
>  		for (cur_index = 0; cur_index < mb_count; cur_index++) {
> -			if (pwrite(ddev_fd, &block_buffer[cur_index <<
> +			if (pwrite(ddev->fd, &block_buffer[cur_index <<
>  					h->v1.mb_blocklog], block_size,
>  					be64_to_cpu(block_index[cur_index]) <<
>  						BBSHIFT) < 0)
> @@ -292,7 +303,7 @@ restore_v1(
>  
>  	final_print_progress(&mb_read, bytes_read);
>  
> -	fixup_superblock(ddev_fd, block_buffer, &sb);
> +	fixup_superblock(ddev->fd, block_buffer, &sb);
>  
>  	free(metablock);
>  }
> @@ -376,12 +387,10 @@ restore_meta_extent(
>  
>  static void
>  restore_v2(
> -	union mdrestore_headers	*h,
> -	FILE			*md_fp,
> -	int			ddev_fd,
> -	bool			is_data_target_file,
> -	int			logdev_fd,
> -	bool			is_log_target_file)
> +	union mdrestore_headers		*h,
> +	FILE				*md_fp,
> +	const struct mdrestore_dev	*ddev,
> +	const struct mdrestore_dev	*logdev)
>  {
>  	struct xfs_sb		sb;
>  	struct xfs_meta_extent	xme;
> @@ -415,16 +424,14 @@ restore_v2(
>  
>  	((struct xfs_dsb *)block_buffer)->sb_inprogress = 1;
>  
> -	verify_device_size(ddev_fd, is_data_target_file, sb.sb_dblocks,
> -			sb.sb_blocksize);
> +	verify_device_size(ddev, sb.sb_dblocks, sb.sb_blocksize);
>  
>  	if (sb.sb_logstart == 0) {
>  		ASSERT(mdrestore.external_log == true);
> -		verify_device_size(logdev_fd, is_log_target_file, sb.sb_logblocks,
> -				sb.sb_blocksize);
> +		verify_device_size(logdev, sb.sb_logblocks, sb.sb_blocksize);
>  	}
>  
> -	if (pwrite(ddev_fd, block_buffer, len, 0) < 0)
> +	if (pwrite(ddev->fd, block_buffer, len, 0) < 0)
>  		fatal("error writing primary superblock: %s\n",
>  			strerror(errno));
>  
> @@ -446,11 +453,11 @@ restore_v2(
>  		switch (be64_to_cpu(xme.xme_addr) & XME_ADDR_DEVICE_MASK) {
>  		case XME_ADDR_DATA_DEVICE:
>  			device = "data";
> -			fd = ddev_fd;
> +			fd = ddev->fd;
>  			break;
>  		case XME_ADDR_LOG_DEVICE:
>  			device = "log";
> -			fd = logdev_fd;
> +			fd = logdev->fd;
>  			break;
>  		default:
>  			fatal("Invalid device found in metadump\n");
> @@ -467,7 +474,7 @@ restore_v2(
>  
>  	final_print_progress(&mb_read, bytes_read);
>  
> -	fixup_superblock(ddev_fd, block_buffer, &sb);
> +	fixup_superblock(ddev->fd, block_buffer, &sb);
>  
>  	free(block_buffer);
>  }
> @@ -492,13 +499,11 @@ main(
>  	char			**argv)
>  {
>  	union mdrestore_headers	headers;
> +	DEFINE_MDRESTORE_DEV(ddev);
> +	DEFINE_MDRESTORE_DEV(logdev);
>  	FILE			*src_f;
> -	char			*logdev = NULL;
> -	int			data_dev_fd = -1;
> -	int			log_dev_fd = -1;
> +	char			*logdev_path = NULL;
>  	int			c;
> -	bool			is_data_dev_file = false;
> -	bool			is_log_dev_file = false;
>  
>  	mdrestore.show_progress = false;
>  	mdrestore.show_info = false;
> @@ -516,7 +521,7 @@ main(
>  				mdrestore.show_info = true;
>  				break;
>  			case 'l':
> -				logdev = optarg;
> +				logdev_path = optarg;
>  				mdrestore.external_log = true;
>  				break;
>  			case 'V':
> @@ -555,7 +560,7 @@ main(
>  
>  	switch (be32_to_cpu(headers.magic)) {
>  	case XFS_MD_MAGIC_V1:
> -		if (logdev != NULL)
> +		if (logdev_path != NULL)
>  			usage();
>  		mdrestore.mdrops = &mdrestore_ops_v1;
>  		break;
> @@ -581,18 +586,16 @@ main(
>  	optind++;
>  
>  	/* check and open data device */
> -	data_dev_fd = open_device(argv[optind], &is_data_dev_file);
> +	open_device(&ddev, argv[optind]);
>  
> +	/* check and open log device */
>  	if (mdrestore.external_log)
> -		/* check and open log device */
> -		log_dev_fd = open_device(logdev, &is_log_dev_file);
> +		open_device(&logdev, logdev_path);
>  
> -	mdrestore.mdrops->restore(&headers, src_f, data_dev_fd,
> -			is_data_dev_file, log_dev_fd, is_log_dev_file);
> +	mdrestore.mdrops->restore(&headers, src_f, &ddev, &logdev);
>  
> -	close(data_dev_fd);
> -	if (mdrestore.external_log)
> -		close(log_dev_fd);
> +	close_device(&ddev);
> +	close_device(&logdev);
>  
>  	if (src_f != stdin)
>  		fclose(src_f);
> 

-- 
- Andrey

