Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E11AD7F9E
	for <xfs@oss.sgi.com>; Tue, 28 Jul 2015 14:12:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 63520AC006
	for <xfs@oss.sgi.com>; Tue, 28 Jul 2015 12:12:36 -0700 (PDT)
Received: from mail-wi0-f174.google.com (mail-wi0-f174.google.com
	[209.85.212.174]) by cuda.sgi.com with ESMTP id
	hZLM4HccARl3J7mB (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Jul 2015 12:12:34 -0700 (PDT)
Received: by wibxm9 with SMTP id xm9so170726250wib.0
	for <xfs@oss.sgi.com>; Tue, 28 Jul 2015 12:12:33 -0700 (PDT)
Received: from [192.168.1.16] ([94.76.9.49])
	by smtp.googlemail.com with ESMTPSA id
	pn6sm34645743wjb.36.2015.07.28.12.12.20 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Tue, 28 Jul 2015 12:12:32 -0700 (PDT)
Message-ID: <55B7D400.50202@gmail.com>
Date: Tue, 28 Jul 2015 22:12:00 +0300
From: Martin Papik <mp6058@gmail.com>
MIME-Version: 1.0
Subject: Re: XFS File system in trouble
References: <03864DDC681E664EBF5D47682BE7D7CF0D3574DF@USADCWVEMBX07.corp.global.level3.com>	<55AA5FCE.4080702@sandeen.net>	<03864DDC681E664EBF5D47682BE7D7CF0D358740@USADCWVEMBX07.corp.global.level3.com>	<CAN3tLtJuk3LKHtxvbXATBR7bjr2e=GTX-fgs-jQniuxqRXjeoA@mail.gmail.com>	<55AAF73A.4040903@mygrande.net>	<20150720111747.GA53450@bfoster.bfoster>	<55B73365.1050908@mygrande.net>	<20150728123307.GC38784@bfoster.bfoster>	<55B79BFD.6020509@mygrande.net>
	<55B7B390.1050206@sandeen.net>
In-Reply-To: <55B7B390.1050206@sandeen.net>
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
To: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512


How about this?

qemu-img create -f qcow2 test 32T
qemu-nbd -c /dev/nbd0 test
xfs_mdrestore -g md0.metadump /dev/nbd0



>>> 
>>> Hmm, I guess the file size exceeds the capabilities of the root
>>> fs, even if there might ultimately be enough space to restore
>>> the metadump.
>> 
>> I wouldn't think so, at least not fundamentally. It's ext4. It's 
>> certainly not big enough to hold an 18T file system, though, and 
>> perhaps that is what xfs_restore is checking.
> 
> No, it's just failing to write any data at an 18T offset.
> 
> The ext4 filesystem (with 4k blocks) is limited to a 16T maximum
> file offset; you won't be able to restore a (sparse) 18T
> filesystem image onto an ext4 filesystem.

>> 
>> RAID-Server:/TEST# xfs_mdrestore -g md0.metadump RAIDfile.img 
>> xfs_mdrestore: cannot set filesystem image size: File too large
>> 
> 
> Hmm, I guess the file size exceeds the capabilities of the root fs,
> even if there might ultimately be enough space to restore the
> metadump.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJVt9P3AAoJELsEaSRwbVYryxEP/1WDJUO15CA35VW/JE13gp/U
qIXsc8tS3ZKds/at1boPAw2/X4HYclfuhV9heYi+npzF/0pimqTY7MkjxVN3JUHf
r2pOZSL0r0YqPw0Wc17sFOY5y1F7AzHS9vIUIMpYTW5A0CasQDUCuetfhlawNWLR
ijjmXWnLivPo7tsIOC7WMl9wmf3kO9P/2wN0aR5oUmtcdn4sPiqPHYv1e6UpiYkr
Qv1M1NtX9rryLQZyWWtHQQGj+3IFyMIT6NszQ8mOPw8ijJTxMlVb5rxyP4I5uzZw
r0KkIWxfU558I/eGHaVHlsWBpaqM5JbiZzQDkh03vCIyZNi5tnwDKl0i2wRsM6m/
N7VvUSwDHOvoxpQtE3KYVcOqlyGXS/S2N6wSBDQ5LqSQDS8JRJYt2wjnaSNG2ib7
ddLlfkGhkM4IDpWjn0HvupDY9jhcKDxEpZ8t73tQLSaq705GYMcYxOmplzM6Iu3E
it7oiCM/p76p5NF5BLqoj1zU/XFKgpadcTOkL6vNjVvDzjhVO/RL8lS7yI8dbHuk
t44SN5jCX+OmawxveAaXs1BSySCgOEK/kZuYYNvrIZq0W3ZoeLJKNFUtuOr24Kwn
HY8/GyRxG9Kg4+KoUvV6skZw+/RjEgDGJ17vVHc23qVfSraJftXjiE42Hp2BI4NK
RHVCtUzI+6fK7xL2Ex06
=Oqcp
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
