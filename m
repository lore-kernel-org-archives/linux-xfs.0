Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50656 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752315AbdKFTiX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2017 14:38:23 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA6JcMnJ009361
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 6 Nov 2017 19:38:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vA6JcLZD023201
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 6 Nov 2017 19:38:22 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vA6JcLVD016244
        for <linux-xfs@vger.kernel.org>; Mon, 6 Nov 2017 19:38:21 GMT
Date: Mon, 6 Nov 2017 11:38:19 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [bug report] xfs: scrub inodes
Message-ID: <20171106193819.GB6244@magnolia>
References: <20171104080243.b5gchkmrofmkdbdf@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171104080243.b5gchkmrofmkdbdf@mwanda>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Nov 04, 2017 at 11:02:43AM +0300, Dan Carpenter wrote:
> Hello Darrick J. Wong,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch 80e4e1268802: "xfs: scrub inodes" from Oct 17, 2017, leads 
> to the following Smatch complaint:
> 
> fs/xfs/scrub/inode.c:356 xfs_scrub_dinode()
> 	 error: we previously assumed 'sc->ip' could be null (see line 338)
> 
> fs/xfs/scrub/inode.c
>    337	
>    338			if (dip->di_mode == 0 && sc->ip)
>                                                  ^^^^^^
> The patch adds a check if sc->ip is NULL
> 
>    339				xfs_scrub_ino_set_corrupt(sc, ino, bp);
>    340	
>    341			if (dip->di_projid_hi != 0 &&
>    342			    !xfs_sb_version_hasprojid32bit(&mp->m_sb))
>    343				xfs_scrub_ino_set_corrupt(sc, ino, bp);
>    344			break;
>    345		default:
>    346			xfs_scrub_ino_set_corrupt(sc, ino, bp);
>    347			return;
>    348		}
>    349	
>    350		/*
>    351		 * di_uid/di_gid -- -1 isn't invalid, but there's no way that
>    352		 * userspace could have created that.
>    353		 */
>    354		if (dip->di_uid == cpu_to_be32(-1U) ||
>    355		    dip->di_gid == cpu_to_be32(-1U))
>    356			xfs_scrub_ino_set_warning(sc, bp);
>                                                   ^^
> But later we pass it to xfs_scrub_ino_set_warning() and it gets
> dereferenced without checking...  I don't know the rules about sc->ip
> well enough to say when it's NULL or not...

xfs_scrub_ino_set_warning and xfs_scrub_ino_set_preen both need to
take the inode number as a parameter and not rely on sc->ip pointing
anywhere.  I'll send a fix shortly; thank you for bringing this to my
attention.

--D

>    357	
>    358		/* di_format */
> 
> regards,
> dan carpenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
