Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7JIZ4qZ220728 for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 13:35:14 -0500
Received: from internal.actusa.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 68B4B14E49B6
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 11:35:48 -0700 (PDT)
Received: from internal.actusa.net (internal.actusa.net [208.83.100.16]) by
	cuda.sgi.com with ESMTP id dxhUBJbkl7gjZwPk for
	<xfs@oss.sgi.com>; Wed, 19 Aug 2009 11:35:48 -0700 (PDT)
Message-ID: <4A8C45F8.4090409@actusa.net>
Date: Wed, 19 Aug 2009 11:35:36 -0700
From: Stuart Sheldon <stu@actusa.net>
MIME-Version: 1.0
Subject: Re: Kernel crash with >2.6.28.10 + drbd + nfs + xfs + heartbeat
References: <4A8C37F3.90300@actusa.net> <20090819182049.GA10787@infradead.org>
In-Reply-To: <20090819182049.GA10787@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: support@actusa.net, xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Thanks!

I've patched our tree and submitted the build job. Will report back with
test results.

Stu


Christoph Hellwig wrote:
> On Wed, Aug 19, 2009 at 10:35:47AM -0700, Stuart Sheldon wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA256
>>
>> Hi all,
>>
>> I've traced this down to what looks to be a XFS problem. When executing
>> a hb_standby the system crashes with the following error on the console:
> 
> Known problem.  Fixed in latest mainline, and
> http://bugzilla.kernel.org/show_bug.cgi?id=13375 has backports for
> 2.6.29 and 2.6.30.  I will send them to 2.6.30-stable this week, but
> there is no 2.6.29-stable anymore.
> 

- --
And you run and you run to catch up with the sun, but its sinking
And racing around to come up behind you again
The sun is the same in the relative way, but youre older
Shorter of breath and one day closer to death
               -- Pink Floyd - "Time Lyrics"
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAEBCAAGBQJKjEX0AAoJEFKVLITDJSGSXxgP/0qSGvIf/WHUm6txOYRo7lAH
xALV13fpfIi4ymlOtRztAFcSk4U2ciY3jgewfCK6/41EHwaeWkt3lCDPP8lLdgsA
PnZNBRPvR9vj5WxI7542VMuLgoBacCFo5xC6i8gE4ftCxmHLKH3GgLPTtzjjJ9AF
QtR+Maj40R3zOPQRJ94xgeTS9ZAO0DNWxf/ozqQqPdFPitqO9MXfPQibwLmQhz+a
n5fXgHV5pBymDnvY2YCBTTBX16dG8kvrnQrFuLVTmFRvco4A20V73sPnszMULQpn
rUb5n5C1KZuXqFj+JOQB7bcMCvK6IQ4d6lQkSwie/jVsBMtNCTTxWd7Sl5KsbjJg
ELG9M2aINkQG95s07F+Y0be40KKkrrr/5hp6Hb2i+zXTjjBIspy9GSZpTJVL557r
jjDwoHPHvkAXasi2iC2Yqqn03vUQq/uzv7QoLf3mrdUNY3lLjiEEU1Cyt8CJO8Gx
+t3OZIi7tQhy6QlgNuZGiX6CKW9HdpITBpv1JabOaqmlKHB6jQICJiYjGVOf0lkW
NMIVzK6rm8TAAcvQhFsBN9wrdJebpuPfyRFij4z5GfMLppxq0GT+MWw84/UKbxrE
NJHHkvrfDvLgWe4jx7gviJr/CNH3UT579Jjy024hUFBXBTUKSbjMoOt1+9W6njIu
BzIBzS+Rt8Ujtg32qgjY
=CePG
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
