Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2F55B7F3F
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 09:47:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 078EB30406A
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 07:47:58 -0700 (PDT)
Received: from mail-wg0-f45.google.com (mail-wg0-f45.google.com
	[74.125.82.45]) by cuda.sgi.com with ESMTP id XSiKRyR2i0ZWGb3g
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 18 Aug 2014 07:47:57 -0700 (PDT)
Received: by mail-wg0-f45.google.com with SMTP id x12so5171097wgg.16
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 07:47:55 -0700 (PDT)
Received: from Telcontar.valinor (177.Red-79-159-63.staticIP.rima-tde.net.
	[79.159.63.177]) by mx.google.com with ESMTPSA id
	gi5sm42792943wjd.33.2014.08.18.07.47.54 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Mon, 18 Aug 2014 07:47:54 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 9FDBE60E5A
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 16:47:52 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
	by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id ytwcbcCkRugQ for <xfs@oss.sgi.com>;
	Mon, 18 Aug 2014 16:47:52 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 792E060726
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 16:47:52 +0200 (CEST)
Date: Mon, 18 Aug 2014 16:47:36 +0200 (CEST)
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Subject: Re: [RFD]: Help in setting up XFS
In-Reply-To: <20140818132026.GO20518@dastard>
Message-ID: <alpine.LSU.2.11.1408181624430.5417@Telcontar.valinor>
References: <BLU181-W3698AB216D54D0CCE5A9739CD40@phx.gbl>
	<20140818070312.GM20518@dastard>
	<BLU181-W782ECB29BAB77090E0292A9CD40@phx.gbl>
	<alpine.LSU.2.11.1408181223400.5417@Telcontar.valinor>
	<20140818132026.GO20518@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mailing list <xfs@oss.sgi.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



On Monday, 2014-08-18 at 23:20 +1000, Dave Chinner wrote:
> On Mon, Aug 18, 2014 at 12:25:57PM +0200, Carlos E. R. wrote:


>> Just plug in the stick and click on the icon to mount it. No
>> different than any other filesystem.
>
> That doesn't work for machines with no desktop or ones that you
> access via ssh. Learn the command line first then you can always get
> the machine to do what you want regardless of how you need to access
> it. Indeed, typing commands is often faster than using the mouse,
> especially if you know how to use command history search
> effectively...

I use the CLI method myself, but I don't see the point on novices using it 
when there are modern methods far easier :-)

    Me, I would make sure the filesystem gets a label, and probably
    create an entry in fstab using that label, with the "user" option
    so that plain users can mount it. Then we have to add a directory
    as root owned by that user inside the stick so that he can write.
    Anyway, the procedure is the same for any Linux filesystem (but
    not for NTFS or FAT), not specific to XFS.


>> If it doesn't work, just ask on the help forum or mail lists of your
>> distribution.
>
> That's just wrong. If you've got an XFS problem or question, then
> this mailing list is exactly the right place to be asking for help.

IMHO no, because, for instance, the method for installation differs in 
each distribution, and their help forums should be more suited for such a 
basic guidance. Anyway, mounting or creating an XFS stick is the same as 
for ext4, btrfs, fat, reiserfs...

     I do a lot of that guidance, have been doing it for
     well over a decade ;-)


And each distribution has specifics. On ubuntu you probably need to do 
"sudo mount ...", a plain mount should fail. So if the generalized help an 
upstream mail list can provide, the best place to ask for help is the 
specific help forum of that distribution, as they will probably know best 
the easiest way to install and use the tools they provide.


But that's just my opinion :-)


- -- 
Cheers,
        Carlos E. R.
        (from openSUSE 13.1 x86_64 "Bottle" at Telcontar)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlPyEhgACgkQtTMYHG2NR9W1HgCdFiMBjJc6sCCdPAKNL6mm43rR
kQQAn0YjyEe0mkyNvlz08KkokepB8g1M
=sSfH
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
