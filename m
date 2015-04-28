Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 642937F61
	for <xfs@oss.sgi.com>; Mon, 27 Apr 2015 20:36:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D206BAC001
	for <xfs@oss.sgi.com>; Mon, 27 Apr 2015 18:35:59 -0700 (PDT)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
	[209.85.212.182]) by cuda.sgi.com with ESMTP id
	gVAkyzRVOEdWnihr (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 27 Apr 2015 18:35:57 -0700 (PDT)
Received: by wiun10 with SMTP id n10so10885557wiu.1
	for <xfs@oss.sgi.com>; Mon, 27 Apr 2015 18:35:56 -0700 (PDT)
Received: from minas-tirith.valinor
	(227.Red-79-146-163.dynamicIP.rima-tde.net. [79.146.163.227])
	by mx.google.com with ESMTPSA id m1sm13964850wiw.7.2015.04.27.18.35.55
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Mon, 27 Apr 2015 18:35:56 -0700 (PDT)
Received: from minas-tirith.valinor (localhost [127.0.0.1])
	by minas-tirith.valinor (Postfix) with ESMTP id 72F46184097
	for <xfs@oss.sgi.com>; Tue, 28 Apr 2015 03:35:54 +0200 (CEST)
Message-ID: <553EE3FA.9050603@opensuse.org>
Date: Tue, 28 Apr 2015 03:35:54 +0200
From: "Carlos E. R." <carlos.e.r@opensuse.org>
MIME-Version: 1.0
Subject: Re: Proposal/RFC: new metadata-specific UUID for V5 supers
References: <553EB3D1.10602@sandeen.net>
	<20150427233754.GT21261@dastard>	<553ED9D8.4050106@sandeen.net>
	<20150428012003.GS15810@dastard>
In-Reply-To: <20150428012003.GS15810@dastard>
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
To: XFS mailing list <xfs@oss.sgi.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 2015-04-28 03:20, Dave Chinner wrote:

>> Well, it's just the loss of ability to change UUID, which is
>> something People Used To Do(tm), and now can't.  It does come up.
>> Honestly if it had been done from day 0, it'd be a no-brainer I
>> think.  Doing it now, with an incompat flag, might not be a
>> reasonable tradeoff.
> 
> I think that labels are a far better way of dealing with this 
> problem. Get rid of the UUID mount checking (and hence the nouuid 
> mount option), and tell people to use by-label instead of by-uuid
> to identify their filesystems when doing clones and snapshots.
> Labels make it much easier for humans to identify the filesystem
> than UUIDs...

As a plain user, I can say that I have needed to mount both the
filesystem and its backup image, but Linux refused on the basis of the
id being the same. Of course, all identifiers are the same, label and
uuid.

- -- 
Cheers / Saludos,

		Carlos E. R.

  (from 13.1 x86_64 "Bottle" (Minas Tirith))
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iF4EAREIAAYFAlU+4/oACgkQja8UbcUWM1wazAD9GYaGlF722BiADT5xt1UCvHOj
f72zxyn7Ti4Xoxho6vAA/2Lik11x1rCy9vEdt6OYo8Z7yYvDncLHKfx+yvt9UxsU
=VNrO
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
