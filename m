Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6A8FC29DF8
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 12:03:35 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 15EB7AC007
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 10:03:31 -0800 (PST)
Received: from mail-pa0-f45.google.com (mail-pa0-f45.google.com
	[209.85.220.45]) by cuda.sgi.com with ESMTP id OrcEDFc3QIAvOBd8
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 15 Jan 2014 10:03:28 -0800 (PST)
Received: by mail-pa0-f45.google.com with SMTP id ld10so1470896pab.4
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 10:03:27 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [RFC] directory quota survey on xfs
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20140115081201.GA3820@gmail.com>
Date: Wed, 15 Jan 2014 11:03:22 -0700
Message-Id: <5966C533-EF18-4804-8C83-DFBD607D9BE6@dilger.ca>
References: <20131222095929.GA11444@gmail.com> <20131223014222.GC3220@dastard>
	<20140115081201.GA3820@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2441794138102024739=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Dmitry Monakhov <dmonakhov@openvz.org>, Li Xi <pkuelelixi@gmail.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>


--===============2441794138102024739==
Content-Type: multipart/signed; boundary="Apple-Mail=_FD255228-C0D0-4E7D-8F9D-F4FA9F697630"; protocol="application/pgp-signature"; micalg=pgp-sha1


--Apple-Mail=_FD255228-C0D0-4E7D-8F9D-F4FA9F697630
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Jan 15, 2014, at 1:12 AM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> On Mon, Dec 23, 2013 at 12:42:22PM +1100, Dave Chinner wrote:
>> I'd also strongly suggest that you use the XFS userspace quota API
>> for managing project quotas, so that we can use the same management
>> tools and tests to verify that they behave the same. Please don't
>> invent a new version of the quota API to implement this - everything
>> you need ifor managing project/directory quotas is already there in
>> xfs_quota.....
> 
> Frankly, I don't like this, really.  Now we have quota-tool to manage
> the quota in ext4.  So IMHO we'd better go on using this tool because it
> is natural for ext4 users.  I still couldn't accept this fact that I
> need to install xfsprogs for using a feature of ext4.  Further, it could
> make users puzzled because they use quota to control user/group quota in
> ext4, but it uses xfs_quota to control project quota.  It could bring
> some troubles for the ext4 users who have written some scripts to manage
> their machines.

Please see Li Xi's recent email "Directory/Project quota supports" on
the linux-ext4 list.  He has already added some prototype support for
project quotas to quota-tools.

I think it might make sense to keep the same API as XFS for the ext4
quotas (to keep compatibility for existing XFS deployments), but add
support into quota-tools so that it is usable by all filesystems.

Cheers, Andreas






--Apple-Mail=_FD255228-C0D0-4E7D-8F9D-F4FA9F697630
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUtbNanKl2rkXzB/gAQLZChAAs615Gzxprw9+mALw7ohMsxmdFGqRfSYw
czhBA9Rl82oOD2Cq9lvtGzAawE35Y3xDe4cPz+DPlq+ul5Du7VBRL0VfCYBDAg4T
mBzp84iFqijD10umZzaSERXK9uFLs+MZCp6n2V5ooYgzWw+gymBnEJU7zIX+D0Vf
uGOz7MxfhCcDOmvDnjgulHTTQhh0dne0wE/9DmfmCSxNZuOjzx+ESXgKT2L7xf3o
pAopF7Q5ppE1M5RYyfGTkqxCAlJ7QbnAw4Mj5nXKWfFVtYeep9VmCGm++szrzkFy
zUOtf3p3BmKubSyLdab4QdU+1Umc1s7+00T45DMgrR2xm8FhpRFrjX9dV61xrg0P
TGs4146xwXYTxwqv4XnOWfbnLJ/B5clX+lC6ZRdyEE/pqGf9DKP0PzbP/5LVnUq+
VthdCOoCvB7Gk0pGRvwuupCvXJX31+7nLUf9R66kUgg7s5I6SlZiGsUwrvEIPJLJ
mypRUaiLzB//6ClTWifNMLS0KON7EGHCnh37Jg82WiZ+vgxej7gvhQOdhCew3axI
G9mWx3fnA0iEobVD0/RzQgtRZ0CqenZ4/XOrmHLplq/hi7+mIuuWeH8kRXnVygim
Qh4I5IALZsttK7L0HQSOHH+v8YVocilDzSZNzGg9pQS+/X1wYXoHiXHCU9lSHe+m
SygajQdk7Lo=
=Ymkx
-----END PGP SIGNATURE-----

--Apple-Mail=_FD255228-C0D0-4E7D-8F9D-F4FA9F697630--


--===============2441794138102024739==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2441794138102024739==--
