Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 495E57F3F
	for <xfs@oss.sgi.com>; Thu,  5 Jun 2014 19:48:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 28A498F8035
	for <xfs@oss.sgi.com>; Thu,  5 Jun 2014 17:48:04 -0700 (PDT)
Received: from mail-wi0-f175.google.com (mail-wi0-f175.google.com
	[209.85.212.175]) by cuda.sgi.com with ESMTP id
	zbiZgs4bdzOs9vNR (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Jun 2014 17:48:02 -0700 (PDT)
Received: by mail-wi0-f175.google.com with SMTP id f8so77961wiw.8
	for <xfs@oss.sgi.com>; Thu, 05 Jun 2014 17:48:01 -0700 (PDT)
Message-ID: <53910FBE.6090109@gmail.com>
Date: Fri, 06 Jun 2014 03:47:58 +0300
From: Martin Papik <mp6058@gmail.com>
MIME-Version: 1.0
Subject: Re: XFS filesystem claims to be mounted after a disconnect
References: <20140503030221.GJ26353@dastard> <538C5E67.6090005@gmail.com>
	<20140602234135.GO6677@dastard> <538D9412.3040009@gmail.com>
	<CAAxjCEzz5n85zAH5HuUQkfxKvzZt5_+cPCj3uzZR7U69H+2tDw@mail.gmail.com>
	<538DA7FF.4080002@gmail.com> <20140603212834.GG14410@dastard>
	<538E4E1B.1020003@gmail.com> <20140605005538.GB4523@dastard>
	<5390C77E.4020003@gmail.com> <20140605224140.GB4453@dastard>
In-Reply-To: <20140605224140.GB4453@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Linux fs XFS <xfs@oss.sgi.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512


Thanks Dave

But wouldn't the same thing that prevents xfs_repair also prevent
dm-multipath from using the device? Or would you typically setup a
partitioning or volume scheme on top of dm-multipath?

Martin

> No. Use dm-multipath to make them appear as a single block device 
> made up as a pair of redundant paths in primary/secondary failover 
> or active/active load balancing configurations. dm-multipath
> handles failover between the two block devices on path failure 
> transparently.
> 
> XFS | dm-mp-0 /    \ sdc    sdd
> 
> The mounted filesystem doesn't even know there are multiple paths
> in this configuration, however the XFS UUID trapping behaviour
> avoids this problem by preventing you from doing XFS operations
> directly on /dev/sdc or /dev/sdd while the filesystem is mount on 
> /dev/dm-mp-0....
> 
> Cheers.
> 
> Dave.
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJTkQ+yAAoJELsEaSRwbVYrJB4QAIyjUk7un+bth/5WnW/imwoh
CGlkS7kuU8Iu96VqwoojOZtY6RcUX5Yq+NoW7NDigFv0iEkaM2j0wg8JoNw6EFqX
uiJuCkBUI3/v8QkFU0GtA4/6NFsu9N709f8J0ilof20L0bNm2wh7SiXqrp28X3HS
8Y1G50PXbBnEM5yKbmXLpVTOhEw35NlaPKBYZ5gBFohPXDb4+J6+g0kJD5wZPSWK
lsHyW8tuuntGIZTtGZ4sHvak5THCXILClmFcPrdzzU110c601RTzJfeq9L7QXTMI
thrUH3KGvT2s4vTwqLLFHdBZNwEXi2X0PaiM7uO0/AYvaaoDfwnLh0lJmSSxRFZn
YYFa6Ko20l4nxFZoy6eRUh8vxvOat4VOlYowlyEcnPTE1nSeJfulun94ztjNXs2k
5VtWlFh12CXSVrynXBVnYKvFOAdecZcztqxjAjjTcjIrWHbZv0UXFtflG1V+zjgD
63SqxwShL2C/685gFXHh7mY0K2vAbnBK+IrRSTWMKVMZ16OuuIFA2WZebnskDfAf
vWWFv8mAEAUP/xYF7u4g4XVov2aQAVxjDosXxuqUbW8QHlTXNB/wc7akXgoD3fmZ
u0cB5Paw9JJeGt5eKYbtReL+Wt3STKtYGu2yNOZo/oiUr0uuoAkcjSfUGqrdu6HL
kQgRYDDjQt37JPVIyyNK
=55eH
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
