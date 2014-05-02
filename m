Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 537D27F75
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 14:16:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2C34E304059
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 12:16:00 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id sfkSo1tdodicknvv for <xfs@oss.sgi.com>;
	Fri, 02 May 2014 12:15:57 -0700 (PDT)
Message-ID: <5363EEF4.7020200@sandeen.net>
Date: Fri, 02 May 2014 14:16:04 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS filesystem claims to be mounted after a disconnect
References: <5363A1D8.2020402@gmail.com>
	<5363B4C9.4000900@sandeen.net>	<5363CB5E.3090008@gmail.com>
	<5363CD70.3000006@sandeen.net> <5363DBD7.4060002@gmail.com>
	<5363E65C.6010006@sandeen.net> <5363ECE8.6030706@gmail.com>
In-Reply-To: <5363ECE8.6030706@gmail.com>
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
To: Martin Papik <mp6058@gmail.com>, xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 5/2/14, 2:07 PM, Martin Papik wrote:

...

>> You're right that this doesn't seem to be well described in
>> documentation, that's probably something we should address.
> 
> Yup, any idea when? .... Also, I think it would be good to have a
> section on what to do when things go south and what to expect. E.g. I
> found out the hard way that xfs_check on a 2TB disk allocates 16G of
> memory, so now I'm running it with cgroup based limitations, otherwise
> I couldn't even open my emails now. I'm still not sure when to run
> xfs_check and when xfs_repair, etc. At least I haven't seen such docs.
> Maybe I missed them.

We have a lot of docs at http://xfs.org/index.php/XFS_Papers_and_Documentation
in publican/xml format, but Dave has been making noises about converting
that to asciidoc.  In any case, the goal is documentation which is readily
available, version-controlled, for which patches may be submitted...

Like everything else, there are more things to do than there are hours
to do them.

- -Eric

> Martin
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTY+70AAoJECCuFpLhPd7gRAYP/2m4sRZZh6yb2z7FZOZOv9l9
uwde0O1/dLt1wpBArcdQoOnMSyPGXzH/0Dd0iDoGSCaTOGlfSwsLTnz7vzemN7am
bhhh0ky9vLaUdmqIBJA/DJYcPx3yJiTUm9W5ats8cWJFOMajgF9X92Lg5nlmDrto
kOw6+73ct3ShHo0yzf/SlbcBkPbQ7SJ3XAFyD7eF2+UxEe+UMRmPZq+C0PCYBYpE
GMi9ByUKuWSM3Misy+e9LBrnHFkq+JT+Z9EnBxJGACWQ+ctDMCjzou1TEWFiljd1
lXdotGOGDR9ETFC4A/9lmCd/CHgJ3xYVXxpgOH4sJuRsUG1QOgw/sInv2fbvDdTg
5f70Od3zzO3UflwWbz8LkltODc1Q+uCWdr2wDzRFQ1JWlxT1BdNvOs9Muly9FQFD
0AwusjyDiOhO8QFocivp2sYuohvUMlMCLKx07QPtVkx0a7o3N8iG4hOjMaAc8oEn
mNAHJMU/Et2VHFJr14mDUee3SeC+lMmKhhZ1SMr/G3WOlwaH6C7jpkts+rXWkHqI
r1GakzXi+F+hONLWSFTylwXFLioqHqjBYt/8UWZ/1pmw4pHFHm7XTwNdsaiLErtW
0a8fYvTFeSHWhPCX6s1XnUBqSFFADo7Q1ApJ3c9+bXlwWM7YOCxA9BtTLXNDJZCQ
22PiBukZVLhpYmNRZs4y
=TPaU
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
