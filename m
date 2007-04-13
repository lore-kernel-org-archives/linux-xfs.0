Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Apr 2007 08:12:12 -0700 (PDT)
Received: from mx1.suse.de (mail.suse.de [195.135.220.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3DFC5fB002711
	for <xfs@oss.sgi.com>; Fri, 13 Apr 2007 08:12:06 -0700
Message-ID: <461F997E.30002@suse.com>
Date: Fri, 13 Apr 2007 10:53:50 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
References: <20070412110550.GM5967@schatzie.adilger.int> <97211C89-1810-4B22-B2F4-9D206D43C1F6@cam.ac.uk> <20070413040156.GU5967@schatzie.adilger.int>
In-Reply-To: <20070413040156.GU5967@schatzie.adilger.int>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Anton Altaparmakov <aia21@cam.ac.uk>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andreas Dilger wrote:
> On Apr 12, 2007  12:22 +0100, Anton Altaparmakov wrote:
>> This would say that the offset on disk can move at any time or that  
>> the data is compressed or encrypted on disk thus the data is not  
>> useful for direct disk access.
> 
> This makes sense.  Even for Reiserfs the same is true with packed tails,
> and I believe if FIBMAP is called on a tail it will migrate the tail into
> a block because this is might be a sign that the file is a kernel that
> LILO wants to boot.

Actually, reiserfs_aop_bmap() returns 0 when the requested block is in a
tail. There's a separate ioctl for unpacking them.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGH5l+LPWxlyuTD7IRAn5/AJ9VcocIcDGr9wtAlgGZuOAQWqVASwCfVdWM
uLZQq1mkf8hsGXOpZtKQH5w=
=AxnN
-----END PGP SIGNATURE-----
