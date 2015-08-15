Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 239A77F3F
	for <xfs@oss.sgi.com>; Sat, 15 Aug 2015 07:28:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0BC4E304032
	for <xfs@oss.sgi.com>; Sat, 15 Aug 2015 05:28:36 -0700 (PDT)
Received: from c.mx.filmlight.ltd.uk (c.mx.filmlight.ltd.uk [54.76.112.217])
	by cuda.sgi.com with ESMTP id dMkAzq7GVE9U97w8 for
	<xfs@oss.sgi.com>; Sat, 15 Aug 2015 05:28:25 -0700 (PDT)
Content-Type: multipart/mixed;
	boundary="Apple-Mail=_BD97A2A9-D1FA-4531-8CAC-6CED9AA0264E"
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: XFS File system in trouble
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <55CE75CA.5070506@mygrande.net>
Date: Sat, 15 Aug 2015 13:28:35 +0100
Message-Id: <74DC7EBF-0029-4E5E-9D96-DF193E2BE83F@filmlight.ltd.uk>
References: <20150720111747.GA53450@bfoster.bfoster>
	<55B73365.1050908@mygrande.net>
	<20150728123307.GC38784@bfoster.bfoster>
	<55B79BFD.6020509@mygrande.net>
	<20150728221150.GA26604@bfoster.bfoster>
	<55BE7C75.4060604@mygrande.net> <55C06F41.4030502@mygrande.net>
	<20150804224240.GU16638@dastard>
	<55C8006C.8070807@mygrande.net> <55CC375C.10902@mygrande.net>
	<20150814012635.GT3902@dastard> <55CE75CA.5070506@mygrande.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Leslie Rhorer <lrhorer@mygrande.net>
Cc: Eric Sandeen <sandeen@sandeen.net>, Brian Foster <bfoster@redhat.com>, Kris Rusocki <kszysiu@braxis.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Roger Willcocks <roger@filmlight.ltd.uk>, "Rhorer,
	Leslie" <Leslie.Rhorer@level3.com>


--Apple-Mail=_BD97A2A9-D1FA-4531-8CAC-6CED9AA0264E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

xfs_repair 3.2.1 runs cleanly.

xfs_repair 3.1.1 complains about a load of stuff, including:

bad version number 0x3 on inode 124656869424
bad version number 0x3 on inode 124656869424, would reset version number

and

entry "Rocket 2722" in shortform directory 90328125499 references =
non-existent inode 98915770424
would have junked entry "Rocket 2722" in directory inode 90328125499


--Apple-Mail=_BD97A2A9-D1FA-4531-8CAC-6CED9AA0264E
Content-Disposition: attachment;
	filename=xfs_repair-3.1.1.txt
Content-Type: text/plain;
	name="xfs_repair-3.1.1.txt"
Content-Transfer-Encoding: quoted-printable

Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
non-null user quota inode field in superblock 5
would reset bad sb for ag 5
bad uncorrected agheader 5, skipping ag...
non-null user quota inode field in superblock 10
would reset bad sb for ag 10
bad uncorrected agheader 10, skipping ag...
non-null user quota inode field in superblock 18
would reset bad sb for ag 18
bad uncorrected agheader 18, skipping ag...
non-null user quota inode field in superblock 23
would reset bad sb for ag 23
bad uncorrected agheader 23, skipping ag...
sb_icount 42368, counted 37184
sb_ifree 6598, counted 5799
sb_fdblocks 2324648299, counted 2025095064
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno =3D 0
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
        - agno =3D 8
        - agno =3D 9
        - agno =3D 10
        - agno =3D 11
        - agno =3D 12
        - agno =3D 13
        - agno =3D 14
        - agno =3D 15
        - agno =3D 16
        - agno =3D 17
        - agno =3D 18
        - agno =3D 19
        - agno =3D 20
        - agno =3D 21
        - agno =3D 22
        - agno =3D 23
        - agno =3D 24
        - agno =3D 25
        - agno =3D 26
        - agno =3D 27
        - agno =3D 28
        - agno =3D 29
bad version number 0x3 on inode 124656869424
bad version number 0x3 on inode 124656869424, would reset version number
        - agno =3D 30
        - agno =3D 31
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno =3D 0
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
        - agno =3D 29
        - agno =3D 31
        - agno =3D 5
entry "VIDEO_TS" in shortform directory 133143990276 references =
non-existent inode 21474840587
would have junked entry "VIDEO_TS" in directory inode 133143990276
would have corrected i8 count in directory 133143990276 from 7 to 6
        - agno =3D 7
        - agno =3D 14
        - agno =3D 15
entry "Downloads" at block 0 offset 72 in directory inode 30064775168 =
references non-existent inode 43037696048
	would clear inode number in entry at offset 72...
entry "Plugins" at block 0 offset 360 in directory inode 30064775168 =
references non-existent inode 98806263846
entry "AUDIO_TS" in shortform directory 64424513539 references =
non-existent inode 77309415427
would have junked entry "AUDIO_TS" in directory inode 64424513539
        - agno =3D 10
        - agno =3D 27
entry "Christmas" at block 0 offset 144 in directory inode 12884905984 =
references non-existent inode 98784251946
	would clear inode number in entry at offset 144...
        - agno =3D 28
        - agno =3D 23
        - agno =3D 22
entry ".." at block 0 offset 32 in directory inode 120259088386 =
references non-existent inode 77309415426
        - agno =3D 13
entry "DOWNTON_ABBEY_D1" at block 0 offset 48 in directory inode =
94489284608 references non-existent inode 77309415426
	would clear inode number in entry at offset 48...
        - agno =3D 24
        - agno =3D 18
entry "VIDEO_TS" in shortform directory 103079219201 references =
non-existent inode 21474840632
entry "The Greatest Hits" in shortform directory 133143990305 references =
non-existent inode 21507739691
        - agno =3D 25
would have junked entry "The Greatest Hits" in directory inode =
133143990305
entry "Photos" at block 0 offset 152 in directory inode 4096 references =
non-existent inode 21474840576
        - agno =3D 26
        - agno =3D 21
        - agno =3D 30
entry "OriginalIFOs" at block 0 offset 48 in directory inode 17179873282 =
references non-existent inode 21474840578
	would clear inode number in entry at offset 48...
entry "Twilight Zone Vol 06" at block 0 offset 112 in directory inode =
90194317313 references non-existent inode 43006791684
	would clear inode number in entry at offset 112...
entry "OriginalIFOs" at block 0 offset 48 in directory inode 17179873284 =
references non-existent inode 21474840580
	would clear inode number in entry at offset 48...
entry "VIDEO_TS" in shortform directory 8589938690 references =
non-existent inode 42949677058
        - agno =3D 6
        - agno =3D 8
        - agno =3D 12
entry "Cricket" in shortform directory 34359742464 references =
non-existent inode 99184005151
	would clear inode number in entry at offset 360...
        - agno =3D 9
        - agno =3D 20
entry "Symantec" in shortform directory 124571324436 references =
non-existent inode 21552037911
entry "Good & Better" at block 0 offset 328 in directory inode =
12884905984 references non-existent inode 21758378088
would have junked entry "VIDEO_TS" in directory inode 8589938690
would have corrected i8 count in directory 8589938690 from 2 to 1
        - agno =3D 19
entry "Back to the Future" at block 0 offset 104 in directory inode =
25769807872 references non-existent inode 21552037922
	would clear inode number in entry at offset 104...
	would clear inode number in entry at offset 32...
        - agno =3D 11
entry "Bourne, Jason" at block 0 offset 232 in directory inode =
25769807872 references non-existent inode 43037630470
	would clear inode number in entry at offset 232...
entry "DOWNTON_ABBEY_S2_D3" at block 0 offset 208 in directory inode =
94489284608 references non-existent inode 98784251906
        - agno =3D 16
entry "Crocodile Dundee" at block 0 offset 432 in directory inode =
25769807872 references non-existent inode 77370851391
would have junked entry "VIDEO_TS" in directory inode 103079219201
entry ".." at block 0 offset 32 in directory inode 47244644354 =
references non-existent inode 42949677058
	would clear inode number in entry at offset 432...
entry "VIDEO_TS" in shortform directory 107374186498 references =
non-existent inode 42949677059
	would clear inode number in entry at offset 152...
entry "Connie" in shortform directory 4355010569 references non-existent =
inode 21552037921
entry ".." at block 0 offset 32 in directory inode 60129546242 =
references non-existent inode 77309415424
	would clear inode number in entry at offset 32...
entry "Ray" at block 0 offset 2152 in directory inode 30064775168 =
references non-existent inode 43037630473
would have corrected i8 count in directory 64424513539 from 4 to 3
would have junked entry "Symantec" in directory inode 124571324436
entry "Disc 1" in shortform directory 38654709764 references =
non-existent inode 42949677086
would have corrected i8 count in directory 124571324436 from 5 to 4
	would clear inode number in entry at offset 328...
entry "VIDEO_TS" in shortform directory 55834578945 references =
non-existent inode 43006791683
entry ".." at block 0 offset 32 in directory inode 68727828484 =
references non-existent inode 42949677060
would have junked entry "VIDEO_TS" in directory inode 55834578945
	would clear inode number in entry at offset 208...
would have corrected i8 count in directory 133143990305 from 4 to 3
would have corrected i8 count in directory 103079219201 from 1 to 0
entry "1 The Best of Borge - Acts 1 and 2" at block 0 offset 48 in =
directory inode 94489284609 references non-existent inode 77309415448
	would clear inode number in entry at offset 32...
entry "Dr Phibes" at block 0 offset 560 in directory inode 25769807872 =
references non-existent inode 98806263821
        - agno =3D 17
would have junked entry "VIDEO_TS" in directory inode 107374186498
would have corrected i8 count in directory 107374186498 from 3 to 2
entry "home" at block 0 offset 264 in directory inode 4096 references =
non-existent inode 42949677056
would have junked entry "Connie" in directory inode 4355010569
entry "VIDEO_TS" in shortform directory 73014448131 references =
non-existent inode 98784251907
would have corrected i8 count in directory 4355010569 from 8 to 7
would have junked entry "VIDEO_TS" in directory inode 73014448131
would have junked entry "Disc 1" in directory inode 38654709764
would have corrected i8 count in directory 38654709764 from 9 to 8
would have corrected i8 count in directory 55834578945 from 2 to 1
entry ".." at block 0 offset 32 in directory inode 115964121113 =
references non-existent inode 98784251908
	would clear inode number in entry at offset 32...
	would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 55834578947 =
references non-existent inode 98784251904
	would clear inode number in entry at offset 48...
	would clear inode number in entry at offset 560...
would have junked entry "Cricket" in directory inode 34359742464
	would clear inode number in entry at offset 2152...
	would clear inode number in entry at offset 264...
would have corrected i8 count in directory 73014448131 from 3 to 2
entry ".." at block 0 offset 32 in directory inode 124571324437 =
references non-existent inode 98784251947
	would clear inode number in entry at offset 32...
entry "VIDEO_TS" at block 0 offset 48 in directory inode 51539611652 =
references non-existent inode 77309415428
	would clear inode number in entry at offset 48...
would have corrected i8 count in directory 34359742464 from 6 to 5
entry "VIDEO_TS" in shortform directory 34359742465 references =
non-existent inode 21474840596
would have junked entry "VIDEO_TS" in directory inode 34359742465
would have corrected i8 count in directory 34359742465 from 4 to 3
entry "Cape Fear" at block 0 offset 216 in directory inode 4099 =
references non-existent inode 77309415424
	would clear inode number in entry at offset 216...
entry "Dreamscape" at block 0 offset 368 in directory inode 4099 =
references non-existent inode 98784251904
	would clear inode number in entry at offset 368...
entry "Lemon Drop Kid, The" at block 0 offset 752 in directory inode =
4099 references non-existent inode 21474840577
	would clear inode number in entry at offset 752...
entry "My Chauffer" at block 0 offset 896 in directory inode 4099 =
references non-existent inode 42949677057
	would clear inode number in entry at offset 896...
entry "Telefon" at block 0 offset 1136 in directory inode 4099 =
references non-existent inode 77309415425
	would clear inode number in entry at offset 32...
entry "Disc 2" in shortform directory 30064775172 references =
non-existent inode 98784251908
	would clear inode number in entry at offset 1136...
would have junked entry "Disc 2" in directory inode 30064775172
entry "Without a Clue" at block 0 offset 1288 in directory inode 4099 =
references non-existent inode 98784251905
would have corrected i8 count in directory 30064775172 from 7 to 6
	would clear inode number in entry at offset 1288...
entry "American Dreamer" at block 0 offset 1528 in directory inode 4099 =
references non-existent inode 43394228246
	would clear inode number in entry at offset 1528...
entry "IMAX" at block 0 offset 880 in directory inode 25769807872 =
references non-existent inode 21552037923
entry "Noises Off" at block 0 offset 1560 in directory inode 4099 =
references non-existent inode 43052523560
	would clear inode number in entry at offset 1560...
entry "6 Lost_Episodes of Victor Borge Vol_2" at block 0 offset 272 in =
directory inode 94489284609 references non-existent inode 98784251933
	would clear inode number in entry at offset 272...
	would clear inode number in entry at offset 880...
entry "James Bond" at block 0 offset 976 in directory inode 25769807872 =
references non-existent inode 43037630471
	would clear inode number in entry at offset 976...
entry "Man with no Name" at block 0 offset 1176 in directory inode =
25769807872 references non-existent inode 77370957824
entry "OriginalIFOs" at block 0 offset 48 in directory inode 94489284613 =
references non-existent inode 98784251914
	would clear inode number in entry at offset 1176...
entry "Merlin Jones" at block 0 offset 1312 in directory inode =
25769807872 references non-existent inode 98806263822
	would clear inode number in entry at offset 1312...
	would clear inode number in entry at offset 48...
entry "Pink Panther" at block 0 offset 1664 in directory inode =
25769807872 references non-existent inode 21552037924
	would clear inode number in entry at offset 1664...
entry "Revenge of the Nerds" at block 0 offset 1792 in directory inode =
25769807872 references non-existent inode 43037630472
	would clear inode number in entry at offset 1792...
entry "SlideShow" at block 0 offset 1984 in directory inode 25769807872 =
references non-existent inode 77370957825
	would clear inode number in entry at offset 1984...
entry "Star Wars" at block 0 offset 2136 in directory inode 25769807872 =
references non-existent inode 98806263823
	would clear inode number in entry at offset 2136...
entry "Wings" at block 0 offset 2496 in directory inode 25769807872 =
references non-existent inode 21552037925
	would clear inode number in entry at offset 2496...
entry "Q01Files" in shortform directory 4355010593 references =
non-existent inode 98806083589
would have junked entry "Q01Files" in directory inode 4355010593
entry "Brave New Voices" at block 13 offset 4056 in directory inode =
25769807872 references non-existent inode 21676552218
	would clear inode number in entry at offset 4056...
would have corrected i8 count in directory 4355010593 from 7 to 6
entry ".." at block 0 offset 32 in directory inode 30064775184 =
references non-existent inode 42949677057
	would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 8589938726 references =
non-existent inode 21474840577
	would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 25769807875 =
references non-existent inode 98784251906
	would clear inode number in entry at offset 32...
entry "Disc 1" in shortform directory 25769807876 references =
non-existent inode 42949677060
would have junked entry "Disc 1" in directory inode 25769807876
would have corrected i8 count in directory 25769807876 from 9 to 8
entry ".." at block 0 offset 32 in directory inode 12884906014 =
references non-existent inode 77309415425
	would clear inode number in entry at offset 32...
entry "VIDEO_TS" in shortform directory 51539611685 references =
non-existent inode 77309415429
would have junked entry "VIDEO_TS" in directory inode 51539611685
would have corrected i8 count in directory 51539611685 from 7 to 6
entry ".." at block 0 offset 32 in directory inode 8589938734 references =
non-existent inode 98784251933
	would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 68727828531 =
references non-existent inode 42949677086
	would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 103079219243 =
references non-existent inode 77309415448
	would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 64424513580 =
references non-existent inode 43006791684
	would clear inode number in entry at offset 32...
entry "Christmas" at block 0 offset 48 in directory inode 94489284652 =
references non-existent inode 21507739692
	would clear inode number in entry at offset 48...
entry "website" in shortform directory 73014448183 references =
non-existent inode 43196874752
would have junked entry "website" in directory inode 73014448183
would have corrected i8 count in directory 73014448183 from 5 to 4
entry ".." at block 0 offset 32 in directory inode 116006125580 =
references non-existent inode 98784251947
	would clear inode number in entry at offset 32...
entry "1997" at block 0 offset 176 in directory inode 128857702411 =
references non-existent inode 21552037912
entry ".." at block 0 offset 32 in directory inode 111673475085 =
references non-existent inode 98784251947
	would clear inode number in entry at offset 176...
	would clear inode number in entry at offset 32...
entry "Q01Files" in shortform directory 94489284668 references =
non-existent inode 43006791737
would have junked entry "Q01Files" in directory inode 94489284668
entry "2006" at block 0 offset 256 in directory inode 128857702411 =
references non-existent inode 43006791739
would have corrected i8 count in directory 94489284668 from 7 to 6
	would clear inode number in entry at offset 256...
entry "VALIDATE" at block 0 offset 440 in directory inode 128857702411 =
references non-existent inode 77370843184
	would clear inode number in entry at offset 440...
entry ".." at block 0 offset 32 in directory inode 128857702412 =
references non-existent inode 98784251947
	would clear inode number in entry at offset 32...
entry "Power" at block 0 offset 48 in directory inode 128857702412 =
references non-existent inode 98802544890
	would clear inode number in entry at offset 48...
entry "Q01Files" in shortform directory 128857702413 references =
non-existent inode 77370843181
entry ".." at block 0 offset 32 in directory inode 103124635648 =
references non-existent inode 98784251947
	would clear inode number in entry at offset 32...
would have junked entry "Q01Files" in directory inode 128857702413
would have corrected i8 count in directory 128857702413 from 8 to 7
entry "04 - 100 Years (Album Version).mp3" at block 0 offset 104 in =
directory inode 90270486545 references non-existent inode 98915754013
	would clear inode number in entry at offset 104...
entry "ARJ" at block 0 offset 48 in directory inode 64471937038 =
references non-existent inode 77370843142
	would clear inode number in entry at offset 48...
entry "Leslie" at block 0 offset 168 in directory inode 64471937038 =
references non-existent inode 98784251947
	would clear inode number in entry at offset 168...
entry ".." at block 0 offset 32 in directory inode 120329281560 =
references non-existent inode 98784251947
	would clear inode number in entry at offset 32...
entry "1993" at block 0 offset 112 in directory inode 120329281560 =
references non-existent inode 98802544862
	would clear inode number in entry at offset 112...
entry "Quicken Downloads" at block 0 offset 376 in directory inode =
120329281560 references non-existent inode 21552037890
	would clear inode number in entry at offset 376...
entry ".." at block 0 offset 32 in directory inode 8644796441 references =
non-existent inode 77370843143
entry "Closer" at block 0 offset 96 in directory inode 68972563 =
references non-existent inode 43006791718
	would clear inode number in entry at offset 32...
	would clear inode number in entry at offset 96...
entry "EasyBoot" at block 0 offset 64 in directory inode 107374198820 =
references non-existent inode 98918465573
	would clear inode number in entry at offset 64...
entry ".." at block 0 offset 32 in directory inode 68972565 references =
non-existent inode 77370843143
	would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 47272431653 =
references non-existent inode 43052523560
	would clear inode number in entry at offset 32...
entry "OriginalIFOs" at block 0 offset 48 in directory inode 17241608247 =
references non-existent inode 21474840600
entry "debian" at block 0 offset 120 in directory inode 47272431662 =
references non-existent inode 21676515394
	would clear inode number in entry at offset 48...
	would clear inode number in entry at offset 120...
entry ".." at block 0 offset 32 in directory inode 17241608248 =
references non-existent inode 98784251905
	would clear inode number in entry at offset 32...
entry "modules" at block 0 offset 224 in directory inode 47272431662 =
references non-existent inode 43198287918
	would clear inode number in entry at offset 224...
entry "drivers" at block 0 offset 144 in directory inode 51602448390 =
references non-existent inode 77370851386
	would clear inode number in entry at offset 144...
entry "server" at block 0 offset 248 in directory inode 51602448390 =
references non-existent inode 98806263841
entry ".." at block 0 offset 32 in directory inode 4360618047 references =
non-existent inode 43037696049
	would clear inode number in entry at offset 32...
	would clear inode number in entry at offset 248...
entry "instantcake-tcd649-1.1-std.iso" at block 0 offset 48 in directory =
inode 4360618047 references non-existent inode 43196874847
	would clear inode number in entry at offset 48...
entry "instantcake-tcd649-1.1-std.iso.zip" at block 0 offset 96 in =
directory inode 4360618047 references non-existent inode 43196874848
	would clear inode number in entry at offset 96...
entry "instantcake-tcd648-1.0-9.2a-01-2-648.iso" at block 0 offset 144 =
in directory inode 4360618047 references non-existent inode 43196874846
	would clear inode number in entry at offset 144...
entry ".." at block 0 offset 32 in directory inode 73031290880 =
references non-existent inode 98784251947
	would clear inode number in entry at offset 32...
entry "Website" at block 0 offset 48 in directory inode 73031290881 =
references non-existent inode 77370843180
	would clear inode number in entry at offset 48...
entry ".." at block 0 offset 32 in directory inode 38704078853 =
references non-existent inode 43037696048
	would clear inode number in entry at offset 32...
entry "i386" in shortform directory 34422018084 references non-existent =
inode 43196874813
entry "x86" in shortform directory 107599970322 references non-existent =
inode 98915766322
would have junked entry "x86" in directory inode 107599970322
would have junked entry "i386" in directory inode 34422018084
would have corrected i8 count in directory 107599970322 from 3 to 2
would have corrected i8 count in directory 34422018084 from 4 to 3
entry ".." at block 0 offset 32 in directory inode 30094696481 =
references non-existent inode 21507739691
	would clear inode number in entry at offset 32...
entry "Frc" at block 0 offset 200 in directory inode 107600003166 =
references non-existent inode 21676544021
	would clear inode number in entry at offset 200...
entry "Nor" at block 0 offset 280 in directory inode 107600003166 =
references non-existent inode 43196874879
	would clear inode number in entry at offset 280...
entry ".." at block 0 offset 32 in directory inode 107600003167 =
references non-existent inode 98915770389
	would clear inode number in entry at offset 32...
entry "Fin" at block 0 offset 80 in directory inode 107600003167 =
references non-existent inode 77491523634
	would clear inode number in entry at offset 80...
entry "Por" at block 0 offset 160 in directory inode 107600003167 =
references non-existent inode 98915770394
	would clear inode number in entry at offset 160...
entry "My Pictures" at block 0 offset 80 in directory inode 68748406819 =
references non-existent inode 43037630465
	would clear inode number in entry at offset 80...
entry "OriginalIFOs" at block 0 offset 960 in directory inode =
64484773928 references non-existent inode 77594005544
	would clear inode number in entry at offset 960...
entry ".." at block 0 offset 32 in directory inode 94536843282 =
references non-existent inode 21667586090
	would clear inode number in entry at offset 32...
entry "2.4.4" at block 0 offset 200 in directory inode 111686406241 =
references non-existent inode 21676515447
	would clear inode number in entry at offset 200...
entry "Old" at block 0 offset 64 in directory inode 34465357826 =
references non-existent inode 43006791720
	would clear inode number in entry at offset 64...
entry ".." at block 0 offset 32 in directory inode 55951405125 =
references non-existent inode 43037696049
	would clear inode number in entry at offset 32...
entry "mfs-ftp" at block 0 offset 72 in directory inode 55951405125 =
references non-existent inode 98915766334
entry "Steve" at block 0 offset 400 in directory inode 60208181291 =
references non-existent inode 43055878204
	would clear inode number in entry at offset 400...
	would clear inode number in entry at offset 72...
entry "inc" in shortform directory 55951405131 references non-existent =
inode 21676499003
would have junked entry "inc" in directory inode 55951405131
would have corrected i8 count in directory 55951405131 from 3 to 2
entry ".." at block 0 offset 32 in directory inode 60208181292 =
references non-existent inode 43037696048
	would clear inode number in entry at offset 32...
entry "inc" in shortform directory 55951405133 references non-existent =
inode 43198287913
would have junked entry "inc" in directory inode 55951405133
would have corrected i8 count in directory 55951405133 from 3 to 2
entry "license" at block 0 offset 112 in directory inode 60208181292 =
references non-existent inode 98915770383
	would clear inode number in entry at offset 112...
entry ".." at block 0 offset 32 in directory inode 47280693257 =
references non-existent inode 98915766286
	would clear inode number in entry at offset 32...
entry "MacOS" at block 0 offset 88 in directory inode 4479877124 =
references non-existent inode 98915766308
	would clear inode number in entry at offset 88...
entry "makemkv-bin-1.9.1" at block 0 offset 1176 in directory inode =
120362094654 references non-existent inode 43394228240
	would clear inode number in entry at offset 1176...
entry "ffmpeg-2.1.1" at block 0 offset 1240 in directory inode =
120362094654 references non-existent inode 43196874826
	would clear inode number in entry at offset 1240...
entry "makemkv-oss-1.9.0" at block 0 offset 1488 in directory inode =
120362094654 references non-existent inode 77491511347
	would clear inode number in entry at offset 1488...
entry "DOCS" at block 0 offset 72 in directory inode 17319272475 =
references non-existent inode 43006791738
	would clear inode number in entry at offset 72...
entry ".." at block 0 offset 32 in directory inode 107600539659 =
references non-existent inode 98915782703
	would clear inode number in entry at offset 32...
entry "WinNT" at block 0 offset 256 in directory inode 17319272475 =
references non-existent inode 77370843182
	would clear inode number in entry at offset 256...
entry "Windows" at block 0 offset 136 in directory inode 94536843319 =
references non-existent inode 77491511346
	would clear inode number in entry at offset 136...
entry "logrotate" at block 0 offset 240 in directory inode 94536843319 =
references non-existent inode 98915766320
entry "src" in shortform directory 47280693277 references non-existent =
inode 77491511349
would have junked entry "src" in directory inode 47280693277
	would clear inode number in entry at offset 240...
would have corrected i8 count in directory 47280693277 from 4 to 3
entry ".." at block 0 offset 32 in directory inode 47280693278 =
references non-existent inode 43037696049
	would clear inode number in entry at offset 32...
entry ".svn" in shortform directory 4479877167 references non-existent =
inode 21676515401
would have junked entry ".svn" in directory inode 4479877167
would have corrected i8 count in directory 4479877167 from 2 to 1
entry "master.zip" in shortform directory 30095568937 references =
non-existent inode 77491519552
would have junked entry "master.zip" in directory inode 30095568937
would have corrected i8 count in directory 30095568937 from 3 to 2
entry ".." at block 0 offset 32 in directory inode 73101590549 =
references non-existent inode 43037630465
	would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 25925189647 =
references non-existent inode 21507739691
	would clear inode number in entry at offset 32...
entry "tmp" in shortform directory 60276125765 references non-existent =
inode 21676499002
would have junked entry "tmp" in directory inode 60276125765
would have corrected i8 count in directory 60276125765 from 4 to 3
entry "Flowplayer" at block 0 offset 48 in directory inode 25925189648 =
references non-existent inode 43006791719
	would clear inode number in entry at offset 48...
entry "lgpl" in shortform directory 60276125775 references non-existent =
inode 77491511357
would have junked entry "lgpl" in directory inode 60276125775
would have corrected i8 count in directory 60276125775 from 3 to 2
entry ".." at block 0 offset 32 in directory inode 4479877246 references =
non-existent inode 98915770389
	would clear inode number in entry at offset 32...
entry "ChnEng" at block 0 offset 80 in directory inode 4479877246 =
references non-existent inode 43198083122
	would clear inode number in entry at offset 80...
entry "Fre" at block 0 offset 200 in directory inode 4479877246 =
references non-existent inode 77491523641
entry ".." at block 0 offset 32 in directory inode 60276125777 =
references non-existent inode 43037696049
	would clear inode number in entry at offset 32...
	would clear inode number in entry at offset 200...
entry "Pol" at block 0 offset 280 in directory inode 4479877246 =
references non-existent inode 98915770398
	would clear inode number in entry at offset 280...
entry "AMD_Chipset_Driver_xp" in shortform directory 111886688296 =
references non-existent inode 21676929031
would have junked entry "AMD_Chipset_Driver_xp" in directory inode =
111886688296
would have corrected i8 count in directory 111886688296 from 2 to 1
entry "Win" at block 0 offset 112 in directory inode 133252530210 =
references non-existent inode 21667586091
	would clear inode number in entry at offset 112...
entry "man" at block 0 offset 216 in directory inode 133252530210 =
references non-existent inode 43037696050
	would clear inode number in entry at offset 216...
entry ".." at block 0 offset 32 in directory inode 107600724055 =
references non-existent inode 21706297361
	would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 85960990858 =
references non-existent inode 98784251947
	would clear inode number in entry at offset 32...
entry "x86" in shortform directory 124656844832 references non-existent =
inode 21676499001
would have junked entry "x86" in directory inode 124656844832
would have corrected i8 count in directory 124656844832 from 5 to 4
entry "text-base" in shortform directory 60276129815 references =
non-existent inode 77491519568
would have junked entry "text-base" in directory inode 60276129815
would have corrected i8 count in directory 60276129815 from 5 to 4
entry "src" in shortform directory 73105653769 references non-existent =
inode 77594005535
would have junked entry "src" in directory inode 73105653769
would have corrected i8 count in directory 73105653769 from 4 to 3
entry "Windows Vista 32bit" at block 0 offset 152 in directory inode =
55952322563 references non-existent inode 77491544085
	would clear inode number in entry at offset 152...
entry "English" at block 0 offset 48 in directory inode 4488884232 =
references non-existent inode 98916159526
	would clear inode number in entry at offset 48...
entry "Windows XP" in shortform directory 55952322565 references =
non-existent inode 77491544087
would have junked entry "Windows XP" in directory inode 55952322565
would have corrected i8 count in directory 55952322565 from 6 to 5
entry "jni" in shortform directory 120448295015 references non-existent =
inode 77491519572
would have junked entry "jni" in directory inode 120448295015
would have corrected i8 count in directory 120448295015 from 9 to 8
entry "tmp" in shortform directory 60276129839 references non-existent =
inode 77491519571
would have junked entry "tmp" in directory inode 60276129839
would have corrected i8 count in directory 60276129839 from 5 to 4
entry "props" in shortform directory 60276129840 references non-existent =
inode 98915770380
entry "Cozumel 2000" at block 0 offset 104 in directory inode 4488884248 =
references non-existent inode 43392253987
	would clear inode number in entry at offset 104...
would have junked entry "props" in directory inode 60276129840
would have corrected i8 count in directory 60276129840 from 5 to 4
entry "enst" in shortform directory 60276129841 references non-existent =
inode 98915770381
would have junked entry "enst" in directory inode 60276129841
entry "os" at block 0 offset 272 in directory inode 8843165728 =
references non-existent inode 21758378090
would have corrected i8 count in directory 60276129841 from 3 to 2
	would clear inode number in entry at offset 272...
entry "HDAudio" in shortform directory 47280783476 references =
non-existent inode 43198292025
would have junked entry "HDAudio" in directory inode 47280783476
would have corrected i8 count in directory 47280783476 from 2 to 1
entry ".." at block 0 offset 32 in directory inode 81653158051 =
references non-existent inode 98784251947
	would clear inode number in entry at offset 32...
entry "out" at block 0 offset 528 in directory inode 68840685627 =
references non-existent inode 77491511315
	would clear inode number in entry at offset 528...
entry "HDx64" in shortform directory 60276203639 references non-existent =
inode 98915782711
would have junked entry "HDx64" in directory inode 60276203639
would have corrected i8 count in directory 60276203639 from 5 to 4
entry ".." at block 0 offset 32 in directory inode 111887126568 =
references non-existent inode 21706297361
	would clear inode number in entry at offset 32...
entry "sensord" at block 0 offset 184 in directory inode 111887126568 =
references non-existent inode 21706330113
entry "Sounds of the Seventies- Super 70's" in shortform directory =
4488884269 references non-existent inode 43392978949
	would clear inode number in entry at offset 184...
would have junked entry "Sounds of the Seventies- Super 70's" in =
directory inode 4488884269
would have corrected i8 count in directory 4488884269 from 2 to 1
entry "AM Gold 1968" in shortform directory 4488884270 references =
non-existent inode 98916237469
would have junked entry "AM Gold 1968" in directory inode 4488884270
would have corrected i8 count in directory 4488884270 from 2 to 1
entry "7_2" at block 0 offset 128 in directory inode 30191923231 =
references non-existent inode 98915766299
entry "The Rock 'N Roll Era 1958" in shortform directory 4488884272 =
references non-existent inode 43392978959
entry ".." at block 0 offset 32 in directory inode 116192387077 =
references non-existent inode 98915770378
	would clear inode number in entry at offset 32...
would have junked entry "The Rock 'N Roll Era 1958" in directory inode =
4488884272
	would clear inode number in entry at offset 128...
would have corrected i8 count in directory 4488884272 from 2 to 1
entry "Equipment Manuals" at block 0 offset 184 in directory inode =
51699605523 references non-existent inode 43196874878
	would clear inode number in entry at offset 184...
entry "NVIDIA Graphics" at block 0 offset 368 in directory inode =
51699605523 references non-existent inode 77491523621
	would clear inode number in entry at offset 368...
entry "1964 Classic Rock" in shortform directory 4488884274 references =
non-existent inode 21706354726
would have junked entry "1964 Classic Rock" in directory inode =
4488884274
would have corrected i8 count in directory 4488884274 from 2 to 1
entry ".." at block 0 offset 32 in directory inode 4488884280 references =
non-existent inode 43392413878
	would clear inode number in entry at offset 32...
entry "Very Best of - Only the beginning" in shortform directory =
111887241217 references non-existent inode 98916237470
would have junked entry "Very Best of - Only the beginning" in directory =
inode 111887241217
would have corrected i8 count in directory 111887241217 from 3 to 2
entry "Sounds of the Seventies- 1973" in shortform directory =
111887241225 references non-existent inode 98918465545
would have junked entry "Sounds of the Seventies- 1973" in directory =
inode 111887241225
would have corrected i8 count in directory 111887241225 from 4 to 3
entry "Groovin'" in shortform directory 111887241228 references =
non-existent inode 43392979005
would have junked entry "Groovin'" in directory inode 111887241228
would have corrected i8 count in directory 111887241228 from 2 to 1
entry "utility" in shortform directory 60276822060 references =
non-existent inode 77491990553
entry "src" in shortform directory 30191923251 references non-existent =
inode 98915766329
would have junked entry "utility" in directory inode 60276822060
would have corrected i8 count in directory 60276822060 from 6 to 5
would have junked entry "src" in directory inode 30191923251
would have corrected i8 count in directory 30191923251 from 3 to 2
entry "text-base" in shortform directory 30191923257 references =
non-existent inode 43198287920
would have junked entry "text-base" in directory inode 30191923257
would have corrected i8 count in directory 30191923257 from 4 to 3
entry "Classical" in shortform directory 202739721 references =
non-existent inode 77492862991
would have junked entry "Classical" in directory inode 202739721
would have corrected i8 count in directory 202739721 from 6 to 5
entry "Photographs" at block 0 offset 176 in directory inode 8843165744 =
references non-existent inode 77491511325
	would clear inode number in entry at offset 176...
entry "text-base" in shortform directory 30191923268 references =
non-existent inode 43198287924
would have junked entry "text-base" in directory inode 30191923268
would have corrected i8 count in directory 30191923268 from 4 to 3
entry "Love Songs" in shortform directory 47332347959 references =
non-existent inode 21706354724
would have junked entry "Love Songs" in directory inode 47332347959
would have corrected i8 count in directory 47332347959 from 2 to 1
entry ".." at block 0 offset 32 in directory inode 47332347961 =
references non-existent inode 43392413878
	would clear inode number in entry at offset 32...
entry "AM Gold - 1973" at block 0 offset 48 in directory inode =
47332347961 references non-existent inode 77492490251
	would clear inode number in entry at offset 48...
entry "Live! Live! Live!" in shortform directory 60276891651 references =
non-existent inode 21706354714
would have junked entry "Live! Live! Live!" in directory inode =
60276891651
would have corrected i8 count in directory 60276891651 from 2 to 1
entry "AM Gold 1970" in shortform directory 60276891652 references =
non-existent inode 43392978958
would have junked entry "AM Gold 1970" in directory inode 60276891652
entry "Gypsy Honeymoon- The Best of Kim Carnes" in shortform directory =
47332347962 references non-existent inode 21706354728
would have corrected i8 count in directory 60276891652 from 4 to 3
would have junked entry "Gypsy Honeymoon- The Best of Kim Carnes" in =
directory inode 47332347962
would have corrected i8 count in directory 47332347962 from 2 to 1
entry "plugins" at block 0 offset 312 in directory inode 124656857201 =
references non-existent inode 77594005540
	would clear inode number in entry at offset 312...
entry "St. Elmo's Fire" in shortform directory 47335895041 references =
non-existent inode 21706354772
would have junked entry "St. Elmo's Fire" in directory inode 47335895041
would have corrected i8 count in directory 47335895041 from 2 to 1
entry "Greatest Hits + Five Unleashed" in shortform directory =
60276891660 references non-existent inode 77492490258
would have junked entry "Greatest Hits + Five Unleashed" in directory =
inode 60276891660
entry ".." at block 0 offset 32 in directory inode 68912447582 =
references non-existent inode 43037696049
	would clear inode number in entry at offset 32...
would have corrected i8 count in directory 60276891660 from 2 to 1
entry "XZL USB DMX" at block 0 offset 80 in directory inode 30191923325 =
references non-existent inode 77491523643
	would clear inode number in entry at offset 80...
entry "sounds" at block 0 offset 1368 in directory inode 30191923325 =
references non-existent inode 77594005563
entry "The Rock & Roll Era- 1963" in shortform directory 60276891661 =
references non-existent inode 21706354763
	would clear inode number in entry at offset 1368...
would have junked entry "The Rock & Roll Era- 1963" in directory inode =
60276891661
would have corrected i8 count in directory 60276891661 from 4 to 3
entry ".." at block 0 offset 32 in directory inode 116192387114 =
references non-existent inode 98915770389
	would clear inode number in entry at offset 32...
entry "src" in shortform directory 55952388115 references non-existent =
inode 77491511355
would have junked entry "src" in directory inode 55952388115
would have corrected i8 count in directory 55952388115 from 5 to 4
entry "Fre" at block 0 offset 216 in directory inode 116192387114 =
references non-existent inode 21676544029
	would clear inode number in entry at offset 216...
entry ".." at block 0 offset 32 in directory inode 60276891663 =
references non-existent inode 43392413878
entry "NAIS" at block 0 offset 760 in directory inode 202739732 =
references non-existent inode 21676515414
	would clear inode number in entry at offset 760...
	would clear inode number in entry at offset 32...
entry "bin" in shortform directory 73105666390 references non-existent =
inode 77491511330
entry "Pol" at block 0 offset 296 in directory inode 116192387114 =
references non-existent inode 43198083120
	would clear inode number in entry at offset 296...
would have junked entry "bin" in directory inode 73105666390
would have corrected i8 count in directory 73105666390 from 3 to 2
entry "libusb-win32" in shortform directory 30191947794 references =
non-existent inode 43198083129
would have junked entry "libusb-win32" in directory inode 30191947794
would have corrected i8 count in directory 30191947794 from 2 to 1
entry "amd64" in shortform directory 73105666392 references non-existent =
inode 77491511331
would have junked entry "amd64" in directory inode 73105666392
would have corrected i8 count in directory 73105666392 from 4 to 3
entry "props" in shortform directory 133252546594 references =
non-existent inode 21676515400
would have junked entry "props" in directory inode 133252546594
would have corrected i8 count in directory 133252546594 from 5 to 4
entry "i386" in shortform directory 73105666394 references non-existent =
inode 77491511334
entry "tmp" in shortform directory 55952388137 references non-existent =
inode 77491519573
would have junked entry "i386" in directory inode 73105666394
would have corrected i8 count in directory 73105666394 from 3 to 2
would have junked entry "tmp" in directory inode 55952388137
would have corrected i8 count in directory 55952388137 from 5 to 4
entry "4_0_U6" at block 0 offset 48 in directory inode 73105666395 =
references non-existent inode 77491511336
	would clear inode number in entry at offset 48...
entry "5_0_U2" at block 0 offset 160 in directory inode 73105666395 =
references non-existent inode 98915766303
	would clear inode number in entry at offset 160...
entry ".." at block 0 offset 32 in directory inode 124656869394 =
references non-existent inode 98915770389
	would clear inode number in entry at offset 32...
entry "Cze" at block 0 offset 120 in directory inode 124656869394 =
references non-existent inode 98915770396
	would clear inode number in entry at offset 120...
entry "Rus" at block 0 offset 344 in directory inode 124656869394 =
references non-existent inode 21676544030
entry "TF-3239DL" in shortform directory 30191951881 references =
non-existent inode 43198287899
	would clear inode number in entry at offset 344...
entry "CLI" in shortform directory 73105666398 references non-existent =
inode 77491511343
would have junked entry "CLI" in directory inode 73105666398
would have junked entry "TF-3239DL" in directory inode 30191951881
would have corrected i8 count in directory 30191951881 from 8 to 7
would have corrected i8 count in directory 73105666398 from 5 to 4
entry "Nor" in shortform directory 133252555235 references non-existent =
inode 21676544039
entry "2010-03-30" at block 0 offset 96 in directory inode 64551399498 =
references non-existent inode 77491511326
	would clear inode number in entry at offset 96...
entry "2013-07-26" at block 0 offset 216 in directory inode 64551399498 =
references non-existent inode 98915766291
	would clear inode number in entry at offset 216...
would have junked entry "Nor" in directory inode 133252555235
would have corrected i8 count in directory 133252555235 from 9 to 8
entry "libabi" at block 0 offset 72 in directory inode 64551399501 =
references non-existent inode 43196874832
	would clear inode number in entry at offset 72...
entry "msvc" at block 0 offset 264 in directory inode 64551399501 =
references non-existent inode 77491511350
	would clear inode number in entry at offset 264...
entry "inc" in shortform directory 64551399506 references non-existent =
inode 77491511353
would have junked entry "inc" in directory inode 64551399506
entry "Vista32" in shortform directory 30191988767 references =
non-existent inode 43265073158
would have corrected i8 count in directory 64551399506 from 5 to 4
would have junked entry "Vista32" in directory inode 30191988767
entry ".svn" in shortform directory 64551399519 references non-existent =
inode 98915770375
would have junked entry ".svn" in directory inode 64551399519
would have corrected i8 count in directory 64551399519 from 2 to 1
would have corrected i8 count in directory 30191988767 from 5 to 4
entry "autoxxx" at block 0 offset 48 in directory inode 73105666406 =
references non-existent inode 21676499006
	would clear inode number in entry at offset 48...
entry "libmakemkv" at block 0 offset 168 in directory inode 73105666406 =
references non-existent inode 43198287914
	would clear inode number in entry at offset 168...
entry "nonusb" in shortform directory 73105666412 references =
non-existent inode 77491523584
would have junked entry "nonusb" in directory inode 73105666412
would have corrected i8 count in directory 73105666412 from 7 to 6
entry ".." at block 0 offset 32 in directory inode 64551436290 =
references non-existent inode 43037696049
	would clear inode number in entry at offset 32...
entry "tivostream_v0p5" at block 0 offset 144 in directory inode =
64551436290 references non-existent inode 77491523585
	would clear inode number in entry at offset 144...
entry "2.4.20_Gen05" at block 0 offset 128 in directory inode 8843169875 =
references non-existent inode 43196874829
	would clear inode number in entry at offset 128...
entry ".." at block 0 offset 32 in directory inode 120471560274 =
references non-existent inode 98915770424
	would clear inode number in entry at offset 32...
entry "libmkv" in shortform directory 8843169882 references non-existent =
inode 21676515393
would have junked entry "libmkv" in directory inode 8843169882
would have corrected i8 count in directory 8843169882 from 3 to 2
entry "hbbtvplayer" at block 0 offset 104 in directory inode 8843169883 =
references non-existent inode 98915766333
	would clear inode number in entry at offset 104...
entry "osmozilla" at block 0 offset 448 in directory inode 8843169883 =
references non-existent inode 21676515395
	would clear inode number in entry at offset 448...
entry "Brolink" at block 0 offset 48 in directory inode 73105719305 =
references non-existent inode 77491523639
entry ".." at block 0 offset 32 in directory inode 8843169890 references =
non-existent inode 98915770389
	would clear inode number in entry at offset 32...
entry "Frc" at block 0 offset 168 in directory inode 8843169890 =
references non-existent inode 21676544040
	would clear inode number in entry at offset 48...
entry "prop-base" in shortform directory 73105719310 references =
non-existent inode 77491519567
would have junked entry "prop-base" in directory inode 73105719310
would have corrected i8 count in directory 73105719310 from 4 to 3
	would clear inode number in entry at offset 168...
bad version number 0x3 on inode 124656869424, would reset version number
entry "Por" at block 0 offset 248 in directory inode 8843169890 =
references non-existent inode 43198083127
	would clear inode number in entry at offset 248...
entry "MP3" at block 0 offset 64 in directory inode 86092185615 =
references non-existent inode 43392413878
entry "i386" in shortform directory 17336291384 references non-existent =
inode 21676515421
	would clear inode number in entry at offset 64...
would have junked entry "i386" in directory inode 17336291384
would have corrected i8 count in directory 17336291384 from 3 to 2
entry ".." at block 0 offset 32 in directory inode 86092185616 =
references non-existent inode 21667586090
	would clear inode number in entry at offset 32...
entry "activityi_data" at block 0 offset 48 in directory inode =
86092185616 references non-existent inode 98806263847
	would clear inode number in entry at offset 48...
entry ".." at block 0 offset 32 in directory inode 90271576326 =
references non-existent inode 98784251947
	would clear inode number in entry at offset 32...
entry "TiVo_Temp" at block 0 offset 224 in directory inode 81786920975 =
references non-existent inode 21706354697
entry "Christmas" at block 0 offset 48 in directory inode 90271576326 =
references non-existent inode 21507739693
	would clear inode number in entry at offset 48...
	would clear inode number in entry at offset 224...
entry "x86_64" in shortform directory 68912455734 references =
non-existent inode 77491511341
would have junked entry "x86_64" in directory inode 68912455734
would have corrected i8 count in directory 68912455734 from 3 to 2
entry "text-base" in shortform directory 8859947015 references =
non-existent inode 21676515399
entry "10_11" in shortform directory 17420197955 references non-existent =
inode 21676515432
would have junked entry "text-base" in directory inode 8859947015
would have corrected i8 count in directory 8859947015 from 4 to 3
would have junked entry "10_11" in directory inode 17420197955
entry "text-base" in shortform directory 8859947019 references =
non-existent inode 21676515435
would have corrected i8 count in directory 17420197955 from 2 to 1
would have junked entry "text-base" in directory inode 8859947019
would have corrected i8 count in directory 8859947019 from 4 to 3
entry "64Bit" in shortform directory 17420197956 references non-existent =
inode 21676515433
would have junked entry "64Bit" in directory inode 17420197956
entry "libebml" at block 0 offset 120 in directory inode 68912455741 =
references non-existent inode 43196874834
	would clear inode number in entry at offset 120...
entry "sstring" at block 0 offset 296 in directory inode 68912455741 =
references non-existent inode 77491511352
	would clear inode number in entry at offset 296...
would have corrected i8 count in directory 17420197956 from 3 to 2
entry "text-base" in shortform directory 8859947020 references =
non-existent inode 21676515436
would have junked entry "text-base" in directory inode 8859947020
would have corrected i8 count in directory 8859947020 from 4 to 3
entry "src" in shortform directory 17420197971 references non-existent =
inode 77491511356
entry "X86" in shortform directory 64551436350 references non-existent =
inode 77491511344
entry "libmmbd" in shortform directory 68912492551 references =
non-existent inode 77491511351
would have junked entry "X86" in directory inode 64551436350
would have corrected i8 count in directory 64551436350 from 3 to 2
would have junked entry "libmmbd" in directory inode 68912492551
would have junked entry "src" in directory inode 17420197971
would have corrected i8 count in directory 17420197971 from 4 to 3
would have corrected i8 count in directory 68912492551 from 2 to 1
entry "props" in shortform directory 17420197976 references non-existent =
inode 43198287921
entry ".." at block 0 offset 32 in directory inode 55986327559 =
references non-existent inode 43392413878
	would clear inode number in entry at offset 32...
would have junked entry "props" in directory inode 17420197976
would have corrected i8 count in directory 17420197976 from 5 to 4
entry "Softly With These Songs - The Best of Roberta Flack" in shortform =
directory 55986327560 references non-existent inode 21706354760
entry "props" in shortform directory 68912492559 references non-existent =
inode 77491511358
entry "prop-base" in shortform directory 17420197977 references =
non-existent inode 21676515398
would have junked entry "props" in directory inode 68912492559
would have junked entry "Softly With These Songs - The Best of Roberta =
Flack" in directory inode 55986327560
would have corrected i8 count in directory 55986327560 from 3 to 2
entry "free-x86_64-regparm0" in shortform directory 64551452696 =
references non-existent inode 77491544082
entry "AlbumName" in shortform directory 30192533551 references =
non-existent inode 98916237468
would have corrected i8 count in directory 68912492559 from 4 to 3
would have junked entry "prop-base" in directory inode 17420197977
would have junked entry "AlbumName" in directory inode 30192533551
entry "Dancin' and Lovin'" in shortform directory 55986327563 references =
non-existent inode 98918465560
would have junked entry "free-x86_64-regparm0" in directory inode =
64551452696
would have corrected i8 count in directory 30192533551 from 2 to 1
entry "props" in shortform directory 68912492560 references non-existent =
inode 77491511359
would have junked entry "props" in directory inode 68912492560
would have corrected i8 count in directory 68912492560 from 5 to 4
entry ".." at block 0 offset 32 in directory inode 30192533554 =
references non-existent inode 43392413878
would have corrected i8 count in directory 64551452696 from 5 to 4
entry "props" in shortform directory 68912492561 references non-existent =
inode 77491519565
would have junked entry "Dancin' and Lovin'" in directory inode =
55986327563
would have corrected i8 count in directory 17420197977 from 5 to 4
	would clear inode number in entry at offset 32...
entry "prop-base" in shortform directory 17420197987 references =
non-existent inode 21676515438
would have corrected i8 count in directory 55986327563 from 3 to 2
would have junked entry "prop-base" in directory inode 17420197987
would have corrected i8 count in directory 17420197987 from 4 to 3
would have junked entry "props" in directory inode 68912492561
would have corrected i8 count in directory 68912492561 from 4 to 3
entry "props" in shortform directory 68912492562 references non-existent =
inode 77491519566
would have junked entry "props" in directory inode 68912492562
would have corrected i8 count in directory 68912492562 from 5 to 4
entry "props" in shortform directory 68912492565 references non-existent =
inode 77491519569
would have junked entry "props" in directory inode 68912492565
would have corrected i8 count in directory 68912492565 from 4 to 3
entry "MS" at block 0 offset 128 in directory inode 38704337116 =
references non-existent inode 98802544891
entry ".svn" in shortform directory 68912492569 references non-existent =
inode 21676515437
	would clear inode number in entry at offset 128...
would have junked entry ".svn" in directory inode 68912492569
would have corrected i8 count in directory 68912492569 from 2 to 1
entry "props" in shortform directory 68912492571 references non-existent =
inode 77491519574
would have junked entry "props" in directory inode 68912492571
would have corrected i8 count in directory 68912492571 from 5 to 4
entry "Greatest Hits" at block 0 offset 96 in directory inode =
30192533554 references non-existent inode 77492162685
	would clear inode number in entry at offset 96...
entry "Sounds of the Seventies- 1974" at block 0 offset 280 in directory =
inode 30192533554 references non-existent inode 98916237479
	would clear inode number in entry at offset 280...
entry "Sounds of the Seventies- 1974" in shortform directory 30192533555 =
references non-existent inode 43392978962
would have junked entry "Sounds of the Seventies- 1974" in directory =
inode 30192533555
would have corrected i8 count in directory 30192533555 from 4 to 3
entry "lock" in shortform directory 4579237926 references non-existent =
inode 77492863018
would have junked entry "lock" in directory inode 4579237926
would have corrected i8 count in directory 4579237926 from 8 to 7
entry ".." at block 0 offset 32 in directory inode 30192533559 =
references non-existent inode 43392413878
	would clear inode number in entry at offset 32...
entry "If Not for You" at block 0 offset 96 in directory inode =
30192533559 references non-existent inode 77492490255
	would clear inode number in entry at offset 96...
entry ".." at block 0 offset 32 in directory inode 81786920996 =
references non-existent inode 77491511324
	would clear inode number in entry at offset 32...
entry "lm_sensors-3.3.3" at block 0 offset 192 in directory inode =
8879145001 references non-existent inode 21706297361
	would clear inode number in entry at offset 192...
entry "Core-Static" at block 0 offset 80 in directory inode 68912492670 =
references non-existent inode 77491617833
	would clear inode number in entry at offset 80...
entry "Localization" at block 0 offset 224 in directory inode =
68912492670 references non-existent inode 98915782696
	would clear inode number in entry at offset 224...
entry "amd64" in shortform directory 38704337133 references non-existent =
inode 43198083124
would have junked entry "amd64" in directory inode 38704337133
entry "prop-base" in shortform directory 73105747975 references =
non-existent inode 77491519570
would have junked entry "prop-base" in directory inode 73105747975
entry ".." at block 0 offset 32 in directory inode 13011120171 =
references non-existent inode 43037696048
	would clear inode number in entry at offset 32...
would have corrected i8 count in directory 73105747975 from 4 to 3
would have corrected i8 count in directory 38704337133 from 4 to 3
entry "x64" in shortform directory 68912726020 references non-existent =
inode 77491617844
would have junked entry "x64" in directory inode 68912726020
would have corrected i8 count in directory 68912726020 from 2 to 1
entry "Spanish" at block 0 offset 200 in directory inode 8889970711 =
references non-existent inode 21706297372
	would clear inode number in entry at offset 200...
entry "bin" in shortform directory 51699613855 references non-existent =
inode 98915766323
would have junked entry "bin" in directory inode 51699613855
would have corrected i8 count in directory 51699613855 from 4 to 3
entry "bin.mips" in shortform directory 17420201999 references =
non-existent inode 21676515446
would have junked entry "bin.mips" in directory inode 17420201999
would have corrected i8 count in directory 17420201999 from 2 to 1
entry ".." at block 0 offset 32 in directory inode 17420202008 =
references non-existent inode 98915770389
	would clear inode number in entry at offset 32...
entry "Dan" at block 0 offset 104 in directory inode 17420202008 =
references non-existent inode 77491523642
	would clear inode number in entry at offset 104...
entry "Fre" at block 0 offset 184 in directory inode 17420202008 =
references non-existent inode 98915770399
	would clear inode number in entry at offset 184...
entry "Copy of Remote" in shortform directory 38719377419 references =
non-existent inode 43196874830
would have junked entry "Copy of Remote" in directory inode 38719377419
would have corrected i8 count in directory 38719377419 from 3 to 2
entry "EZ Ridin'" in shortform directory 116343926954 references =
non-existent inode 21706354762
would have junked entry "EZ Ridin'" in directory inode 116343926954
would have corrected i8 count in directory 116343926954 from 2 to 1
entry "prop-base" in shortform directory 38719377442 references =
non-existent inode 43198287925
would have junked entry "prop-base" in directory inode 38719377442
entry "fr" in shortform directory 13011382273 references non-existent =
inode 21676498954
would have junked entry "fr" in directory inode 13011382273
would have corrected i8 count in directory 38719377442 from 4 to 3
would have corrected i8 count in directory 13011382273 from 3 to 2
entry "prop-base" in shortform directory 38719377445 references =
non-existent inode 43198287928
would have junked entry "prop-base" in directory inode 38719377445
would have corrected i8 count in directory 38719377445 from 4 to 3
entry ".." at block 0 offset 32 in directory inode 47336734723 =
references non-existent inode 21758378070
	would clear inode number in entry at offset 32...
entry ".imap" in shortform directory 47336734725 references non-existent =
inode 43393732655
would have junked entry ".imap" in directory inode 47336734725
would have corrected i8 count in directory 47336734725 from 3 to 2
entry "Heaven on Earth" in shortform directory 68996411446 references =
non-existent inode 21706354713
would have junked entry "Heaven on Earth" in directory inode 68996411446
entry "Dd57" at block 0 offset 80 in directory inode 30192885820 =
references non-existent inode 43393732624
entry "Vienna Master Series - Popular Concert" in shortform directory =
8891183118 references non-existent inode 98916237496
would have corrected i8 count in directory 68996411446 from 2 to 1
entry "AM GOLD 1971" in shortform directory 68996411449 references =
non-existent inode 43392978961
	would clear inode number in entry at offset 80...
would have junked entry "Vienna Master Series - Popular Concert" in =
directory inode 8891183118
entry "The Very Best of Dusty Springfield (Mercury)" in shortform =
directory 133306257434 references non-existent inode 21706354722
would have junked entry "The Very Best of Dusty Springfield (Mercury)" =
in directory inode 133306257434
would have junked entry "AM GOLD 1971" in directory inode 68996411449
would have corrected i8 count in directory 8891183118 from 2 to 1
would have corrected i8 count in directory 133306257434 from 4 to 3
would have corrected i8 count in directory 68996411449 from 2 to 1
entry "Down to Earth" in shortform directory 8891183121 references =
non-existent inode 98918465544
would have junked entry "Down to Earth" in directory inode 8891183121
entry "Starbox" in shortform directory 133306257442 references =
non-existent inode 43392979000
would have junked entry "Starbox" in directory inode 133306257442
would have corrected i8 count in directory 133306257442 from 3 to 2
entry "Verities & Balderdash" in shortform directory 68996411450 =
references non-existent inode 77492490240
would have corrected i8 count in directory 8891183121 from 3 to 2
would have junked entry "Verities & Balderdash" in directory inode =
68996411450
would have corrected i8 count in directory 68996411450 from 2 to 1
entry "Classic Rock- 1966 - The Beat Goes On" in shortform directory =
8891183123 references non-existent inode 77492490267
would have junked entry "Classic Rock- 1966 - The Beat Goes On" in =
directory inode 8891183123
would have corrected i8 count in directory 8891183123 from 3 to 2
entry "Greatest Hits" in shortform directory 8891183124 references =
non-existent inode 43392979003
would have junked entry "Greatest Hits" in directory inode 8891183124
would have corrected i8 count in directory 8891183124 from 4 to 3
entry ".." at block 0 offset 32 in directory inode 68996796417 =
references non-existent inode 43392413878
	would clear inode number in entry at offset 32...
entry "Rock, Rhythm and Doo Wop, Vol. 1- The Greatest Songs =46rom Early =
Rock 'n' Roll" at block 0 offset 144 in directory inode 68996796417 =
references non-existent inode 43392979001
	would clear inode number in entry at offset 144...
entry "Konzerte Concertos on authentic instruments" in shortform =
directory 133306257451 references non-existent inode 21706354717
would have junked entry "Konzerte Concertos on authentic instruments" in =
directory inode 133306257451
would have corrected i8 count in directory 133306257451 from 2 to 1
entry "rr272x" in shortform directory 124689535045 references =
non-existent inode 21676552198
would have junked entry "rr272x" in directory inode 124689535045
entry "Christmas in America" in shortform directory 8891183134 =
references non-existent inode 77492162679
would have junked entry "Christmas in America" in directory inode =
8891183134
would have corrected i8 count in directory 8891183134 from 2 to 1
entry "Symphonic Poems" in shortform directory 68996796425 references =
non-existent inode 21706354718
would have junked entry "Symphonic Poems" in directory inode 68996796425
would have corrected i8 count in directory 68996796425 from 2 to 1
would have corrected i8 count in directory 124689535045 from 2 to 1
entry ".." at block 0 offset 32 in directory inode 81786929197 =
references non-existent inode 43037696049
	would clear inode number in entry at offset 32...
entry "fate" in shortform directory 34465358139 references non-existent =
inode 43196874831
would have junked entry "fate" in directory inode 34465358139
would have corrected i8 count in directory 34465358139 from 9 to 8
entry "lgpl" in shortform directory 34465358141 references non-existent =
inode 43196874833
would have junked entry "lgpl" in directory inode 34465358141
would have corrected i8 count in directory 34465358141 from 3 to 2
entry "matroska" in shortform directory 34493800449 references =
non-existent inode 43198287915
would have junked entry "matroska" in directory inode 34493800449
would have corrected i8 count in directory 34493800449 from 2 to 1
entry "tms470" in shortform directory 81786929201 references =
non-existent inode 21676499000
would have junked entry "tms470" in directory inode 81786929201
would have corrected i8 count in directory 81786929201 from 6 to 5
entry ".." at block 0 offset 32 in directory inode 68996796438 =
references non-existent inode 77492162666
entry ".." at block 0 offset 32 in directory inode 124689535051 =
references non-existent inode 43198287899
	would clear inode number in entry at offset 32...
entry "icons" in shortform directory 81786929207 references non-existent =
inode 98915766328
entry "props" in shortform directory 34493800456 references non-existent =
inode 43198287922
would have junked entry "icons" in directory inode 81786929207
would have corrected i8 count in directory 81786929207 from 2 to 1
	would clear inode number in entry at offset 32...
entry "32x32" in shortform directory 81786929211 references non-existent =
inode 98915766332
would have junked entry "32x32" in directory inode 81786929211
would have corrected i8 count in directory 81786929211 from 6 to 5
would have junked entry "props" in directory inode 34493800456
entry "Honeywell" in shortform directory 81786929214 references =
non-existent inode 43392253981
would have junked entry "Honeywell" in directory inode 81786929214
would have corrected i8 count in directory 81786929214 from 3 to 2
would have corrected i8 count in directory 34493800456 from 4 to 3
entry "Linux-2.4.x & Linux-2.6.x" at block 0 offset 48 in directory =
inode 17420214285 references non-existent inode 21676552204
entry "props" in shortform directory 34493800463 references non-existent =
inode 43198287929
would have junked entry "props" in directory inode 34493800463
	would clear inode number in entry at offset 48...
entry "Windows Vista 64bit" at block 0 offset 208 in directory inode =
17420214285 references non-existent inode 43198287912
would have corrected i8 count in directory 34493800463 from 4 to 3
entry ".." at block 0 offset 32 in directory inode 81786929215 =
references non-existent inode 98915770389
	would clear inode number in entry at offset 32...
	would clear inode number in entry at offset 208...
entry "Swe" at block 0 offset 192 in directory inode 81786929215 =
references non-existent inode 21676544026
	would clear inode number in entry at offset 192...
entry "X86" in shortform directory 86092197954 references non-existent =
inode 98915766318
entry "en-us" at block 0 offset 112 in directory inode 38720200754 =
references non-existent inode 77491617849
	would clear inode number in entry at offset 112...
entry "it" at block 0 offset 192 in directory inode 38720200754 =
references non-existent inode 98915782704
would have junked entry "X86" in directory inode 86092197954
would have corrected i8 count in directory 86092197954 from 3 to 2
	would clear inode number in entry at offset 192...
entry "NDIS2" at block 0 offset 48 in directory inode 38720200760 =
references non-existent inode 43265073157
	would clear inode number in entry at offset 48...
entry "VDeck64" in shortform directory 38720200761 references =
non-existent inode 77491617855
would have junked entry "VDeck64" in directory inode 38720200761
would have corrected i8 count in directory 38720200761 from 7 to 6
entry "The Christmas Album" in shortform directory 51700580373 =
references non-existent inode 98916237495
would have junked entry "The Christmas Album" in directory inode =
51700580373
would have corrected i8 count in directory 51700580373 from 2 to 1
entry ".." at block 0 offset 32 in directory inode 47336734776 =
references non-existent inode 43394228246
	would clear inode number in entry at offset 32...
entry "AM GOLD1969" in shortform directory 73272119303 references =
non-existent inode 77492490254
would have junked entry "AM GOLD1969" in directory inode 73272119303
would have corrected i8 count in directory 73272119303 from 2 to 1
entry "Greatest Hits, Vol. 2" in shortform directory 73272119305 =
references non-existent inode 43392978980
would have junked entry "Greatest Hits, Vol. 2" in directory inode =
73272119305
entry "src" in shortform directory 86092197971 references non-existent =
inode 21676499004
would have corrected i8 count in directory 73272119305 from 3 to 2
would have junked entry "src" in directory inode 86092197971
entry "The Best of Styx (RCA)" in shortform directory 73272119306 =
references non-existent inode 98918465546
would have corrected i8 count in directory 86092197971 from 3 to 2
would have junked entry "The Best of Styx (RCA)" in directory inode =
73272119306
would have corrected i8 count in directory 73272119306 from 5 to 4
entry "Classic Rock- 1968 - The Beat Goes On" in shortform directory =
73272119309 references non-existent inode 43392979007
would have junked entry "Classic Rock- 1968 - The Beat Goes On" in =
directory inode 73272119309
would have corrected i8 count in directory 73272119309 from 2 to 1
entry "QtExt" in shortform directory 86092197972 references non-existent =
inode 98915766325
would have junked entry "QtExt" in directory inode 86092197972
would have corrected i8 count in directory 86092197972 from 3 to 2
entry "lgpl" in shortform directory 86092197973 references non-existent =
inode 98915766326
would have junked entry "lgpl" in directory inode 86092197973
would have corrected i8 count in directory 86092197973 from 2 to 1
entry "lgpl" in shortform directory 86092197977 references non-existent =
inode 98915766331
entry "Politics" in shortform directory 13011382322 references =
non-existent inode 21676515413
would have junked entry "lgpl" in directory inode 86092197977
would have junked entry "Politics" in directory inode 13011382322
would have corrected i8 count in directory 86092197977 from 3 to 2
entry "props" in shortform directory 86092197979 references non-existent =
inode 43198287919
would have corrected i8 count in directory 13011382322 from 4 to 3
would have junked entry "props" in directory inode 86092197979
would have corrected i8 count in directory 86092197979 from 5 to 4
entry "text-base" in shortform directory 86092197980 references =
non-existent inode 98915770369
would have junked entry "text-base" in directory inode 86092197980
would have corrected i8 count in directory 86092197980 from 4 to 3
entry "text-base" in shortform directory 86092197981 references =
non-existent inode 98915770370
would have junked entry "text-base" in directory inode 86092197981
would have corrected i8 count in directory 86092197981 from 5 to 4
entry "text-base" in shortform directory 86092197982 references =
non-existent inode 98915770371
would have junked entry "text-base" in directory inode 86092197982
would have corrected i8 count in directory 86092197982 from 4 to 3
entry "props" in shortform directory 86092197985 references non-existent =
inode 98915770376
would have junked entry "props" in directory inode 86092197985
entry ".." at block 0 offset 32 in directory inode 90328010761 =
references non-existent inode 21667586090
	would clear inode number in entry at offset 32...
would have corrected i8 count in directory 86092197985 from 5 to 4
entry "text-base" in shortform directory 86092197990 references =
non-existent inode 98915770382
would have junked entry "text-base" in directory inode 86092197990
would have corrected i8 count in directory 86092197990 from 4 to 3
entry ".." at block 0 offset 32 in directory inode 86092198002 =
references non-existent inode 43037696049
	would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 86092201989 =
references non-existent inode 98915770389
	would clear inode number in entry at offset 32...
entry "Japanese" at block 0 offset 120 in directory inode 417902664 =
references non-existent inode 77491990544
	would clear inode number in entry at offset 120...
entry "Cze" at block 0 offset 120 in directory inode 86092201989 =
references non-existent inode 43198083093
	would clear inode number in entry at offset 120...
entry "Hun" at block 0 offset 232 in directory inode 86092201989 =
references non-existent inode 77491523624
	would clear inode number in entry at offset 232...
entry "Por" at block 0 offset 312 in directory inode 86092201989 =
references non-existent inode 98915770392
	would clear inode number in entry at offset 312...
entry ".." at block 0 offset 32 in directory inode 38720765985 =
references non-existent inode 43392413878
	would clear inode number in entry at offset 32...
entry "Suse-SLES" in shortform directory 124689539163 references =
non-existent inode 21676515431
would have junked entry "Suse-SLES" in directory inode 124689539163
entry "Debian" in shortform directory 124689539163 references =
non-existent inode 98915766327
entry ".." at block 0 offset 32 in directory inode 38720765989 =
references non-existent inode 43392413878
	would clear inode number in entry at offset 32...
entry "i386" in shortform directory 13027205190 references non-existent =
inode 21676515423
entry "Greatest Hits (Ten Years & Change 1979-1991)" at block 0 offset =
80 in directory inode 38720765989 references non-existent inode =
43392978999
would have junked entry "Debian" in directory inode 124689539163
would have junked entry "i386" in directory inode 13027205190
would have corrected i8 count in directory 13027205190 from 4 to 3
entry "Classic Rock- 1966 - Blowin' Your Mind" in shortform directory =
120472117286 references non-existent inode 77492162675
would have corrected i8 count in directory 124689539163 from 7 to 5
	would clear inode number in entry at offset 80...
would have junked entry "Classic Rock- 1966 - Blowin' Your Mind" in =
directory inode 120472117286
would have corrected i8 count in directory 120472117286 from 2 to 1
entry ".." at block 0 offset 32 in directory inode 120472117287 =
references non-existent inode 43392413878
	would clear inode number in entry at offset 32...
entry "Martina McBride" at block 0 offset 392 in directory inode =
120472117287 references non-existent inode 21706354715
	would clear inode number in entry at offset 392...
entry "Orchestra Manhattan" at block 0 offset 568 in directory inode =
120472117287 references non-existent inode 43392978952
entry "Japanese" at block 0 offset 120 in directory inode 17436610595 =
references non-existent inode 77491990551
	would clear inode number in entry at offset 120...
	would clear inode number in entry at offset 568...
entry "Wedding Day Music" in shortform directory 120472117289 references =
non-existent inode 98916237481
would have junked entry "Wedding Day Music" in directory inode =
120472117289
would have corrected i8 count in directory 120472117289 from 2 to 1
entry "AM GOLD 1971" in shortform directory 120472117291 references =
non-existent inode 43392978964
would have junked entry "AM GOLD 1971" in directory inode 120472117291
entry "lgpl" in shortform directory 13027205211 references non-existent =
inode 21676499005
would have junked entry "lgpl" in directory inode 13027205211
would have corrected i8 count in directory 13027205211 from 2 to 1
would have corrected i8 count in directory 120472117291 from 2 to 1
entry "props" in shortform directory 13027205218 references non-existent =
inode 21676515396
would have junked entry "props" in directory inode 13027205218
would have corrected i8 count in directory 13027205218 from 5 to 4
entry "Fresh Aire Christmas 1988" in shortform directory 17436659751 =
references non-existent inode 98916237471
entry "local-mail" in shortform directory 8891777032 references =
non-existent inode 21758378075
would have junked entry "local-mail" in directory inode 8891777032
would have junked entry "Fresh Aire Christmas 1988" in directory inode =
17436659751
would have corrected i8 count in directory 17436659751 from 5 to 4
would have corrected i8 count in directory 8891777032 from 7 to 6
entry "Borodin String Quartets Nos. 1 & 2" in shortform directory =
17436659752 references non-existent inode 77492162681
would have junked entry "Borodin String Quartets Nos. 1 & 2" in =
directory inode 17436659752
would have corrected i8 count in directory 17436659752 from 3 to 2
entry "calendar" in shortform directory 68997402671 references =
non-existent inode 77492863015
would have junked entry "calendar" in directory inode 68997402671
would have corrected i8 count in directory 68997402671 from 3 to 2
entry ".." at block 0 offset 32 in directory inode 111895687207 =
references non-existent inode 43392978952
entry "Core-Static" at block 0 offset 80 in directory inode 13027512336 =
references non-existent inode 21676929041
entry "Raw" in shortform directory 38720962585 references non-existent =
inode 43392978965
would have junked entry "Raw" in directory inode 38720962585
would have corrected i8 count in directory 38720962585 from 3 to 2
	would clear inode number in entry at offset 80...
	would clear inode number in entry at offset 32...
entry "Localization" at block 0 offset 224 in directory inode =
13027512336 references non-existent inode 43198292030
	would clear inode number in entry at offset 224...
entry "Greatest HIts" in shortform directory 111895687208 references =
non-existent inode 98916237475
entry "x64" in shortform directory 13027512342 references non-existent =
inode 21676929047
would have junked entry "Greatest HIts" in directory inode 111895687208
would have junked entry "x64" in directory inode 13027512342
would have corrected i8 count in directory 13027512342 from 6 to 5
would have corrected i8 count in directory 111895687208 from 2 to 1
entry ".." at block 0 offset 32 in directory inode 111895687209 =
references non-existent inode 43392978953
	would clear inode number in entry at offset 32...
entry "X64" in shortform directory 13027512343 references non-existent =
inode 21676929048
would have junked entry "X64" in directory inode 13027512343
would have corrected i8 count in directory 13027512343 from 3 to 2
entry "JP" at block 0 offset 96 in directory inode 13074718790 =
references non-existent inode 43392253962
	would clear inode number in entry at offset 96...
entry "TVApp" at block 0 offset 88 in directory inode 82064986146 =
references non-existent inode 98916159538
	would clear inode number in entry at offset 88...
entry "5_3" at block 0 offset 168 in directory inode 128987131937 =
references non-existent inode 21676515426
	would clear inode number in entry at offset 168...
entry "5_8" at block 0 offset 232 in directory inode 128987131937 =
references non-existent inode 43198083135
	would clear inode number in entry at offset 232...
entry ".." at block 0 offset 32 in directory inode 107600814352 =
references non-existent inode 43392978953
	would clear inode number in entry at offset 32...
entry "O Holy Night Disc 1" in shortform directory 13074718840 =
references non-existent inode 77492162674
would have junked entry "O Holy Night Disc 1" in directory inode =
13074718840
would have corrected i8 count in directory 13074718840 from 6 to 5
entry "O Holy Night Disc 1" in shortform directory 13091356672 =
references non-existent inode 43392978978
would have junked entry "O Holy Night Disc 1" in directory inode =
13091356672
would have corrected i8 count in directory 13091356672 from 3 to 2
entry ".." at block 0 offset 32 in directory inode 107600814365 =
references non-existent inode 21706354704
	would clear inode number in entry at offset 32...
entry "Alfred Brendel Plays Beethoven Piano Sonatas, Vol. 2 (1 of 2)" at =
block 0 offset 48 in directory inode 13091356696 references non-existent =
inode 43392978954
	would clear inode number in entry at offset 48...
entry "patch_tool" in shortform directory 86092361747 references =
non-existent inode 98915782710
would have junked entry "patch_tool" in directory inode 86092361747
would have corrected i8 count in directory 86092361747 from 6 to 5
entry "file_db_data" at block 0 offset 128 in directory inode =
17437196300 references non-existent inode 43393732657
	would clear inode number in entry at offset 128...
entry ".." at block 0 offset 32 in directory inode 120533618729 =
references non-existent inode 42949677056
	would clear inode number in entry at offset 32...
entry ".config" at block 0 offset 48 in directory inode 120533618729 =
references non-existent inode 77492863017
	would clear inode number in entry at offset 48...
entry "mail" at block 0 offset 152 in directory inode 120533618729 =
references non-existent inode 99184005156
	would clear inode number in entry at offset 152...
entry "Templates" at block 0 offset 1232 in directory inode 120533618729 =
references non-existent inode 21758378089
	would clear inode number in entry at offset 1232...
entry "Videos" at block 0 offset 1344 in directory inode 120533618729 =
references non-existent inode 43394228287
	would clear inode number in entry at offset 1344...
entry "kicker" at block 0 offset 184 in directory inode 120533618733 =
references non-existent inode 21758378074
	would clear inode number in entry at offset 184...
entry "kwallet" at block 0 offset 304 in directory inode 120533618733 =
references non-existent inode 43393732656
	would clear inode number in entry at offset 304...
entry "Alive 'N Kickin' (Collectables)" in shortform directory =
124753793139 references non-existent inode 21706354712
would have junked entry "Alive 'N Kickin' (Collectables)" in directory =
inode 124753793139
would have corrected i8 count in directory 124753793139 from 2 to 1
entry ".." at block 0 offset 32 in directory inode 124753793147 =
references non-existent inode 43392413878
	would clear inode number in entry at offset 32...
entry "The Jazz Singer" at block 0 offset 232 in directory inode =
124753793147 references non-existent inode 21706354754
	would clear inode number in entry at offset 232...
entry "Sounds of the Seventies- AM Nuggets" in shortform directory =
124753793148 references non-existent inode 77492490256
would have junked entry "Sounds of the Seventies- AM Nuggets" in =
directory inode 124753793148
would have corrected i8 count in directory 124753793148 from 2 to 1
entry ".." at block 0 offset 32 in directory inode 124753965056 =
references non-existent inode 43392413878
	would clear inode number in entry at offset 32...
entry "Seven Separate Fools" at block 0 offset 200 in directory inode =
124753965056 references non-existent inode 77492490272
entry "lgpl" in shortform directory 17437196324 references non-existent =
inode 21758378085
	would clear inode number in entry at offset 200...
would have junked entry "lgpl" in directory inode 17437196324
would have corrected i8 count in directory 17437196324 from 3 to 2
entry "matroska" in shortform directory 17437196325 references =
non-existent inode 21758378087
would have junked entry "matroska" in directory inode 17437196325
would have corrected i8 count in directory 17437196325 from 2 to 1
entry "alpha" in shortform directory 90328019070 references non-existent =
inode 43196874827
would have junked entry "alpha" in directory inode 90328019070
entry "x86" in shortform directory 90328019070 references non-existent =
inode 77491511348
would have junked entry "x86" in directory inode 90328019070
entry "default.mpg" in shortform directory 60277866727 references =
non-existent inode 43052523580
would have corrected i8 count in directory 90328019070 from 10 to 8
would have junked entry "default.mpg" in directory inode 60277866727
would have corrected i8 count in directory 60277866727 from 4 to 3
entry ".." at block 0 offset 32 in directory inode 90328121345 =
references non-existent inode 43037696049
	would clear inode number in entry at offset 32...
entry "Greatest Hits (CemaAtlantic)" in shortform directory 418459710 =
references non-existent inode 77492490252
would have junked entry "Greatest Hits (CemaAtlantic)" in directory =
inode 418459710
entry ".deps" at block 0 offset 48 in directory inode 90328121345 =
references non-existent inode 77491523620
would have corrected i8 count in directory 418459710 from 5 to 4
	would clear inode number in entry at offset 48...
entry "Classic Rock- 1965" in shortform directory 419037188 references =
non-existent inode 21706354767
would have junked entry "Classic Rock- 1965" in directory inode =
419037188
entry "16x16" in shortform directory 90328121352 references non-existent =
inode 98915766330
would have junked entry "16x16" in directory inode 90328121352
would have corrected i8 count in directory 90328121352 from 6 to 5
would have corrected i8 count in directory 419037188 from 2 to 1
entry "Super Hits of the '70s- Have a Nice Day, Vol. 7" in shortform =
directory 419037189 references non-existent inode 98918465562
entry "Editor" at block 0 offset 48 in directory inode 107663573017 =
references non-existent inode 21706354789
	would clear inode number in entry at offset 48...
would have junked entry "Super Hits of the '70s- Have a Nice Day, Vol. =
7" in directory inode 419037189
would have corrected i8 count in directory 419037189 from 2 to 1
entry ".." at block 0 offset 32 in directory inode 90328121357 =
references non-existent inode 77491519615
	would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 90328121367 =
references non-existent inode 98915770389
	would clear inode number in entry at offset 32...
entry "Por" at block 0 offset 160 in directory inode 90328121367 =
references non-existent inode 21676544027
	would clear inode number in entry at offset 160...
entry "Sounds of the Seventies- 1972" in shortform directory 86092816396 =
references non-existent inode 77492162683
would have junked entry "Sounds of the Seventies- 1972" in directory =
inode 86092816396
would have corrected i8 count in directory 86092816396 from 3 to 2
entry ".." at block 0 offset 32 in directory inode 128987152396 =
references non-existent inode 98915770389
	would clear inode number in entry at offset 32...
entry "Bul" at block 0 offset 48 in directory inode 128987152396 =
references non-existent inode 43198083121
	would clear inode number in entry at offset 48...
entry ".config" at block 0 offset 48 in directory inode 133306986547 =
references non-existent inode 21758378070
entry "Fin" at block 0 offset 160 in directory inode 128987152396 =
references non-existent inode 77491523640
	would clear inode number in entry at offset 48...
entry "mail" at block 0 offset 152 in directory inode 133306986547 =
references non-existent inode 43393732652
	would clear inode number in entry at offset 152...
	would clear inode number in entry at offset 160...
entry "backupsync" in shortform directory 133306986548 references =
non-existent inode 43393732653
would have junked entry "backupsync" in directory inode 133306986548
would have corrected i8 count in directory 133306986548 from 3 to 2
entry "Ita" at block 0 offset 240 in directory inode 128987152396 =
references non-existent inode 98915770397
	would clear inode number in entry at offset 240...
entry "tmp" at block 0 offset 48 in directory inode 133306986553 =
references non-existent inode 77492863021
	would clear inode number in entry at offset 48...
entry ".." at block 0 offset 32 in directory inode 38825242678 =
references non-existent inode 43393732652
	would clear inode number in entry at offset 32...
entry "INBOX" at block 0 offset 192 in directory inode 38825242678 =
references non-existent inode 77492863016
	would clear inode number in entry at offset 192...
entry "NUT" at block 0 offset 296 in directory inode 38825242678 =
references non-existent inode 99184005155
	would clear inode number in entry at offset 296...
entry "Greatest Hits (Capitol)" in shortform directory 82065092720 =
references non-existent inode 98916237482
entry ".." at block 0 offset 32 in directory inode 116343980276 =
references non-existent inode 21706354699
would have junked entry "Greatest Hits (Capitol)" in directory inode =
82065092720
	would clear inode number in entry at offset 32...
would have corrected i8 count in directory 82065092720 from 3 to 2
entry "Symphonic Poems" in shortform directory 82065092722 references =
non-existent inode 77492490253
would have junked entry "Symphonic Poems" in directory inode 82065092722
would have corrected i8 count in directory 82065092722 from 2 to 1
entry ".." at block 0 offset 32 in directory inode 116343980280 =
references non-existent inode 43392978953
	would clear inode number in entry at offset 32...
entry "lgpl" in shortform directory 38829563910 references non-existent =
inode 43394228244
would have junked entry "lgpl" in directory inode 38829563910
would have corrected i8 count in directory 38829563910 from 2 to 1
entry "lgpl" in shortform directory 38829563913 references non-existent =
inode 43394228259
would have junked entry "lgpl" in directory inode 38829563913
would have corrected i8 count in directory 38829563913 from 3 to 2
entry "PowerQuest PartitionMagic 6.0" at block 0 offset 104 in directory =
inode 124762431535 references non-existent inode 21706354788
	would clear inode number in entry at offset 104...
entry "UTILITY" at block 0 offset 232 in directory inode 124762431535 =
references non-existent inode 43393732623
	would clear inode number in entry at offset 232...
entry ".." at block 0 offset 32 in directory inode 38829563921 =
references non-existent inode 98915766286
	would clear inode number in entry at offset 32...
entry "VIDEO_TS" at block 0 offset 72 in directory inode 38829563921 =
references non-existent inode 43055878155
	would clear inode number in entry at offset 72...
entry "Rocket 2722" in shortform directory 90328125499 references =
non-existent inode 98915770424
would have junked entry "Rocket 2722" in directory inode 90328125499
would have corrected i8 count in directory 90328125499 from 3 to 2
entry "Gyorgy Sandor Plays Prokofiev, Vol. 1 (3 of 3)" at block 0 offset =
176 in directory inode 82065301526 references non-existent inode =
43392978956
	would clear inode number in entry at offset 176...
entry "valetines 001.jpg" at block 0 offset 1096 in directory inode =
38829563929 references non-existent inode 21758378098
	would clear inode number in entry at offset 1096...
entry "Disk 8" in shortform directory 94562865200 references =
non-existent inode 21676515402
would have junked entry "Disk 8" in directory inode 94562865200
would have corrected i8 count in directory 94562865200 from 8 to 7
entry ".." at block 0 offset 32 in directory inode 82065301528 =
references non-existent inode 98916237472
	would clear inode number in entry at offset 32...
entry "skins" at block 0 offset 592 in directory inode 38829563939 =
references non-existent inode 43394228242
	would clear inode number in entry at offset 592...
entry ".." at block 0 offset 32 in directory inode 103166758944 =
references non-existent inode 98915766285
	would clear inode number in entry at offset 32...
entry "lock" in shortform directory 86093082687 references non-existent =
inode 21758378071
entry "prop-base" in shortform directory 90328137762 references =
non-existent inode 98915770373
would have junked entry "prop-base" in directory inode 90328137762
would have corrected i8 count in directory 90328137762 from 5 to 4
would have junked entry "lock" in directory inode 86093082687
would have corrected i8 count in directory 86093082687 from 7 to 6
entry "Checking" in shortform directory 38829563965 references =
non-existent inode 43196874811
would have junked entry "Checking" in directory inode 38829563965
would have corrected i8 count in directory 38829563965 from 3 to 2
entry "Email" in shortform directory 38829563966 references non-existent =
inode 43196874812
would have junked entry "Email" in directory inode 38829563966
would have corrected i8 count in directory 38829563966 from 5 to 4
entry "Quiet Riot - Greatest Hits" in shortform directory 82201460747 =
references non-existent inode 98918465572
would have junked entry "Quiet Riot - Greatest Hits" in directory inode =
82201460747
would have corrected i8 count in directory 82201460747 from 2 to 1
entry ".." at block 0 offset 32 in directory inode 82201460748 =
references non-existent inode 43393732623
	would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 86093668380 =
references non-existent inode 77491511324
	would clear inode number in entry at offset 32...
entry "Season 5" at block 0 offset 560 in directory inode 86093668383 =
references non-existent inode 98915766286
	would clear inode number in entry at offset 560...
entry "Season 7" at block 0 offset 656 in directory inode 86093668383 =
references non-existent inode 77491511324
	would clear inode number in entry at offset 656...
entry "Season 8" at block 0 offset 704 in directory inode 86093668383 =
references non-existent inode 98915766285
	would clear inode number in entry at offset 704...
entry "Photos" at block 0 offset 400 in directory inode 94587891751 =
references non-existent inode 98915766287
	would clear inode number in entry at offset 400...
entry ".." at block 0 offset 32 in directory inode 86093668397 =
references non-existent inode 77594005563
	would clear inode number in entry at offset 32...
entry "prop-base" in shortform directory 94587895810 references =
non-existent inode 98915770379
would have junked entry "prop-base" in directory inode 94587895810
would have corrected i8 count in directory 94587895810 from 5 to 4
entry ".." at block 0 offset 32 in directory inode 103166820441 =
references non-existent inode 98915770389
	would clear inode number in entry at offset 32...
entry "Ita" at block 0 offset 264 in directory inode 103166820441 =
references non-existent inode 21676544028
	would clear inode number in entry at offset 264...
entry "Rom" at block 0 offset 344 in directory inode 103166820441 =
references non-existent inode 43198083119
	would clear inode number in entry at offset 344...
entry ".." at block 0 offset 32 in directory inode 82201460786 =
references non-existent inode 77594005563
	would clear inode number in entry at offset 32...
entry "Cat Scream-SoundBible.com-871191563.mp3" at block 0 offset 104 in =
directory inode 82201460786 references non-existent inode 77594005565
entry "Cht" in shortform directory 94587895822 references non-existent =
inode 43198083118
would have junked entry "Cht" in directory inode 94587895822
entry "Q Light Controller" in shortform directory 103166820454 =
references non-existent inode 77491527690
would have corrected i8 count in directory 94587895822 from 8 to 7
would have junked entry "Q Light Controller" in directory inode =
103166820454
	would clear inode number in entry at offset 104...
would have corrected i8 count in directory 103166820454 from 6 to 5
entry "Evil_Laugh_Male_6-Himan-1359990674.mp3" at block 0 offset 192 in =
directory inode 82201460786 references non-existent inode 77594005567
	would clear inode number in entry at offset 192...
entry "Female_Scream_Horror-NeoPhyTe-138499973.mp3" at block 0 offset =
248 in directory inode 82201460786 references non-existent inode =
77491511309
	would clear inode number in entry at offset 248...
entry "Lynn Anderson" at block 0 offset 72 in directory inode =
64796069907 references non-existent inode 77492490285
	would clear inode number in entry at offset 72...
entry "Animals" at block 0 offset 96 in directory inode 64796069909 =
references non-existent inode 77492490287
	would clear inode number in entry at offset 96...
entry "Bathroom" at block 0 offset 224 in directory inode 64796069909 =
references non-existent inode 98918465574
	would clear inode number in entry at offset 224...
entry "Office Supplies" at block 0 offset 568 in directory inode =
64796069909 references non-existent inode 21706354790
	would clear inode number in entry at offset 568...
entry "Transitional Elements" at block 0 offset 696 in directory inode =
64796069909 references non-existent inode 43393732625
	would clear inode number in entry at offset 696...
entry ".." at block 0 offset 32 in directory inode 94587895836 =
references non-existent inode 77491523643
	would clear inode number in entry at offset 32...
entry "BIOS" at block 0 offset 48 in directory inode 103166820468 =
references non-existent inode 77491527723
	would clear inode number in entry at offset 48...
entry "rr232x-linux-src-v1.10" at block 0 offset 152 in directory inode =
103166820468 references non-existent inode 98915774487
	would clear inode number in entry at offset 152...
entry "x86-64" in shortform directory 90328141849 references =
non-existent inode 98915766301
would have junked entry "x86-64" in directory inode 90328141849
would have corrected i8 count in directory 90328141849 from 3 to 2
entry "DOFC" at block 0 offset 48 in directory inode 90328141851 =
references non-existent inode 98915782695
	would clear inode number in entry at offset 48...
entry "props" in shortform directory 90328141866 references non-existent =
inode 98915770377
entry "TVFM" in shortform directory 128991920148 references non-existent =
inode 21676552203
would have junked entry "TVFM" in directory inode 128991920148
would have junked entry "props" in directory inode 90328141866
would have corrected i8 count in directory 128991920148 from 2 to 1
entry ".." at block 0 offset 32 in directory inode 107666485369 =
references non-existent inode 98915766285
would have corrected i8 count in directory 90328141866 from 5 to 4
	would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 116398661643 =
references non-existent inode 99184005153
	would clear inode number in entry at offset 32...
entry "Linux-2.4.x" at block 0 offset 48 in directory inode 94659698699 =
references non-existent inode 98915774493
	would clear inode number in entry at offset 48...
entry "storport" in shortform directory 94659698704 references =
non-existent inode 98915766311
would have junked entry "storport" in directory inode 94659698704
would have corrected i8 count in directory 94659698704 from 3 to 2
entry ".." at block 0 offset 32 in directory inode 103166828595 =
references non-existent inode 77491527723
	would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 103166828598 =
references non-existent inode 43196874878
	would clear inode number in entry at offset 32...
entry "ja" at block 0 offset 208 in directory inode 94659702817 =
references non-existent inode 21676929032
	would clear inode number in entry at offset 208...
entry "pt-BR" at block 0 offset 288 in directory inode 94659702817 =
references non-existent inode 43198292024
	would clear inode number in entry at offset 288...
entry "AMD_Chipset_Driver_xp" at block 0 offset 48 in directory inode =
94659702828 references non-existent inode 98915782703
	would clear inode number in entry at offset 48...
entry "The Best of Bill Medley" in shortform directory 90516987962 =
references non-existent inode 43392978950
would have junked entry "The Best of Bill Medley" in directory inode =
90516987962
would have corrected i8 count in directory 90516987962 from 2 to 1
entry ".." at block 0 offset 32 in directory inode 90516987964 =
references non-existent inode 43392413878
	would clear inode number in entry at offset 32...
entry "Motown Legends, Vol. 1" at block 0 offset 200 in directory inode =
90516987964 references non-existent inode 98916237477
	would clear inode number in entry at offset 200...
entry "Misc" in shortform directory 90517016577 references non-existent =
inode 98916237498
would have junked entry "Misc" in directory inode 90517016577
would have corrected i8 count in directory 90517016577 from 3 to 2
entry "Classic Rock- 1968" in shortform directory 90517016581 references =
non-existent inode 77492490268
would have junked entry "Classic Rock- 1968" in directory inode =
90517016581
would have corrected i8 count in directory 90517016581 from 2 to 1
entry "gidmigratortext" in shortform directory 73306308666 references =
non-existent inode 77594005542
would have junked entry "gidmigratortext" in directory inode 73306308666
would have corrected i8 count in directory 73306308666 from 2 to 1
entry "SpryAssets" at block 0 offset 48 in directory inode 34782498868 =
references non-existent inode 43392253957
	would clear inode number in entry at offset 48...
entry "1920 x 1080" at block 0 offset 48 in directory inode 34782539794 =
references non-existent inode 77491990566
	would clear inode number in entry at offset 48...
entry ".." at block 0 offset 32 in directory inode 94994862126 =
references non-existent inode 43392253987
	would clear inode number in entry at offset 32...
entry "RecentDocuments" at block 0 offset 48 in directory inode =
64796418214 references non-existent inode 77492863014
	would clear inode number in entry at offset 48...
entry "kfileplaces" at block 0 offset 160 in directory inode 64796418214 =
references non-existent inode 99184005152
	would clear inode number in entry at offset 160...
entry ".." at block 0 offset 32 in directory inode 34782539822 =
references non-existent inode 43392413878
	would clear inode number in entry at offset 32...
entry "Ghostbusters" in shortform directory 34782539827 references =
non-existent inode 98918465543
would have junked entry "Ghostbusters" in directory inode 34782539827
would have corrected i8 count in directory 34782539827 from 4 to 3
entry "TIME LIFE - AM GOLD - 1965" in shortform directory 34782539831 =
references non-existent inode 77492490270
would have junked entry "TIME LIFE - AM GOLD - 1965" in directory inode =
34782539831
would have corrected i8 count in directory 34782539831 from 3 to 2
entry "Debussy for Daydreaming" in shortform directory 34782539837 =
references non-existent inode 98916237473
would have junked entry "Debussy for Daydreaming" in directory inode =
34782539837
would have corrected i8 count in directory 34782539837 from 2 to 1
entry "16x16" in shortform directory 64796418238 references non-existent =
inode 77491511313
would have junked entry "16x16" in directory inode 64796418238
would have corrected i8 count in directory 64796418238 from 6 to 5
entry "akonadi" in shortform directory 90549440584 references =
non-existent inode 99184005153
entry ".." at block 0 offset 32 in directory inode 34847252525 =
references non-existent inode 98916237462
	would clear inode number in entry at offset 32...
would have junked entry "akonadi" in directory inode 90549440584
would have corrected i8 count in directory 90549440584 from 4 to 3
entry ".." at block 0 offset 32 in directory inode 90549440603 =
references non-existent inode 21706330135
	would clear inode number in entry at offset 32...
entry "2015-02-20 Puerto Rico" at block 0 offset 88 in directory inode =
90549440603 references non-existent inode 98915754040
	would clear inode number in entry at offset 88...
entry "OS2DOS" at block 0 offset 48 in directory inode 34847252575 =
references non-existent inode 77492490286
	would clear inode number in entry at offset 48...
entry "Stills" in shortform directory 129135882335 references =
non-existent inode 21706330135
would have junked entry "Stills" in directory inode 129135882335
would have corrected i8 count in directory 129135882335 from 3 to 2
entry "The Best of Frank Mills- Happy Music" in shortform directory =
95118995629 references non-existent inode 77492162687
would have junked entry "The Best of Frank Mills- Happy Music" in =
directory inode 95118995629
would have corrected i8 count in directory 95118995629 from 2 to 1
entry "Moving" in shortform directory 95118995634 references =
non-existent inode 21706354755
would have junked entry "Moving" in directory inode 95118995634
would have corrected i8 count in directory 95118995634 from 4 to 3
entry "Masters of Classical Music, Vol. 5 Wagner" in shortform directory =
95118995644 references non-existent inode 77492162682
would have junked entry "Masters of Classical Music, Vol. 5 Wagner" in =
directory inode 95118995644
would have corrected i8 count in directory 95118995644 from 2 to 1
entry ".." at block 0 offset 32 in directory inode 129135882353 =
references non-existent inode 43392413878
	would clear inode number in entry at offset 32...
entry "Carmen-Suite Nr. 1-no. 1" at block 0 offset 208 in directory =
inode 129135882353 references non-existent inode 21706354716
	would clear inode number in entry at offset 208...
entry "Dvorak" at block 0 offset 384 in directory inode 129135882353 =
references non-existent inode 43392978953
	would clear inode number in entry at offset 384...
entry "Misc" at block 0 offset 624 in directory inode 129135882353 =
references non-existent inode 77492162680
	would clear inode number in entry at offset 624...
entry "S=C3=A1ndor, J=C3=A1nos" at block 0 offset 736 in directory inode =
129135882353 references non-existent inode 98916237472
	would clear inode number in entry at offset 736...
entry ".." at block 0 offset 32 in directory inode 95157329964 =
references non-existent inode 99184005156
	would clear inode number in entry at offset 32...
entry "NewEgg" at block 0 offset 312 in directory inode 95157329964 =
references non-existent inode 21758378076
	would clear inode number in entry at offset 312...
entry "Sent" at block 0 offset 424 in directory inode 95157329964 =
references non-existent inode 43393732658
	would clear inode number in entry at offset 424...
entry "Sounds of the Seventies- 1972" in shortform directory =
103167189121 references non-existent inode 21706354727
would have junked entry "Sounds of the Seventies- 1972" in directory =
inode 103167189121
would have corrected i8 count in directory 103167189121 from 2 to 1
entry ".." at block 0 offset 32 in directory inode 103167189169 =
references non-existent inode 98916237465
	would clear inode number in entry at offset 32...
entry "src" in shortform directory 95375138851 references non-existent =
inode 98915754014
would have junked entry "src" in directory inode 95375138851
would have corrected i8 count in directory 95375138851 from 3 to 2
entry "lgpl" in shortform directory 95375138852 references non-existent =
inode 98915754036
would have junked entry "lgpl" in directory inode 95375138852
would have corrected i8 count in directory 95375138852 from 4 to 3
entry "d01" in shortform directory 95375138856 references non-existent =
inode 99189358615
would have junked entry "d01" in directory inode 95375138856
would have corrected i8 count in directory 95375138856 from 3 to 2
entry "Broadcom Wireless" in shortform directory 95375138861 references =
non-existent inode 21676544020
would have junked entry "Broadcom Wireless" in directory inode =
95375138861
entry "TrendNet" in shortform directory 95375138861 references =
non-existent inode 98915754007
would have junked entry "TrendNet" in directory inode 95375138861
would have corrected i8 count in directory 95375138861 from 4 to 2
entry "tmp" in shortform directory 103167508531 references non-existent =
inode 21758378072
would have junked entry "tmp" in directory inode 103167508531
would have corrected i8 count in directory 103167508531 from 5 to 4
entry ".." at block 0 offset 32 in directory inode 103167508533 =
references non-existent inode 77492863017
	would clear inode number in entry at offset 32...
entry "backupsync" in shortform directory 51736309770 references =
non-existent inode 99184005157
would have junked entry "backupsync" in directory inode 51736309770
would have corrected i8 count in directory 51736309770 from 3 to 2
entry "inc" in shortform directory 26008100926 references non-existent =
inode 77491511354
would have junked entry "inc" in directory inode 26008100926
would have corrected i8 count in directory 26008100926 from 4 to 3
entry ".." at block 0 offset 32 in directory inode 26057682952 =
references non-existent inode 43037696048
	would clear inode number in entry at offset 32...
entry "tmp" in shortform directory 26154033339 references non-existent =
inode 43198287923
would have junked entry "tmp" in directory inode 26154033339
would have corrected i8 count in directory 26154033339 from 5 to 4
entry "tmp" in shortform directory 26260242761 references non-existent =
inode 43198287926
would have junked entry "tmp" in directory inode 26260242761
would have corrected i8 count in directory 26260242761 from 5 to 4
entry "tmp" in shortform directory 26260242762 references non-existent =
inode 43198287927
would have junked entry "tmp" in directory inode 26260242762
would have corrected i8 count in directory 26260242762 from 5 to 4
entry "mflpro_c1" in shortform directory 26260242856 references =
non-existent inode 98915770389
would have junked entry "mflpro_c1" in directory inode 26260242856
would have corrected i8 count in directory 26260242856 from 5 to 4
entry ".." at block 0 offset 32 in directory inode 26260242858 =
references non-existent inode 98915770389
	would clear inode number in entry at offset 32...
entry "Eng" at block 0 offset 136 in directory inode 26260242858 =
references non-existent inode 21676544041
	would clear inode number in entry at offset 136...
entry "Ita" at block 0 offset 216 in directory inode 26260242858 =
references non-existent inode 43198083128
	would clear inode number in entry at offset 216...
entry "Linux" in shortform directory 26260267045 references non-existent =
inode 43198287897
would have junked entry "Linux" in directory inode 26260267045
would have corrected i8 count in directory 26260267045 from 4 to 3
entry ".." at block 0 offset 32 in directory inode 26260271146 =
references non-existent inode 21676929031
	would clear inode number in entry at offset 32...
entry "Driver" at block 0 offset 104 in directory inode 26260271146 =
references non-existent inode 43198292023
	would clear inode number in entry at offset 104...
entry "Dirty Dancing" in shortform directory 27415207952 references =
non-existent inode 43392978963
would have junked entry "Dirty Dancing" in directory inode 27415207952
would have corrected i8 count in directory 27415207952 from 2 to 1
entry ".." at block 0 offset 32 in directory inode 27739979799 =
references non-existent inode 21758378090
	would clear inode number in entry at offset 32...
entry ".." at block 0 offset 32 in directory inode 27739979812 =
references non-existent inode 21676515402
	would clear inode number in entry at offset 32...
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
entry "Photos" in directory inode 4096 points to non-existent inode =
21474840576, would junk entry
entry "home" in directory inode 4096 points to non-existent inode =
42949677056, would junk entry
bad hash table for directory inode 4096 (no data entry): would rebuild
entry "Cape Fear" in directory inode 4099 points to non-existent inode =
77309415424, would junk entry
entry "Dreamscape" in directory inode 4099 points to non-existent inode =
98784251904, would junk entry
entry "Lemon Drop Kid, The" in directory inode 4099 points to =
non-existent inode 21474840577, would junk entry
entry "My Chauffer" in directory inode 4099 points to non-existent inode =
42949677057, would junk entry
entry "Telefon" in directory inode 4099 points to non-existent inode =
77309415425, would junk entry
entry "Without a Clue" in directory inode 4099 points to non-existent =
inode 98784251905, would junk entry
entry "American Dreamer" in directory inode 4099 points to non-existent =
inode 43394228246, would junk entry
entry "Noises Off" in directory inode 4099 points to non-existent inode =
43052523560, would junk entry
bad hash table for directory inode 4099 (no data entry): would rebuild
entry "Closer" in directory inode 68972563 points to non-existent inode =
43006791718, would junk entry
bad hash table for directory inode 68972563 (no data entry): would =
rebuild
entry ".." in directory inode 68972565 points to non-existent inode =
77370843143, would junk entry
bad hash table for directory inode 68972565 (no data entry): would =
rebuild
entry "Classical" in shortform directory 202739721 references =
non-existent inode 77492862991would junk entry
would fix i8count in inode 202739721
entry "NAIS" in directory inode 202739732 points to non-existent inode =
21676515414, would junk entry
bad hash table for directory inode 202739732 (no data entry): would =
rebuild
entry "Japanese" in directory inode 417902664 points to non-existent =
inode 77491990544, would junk entry
bad hash table for directory inode 417902664 (no data entry): would =
rebuild
entry "Greatest Hits (CemaAtlantic)" in shortform directory 418459710 =
references non-existent inode 77492490252would junk entry
would fix i8count in inode 418459710
entry "Classic Rock- 1965" in shortform directory 419037188 references =
non-existent inode 21706354767would junk entry
would fix i8count in inode 419037188
entry "Super Hits of the '70s- Have a Nice Day, Vol. 7" in shortform =
directory 419037189 references non-existent inode 98918465562would junk =
entry
would fix i8count in inode 419037189
entry "Connie" in shortform directory 4355010569 references non-existent =
inode 21552037921would junk entry
would fix i8count in inode 4355010569
entry "Q01Files" in shortform directory 4355010593 references =
non-existent inode 98806083589would junk entry
would fix i8count in inode 4355010593
entry ".." in directory inode 4360618047 points to non-existent inode =
43037696049, would junk entry
entry "instantcake-tcd649-1.1-std.iso" in directory inode 4360618047 =
points to non-existent inode 43196874847, would junk entry
entry "instantcake-tcd649-1.1-std.iso.zip" in directory inode 4360618047 =
points to non-existent inode 43196874848, would junk entry
entry "instantcake-tcd648-1.0-9.2a-01-2-648.iso" in directory inode =
4360618047 points to non-existent inode 43196874846, would junk entry
bad hash table for directory inode 4360618047 (no data entry): would =
rebuild
entry "MacOS" in directory inode 4479877124 points to non-existent inode =
98915766308, would junk entry
bad hash table for directory inode 4479877124 (no data entry): would =
rebuild
entry ".svn" in shortform directory 4479877167 references non-existent =
inode 21676515401would junk entry
would fix i8count in inode 4479877167
entry ".." in directory inode 4479877246 points to non-existent inode =
98915770389, would junk entry
entry "ChnEng" in directory inode 4479877246 points to non-existent =
inode 43198083122, would junk entry
entry "Fre" in directory inode 4479877246 points to non-existent inode =
77491523641, would junk entry
entry "Pol" in directory inode 4479877246 points to non-existent inode =
98915770398, would junk entry
bad hash table for directory inode 4479877246 (no data entry): would =
rebuild
entry "English" in directory inode 4488884232 points to non-existent =
inode 98916159526, would junk entry
bad hash table for directory inode 4488884232 (no data entry): would =
rebuild
entry "Cozumel 2000" in directory inode 4488884248 points to =
non-existent inode 43392253987, would junk entry
bad hash table for directory inode 4488884248 (no data entry): would =
rebuild
entry "Sounds of the Seventies- Super 70's" in shortform directory =
4488884269 references non-existent inode 43392978949would junk entry
would fix i8count in inode 4488884269
entry "AM Gold 1968" in shortform directory 4488884270 references =
non-existent inode 98916237469would junk entry
would fix i8count in inode 4488884270
entry "The Rock 'N Roll Era 1958" in shortform directory 4488884272 =
references non-existent inode 43392978959would junk entry
would fix i8count in inode 4488884272
entry "1964 Classic Rock" in shortform directory 4488884274 references =
non-existent inode 21706354726would junk entry
would fix i8count in inode 4488884274
entry ".." in directory inode 4488884280 points to non-existent inode =
43392413878, would junk entry
bad hash table for directory inode 4488884280 (no data entry): would =
rebuild
entry "lock" in shortform directory 4579237926 references non-existent =
inode 77492863018would junk entry
would fix i8count in inode 4579237926
entry "VIDEO_TS" in shortform directory 8589938690 references =
non-existent inode 42949677058would junk entry
would fix i8count in inode 8589938690
entry ".." in directory inode 8589938726 points to non-existent inode =
21474840577, would junk entry
bad hash table for directory inode 8589938726 (no data entry): would =
rebuild
entry ".." in directory inode 8589938734 points to non-existent inode =
98784251933, would junk entry
bad hash table for directory inode 8589938734 (no data entry): would =
rebuild
entry ".." in directory inode 8644796441 points to non-existent inode =
77370843143, would junk entry
bad hash table for directory inode 8644796441 (no data entry): would =
rebuild
entry "os" in directory inode 8843165728 points to non-existent inode =
21758378090, would junk entry
bad hash table for directory inode 8843165728 (no data entry): would =
rebuild
entry "Photographs" in directory inode 8843165744 points to non-existent =
inode 77491511325, would junk entry
bad hash table for directory inode 8843165744 (no data entry): would =
rebuild
entry "2.4.20_Gen05" in directory inode 8843169875 points to =
non-existent inode 43196874829, would junk entry
bad hash table for directory inode 8843169875 (no data entry): would =
rebuild
entry "libmkv" in shortform directory 8843169882 references non-existent =
inode 21676515393would junk entry
would fix i8count in inode 8843169882
entry "hbbtvplayer" in directory inode 8843169883 points to non-existent =
inode 98915766333, would junk entry
entry "osmozilla" in directory inode 8843169883 points to non-existent =
inode 21676515395, would junk entry
bad hash table for directory inode 8843169883 (no data entry): would =
rebuild
entry ".." in directory inode 8843169890 points to non-existent inode =
98915770389, would junk entry
entry "Frc" in directory inode 8843169890 points to non-existent inode =
21676544040, would junk entry
entry "Por" in directory inode 8843169890 points to non-existent inode =
43198083127, would junk entry
bad hash table for directory inode 8843169890 (no data entry): would =
rebuild
entry "text-base" in shortform directory 8859947015 references =
non-existent inode 21676515399would junk entry
would fix i8count in inode 8859947015
entry "text-base" in shortform directory 8859947019 references =
non-existent inode 21676515435would junk entry
would fix i8count in inode 8859947019
entry "text-base" in shortform directory 8859947020 references =
non-existent inode 21676515436would junk entry
would fix i8count in inode 8859947020
entry "lm_sensors-3.3.3" in directory inode 8879145001 points to =
non-existent inode 21706297361, would junk entry
bad hash table for directory inode 8879145001 (no data entry): would =
rebuild
entry "Spanish" in directory inode 8889970711 points to non-existent =
inode 21706297372, would junk entry
bad hash table for directory inode 8889970711 (no data entry): would =
rebuild
entry "Vienna Master Series - Popular Concert" in shortform directory =
8891183118 references non-existent inode 98916237496would junk entry
would fix i8count in inode 8891183118
entry "Down to Earth" in shortform directory 8891183121 references =
non-existent inode 98918465544would junk entry
would fix i8count in inode 8891183121
entry "Classic Rock- 1966 - The Beat Goes On" in shortform directory =
8891183123 references non-existent inode 77492490267would junk entry
would fix i8count in inode 8891183123
entry "Greatest Hits" in shortform directory 8891183124 references =
non-existent inode 43392979003would junk entry
would fix i8count in inode 8891183124
entry "Christmas in America" in shortform directory 8891183134 =
references non-existent inode 77492162679would junk entry
would fix i8count in inode 8891183134
entry "local-mail" in shortform directory 8891777032 references =
non-existent inode 21758378075would junk entry
would fix i8count in inode 8891777032
entry "Christmas" in directory inode 12884905984 points to non-existent =
inode 98784251946, would junk entry
entry "Good & Better" in directory inode 12884905984 points to =
non-existent inode 21758378088, would junk entry
bad hash table for directory inode 12884905984 (no data entry): would =
rebuild
entry ".." in directory inode 12884906014 points to non-existent inode =
77309415425, would junk entry
bad hash table for directory inode 12884906014 (no data entry): would =
rebuild
entry ".." in directory inode 13011120171 points to non-existent inode =
43037696048, would junk entry
bad hash table for directory inode 13011120171 (no data entry): would =
rebuild
entry "fr" in shortform directory 13011382273 references non-existent =
inode 21676498954would junk entry
would fix i8count in inode 13011382273
entry "Politics" in shortform directory 13011382322 references =
non-existent inode 21676515413would junk entry
would fix i8count in inode 13011382322
entry "i386" in shortform directory 13027205190 references non-existent =
inode 21676515423would junk entry
would fix i8count in inode 13027205190
entry "lgpl" in shortform directory 13027205211 references non-existent =
inode 21676499005would junk entry
would fix i8count in inode 13027205211
entry "props" in shortform directory 13027205218 references non-existent =
inode 21676515396would junk entry
would fix i8count in inode 13027205218
entry "Core-Static" in directory inode 13027512336 points to =
non-existent inode 21676929041, would junk entry
entry "Localization" in directory inode 13027512336 points to =
non-existent inode 43198292030, would junk entry
bad hash table for directory inode 13027512336 (no data entry): would =
rebuild
entry "x64" in shortform directory 13027512342 references non-existent =
inode 21676929047would junk entry
would fix i8count in inode 13027512342
entry "X64" in shortform directory 13027512343 references non-existent =
inode 21676929048would junk entry
would fix i8count in inode 13027512343
entry "JP" in directory inode 13074718790 points to non-existent inode =
43392253962, would junk entry
bad hash table for directory inode 13074718790 (no data entry): would =
rebuild
entry "O Holy Night Disc 1" in shortform directory 13074718840 =
references non-existent inode 77492162674would junk entry
would fix i8count in inode 13074718840
entry "O Holy Night Disc 1" in shortform directory 13091356672 =
references non-existent inode 43392978978would junk entry
would fix i8count in inode 13091356672
entry "Alfred Brendel Plays Beethoven Piano Sonatas, Vol. 2 (1 of 2)" in =
directory inode 13091356696 points to non-existent inode 43392978954, =
would junk entry
bad hash table for directory inode 13091356696 (no data entry): would =
rebuild
entry "OriginalIFOs" in directory inode 17179873282 points to =
non-existent inode 21474840578, would junk entry
bad hash table for directory inode 17179873282 (no data entry): would =
rebuild
entry "OriginalIFOs" in directory inode 17179873284 points to =
non-existent inode 21474840580, would junk entry
bad hash table for directory inode 17179873284 (no data entry): would =
rebuild
entry "OriginalIFOs" in directory inode 17241608247 points to =
non-existent inode 21474840600, would junk entry
bad hash table for directory inode 17241608247 (no data entry): would =
rebuild
entry ".." in directory inode 17241608248 points to non-existent inode =
98784251905, would junk entry
bad hash table for directory inode 17241608248 (no data entry): would =
rebuild
entry "DOCS" in directory inode 17319272475 points to non-existent inode =
43006791738, would junk entry
entry "WinNT" in directory inode 17319272475 points to non-existent =
inode 77370843182, would junk entry
bad hash table for directory inode 17319272475 (no data entry): would =
rebuild
entry "i386" in shortform directory 17336291384 references non-existent =
inode 21676515421would junk entry
would fix i8count in inode 17336291384
entry "10_11" in shortform directory 17420197955 references non-existent =
inode 21676515432would junk entry
would fix i8count in inode 17420197955
entry "64Bit" in shortform directory 17420197956 references non-existent =
inode 21676515433would junk entry
would fix i8count in inode 17420197956
entry "src" in shortform directory 17420197971 references non-existent =
inode 77491511356would junk entry
would fix i8count in inode 17420197971
entry "props" in shortform directory 17420197976 references non-existent =
inode 43198287921would junk entry
would fix i8count in inode 17420197976
entry "prop-base" in shortform directory 17420197977 references =
non-existent inode 21676515398would junk entry
would fix i8count in inode 17420197977
entry "prop-base" in shortform directory 17420197987 references =
non-existent inode 21676515438would junk entry
would fix i8count in inode 17420197987
entry "bin.mips" in shortform directory 17420201999 references =
non-existent inode 21676515446would junk entry
would fix i8count in inode 17420201999
entry ".." in directory inode 17420202008 points to non-existent inode =
98915770389, would junk entry
entry "Dan" in directory inode 17420202008 points to non-existent inode =
77491523642, would junk entry
entry "Fre" in directory inode 17420202008 points to non-existent inode =
98915770399, would junk entry
bad hash table for directory inode 17420202008 (no data entry): would =
rebuild
entry "Linux-2.4.x & Linux-2.6.x" in directory inode 17420214285 points =
to non-existent inode 21676552204, would junk entry
entry "Windows Vista 64bit" in directory inode 17420214285 points to =
non-existent inode 43198287912, would junk entry
bad hash table for directory inode 17420214285 (no data entry): would =
rebuild
entry "Japanese" in directory inode 17436610595 points to non-existent =
inode 77491990551, would junk entry
bad hash table for directory inode 17436610595 (no data entry): would =
rebuild
entry "Fresh Aire Christmas 1988" in shortform directory 17436659751 =
references non-existent inode 98916237471would junk entry
would fix i8count in inode 17436659751
entry "Borodin String Quartets Nos. 1 & 2" in shortform directory =
17436659752 references non-existent inode 77492162681would junk entry
would fix i8count in inode 17436659752
entry "file_db_data" in directory inode 17437196300 points to =
non-existent inode 43393732657, would junk entry
bad hash table for directory inode 17437196300 (no data entry): would =
rebuild
entry "lgpl" in shortform directory 17437196324 references non-existent =
inode 21758378085would junk entry
would fix i8count in inode 17437196324
entry "matroska" in shortform directory 17437196325 references =
non-existent inode 21758378087would junk entry
would fix i8count in inode 17437196325
entry "Back to the Future" in directory inode 25769807872 points to =
non-existent inode 21552037922, would junk entry
entry "Bourne, Jason" in directory inode 25769807872 points to =
non-existent inode 43037630470, would junk entry
entry "Crocodile Dundee" in directory inode 25769807872 points to =
non-existent inode 77370851391, would junk entry
entry "Dr Phibes" in directory inode 25769807872 points to non-existent =
inode 98806263821, would junk entry
entry "IMAX" in directory inode 25769807872 points to non-existent inode =
21552037923, would junk entry
entry "James Bond" in directory inode 25769807872 points to non-existent =
inode 43037630471, would junk entry
entry "Man with no Name" in directory inode 25769807872 points to =
non-existent inode 77370957824, would junk entry
entry "Merlin Jones" in directory inode 25769807872 points to =
non-existent inode 98806263822, would junk entry
entry "Pink Panther" in directory inode 25769807872 points to =
non-existent inode 21552037924, would junk entry
entry "Revenge of the Nerds" in directory inode 25769807872 points to =
non-existent inode 43037630472, would junk entry
entry "SlideShow" in directory inode 25769807872 points to non-existent =
inode 77370957825, would junk entry
entry "Star Wars" in directory inode 25769807872 points to non-existent =
inode 98806263823, would junk entry
entry "Wings" in directory inode 25769807872 points to non-existent =
inode 21552037925, would junk entry
entry "Brave New Voices" in directory inode 25769807872 points to =
non-existent inode 21676552218, would junk entry
entry ".." in directory inode 25769807875 points to non-existent inode =
98784251906, would junk entry
bad hash table for directory inode 25769807875 (no data entry): would =
rebuild
entry "Disc 1" in shortform directory 25769807876 references =
non-existent inode 42949677060would junk entry
would fix i8count in inode 25769807876
entry ".." in directory inode 25925189647 points to non-existent inode =
21507739691, would junk entry
bad hash table for directory inode 25925189647 (no data entry): would =
rebuild
entry "Flowplayer" in directory inode 25925189648 points to non-existent =
inode 43006791719, would junk entry
bad hash table for directory inode 25925189648 (no data entry): would =
rebuild
entry "inc" in shortform directory 26008100926 references non-existent =
inode 77491511354would junk entry
would fix i8count in inode 26008100926
entry ".." in directory inode 26057682952 points to non-existent inode =
43037696048, would junk entry
bad hash table for directory inode 26057682952 (no data entry): would =
rebuild
entry "tmp" in shortform directory 26154033339 references non-existent =
inode 43198287923would junk entry
would fix i8count in inode 26154033339
entry "tmp" in shortform directory 26260242761 references non-existent =
inode 43198287926would junk entry
would fix i8count in inode 26260242761
entry "tmp" in shortform directory 26260242762 references non-existent =
inode 43198287927would junk entry
would fix i8count in inode 26260242762
entry "mflpro_c1" in shortform directory 26260242856 references =
non-existent inode 98915770389would junk entry
would fix i8count in inode 26260242856
entry ".." in directory inode 26260242858 points to non-existent inode =
98915770389, would junk entry
entry "Eng" in directory inode 26260242858 points to non-existent inode =
21676544041, would junk entry
entry "Ita" in directory inode 26260242858 points to non-existent inode =
43198083128, would junk entry
bad hash table for directory inode 26260242858 (no data entry): would =
rebuild
entry "Linux" in shortform directory 26260267045 references non-existent =
inode 43198287897would junk entry
would fix i8count in inode 26260267045
entry ".." in directory inode 26260271146 points to non-existent inode =
21676929031, would junk entry
entry "Driver" in directory inode 26260271146 points to non-existent =
inode 43198292023, would junk entry
bad hash table for directory inode 26260271146 (no data entry): would =
rebuild
entry "Dirty Dancing" in shortform directory 27415207952 references =
non-existent inode 43392978963would junk entry
would fix i8count in inode 27415207952
entry ".." in directory inode 27739979799 points to non-existent inode =
21758378090, would junk entry
bad hash table for directory inode 27739979799 (no data entry): would =
rebuild
entry ".." in directory inode 27739979812 points to non-existent inode =
21676515402, would junk entry
bad hash table for directory inode 27739979812 (no data entry): would =
rebuild
entry "Downloads" in directory inode 30064775168 points to non-existent =
inode 43037696048, would junk entry
entry "Plugins" in directory inode 30064775168 points to non-existent =
inode 98806263846, would junk entry
entry "Ray" in directory inode 30064775168 points to non-existent inode =
43037630473, would junk entry
bad hash table for directory inode 30064775168 (no data entry): would =
rebuild
entry "Disc 2" in shortform directory 30064775172 references =
non-existent inode 98784251908would junk entry
would fix i8count in inode 30064775172
entry ".." in directory inode 30064775184 points to non-existent inode =
42949677057, would junk entry
bad hash table for directory inode 30064775184 (no data entry): would =
rebuild
entry ".." in directory inode 30094696481 points to non-existent inode =
21507739691, would junk entry
bad hash table for directory inode 30094696481 (no data entry): would =
rebuild
entry "master.zip" in shortform directory 30095568937 references =
non-existent inode 77491519552would junk entry
would fix i8count in inode 30095568937
entry "7_2" in directory inode 30191923231 points to non-existent inode =
98915766299, would junk entry
bad hash table for directory inode 30191923231 (no data entry): would =
rebuild
entry "src" in shortform directory 30191923251 references non-existent =
inode 98915766329would junk entry
would fix i8count in inode 30191923251
entry "text-base" in shortform directory 30191923257 references =
non-existent inode 43198287920would junk entry
would fix i8count in inode 30191923257
entry "text-base" in shortform directory 30191923268 references =
non-existent inode 43198287924would junk entry
would fix i8count in inode 30191923268
entry "XZL USB DMX" in directory inode 30191923325 points to =
non-existent inode 77491523643, would junk entry
entry "sounds" in directory inode 30191923325 points to non-existent =
inode 77594005563, would junk entry
bad hash table for directory inode 30191923325 (no data entry): would =
rebuild
entry "libusb-win32" in shortform directory 30191947794 references =
non-existent inode 43198083129would junk entry
would fix i8count in inode 30191947794
entry "TF-3239DL" in shortform directory 30191951881 references =
non-existent inode 43198287899would junk entry
would fix i8count in inode 30191951881
entry "Vista32" in shortform directory 30191988767 references =
non-existent inode 43265073158would junk entry
would fix i8count in inode 30191988767
entry "AlbumName" in shortform directory 30192533551 references =
non-existent inode 98916237468would junk entry
would fix i8count in inode 30192533551
entry ".." in directory inode 30192533554 points to non-existent inode =
43392413878, would junk entry
entry "Greatest Hits" in directory inode 30192533554 points to =
non-existent inode 77492162685, would junk entry
entry "Sounds of the Seventies- 1974" in directory inode 30192533554 =
points to non-existent inode 98916237479, would junk entry
bad hash table for directory inode 30192533554 (no data entry): would =
rebuild
entry "Sounds of the Seventies- 1974" in shortform directory 30192533555 =
references non-existent inode 43392978962would junk entry
would fix i8count in inode 30192533555
entry ".." in directory inode 30192533559 points to non-existent inode =
43392413878, would junk entry
entry "If Not for You" in directory inode 30192533559 points to =
non-existent inode 77492490255, would junk entry
bad hash table for directory inode 30192533559 (no data entry): would =
rebuild
entry "Dd57" in directory inode 30192885820 points to non-existent inode =
43393732624, would junk entry
bad hash table for directory inode 30192885820 (no data entry): would =
rebuild
entry "Cricket" in shortform directory 34359742464 references =
non-existent inode 99184005151would junk entry
would fix i8count in inode 34359742464
entry "VIDEO_TS" in shortform directory 34359742465 references =
non-existent inode 21474840596would junk entry
would fix i8count in inode 34359742465
entry "i386" in shortform directory 34422018084 references non-existent =
inode 43196874813would junk entry
would fix i8count in inode 34422018084
entry "Old" in directory inode 34465357826 points to non-existent inode =
43006791720, would junk entry
bad hash table for directory inode 34465357826 (no data entry): would =
rebuild
entry "fate" in shortform directory 34465358139 references non-existent =
inode 43196874831would junk entry
would fix i8count in inode 34465358139
entry "lgpl" in shortform directory 34465358141 references non-existent =
inode 43196874833would junk entry
would fix i8count in inode 34465358141
entry "matroska" in shortform directory 34493800449 references =
non-existent inode 43198287915would junk entry
would fix i8count in inode 34493800449
entry "props" in shortform directory 34493800456 references non-existent =
inode 43198287922would junk entry
would fix i8count in inode 34493800456
entry "props" in shortform directory 34493800463 references non-existent =
inode 43198287929would junk entry
would fix i8count in inode 34493800463
entry "SpryAssets" in directory inode 34782498868 points to non-existent =
inode 43392253957, would junk entry
bad hash table for directory inode 34782498868 (no data entry): would =
rebuild
entry "1920 x 1080" in directory inode 34782539794 points to =
non-existent inode 77491990566, would junk entry
bad hash table for directory inode 34782539794 (no data entry): would =
rebuild
entry ".." in directory inode 34782539822 points to non-existent inode =
43392413878, would junk entry
bad hash table for directory inode 34782539822 (no data entry): would =
rebuild
entry "Ghostbusters" in shortform directory 34782539827 references =
non-existent inode 98918465543would junk entry
would fix i8count in inode 34782539827
entry "TIME LIFE - AM GOLD - 1965" in shortform directory 34782539831 =
references non-existent inode 77492490270would junk entry
would fix i8count in inode 34782539831
entry "Debussy for Daydreaming" in shortform directory 34782539837 =
references non-existent inode 98916237473would junk entry
would fix i8count in inode 34782539837
entry ".." in directory inode 34847252525 points to non-existent inode =
98916237462, would junk entry
bad hash table for directory inode 34847252525 (no data entry): would =
rebuild
entry "OS2DOS" in directory inode 34847252575 points to non-existent =
inode 77492490286, would junk entry
bad hash table for directory inode 34847252575 (no data entry): would =
rebuild
entry "Disc 1" in shortform directory 38654709764 references =
non-existent inode 42949677086would junk entry
would fix i8count in inode 38654709764
entry ".." in directory inode 38704078853 points to non-existent inode =
43037696048, would junk entry
bad hash table for directory inode 38704078853 (no data entry): would =
rebuild
entry "MS" in directory inode 38704337116 points to non-existent inode =
98802544891, would junk entry
bad hash table for directory inode 38704337116 (no data entry): would =
rebuild
entry "amd64" in shortform directory 38704337133 references non-existent =
inode 43198083124would junk entry
would fix i8count in inode 38704337133
entry "Copy of Remote" in shortform directory 38719377419 references =
non-existent inode 43196874830would junk entry
would fix i8count in inode 38719377419
entry "prop-base" in shortform directory 38719377442 references =
non-existent inode 43198287925would junk entry
would fix i8count in inode 38719377442
entry "prop-base" in shortform directory 38719377445 references =
non-existent inode 43198287928would junk entry
would fix i8count in inode 38719377445
entry "en-us" in directory inode 38720200754 points to non-existent =
inode 77491617849, would junk entry
entry "it" in directory inode 38720200754 points to non-existent inode =
98915782704, would junk entry
bad hash table for directory inode 38720200754 (no data entry): would =
rebuild
entry "NDIS2" in directory inode 38720200760 points to non-existent =
inode 43265073157, would junk entry
bad hash table for directory inode 38720200760 (no data entry): would =
rebuild
entry "VDeck64" in shortform directory 38720200761 references =
non-existent inode 77491617855would junk entry
would fix i8count in inode 38720200761
entry ".." in directory inode 38720765985 points to non-existent inode =
43392413878, would junk entry
bad hash table for directory inode 38720765985 (no data entry): would =
rebuild
entry ".." in directory inode 38720765989 points to non-existent inode =
43392413878, would junk entry
entry "Greatest Hits (Ten Years & Change 1979-1991)" in directory inode =
38720765989 points to non-existent inode 43392978999, would junk entry
bad hash table for directory inode 38720765989 (no data entry): would =
rebuild
entry "Raw" in shortform directory 38720962585 references non-existent =
inode 43392978965would junk entry
would fix i8count in inode 38720962585
entry ".." in directory inode 38825242678 points to non-existent inode =
43393732652, would junk entry
entry "INBOX" in directory inode 38825242678 points to non-existent =
inode 77492863016, would junk entry
entry "NUT" in directory inode 38825242678 points to non-existent inode =
99184005155, would junk entry
bad hash table for directory inode 38825242678 (no data entry): would =
rebuild
entry "lgpl" in shortform directory 38829563910 references non-existent =
inode 43394228244would junk entry
would fix i8count in inode 38829563910
entry "lgpl" in shortform directory 38829563913 references non-existent =
inode 43394228259would junk entry
would fix i8count in inode 38829563913
entry ".." in directory inode 38829563921 points to non-existent inode =
98915766286, would junk entry
entry "VIDEO_TS" in directory inode 38829563921 points to non-existent =
inode 43055878155, would junk entry
bad hash table for directory inode 38829563921 (no data entry): would =
rebuild
entry "valetines 001.jpg" in directory inode 38829563929 points to =
non-existent inode 21758378098, would junk entry
bad hash table for directory inode 38829563929 (no data entry): would =
rebuild
entry "skins" in directory inode 38829563939 points to non-existent =
inode 43394228242, would junk entry
bad hash table for directory inode 38829563939 (no data entry): would =
rebuild
entry "Checking" in shortform directory 38829563965 references =
non-existent inode 43196874811would junk entry
would fix i8count in inode 38829563965
entry "Email" in shortform directory 38829563966 references non-existent =
inode 43196874812would junk entry
would fix i8count in inode 38829563966
entry ".." in directory inode 47244644354 points to non-existent inode =
42949677058, would junk entry
bad hash table for directory inode 47244644354 (no data entry): would =
rebuild
entry ".." in directory inode 47272431653 points to non-existent inode =
43052523560, would junk entry
bad hash table for directory inode 47272431653 (no data entry): would =
rebuild
entry "debian" in directory inode 47272431662 points to non-existent =
inode 21676515394, would junk entry
entry "modules" in directory inode 47272431662 points to non-existent =
inode 43198287918, would junk entry
bad hash table for directory inode 47272431662 (no data entry): would =
rebuild
entry ".." in directory inode 47280693257 points to non-existent inode =
98915766286, would junk entry
bad hash table for directory inode 47280693257 (no data entry): would =
rebuild
entry "src" in shortform directory 47280693277 references non-existent =
inode 77491511349would junk entry
would fix i8count in inode 47280693277
entry ".." in directory inode 47280693278 points to non-existent inode =
43037696049, would junk entry
bad hash table for directory inode 47280693278 (no data entry): would =
rebuild
entry "HDAudio" in shortform directory 47280783476 references =
non-existent inode 43198292025would junk entry
would fix i8count in inode 47280783476
entry "Love Songs" in shortform directory 47332347959 references =
non-existent inode 21706354724would junk entry
would fix i8count in inode 47332347959
entry ".." in directory inode 47332347961 points to non-existent inode =
43392413878, would junk entry
entry "AM Gold - 1973" in directory inode 47332347961 points to =
non-existent inode 77492490251, would junk entry
bad hash table for directory inode 47332347961 (no data entry): would =
rebuild
entry "Gypsy Honeymoon- The Best of Kim Carnes" in shortform directory =
47332347962 references non-existent inode 21706354728would junk entry
would fix i8count in inode 47332347962
entry "St. Elmo's Fire" in shortform directory 47335895041 references =
non-existent inode 21706354772would junk entry
would fix i8count in inode 47335895041
entry ".." in directory inode 47336734723 points to non-existent inode =
21758378070, would junk entry
bad hash table for directory inode 47336734723 (no data entry): would =
rebuild
entry ".imap" in shortform directory 47336734725 references non-existent =
inode 43393732655would junk entry
would fix i8count in inode 47336734725
entry ".." in directory inode 47336734776 points to non-existent inode =
43394228246, would junk entry
bad hash table for directory inode 47336734776 (no data entry): would =
rebuild
entry "VIDEO_TS" in directory inode 51539611652 points to non-existent =
inode 77309415428, would junk entry
bad hash table for directory inode 51539611652 (no data entry): would =
rebuild
entry "VIDEO_TS" in shortform directory 51539611685 references =
non-existent inode 77309415429would junk entry
would fix i8count in inode 51539611685
entry "drivers" in directory inode 51602448390 points to non-existent =
inode 77370851386, would junk entry
entry "server" in directory inode 51602448390 points to non-existent =
inode 98806263841, would junk entry
bad hash table for directory inode 51602448390 (no data entry): would =
rebuild
entry "Equipment Manuals" in directory inode 51699605523 points to =
non-existent inode 43196874878, would junk entry
entry "NVIDIA Graphics" in directory inode 51699605523 points to =
non-existent inode 77491523621, would junk entry
bad hash table for directory inode 51699605523 (no data entry): would =
rebuild
entry "bin" in shortform directory 51699613855 references non-existent =
inode 98915766323would junk entry
would fix i8count in inode 51699613855
entry "The Christmas Album" in shortform directory 51700580373 =
references non-existent inode 98916237495would junk entry
would fix i8count in inode 51700580373
entry "backupsync" in shortform directory 51736309770 references =
non-existent inode 99184005157would junk entry
would fix i8count in inode 51736309770
entry "VIDEO_TS" in shortform directory 55834578945 references =
non-existent inode 43006791683would junk entry
would fix i8count in inode 55834578945
entry ".." in directory inode 55834578947 points to non-existent inode =
98784251904, would junk entry
bad hash table for directory inode 55834578947 (no data entry): would =
rebuild
entry ".." in directory inode 55951405125 points to non-existent inode =
43037696049, would junk entry
entry "mfs-ftp" in directory inode 55951405125 points to non-existent =
inode 98915766334, would junk entry
bad hash table for directory inode 55951405125 (no data entry): would =
rebuild
entry "inc" in shortform directory 55951405131 references non-existent =
inode 21676499003would junk entry
would fix i8count in inode 55951405131
entry "inc" in shortform directory 55951405133 references non-existent =
inode 43198287913would junk entry
would fix i8count in inode 55951405133
entry "Windows Vista 32bit" in directory inode 55952322563 points to =
non-existent inode 77491544085, would junk entry
bad hash table for directory inode 55952322563 (no data entry): would =
rebuild
entry "Windows XP" in shortform directory 55952322565 references =
non-existent inode 77491544087would junk entry
would fix i8count in inode 55952322565
entry "src" in shortform directory 55952388115 references non-existent =
inode 77491511355would junk entry
would fix i8count in inode 55952388115
entry "tmp" in shortform directory 55952388137 references non-existent =
inode 77491519573would junk entry
would fix i8count in inode 55952388137
entry ".." in directory inode 55986327559 points to non-existent inode =
43392413878, would junk entry
bad hash table for directory inode 55986327559 (no data entry): would =
rebuild
entry "Softly With These Songs - The Best of Roberta Flack" in shortform =
directory 55986327560 references non-existent inode 21706354760would =
junk entry
would fix i8count in inode 55986327560
entry "Dancin' and Lovin'" in shortform directory 55986327563 references =
non-existent inode 98918465560would junk entry
would fix i8count in inode 55986327563
entry ".." in directory inode 60129546242 points to non-existent inode =
77309415424, would junk entry
bad hash table for directory inode 60129546242 (no data entry): would =
rebuild
entry "Steve" in directory inode 60208181291 points to non-existent =
inode 43055878204, would junk entry
bad hash table for directory inode 60208181291 (no data entry): would =
rebuild
entry ".." in directory inode 60208181292 points to non-existent inode =
43037696048, would junk entry
entry "license" in directory inode 60208181292 points to non-existent =
inode 98915770383, would junk entry
bad hash table for directory inode 60208181292 (no data entry): would =
rebuild
entry "tmp" in shortform directory 60276125765 references non-existent =
inode 21676499002would junk entry
would fix i8count in inode 60276125765
entry "lgpl" in shortform directory 60276125775 references non-existent =
inode 77491511357would junk entry
would fix i8count in inode 60276125775
entry ".." in directory inode 60276125777 points to non-existent inode =
43037696049, would junk entry
bad hash table for directory inode 60276125777 (no data entry): would =
rebuild
entry "text-base" in shortform directory 60276129815 references =
non-existent inode 77491519568would junk entry
would fix i8count in inode 60276129815
entry "tmp" in shortform directory 60276129839 references non-existent =
inode 77491519571would junk entry
would fix i8count in inode 60276129839
entry "props" in shortform directory 60276129840 references non-existent =
inode 98915770380would junk entry
would fix i8count in inode 60276129840
entry "enst" in shortform directory 60276129841 references non-existent =
inode 98915770381would junk entry
would fix i8count in inode 60276129841
entry "HDx64" in shortform directory 60276203639 references non-existent =
inode 98915782711would junk entry
would fix i8count in inode 60276203639
entry "utility" in shortform directory 60276822060 references =
non-existent inode 77491990553would junk entry
would fix i8count in inode 60276822060
entry "Live! Live! Live!" in shortform directory 60276891651 references =
non-existent inode 21706354714would junk entry
would fix i8count in inode 60276891651
entry "AM Gold 1970" in shortform directory 60276891652 references =
non-existent inode 43392978958would junk entry
would fix i8count in inode 60276891652
entry "Greatest Hits + Five Unleashed" in shortform directory =
60276891660 references non-existent inode 77492490258would junk entry
would fix i8count in inode 60276891660
entry "The Rock & Roll Era- 1963" in shortform directory 60276891661 =
references non-existent inode 21706354763would junk entry
would fix i8count in inode 60276891661
entry ".." in directory inode 60276891663 points to non-existent inode =
43392413878, would junk entry
bad hash table for directory inode 60276891663 (no data entry): would =
rebuild
entry "default.mpg" in shortform directory 60277866727 references =
non-existent inode 43052523580would junk entry
would fix i8count in inode 60277866727
entry "AUDIO_TS" in shortform directory 64424513539 references =
non-existent inode 77309415427would junk entry
would fix i8count in inode 64424513539
entry ".." in directory inode 64424513580 points to non-existent inode =
43006791684, would junk entry
bad hash table for directory inode 64424513580 (no data entry): would =
rebuild
entry "ARJ" in directory inode 64471937038 points to non-existent inode =
77370843142, would junk entry
entry "Leslie" in directory inode 64471937038 points to non-existent =
inode 98784251947, would junk entry
bad hash table for directory inode 64471937038 (no data entry): would =
rebuild
entry "OriginalIFOs" in directory inode 64484773928 points to =
non-existent inode 77594005544, would junk entry
bad hash table for directory inode 64484773928 (no data entry): would =
rebuild
entry "2010-03-30" in directory inode 64551399498 points to non-existent =
inode 77491511326, would junk entry
entry "2013-07-26" in directory inode 64551399498 points to non-existent =
inode 98915766291, would junk entry
bad hash table for directory inode 64551399498 (no data entry): would =
rebuild
entry "libabi" in directory inode 64551399501 points to non-existent =
inode 43196874832, would junk entry
entry "msvc" in directory inode 64551399501 points to non-existent inode =
77491511350, would junk entry
bad hash table for directory inode 64551399501 (no data entry): would =
rebuild
entry "inc" in shortform directory 64551399506 references non-existent =
inode 77491511353would junk entry
would fix i8count in inode 64551399506
entry ".svn" in shortform directory 64551399519 references non-existent =
inode 98915770375would junk entry
would fix i8count in inode 64551399519
entry ".." in directory inode 64551436290 points to non-existent inode =
43037696049, would junk entry
entry "tivostream_v0p5" in directory inode 64551436290 points to =
non-existent inode 77491523585, would junk entry
bad hash table for directory inode 64551436290 (no data entry): would =
rebuild
entry "X86" in shortform directory 64551436350 references non-existent =
inode 77491511344would junk entry
would fix i8count in inode 64551436350
entry "free-x86_64-regparm0" in shortform directory 64551452696 =
references non-existent inode 77491544082would junk entry
would fix i8count in inode 64551452696
entry "Lynn Anderson" in directory inode 64796069907 points to =
non-existent inode 77492490285, would junk entry
bad hash table for directory inode 64796069907 (no data entry): would =
rebuild
entry "Animals" in directory inode 64796069909 points to non-existent =
inode 77492490287, would junk entry
entry "Bathroom" in directory inode 64796069909 points to non-existent =
inode 98918465574, would junk entry
entry "Office Supplies" in directory inode 64796069909 points to =
non-existent inode 21706354790, would junk entry
entry "Transitional Elements" in directory inode 64796069909 points to =
non-existent inode 43393732625, would junk entry
bad hash table for directory inode 64796069909 (no data entry): would =
rebuild
entry "RecentDocuments" in directory inode 64796418214 points to =
non-existent inode 77492863014, would junk entry
entry "kfileplaces" in directory inode 64796418214 points to =
non-existent inode 99184005152, would junk entry
bad hash table for directory inode 64796418214 (no data entry): would =
rebuild
entry "16x16" in shortform directory 64796418238 references non-existent =
inode 77491511313would junk entry
would fix i8count in inode 64796418238
entry ".." in directory inode 68727828484 points to non-existent inode =
42949677060, would junk entry
bad hash table for directory inode 68727828484 (no data entry): would =
rebuild
entry ".." in directory inode 68727828531 points to non-existent inode =
42949677086, would junk entry
bad hash table for directory inode 68727828531 (no data entry): would =
rebuild
entry "My Pictures" in directory inode 68748406819 points to =
non-existent inode 43037630465, would junk entry
bad hash table for directory inode 68748406819 (no data entry): would =
rebuild
entry "out" in directory inode 68840685627 points to non-existent inode =
77491511315, would junk entry
bad hash table for directory inode 68840685627 (no data entry): would =
rebuild
entry ".." in directory inode 68912447582 points to non-existent inode =
43037696049, would junk entry
bad hash table for directory inode 68912447582 (no data entry): would =
rebuild
entry "x86_64" in shortform directory 68912455734 references =
non-existent inode 77491511341would junk entry
would fix i8count in inode 68912455734
entry "libebml" in directory inode 68912455741 points to non-existent =
inode 43196874834, would junk entry
entry "sstring" in directory inode 68912455741 points to non-existent =
inode 77491511352, would junk entry
bad hash table for directory inode 68912455741 (no data entry): would =
rebuild
entry "libmmbd" in shortform directory 68912492551 references =
non-existent inode 77491511351would junk entry
would fix i8count in inode 68912492551
entry "props" in shortform directory 68912492559 references non-existent =
inode 77491511358would junk entry
would fix i8count in inode 68912492559
entry "props" in shortform directory 68912492560 references non-existent =
inode 77491511359would junk entry
would fix i8count in inode 68912492560
entry "props" in shortform directory 68912492561 references non-existent =
inode 77491519565would junk entry
would fix i8count in inode 68912492561
entry "props" in shortform directory 68912492562 references non-existent =
inode 77491519566would junk entry
would fix i8count in inode 68912492562
entry "props" in shortform directory 68912492565 references non-existent =
inode 77491519569would junk entry
would fix i8count in inode 68912492565
entry ".svn" in shortform directory 68912492569 references non-existent =
inode 21676515437would junk entry
would fix i8count in inode 68912492569
entry "props" in shortform directory 68912492571 references non-existent =
inode 77491519574would junk entry
would fix i8count in inode 68912492571
entry "Core-Static" in directory inode 68912492670 points to =
non-existent inode 77491617833, would junk entry
entry "Localization" in directory inode 68912492670 points to =
non-existent inode 98915782696, would junk entry
bad hash table for directory inode 68912492670 (no data entry): would =
rebuild
entry "x64" in shortform directory 68912726020 references non-existent =
inode 77491617844would junk entry
would fix i8count in inode 68912726020
entry "Heaven on Earth" in shortform directory 68996411446 references =
non-existent inode 21706354713would junk entry
would fix i8count in inode 68996411446
entry "AM GOLD 1971" in shortform directory 68996411449 references =
non-existent inode 43392978961would junk entry
would fix i8count in inode 68996411449
entry "Verities & Balderdash" in shortform directory 68996411450 =
references non-existent inode 77492490240would junk entry
would fix i8count in inode 68996411450
entry ".." in directory inode 68996796417 points to non-existent inode =
43392413878, would junk entry
entry "Rock, Rhythm and Doo Wop, Vol. 1- The Greatest Songs =46rom Early =
Rock 'n' Roll" in directory inode 68996796417 points to non-existent =
inode 43392979001, would junk entry
bad hash table for directory inode 68996796417 (no data entry): would =
rebuild
entry "Symphonic Poems" in shortform directory 68996796425 references =
non-existent inode 21706354718would junk entry
would fix i8count in inode 68996796425
entry ".." in directory inode 68996796438 points to non-existent inode =
77492162666, would junk entry
bad hash table for directory inode 68996796438 (no data entry): would =
rebuild
entry "calendar" in shortform directory 68997402671 references =
non-existent inode 77492863015would junk entry
would fix i8count in inode 68997402671
entry "VIDEO_TS" in shortform directory 73014448131 references =
non-existent inode 98784251907would junk entry
would fix i8count in inode 73014448131
entry "website" in shortform directory 73014448183 references =
non-existent inode 43196874752would junk entry
would fix i8count in inode 73014448183
entry ".." in directory inode 73031290880 points to non-existent inode =
98784251947, would junk entry
bad hash table for directory inode 73031290880 (no data entry): would =
rebuild
entry "Website" in directory inode 73031290881 points to non-existent =
inode 77370843180, would junk entry
bad hash table for directory inode 73031290881 (no data entry): would =
rebuild
entry ".." in directory inode 73101590549 points to non-existent inode =
43037630465, would junk entry
bad hash table for directory inode 73101590549 (no data entry): would =
rebuild
entry "src" in shortform directory 73105653769 references non-existent =
inode 77594005535would junk entry
would fix i8count in inode 73105653769
entry "bin" in shortform directory 73105666390 references non-existent =
inode 77491511330would junk entry
would fix i8count in inode 73105666390
entry "amd64" in shortform directory 73105666392 references non-existent =
inode 77491511331would junk entry
would fix i8count in inode 73105666392
entry "i386" in shortform directory 73105666394 references non-existent =
inode 77491511334would junk entry
would fix i8count in inode 73105666394
entry "4_0_U6" in directory inode 73105666395 points to non-existent =
inode 77491511336, would junk entry
entry "5_0_U2" in directory inode 73105666395 points to non-existent =
inode 98915766303, would junk entry
bad hash table for directory inode 73105666395 (no data entry): would =
rebuild
entry "CLI" in shortform directory 73105666398 references non-existent =
inode 77491511343would junk entry
would fix i8count in inode 73105666398
entry "autoxxx" in directory inode 73105666406 points to non-existent =
inode 21676499006, would junk entry
entry "libmakemkv" in directory inode 73105666406 points to non-existent =
inode 43198287914, would junk entry
bad hash table for directory inode 73105666406 (no data entry): would =
rebuild
entry "nonusb" in shortform directory 73105666412 references =
non-existent inode 77491523584would junk entry
would fix i8count in inode 73105666412
entry "Brolink" in directory inode 73105719305 points to non-existent =
inode 77491523639, would junk entry
bad hash table for directory inode 73105719305 (no data entry): would =
rebuild
entry "prop-base" in shortform directory 73105719310 references =
non-existent inode 77491519567would junk entry
would fix i8count in inode 73105719310
entry "prop-base" in shortform directory 73105747975 references =
non-existent inode 77491519570would junk entry
would fix i8count in inode 73105747975
entry "AM GOLD1969" in shortform directory 73272119303 references =
non-existent inode 77492490254would junk entry
would fix i8count in inode 73272119303
entry "Greatest Hits, Vol. 2" in shortform directory 73272119305 =
references non-existent inode 43392978980would junk entry
would fix i8count in inode 73272119305
entry "The Best of Styx (RCA)" in shortform directory 73272119306 =
references non-existent inode 98918465546would junk entry
would fix i8count in inode 73272119306
entry "Classic Rock- 1968 - The Beat Goes On" in shortform directory =
73272119309 references non-existent inode 43392979007would junk entry
would fix i8count in inode 73272119309
entry "gidmigratortext" in shortform directory 73306308666 references =
non-existent inode 77594005542would junk entry
would fix i8count in inode 73306308666
entry ".." in directory inode 81653158051 points to non-existent inode =
98784251947, would junk entry
bad hash table for directory inode 81653158051 (no data entry): would =
rebuild
entry "TiVo_Temp" in directory inode 81786920975 points to non-existent =
inode 21706354697, would junk entry
bad hash table for directory inode 81786920975 (no data entry): would =
rebuild
entry ".." in directory inode 81786920996 points to non-existent inode =
77491511324, would junk entry
bad hash table for directory inode 81786920996 (no data entry): would =
rebuild
entry ".." in directory inode 81786929197 points to non-existent inode =
43037696049, would junk entry
bad hash table for directory inode 81786929197 (no data entry): would =
rebuild
entry "tms470" in shortform directory 81786929201 references =
non-existent inode 21676499000would junk entry
would fix i8count in inode 81786929201
entry "icons" in shortform directory 81786929207 references non-existent =
inode 98915766328would junk entry
would fix i8count in inode 81786929207
entry "32x32" in shortform directory 81786929211 references non-existent =
inode 98915766332would junk entry
would fix i8count in inode 81786929211
entry "Honeywell" in shortform directory 81786929214 references =
non-existent inode 43392253981would junk entry
would fix i8count in inode 81786929214
entry ".." in directory inode 81786929215 points to non-existent inode =
98915770389, would junk entry
entry "Swe" in directory inode 81786929215 points to non-existent inode =
21676544026, would junk entry
bad hash table for directory inode 81786929215 (no data entry): would =
rebuild
entry "TVApp" in directory inode 82064986146 points to non-existent =
inode 98916159538, would junk entry
bad hash table for directory inode 82064986146 (no data entry): would =
rebuild
entry "Greatest Hits (Capitol)" in shortform directory 82065092720 =
references non-existent inode 98916237482would junk entry
would fix i8count in inode 82065092720
entry "Symphonic Poems" in shortform directory 82065092722 references =
non-existent inode 77492490253would junk entry
would fix i8count in inode 82065092722
entry "Gyorgy Sandor Plays Prokofiev, Vol. 1 (3 of 3)" in directory =
inode 82065301526 points to non-existent inode 43392978956, would junk =
entry
bad hash table for directory inode 82065301526 (no data entry): would =
rebuild
entry ".." in directory inode 82065301528 points to non-existent inode =
98916237472, would junk entry
bad hash table for directory inode 82065301528 (no data entry): would =
rebuild
entry "Quiet Riot - Greatest Hits" in shortform directory 82201460747 =
references non-existent inode 98918465572would junk entry
would fix i8count in inode 82201460747
entry ".." in directory inode 82201460748 points to non-existent inode =
43393732623, would junk entry
bad hash table for directory inode 82201460748 (no data entry): would =
rebuild
entry ".." in directory inode 82201460786 points to non-existent inode =
77594005563, would junk entry
entry "Cat Scream-SoundBible.com-871191563.mp3" in directory inode =
82201460786 points to non-existent inode 77594005565, would junk entry
entry "Evil_Laugh_Male_6-Himan-1359990674.mp3" in directory inode =
82201460786 points to non-existent inode 77594005567, would junk entry
entry "Female_Scream_Horror-NeoPhyTe-138499973.mp3" in directory inode =
82201460786 points to non-existent inode 77491511309, would junk entry
bad hash table for directory inode 82201460786 (no data entry): would =
rebuild
entry ".." in directory inode 85960990858 points to non-existent inode =
98784251947, would junk entry
bad hash table for directory inode 85960990858 (no data entry): would =
rebuild
entry "MP3" in directory inode 86092185615 points to non-existent inode =
43392413878, would junk entry
bad hash table for directory inode 86092185615 (no data entry): would =
rebuild
entry ".." in directory inode 86092185616 points to non-existent inode =
21667586090, would junk entry
entry "activityi_data" in directory inode 86092185616 points to =
non-existent inode 98806263847, would junk entry
bad hash table for directory inode 86092185616 (no data entry): would =
rebuild
entry "X86" in shortform directory 86092197954 references non-existent =
inode 98915766318would junk entry
would fix i8count in inode 86092197954
entry "src" in shortform directory 86092197971 references non-existent =
inode 21676499004would junk entry
would fix i8count in inode 86092197971
entry "QtExt" in shortform directory 86092197972 references non-existent =
inode 98915766325would junk entry
would fix i8count in inode 86092197972
entry "lgpl" in shortform directory 86092197973 references non-existent =
inode 98915766326would junk entry
would fix i8count in inode 86092197973
entry "lgpl" in shortform directory 86092197977 references non-existent =
inode 98915766331would junk entry
would fix i8count in inode 86092197977
entry "props" in shortform directory 86092197979 references non-existent =
inode 43198287919would junk entry
would fix i8count in inode 86092197979
entry "text-base" in shortform directory 86092197980 references =
non-existent inode 98915770369would junk entry
would fix i8count in inode 86092197980
entry "text-base" in shortform directory 86092197981 references =
non-existent inode 98915770370would junk entry
would fix i8count in inode 86092197981
entry "text-base" in shortform directory 86092197982 references =
non-existent inode 98915770371would junk entry
would fix i8count in inode 86092197982
entry "props" in shortform directory 86092197985 references non-existent =
inode 98915770376would junk entry
would fix i8count in inode 86092197985
entry "text-base" in shortform directory 86092197990 references =
non-existent inode 98915770382would junk entry
would fix i8count in inode 86092197990
entry ".." in directory inode 86092198002 points to non-existent inode =
43037696049, would junk entry
bad hash table for directory inode 86092198002 (no data entry): would =
rebuild
entry ".." in directory inode 86092201989 points to non-existent inode =
98915770389, would junk entry
entry "Cze" in directory inode 86092201989 points to non-existent inode =
43198083093, would junk entry
entry "Hun" in directory inode 86092201989 points to non-existent inode =
77491523624, would junk entry
entry "Por" in directory inode 86092201989 points to non-existent inode =
98915770392, would junk entry
bad hash table for directory inode 86092201989 (no data entry): would =
rebuild
entry "patch_tool" in shortform directory 86092361747 references =
non-existent inode 98915782710would junk entry
would fix i8count in inode 86092361747
entry "Sounds of the Seventies- 1972" in shortform directory 86092816396 =
references non-existent inode 77492162683would junk entry
would fix i8count in inode 86092816396
entry "lock" in shortform directory 86093082687 references non-existent =
inode 21758378071would junk entry
would fix i8count in inode 86093082687
entry ".." in directory inode 86093668380 points to non-existent inode =
77491511324, would junk entry
bad hash table for directory inode 86093668380 (no data entry): would =
rebuild
entry "Season 5" in directory inode 86093668383 points to non-existent =
inode 98915766286, would junk entry
entry "Season 7" in directory inode 86093668383 points to non-existent =
inode 77491511324, would junk entry
entry "Season 8" in directory inode 86093668383 points to non-existent =
inode 98915766285, would junk entry
bad hash table for directory inode 86093668383 (no data entry): would =
rebuild
entry ".." in directory inode 86093668397 points to non-existent inode =
77594005563, would junk entry
bad hash table for directory inode 86093668397 (no data entry): would =
rebuild
entry "Twilight Zone Vol 06" in directory inode 90194317313 points to =
non-existent inode 43006791684, would junk entry
bad hash table for directory inode 90194317313 (no data entry): would =
rebuild
entry "04 - 100 Years (Album Version).mp3" in directory inode =
90270486545 points to non-existent inode 98915754013, would junk entry
bad hash table for directory inode 90270486545 (no data entry): would =
rebuild
entry ".." in directory inode 90271576326 points to non-existent inode =
98784251947, would junk entry
entry "Christmas" in directory inode 90271576326 points to non-existent =
inode 21507739693, would junk entry
bad hash table for directory inode 90271576326 (no data entry): would =
rebuild
entry ".." in directory inode 90328010761 points to non-existent inode =
21667586090, would junk entry
bad hash table for directory inode 90328010761 (no data entry): would =
rebuild
entry "alpha" in shortform directory 90328019070 references non-existent =
inode 43196874827would junk entry
entry "x86" in shortform directory 90328019070 references non-existent =
inode 77491511348would junk entry
would fix i8count in inode 90328019070
entry ".." in directory inode 90328121345 points to non-existent inode =
43037696049, would junk entry
entry ".deps" in directory inode 90328121345 points to non-existent =
inode 77491523620, would junk entry
bad hash table for directory inode 90328121345 (no data entry): would =
rebuild
entry "16x16" in shortform directory 90328121352 references non-existent =
inode 98915766330would junk entry
would fix i8count in inode 90328121352
entry ".." in directory inode 90328121357 points to non-existent inode =
77491519615, would junk entry
bad hash table for directory inode 90328121357 (no data entry): would =
rebuild
entry ".." in directory inode 90328121367 points to non-existent inode =
98915770389, would junk entry
entry "Por" in directory inode 90328121367 points to non-existent inode =
21676544027, would junk entry
bad hash table for directory inode 90328121367 (no data entry): would =
rebuild
entry "Rocket 2722" in shortform directory 90328125499 references =
non-existent inode 98915770424would junk entry
would fix i8count in inode 90328125499
entry "prop-base" in shortform directory 90328137762 references =
non-existent inode 98915770373would junk entry
would fix i8count in inode 90328137762
entry "x86-64" in shortform directory 90328141849 references =
non-existent inode 98915766301would junk entry
would fix i8count in inode 90328141849
entry "DOFC" in directory inode 90328141851 points to non-existent inode =
98915782695, would junk entry
bad hash table for directory inode 90328141851 (no data entry): would =
rebuild
entry "props" in shortform directory 90328141866 references non-existent =
inode 98915770377would junk entry
would fix i8count in inode 90328141866
entry "The Best of Bill Medley" in shortform directory 90516987962 =
references non-existent inode 43392978950would junk entry
would fix i8count in inode 90516987962
entry ".." in directory inode 90516987964 points to non-existent inode =
43392413878, would junk entry
entry "Motown Legends, Vol. 1" in directory inode 90516987964 points to =
non-existent inode 98916237477, would junk entry
bad hash table for directory inode 90516987964 (no data entry): would =
rebuild
entry "Misc" in shortform directory 90517016577 references non-existent =
inode 98916237498would junk entry
would fix i8count in inode 90517016577
entry "Classic Rock- 1968" in shortform directory 90517016581 references =
non-existent inode 77492490268would junk entry
would fix i8count in inode 90517016581
entry "akonadi" in shortform directory 90549440584 references =
non-existent inode 99184005153would junk entry
would fix i8count in inode 90549440584
entry ".." in directory inode 90549440603 points to non-existent inode =
21706330135, would junk entry
entry "2015-02-20 Puerto Rico" in directory inode 90549440603 points to =
non-existent inode 98915754040, would junk entry
bad hash table for directory inode 90549440603 (no data entry): would =
rebuild
entry "DOWNTON_ABBEY_D1" in directory inode 94489284608 points to =
non-existent inode 77309415426, would junk entry
entry "DOWNTON_ABBEY_S2_D3" in directory inode 94489284608 points to =
non-existent inode 98784251906, would junk entry
bad hash table for directory inode 94489284608 (no data entry): would =
rebuild
entry "1 The Best of Borge - Acts 1 and 2" in directory inode =
94489284609 points to non-existent inode 77309415448, would junk entry
entry "6 Lost_Episodes of Victor Borge Vol_2" in directory inode =
94489284609 points to non-existent inode 98784251933, would junk entry
bad hash table for directory inode 94489284609 (no data entry): would =
rebuild
entry "OriginalIFOs" in directory inode 94489284613 points to =
non-existent inode 98784251914, would junk entry
bad hash table for directory inode 94489284613 (no data entry): would =
rebuild
entry "Christmas" in directory inode 94489284652 points to non-existent =
inode 21507739692, would junk entry
bad hash table for directory inode 94489284652 (no data entry): would =
rebuild
entry "Q01Files" in shortform directory 94489284668 references =
non-existent inode 43006791737would junk entry
would fix i8count in inode 94489284668
entry ".." in directory inode 94536843282 points to non-existent inode =
21667586090, would junk entry
bad hash table for directory inode 94536843282 (no data entry): would =
rebuild
entry "Windows" in directory inode 94536843319 points to non-existent =
inode 77491511346, would junk entry
entry "logrotate" in directory inode 94536843319 points to non-existent =
inode 98915766320, would junk entry
bad hash table for directory inode 94536843319 (no data entry): would =
rebuild
entry "Disk 8" in shortform directory 94562865200 references =
non-existent inode 21676515402would junk entry
would fix i8count in inode 94562865200
entry "Photos" in directory inode 94587891751 points to non-existent =
inode 98915766287, would junk entry
bad hash table for directory inode 94587891751 (no data entry): would =
rebuild
entry "prop-base" in shortform directory 94587895810 references =
non-existent inode 98915770379would junk entry
would fix i8count in inode 94587895810
entry "Cht" in shortform directory 94587895822 references non-existent =
inode 43198083118would junk entry
would fix i8count in inode 94587895822
entry ".." in directory inode 94587895836 points to non-existent inode =
77491523643, would junk entry
bad hash table for directory inode 94587895836 (no data entry): would =
rebuild
entry "Linux-2.4.x" in directory inode 94659698699 points to =
non-existent inode 98915774493, would junk entry
bad hash table for directory inode 94659698699 (no data entry): would =
rebuild
entry "storport" in shortform directory 94659698704 references =
non-existent inode 98915766311would junk entry
would fix i8count in inode 94659698704
entry "ja" in directory inode 94659702817 points to non-existent inode =
21676929032, would junk entry
entry "pt-BR" in directory inode 94659702817 points to non-existent =
inode 43198292024, would junk entry
bad hash table for directory inode 94659702817 (no data entry): would =
rebuild
entry "AMD_Chipset_Driver_xp" in directory inode 94659702828 points to =
non-existent inode 98915782703, would junk entry
bad hash table for directory inode 94659702828 (no data entry): would =
rebuild
entry ".." in directory inode 94994862126 points to non-existent inode =
43392253987, would junk entry
bad hash table for directory inode 94994862126 (no data entry): would =
rebuild
entry "The Best of Frank Mills- Happy Music" in shortform directory =
95118995629 references non-existent inode 77492162687would junk entry
would fix i8count in inode 95118995629
entry "Moving" in shortform directory 95118995634 references =
non-existent inode 21706354755would junk entry
would fix i8count in inode 95118995634
entry "Masters of Classical Music, Vol. 5 Wagner" in shortform directory =
95118995644 references non-existent inode 77492162682would junk entry
would fix i8count in inode 95118995644
entry ".." in directory inode 95157329964 points to non-existent inode =
99184005156, would junk entry
entry "NewEgg" in directory inode 95157329964 points to non-existent =
inode 21758378076, would junk entry
entry "Sent" in directory inode 95157329964 points to non-existent inode =
43393732658, would junk entry
bad hash table for directory inode 95157329964 (no data entry): would =
rebuild
entry "src" in shortform directory 95375138851 references non-existent =
inode 98915754014would junk entry
would fix i8count in inode 95375138851
entry "lgpl" in shortform directory 95375138852 references non-existent =
inode 98915754036would junk entry
would fix i8count in inode 95375138852
entry "d01" in shortform directory 95375138856 references non-existent =
inode 99189358615would junk entry
would fix i8count in inode 95375138856
entry "Broadcom Wireless" in shortform directory 95375138861 references =
non-existent inode 21676544020would junk entry
entry "TrendNet" in shortform directory 95375138861 references =
non-existent inode 98915754007would junk entry
would fix i8count in inode 95375138861
entry "VIDEO_TS" in shortform directory 103079219201 references =
non-existent inode 21474840632would junk entry
would fix i8count in inode 103079219201
entry ".." in directory inode 103079219243 points to non-existent inode =
77309415448, would junk entry
bad hash table for directory inode 103079219243 (no data entry): would =
rebuild
entry ".." in directory inode 103124635648 points to non-existent inode =
98784251947, would junk entry
bad hash table for directory inode 103124635648 (no data entry): would =
rebuild
entry ".." in directory inode 103166758944 points to non-existent inode =
98915766285, would junk entry
bad hash table for directory inode 103166758944 (no data entry): would =
rebuild
entry ".." in directory inode 103166820441 points to non-existent inode =
98915770389, would junk entry
entry "Ita" in directory inode 103166820441 points to non-existent inode =
21676544028, would junk entry
entry "Rom" in directory inode 103166820441 points to non-existent inode =
43198083119, would junk entry
bad hash table for directory inode 103166820441 (no data entry): would =
rebuild
entry "Q Light Controller" in shortform directory 103166820454 =
references non-existent inode 77491527690would junk entry
would fix i8count in inode 103166820454
entry "BIOS" in directory inode 103166820468 points to non-existent =
inode 77491527723, would junk entry
entry "rr232x-linux-src-v1.10" in directory inode 103166820468 points to =
non-existent inode 98915774487, would junk entry
bad hash table for directory inode 103166820468 (no data entry): would =
rebuild
entry ".." in directory inode 103166828595 points to non-existent inode =
77491527723, would junk entry
bad hash table for directory inode 103166828595 (no data entry): would =
rebuild
entry ".." in directory inode 103166828598 points to non-existent inode =
43196874878, would junk entry
bad hash table for directory inode 103166828598 (no data entry): would =
rebuild
entry "Sounds of the Seventies- 1972" in shortform directory =
103167189121 references non-existent inode 21706354727would junk entry
would fix i8count in inode 103167189121
entry ".." in directory inode 103167189169 points to non-existent inode =
98916237465, would junk entry
bad hash table for directory inode 103167189169 (no data entry): would =
rebuild
entry "tmp" in shortform directory 103167508531 references non-existent =
inode 21758378072would junk entry
would fix i8count in inode 103167508531
entry ".." in directory inode 103167508533 points to non-existent inode =
77492863017, would junk entry
bad hash table for directory inode 103167508533 (no data entry): would =
rebuild
entry "VIDEO_TS" in shortform directory 107374186498 references =
non-existent inode 42949677059would junk entry
would fix i8count in inode 107374186498
entry "EasyBoot" in directory inode 107374198820 points to non-existent =
inode 98918465573, would junk entry
bad hash table for directory inode 107374198820 (no data entry): would =
rebuild
entry "x86" in shortform directory 107599970322 references non-existent =
inode 98915766322would junk entry
would fix i8count in inode 107599970322
entry "Frc" in directory inode 107600003166 points to non-existent inode =
21676544021, would junk entry
entry "Nor" in directory inode 107600003166 points to non-existent inode =
43196874879, would junk entry
bad hash table for directory inode 107600003166 (no data entry): would =
rebuild
entry ".." in directory inode 107600003167 points to non-existent inode =
98915770389, would junk entry
entry "Fin" in directory inode 107600003167 points to non-existent inode =
77491523634, would junk entry
entry "Por" in directory inode 107600003167 points to non-existent inode =
98915770394, would junk entry
bad hash table for directory inode 107600003167 (no data entry): would =
rebuild
entry ".." in directory inode 107600539659 points to non-existent inode =
98915782703, would junk entry
bad hash table for directory inode 107600539659 (no data entry): would =
rebuild
entry ".." in directory inode 107600724055 points to non-existent inode =
21706297361, would junk entry
bad hash table for directory inode 107600724055 (no data entry): would =
rebuild
entry ".." in directory inode 107600814352 points to non-existent inode =
43392978953, would junk entry
bad hash table for directory inode 107600814352 (no data entry): would =
rebuild
entry ".." in directory inode 107600814365 points to non-existent inode =
21706354704, would junk entry
bad hash table for directory inode 107600814365 (no data entry): would =
rebuild
entry "Editor" in directory inode 107663573017 points to non-existent =
inode 21706354789, would junk entry
bad hash table for directory inode 107663573017 (no data entry): would =
rebuild
entry ".." in directory inode 107666485369 points to non-existent inode =
98915766285, would junk entry
bad hash table for directory inode 107666485369 (no data entry): would =
rebuild
entry ".." in directory inode 111673475085 points to non-existent inode =
98784251947, would junk entry
bad hash table for directory inode 111673475085 (no data entry): would =
rebuild
entry "2.4.4" in directory inode 111686406241 points to non-existent =
inode 21676515447, would junk entry
bad hash table for directory inode 111686406241 (no data entry): would =
rebuild
entry "AMD_Chipset_Driver_xp" in shortform directory 111886688296 =
references non-existent inode 21676929031would junk entry
would fix i8count in inode 111886688296
entry ".." in directory inode 111887126568 points to non-existent inode =
21706297361, would junk entry
entry "sensord" in directory inode 111887126568 points to non-existent =
inode 21706330113, would junk entry
bad hash table for directory inode 111887126568 (no data entry): would =
rebuild
entry "Very Best of - Only the beginning" in shortform directory =
111887241217 references non-existent inode 98916237470would junk entry
would fix i8count in inode 111887241217
entry "Sounds of the Seventies- 1973" in shortform directory =
111887241225 references non-existent inode 98918465545would junk entry
would fix i8count in inode 111887241225
entry "Groovin'" in shortform directory 111887241228 references =
non-existent inode 43392979005would junk entry
would fix i8count in inode 111887241228
entry ".." in directory inode 111895687207 points to non-existent inode =
43392978952, would junk entry
bad hash table for directory inode 111895687207 (no data entry): would =
rebuild
entry "Greatest HIts" in shortform directory 111895687208 references =
non-existent inode 98916237475would junk entry
would fix i8count in inode 111895687208
entry ".." in directory inode 111895687209 points to non-existent inode =
43392978953, would junk entry
bad hash table for directory inode 111895687209 (no data entry): would =
rebuild
entry ".." in directory inode 115964121113 points to non-existent inode =
98784251908, would junk entry
bad hash table for directory inode 115964121113 (no data entry): would =
rebuild
entry ".." in directory inode 116006125580 points to non-existent inode =
98784251947, would junk entry
bad hash table for directory inode 116006125580 (no data entry): would =
rebuild
entry ".." in directory inode 116192387077 points to non-existent inode =
98915770378, would junk entry
bad hash table for directory inode 116192387077 (no data entry): would =
rebuild
entry ".." in directory inode 116192387114 points to non-existent inode =
98915770389, would junk entry
entry "Fre" in directory inode 116192387114 points to non-existent inode =
21676544029, would junk entry
entry "Pol" in directory inode 116192387114 points to non-existent inode =
43198083120, would junk entry
bad hash table for directory inode 116192387114 (no data entry): would =
rebuild
entry "EZ Ridin'" in shortform directory 116343926954 references =
non-existent inode 21706354762would junk entry
would fix i8count in inode 116343926954
entry ".." in directory inode 116343980276 points to non-existent inode =
21706354699, would junk entry
bad hash table for directory inode 116343980276 (no data entry): would =
rebuild
entry ".." in directory inode 116343980280 points to non-existent inode =
43392978953, would junk entry
bad hash table for directory inode 116343980280 (no data entry): would =
rebuild
entry ".." in directory inode 116398661643 points to non-existent inode =
99184005153, would junk entry
bad hash table for directory inode 116398661643 (no data entry): would =
rebuild
entry ".." in directory inode 120259088386 points to non-existent inode =
77309415426, would junk entry
bad hash table for directory inode 120259088386 (no data entry): would =
rebuild
entry ".." in directory inode 120329281560 points to non-existent inode =
98784251947, would junk entry
entry "1993" in directory inode 120329281560 points to non-existent =
inode 98802544862, would junk entry
entry "Quicken Downloads" in directory inode 120329281560 points to =
non-existent inode 21552037890, would junk entry
bad hash table for directory inode 120329281560 (no data entry): would =
rebuild
entry "makemkv-bin-1.9.1" in directory inode 120362094654 points to =
non-existent inode 43394228240, would junk entry
entry "ffmpeg-2.1.1" in directory inode 120362094654 points to =
non-existent inode 43196874826, would junk entry
entry "makemkv-oss-1.9.0" in directory inode 120362094654 points to =
non-existent inode 77491511347, would junk entry
bad hash table for directory inode 120362094654 (no data entry): would =
rebuild
entry "jni" in shortform directory 120448295015 references non-existent =
inode 77491519572would junk entry
would fix i8count in inode 120448295015
entry ".." in directory inode 120471560274 points to non-existent inode =
98915770424, would junk entry
bad hash table for directory inode 120471560274 (no data entry): would =
rebuild
entry "Classic Rock- 1966 - Blowin' Your Mind" in shortform directory =
120472117286 references non-existent inode 77492162675would junk entry
would fix i8count in inode 120472117286
entry ".." in directory inode 120472117287 points to non-existent inode =
43392413878, would junk entry
entry "Martina McBride" in directory inode 120472117287 points to =
non-existent inode 21706354715, would junk entry
entry "Orchestra Manhattan" in directory inode 120472117287 points to =
non-existent inode 43392978952, would junk entry
bad hash table for directory inode 120472117287 (no data entry): would =
rebuild
entry "Wedding Day Music" in shortform directory 120472117289 references =
non-existent inode 98916237481would junk entry
would fix i8count in inode 120472117289
entry "AM GOLD 1971" in shortform directory 120472117291 references =
non-existent inode 43392978964would junk entry
would fix i8count in inode 120472117291
entry ".." in directory inode 120533618729 points to non-existent inode =
42949677056, would junk entry
entry ".config" in directory inode 120533618729 points to non-existent =
inode 77492863017, would junk entry
entry "mail" in directory inode 120533618729 points to non-existent =
inode 99184005156, would junk entry
entry "Templates" in directory inode 120533618729 points to non-existent =
inode 21758378089, would junk entry
entry "Videos" in directory inode 120533618729 points to non-existent =
inode 43394228287, would junk entry
bad hash table for directory inode 120533618729 (no data entry): would =
rebuild
entry "kicker" in directory inode 120533618733 points to non-existent =
inode 21758378074, would junk entry
entry "kwallet" in directory inode 120533618733 points to non-existent =
inode 43393732656, would junk entry
bad hash table for directory inode 120533618733 (no data entry): would =
rebuild
entry "Symantec" in shortform directory 124571324436 references =
non-existent inode 21552037911would junk entry
would fix i8count in inode 124571324436
entry ".." in directory inode 124571324437 points to non-existent inode =
98784251947, would junk entry
bad hash table for directory inode 124571324437 (no data entry): would =
rebuild
entry "x86" in shortform directory 124656844832 references non-existent =
inode 21676499001would junk entry
would fix i8count in inode 124656844832
entry "plugins" in directory inode 124656857201 points to non-existent =
inode 77594005540, would junk entry
bad hash table for directory inode 124656857201 (no data entry): would =
rebuild
entry ".." in directory inode 124656869394 points to non-existent inode =
98915770389, would junk entry
entry "Cze" in directory inode 124656869394 points to non-existent inode =
98915770396, would junk entry
entry "Rus" in directory inode 124656869394 points to non-existent inode =
21676544030, would junk entry
bad hash table for directory inode 124656869394 (no data entry): would =
rebuild
entry "rr272x" in shortform directory 124689535045 references =
non-existent inode 21676552198would junk entry
would fix i8count in inode 124689535045
entry ".." in directory inode 124689535051 points to non-existent inode =
43198287899, would junk entry
bad hash table for directory inode 124689535051 (no data entry): would =
rebuild
entry "Suse-SLES" in shortform directory 124689539163 references =
non-existent inode 21676515431would junk entry
entry "Debian" in shortform directory 124689539163 references =
non-existent inode 98915766327would junk entry
would fix i8count in inode 124689539163
entry "Alive 'N Kickin' (Collectables)" in shortform directory =
124753793139 references non-existent inode 21706354712would junk entry
would fix i8count in inode 124753793139
entry ".." in directory inode 124753793147 points to non-existent inode =
43392413878, would junk entry
entry "The Jazz Singer" in directory inode 124753793147 points to =
non-existent inode 21706354754, would junk entry
bad hash table for directory inode 124753793147 (no data entry): would =
rebuild
entry "Sounds of the Seventies- AM Nuggets" in shortform directory =
124753793148 references non-existent inode 77492490256would junk entry
would fix i8count in inode 124753793148
entry ".." in directory inode 124753965056 points to non-existent inode =
43392413878, would junk entry
entry "Seven Separate Fools" in directory inode 124753965056 points to =
non-existent inode 77492490272, would junk entry
bad hash table for directory inode 124753965056 (no data entry): would =
rebuild
entry "PowerQuest PartitionMagic 6.0" in directory inode 124762431535 =
points to non-existent inode 21706354788, would junk entry
entry "UTILITY" in directory inode 124762431535 points to non-existent =
inode 43393732623, would junk entry
bad hash table for directory inode 124762431535 (no data entry): would =
rebuild
entry "1997" in directory inode 128857702411 points to non-existent =
inode 21552037912, would junk entry
entry "2006" in directory inode 128857702411 points to non-existent =
inode 43006791739, would junk entry
entry "VALIDATE" in directory inode 128857702411 points to non-existent =
inode 77370843184, would junk entry
bad hash table for directory inode 128857702411 (no data entry): would =
rebuild
entry ".." in directory inode 128857702412 points to non-existent inode =
98784251947, would junk entry
entry "Power" in directory inode 128857702412 points to non-existent =
inode 98802544890, would junk entry
bad hash table for directory inode 128857702412 (no data entry): would =
rebuild
entry "Q01Files" in shortform directory 128857702413 references =
non-existent inode 77370843181would junk entry
would fix i8count in inode 128857702413
entry "5_3" in directory inode 128987131937 points to non-existent inode =
21676515426, would junk entry
entry "5_8" in directory inode 128987131937 points to non-existent inode =
43198083135, would junk entry
bad hash table for directory inode 128987131937 (no data entry): would =
rebuild
entry ".." in directory inode 128987152396 points to non-existent inode =
98915770389, would junk entry
entry "Bul" in directory inode 128987152396 points to non-existent inode =
43198083121, would junk entry
entry "Fin" in directory inode 128987152396 points to non-existent inode =
77491523640, would junk entry
entry "Ita" in directory inode 128987152396 points to non-existent inode =
98915770397, would junk entry
bad hash table for directory inode 128987152396 (no data entry): would =
rebuild
entry "TVFM" in shortform directory 128991920148 references non-existent =
inode 21676552203would junk entry
would fix i8count in inode 128991920148
entry "Stills" in shortform directory 129135882335 references =
non-existent inode 21706330135would junk entry
would fix i8count in inode 129135882335
entry ".." in directory inode 129135882353 points to non-existent inode =
43392413878, would junk entry
entry "Carmen-Suite Nr. 1-no. 1" in directory inode 129135882353 points =
to non-existent inode 21706354716, would junk entry
entry "Dvorak" in directory inode 129135882353 points to non-existent =
inode 43392978953, would junk entry
entry "Misc" in directory inode 129135882353 points to non-existent =
inode 77492162680, would junk entry
entry "S=C3=A1ndor, J=C3=A1nos" in directory inode 129135882353 points =
to non-existent inode 98916237472, would junk entry
bad hash table for directory inode 129135882353 (no data entry): would =
rebuild
entry "VIDEO_TS" in shortform directory 133143990276 references =
non-existent inode 21474840587would junk entry
would fix i8count in inode 133143990276
entry "The Greatest Hits" in shortform directory 133143990305 references =
non-existent inode 21507739691would junk entry
would fix i8count in inode 133143990305
entry "Win" in directory inode 133252530210 points to non-existent inode =
21667586091, would junk entry
entry "man" in directory inode 133252530210 points to non-existent inode =
43037696050, would junk entry
bad hash table for directory inode 133252530210 (no data entry): would =
rebuild
entry "props" in shortform directory 133252546594 references =
non-existent inode 21676515400would junk entry
would fix i8count in inode 133252546594
entry "Nor" in shortform directory 133252555235 references non-existent =
inode 21676544039would junk entry
would fix i8count in inode 133252555235
entry "The Very Best of Dusty Springfield (Mercury)" in shortform =
directory 133306257434 references non-existent inode 21706354722would =
junk entry
would fix i8count in inode 133306257434
entry "Starbox" in shortform directory 133306257442 references =
non-existent inode 43392979000would junk entry
would fix i8count in inode 133306257442
entry "Konzerte Concertos on authentic instruments" in shortform =
directory 133306257451 references non-existent inode 21706354717would =
junk entry
would fix i8count in inode 133306257451
entry ".config" in directory inode 133306986547 points to non-existent =
inode 21758378070, would junk entry
entry "mail" in directory inode 133306986547 points to non-existent =
inode 43393732652, would junk entry
bad hash table for directory inode 133306986547 (no data entry): would =
rebuild
entry "backupsync" in shortform directory 133306986548 references =
non-existent inode 43393732653would junk entry
would fix i8count in inode 133306986548
entry "tmp" in directory inode 133306986553 points to non-existent inode =
77492863021, would junk entry
bad hash table for directory inode 133306986553 (no data entry): would =
rebuild
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
disconnected dir inode 68972565, would move to lost+found
disconnected dir inode 202739755, would move to lost+found
disconnected dir inode 202969156, would move to lost+found
disconnected dir inode 202969176, would move to lost+found
disconnected dir inode 202973213, would move to lost+found
disconnected dir inode 202981377, would move to lost+found
disconnected dir inode 417288195, would move to lost+found
disconnected dir inode 417296423, would move to lost+found
disconnected dir inode 418459704, would move to lost+found
disconnected dir inode 418459705, would move to lost+found
disconnected dir inode 418459706, would move to lost+found
disconnected dir inode 418459707, would move to lost+found
disconnected dir inode 418459708, would move to lost+found
disconnected dir inode 418459709, would move to lost+found
disconnected dir inode 418459710, would move to lost+found
disconnected dir inode 418459711, would move to lost+found
disconnected dir inode 419037184, would move to lost+found
disconnected dir inode 419037185, would move to lost+found
disconnected dir inode 419037186, would move to lost+found
disconnected dir inode 419037187, would move to lost+found
disconnected dir inode 419037188, would move to lost+found
disconnected dir inode 419037189, would move to lost+found
disconnected dir inode 469307446, would move to lost+found
disconnected dir inode 469311510, would move to lost+found
disconnected dir inode 469311521, would move to lost+found
disconnected dir inode 4355010570, would move to lost+found
disconnected dir inode 4360618047, would move to lost+found
disconnected dir inode 4479877155, would move to lost+found
disconnected dir inode 4479877246, would move to lost+found
disconnected dir inode 4479889458, would move to lost+found
disconnected dir inode 4480135186, would move to lost+found
disconnected dir inode 4488884269, would move to lost+found
disconnected dir inode 4488884270, would move to lost+found
disconnected dir inode 4488884271, would move to lost+found
disconnected dir inode 4488884272, would move to lost+found
disconnected dir inode 4488884273, would move to lost+found
disconnected dir inode 4488884274, would move to lost+found
disconnected dir inode 4488884275, would move to lost+found
disconnected dir inode 4488884276, would move to lost+found
disconnected dir inode 4488884277, would move to lost+found
disconnected dir inode 4488884278, would move to lost+found
disconnected dir inode 4488884279, would move to lost+found
disconnected dir inode 4488884280, would move to lost+found
disconnected dir inode 4488884281, would move to lost+found
disconnected dir inode 4488884282, would move to lost+found
disconnected dir inode 8589938726, would move to lost+found
disconnected dir inode 8589938734, would move to lost+found
disconnected dir inode 8644796441, would move to lost+found
disconnected dir inode 8843169879, would move to lost+found
disconnected dir inode 8843169890, would move to lost+found
disconnected dir inode 8859947014, would move to lost+found
disconnected dir inode 8879145003, would move to lost+found
disconnected dir inode 8891183112, would move to lost+found
disconnected dir inode 8891183113, would move to lost+found
disconnected dir inode 8891183114, would move to lost+found
disconnected dir inode 8891183115, would move to lost+found
disconnected dir inode 8891183116, would move to lost+found
disconnected dir inode 8891183117, would move to lost+found
disconnected dir inode 8891183118, would move to lost+found
disconnected dir inode 8891183119, would move to lost+found
disconnected dir inode 8891183120, would move to lost+found
disconnected dir inode 8891183121, would move to lost+found
disconnected dir inode 8891183122, would move to lost+found
disconnected dir inode 8891183123, would move to lost+found
disconnected dir inode 8891183124, would move to lost+found
disconnected dir inode 8891183125, would move to lost+found
disconnected dir inode 8891183133, would move to lost+found
disconnected dir inode 8891183157, would move to lost+found
disconnected dir inode 8891379716, would move to lost+found
disconnected dir inode 12884906014, would move to lost+found
disconnected dir inode 13011120171, would move to lost+found
disconnected dir inode 13027205212, would move to lost+found
disconnected dir inode 13027205214, would move to lost+found
disconnected dir inode 13027205230, would move to lost+found
disconnected dir inode 13027217453, would move to lost+found
disconnected dir inode 13027512330, would move to lost+found
disconnected dir inode 13074718840, would move to lost+found
disconnected dir inode 13074718841, would move to lost+found
disconnected dir inode 13074718842, would move to lost+found
disconnected dir inode 13074718843, would move to lost+found
disconnected dir inode 13074718844, would move to lost+found
disconnected dir inode 13074718845, would move to lost+found
disconnected dir inode 13074718846, would move to lost+found
disconnected dir inode 13074718847, would move to lost+found
disconnected dir inode 13091356672, would move to lost+found
disconnected dir inode 13091356673, would move to lost+found
disconnected dir inode 13091356674, would move to lost+found
disconnected dir inode 13091356675, would move to lost+found
disconnected dir inode 13091356676, would move to lost+found
disconnected dir inode 13091356677, would move to lost+found
disconnected dir inode 13091356703, would move to lost+found
disconnected dir inode 13091356706, would move to lost+found
disconnected dir inode 13091356729, would move to lost+found
disconnected dir inode 17241608248, would move to lost+found
disconnected dir inode 17336291336, would move to lost+found
disconnected dir inode 17420197970, would move to lost+found
disconnected dir inode 17420197971, would move to lost+found
disconnected dir inode 17420197976, would move to lost+found
disconnected dir inode 17420202008, would move to lost+found
disconnected dir inode 17420202022, would move to lost+found
disconnected dir inode 17420435478, would move to lost+found
disconnected dir inode 17420435484, would move to lost+found
disconnected dir inode 17436659734, would move to lost+found
disconnected dir inode 17436659735, would move to lost+found
disconnected dir inode 17436659736, would move to lost+found
disconnected dir inode 17436659737, would move to lost+found
disconnected dir inode 17436659738, would move to lost+found
disconnected dir inode 17436659739, would move to lost+found
disconnected dir inode 17436659740, would move to lost+found
disconnected dir inode 17436659741, would move to lost+found
disconnected dir inode 17436659742, would move to lost+found
disconnected dir inode 17436659743, would move to lost+found
disconnected dir inode 17436659744, would move to lost+found
disconnected dir inode 17436659745, would move to lost+found
disconnected dir inode 17436659746, would move to lost+found
disconnected dir inode 17436659747, would move to lost+found
disconnected dir inode 17436729349, would move to lost+found
disconnected dir inode 17436729352, would move to lost+found
disconnected dir inode 17436729353, would move to lost+found
disconnected dir inode 17436729376, would move to lost+found
disconnected dir inode 17436729377, would move to lost+found
disconnected dir inode 25769807875, would move to lost+found
disconnected dir inode 25925189647, would move to lost+found
disconnected dir inode 26008141866, would move to lost+found
disconnected dir inode 26057682952, would move to lost+found
disconnected dir inode 26154033305, would move to lost+found
disconnected dir inode 26260242760, would move to lost+found
disconnected dir inode 26260242763, would move to lost+found
disconnected dir inode 26260242848, would move to lost+found
disconnected dir inode 26260242858, would move to lost+found
disconnected dir inode 26260242873, would move to lost+found
disconnected dir inode 26260267046, would move to lost+found
disconnected dir inode 26260271146, would move to lost+found
disconnected dir inode 26260271148, would move to lost+found
disconnected dir inode 26260271155, would move to lost+found
disconnected dir inode 27415207947, would move to lost+found
disconnected dir inode 27415207948, would move to lost+found
disconnected dir inode 27415207949, would move to lost+found
disconnected dir inode 27415207950, would move to lost+found
disconnected dir inode 27415207951, would move to lost+found
disconnected dir inode 27415207952, would move to lost+found
disconnected dir inode 27415207953, would move to lost+found
disconnected dir inode 27415207954, would move to lost+found
disconnected dir inode 27415207955, would move to lost+found
disconnected dir inode 27415207956, would move to lost+found
disconnected dir inode 27415207957, would move to lost+found
disconnected dir inode 27415207958, would move to lost+found
disconnected dir inode 27415207959, would move to lost+found
disconnected dir inode 27415207960, would move to lost+found
disconnected dir inode 27415265342, would move to lost+found
disconnected dir inode 27739979786, would move to lost+found
disconnected dir inode 27739979799, would move to lost+found
disconnected dir inode 27739979812, would move to lost+found
disconnected dir inode 30064775184, would move to lost+found
disconnected dir inode 30094696481, would move to lost+found
disconnected dir inode 30095568937, would move to lost+found
disconnected dir inode 30191648788, would move to lost+found
disconnected dir inode 30191923240, would move to lost+found
disconnected dir inode 30191923248, would move to lost+found
disconnected dir inode 30191923253, would move to lost+found
disconnected dir inode 30191923258, would move to lost+found
disconnected dir inode 30191923269, would move to lost+found
disconnected dir inode 30191923272, would move to lost+found
disconnected dir inode 30191923327, would move to lost+found
disconnected dir inode 30191947794, would move to lost+found
disconnected dir inode 30191988752, would move to lost+found
disconnected dir inode 30191988761, would move to lost+found
disconnected dir inode 30192533551, would move to lost+found
disconnected dir inode 30192533552, would move to lost+found
disconnected dir inode 30192533553, would move to lost+found
disconnected dir inode 30192533554, would move to lost+found
disconnected dir inode 30192533555, would move to lost+found
disconnected dir inode 30192533556, would move to lost+found
disconnected dir inode 30192533557, would move to lost+found
disconnected dir inode 30192533558, would move to lost+found
disconnected dir inode 30192533559, would move to lost+found
disconnected dir inode 30192533560, would move to lost+found
disconnected dir inode 30192533561, would move to lost+found
disconnected dir inode 30192533562, would move to lost+found
disconnected dir inode 30192533563, would move to lost+found
disconnected dir inode 30192533564, would move to lost+found
disconnected dir inode 30192533566, would move to lost+found
disconnected dir inode 34465358126, would move to lost+found
disconnected dir inode 34493800450, would move to lost+found
disconnected dir inode 34493800455, would move to lost+found
disconnected dir inode 34493800459, would move to lost+found
disconnected dir inode 34493800462, would move to lost+found
disconnected dir inode 34495025181, would move to lost+found
disconnected dir inode 34495025194, would move to lost+found
disconnected dir inode 34562310184, would move to lost+found
disconnected dir inode 34782539819, would move to lost+found
disconnected dir inode 34782539820, would move to lost+found
disconnected dir inode 34782539821, would move to lost+found
disconnected dir inode 34782539822, would move to lost+found
disconnected dir inode 34782539823, would move to lost+found
disconnected dir inode 34782539824, would move to lost+found
disconnected dir inode 34782539825, would move to lost+found
disconnected dir inode 34782539826, would move to lost+found
disconnected dir inode 34782539827, would move to lost+found
disconnected dir inode 34782539828, would move to lost+found
disconnected dir inode 34782539829, would move to lost+found
disconnected dir inode 34782539830, would move to lost+found
disconnected dir inode 34782539831, would move to lost+found
disconnected dir inode 34782539832, would move to lost+found
disconnected dir inode 34847252487, would move to lost+found
disconnected dir inode 34847252525, would move to lost+found
disconnected dir inode 38704078853, would move to lost+found
disconnected dir inode 38719377423, would move to lost+found
disconnected dir inode 38719377433, would move to lost+found
disconnected dir inode 38719377442, would move to lost+found
disconnected dir inode 38719377445, would move to lost+found
disconnected dir inode 38719377466, would move to lost+found
disconnected dir inode 38719963141, would move to lost+found
disconnected dir inode 38720200755, would move to lost+found
disconnected dir inode 38720765961, would move to lost+found
disconnected dir inode 38720765979, would move to lost+found
disconnected dir inode 38720765980, would move to lost+found
disconnected dir inode 38720765981, would move to lost+found
disconnected dir inode 38720765982, would move to lost+found
disconnected dir inode 38720765983, would move to lost+found
disconnected dir inode 38720765984, would move to lost+found
disconnected dir inode 38720765985, would move to lost+found
disconnected dir inode 38720765986, would move to lost+found
disconnected dir inode 38720765987, would move to lost+found
disconnected dir inode 38720765988, would move to lost+found
disconnected dir inode 38720765989, would move to lost+found
disconnected dir inode 38720765990, would move to lost+found
disconnected dir inode 38720765991, would move to lost+found
disconnected dir inode 38720765992, would move to lost+found
disconnected dir inode 38720962566, would move to lost+found
disconnected dir inode 38720962589, would move to lost+found
disconnected dir inode 38825242678, would move to lost+found
disconnected inode 38829563915, would move to lost+found
disconnected inode 38829563916, would move to lost+found
disconnected inode 38829563917, would move to lost+found
disconnected inode 38829563918, would move to lost+found
disconnected inode 38829563919, would move to lost+found
disconnected inode 38829563920, would move to lost+found
disconnected dir inode 38829563921, would move to lost+found
disconnected dir inode 47244644354, would move to lost+found
disconnected dir inode 47272431634, would move to lost+found
disconnected dir inode 47272431653, would move to lost+found
disconnected dir inode 47280685073, would move to lost+found
disconnected dir inode 47280693249, would move to lost+found
disconnected dir inode 47280693257, would move to lost+found
disconnected dir inode 47280693278, would move to lost+found
disconnected dir inode 47280693287, would move to lost+found
disconnected dir inode 47280693289, would move to lost+found
disconnected dir inode 47280693290, would move to lost+found
disconnected dir inode 47280693309, would move to lost+found
disconnected dir inode 47280783368, would move to lost+found
disconnected dir inode 47280783379, would move to lost+found
disconnected dir inode 47280783382, would move to lost+found
disconnected dir inode 47280783439, would move to lost+found
disconnected dir inode 47280783442, would move to lost+found
disconnected dir inode 47280783443, would move to lost+found
disconnected dir inode 47280783478, would move to lost+found
disconnected dir inode 47285768194, would move to lost+found
disconnected dir inode 47332347956, would move to lost+found
disconnected dir inode 47332347957, would move to lost+found
disconnected dir inode 47332347958, would move to lost+found
disconnected dir inode 47332347959, would move to lost+found
disconnected dir inode 47332347960, would move to lost+found
disconnected dir inode 47332347961, would move to lost+found
disconnected dir inode 47332347962, would move to lost+found
disconnected dir inode 47332347963, would move to lost+found
disconnected dir inode 47332347964, would move to lost+found
disconnected dir inode 47332347965, would move to lost+found
disconnected dir inode 47332347966, would move to lost+found
disconnected dir inode 47332347967, would move to lost+found
disconnected dir inode 47335895040, would move to lost+found
disconnected dir inode 47335895041, would move to lost+found
disconnected dir inode 47335895044, would move to lost+found
disconnected dir inode 47335895063, would move to lost+found
disconnected dir inode 47335895076, would move to lost+found
disconnected dir inode 47335895107, would move to lost+found
disconnected dir inode 47336734723, would move to lost+found
disconnected dir inode 47336734725, would move to lost+found
disconnected dir inode 47336734726, would move to lost+found
disconnected dir inode 47336734776, would move to lost+found
disconnected dir inode 51699605524, would move to lost+found
disconnected dir inode 51699605532, would move to lost+found
disconnected dir inode 51699613850, would move to lost+found
disconnected dir inode 51699613862, would move to lost+found
disconnected dir inode 51699613865, would move to lost+found
disconnected dir inode 51699613866, would move to lost+found
disconnected dir inode 51699613872, would move to lost+found
disconnected dir inode 51699613875, would move to lost+found
disconnected dir inode 51699613876, would move to lost+found
disconnected dir inode 51699839001, would move to lost+found
disconnected dir inode 51699839007, would move to lost+found
disconnected dir inode 51699839013, would move to lost+found
disconnected dir inode 51699839026, would move to lost+found
disconnected dir inode 51699957775, would move to lost+found
disconnected dir inode 51699957784, would move to lost+found
disconnected dir inode 51700580368, would move to lost+found
disconnected dir inode 51700580369, would move to lost+found
disconnected dir inode 51700580370, would move to lost+found
disconnected dir inode 51700580371, would move to lost+found
disconnected dir inode 51700580372, would move to lost+found
disconnected dir inode 51700580373, would move to lost+found
disconnected dir inode 51700580374, would move to lost+found
disconnected dir inode 51700580375, would move to lost+found
disconnected dir inode 51700580376, would move to lost+found
disconnected dir inode 51700580377, would move to lost+found
disconnected dir inode 51700580378, would move to lost+found
disconnected dir inode 51700580379, would move to lost+found
disconnected dir inode 51700580380, would move to lost+found
disconnected dir inode 51700580381, would move to lost+found
disconnected dir inode 51700580383, would move to lost+found
disconnected dir inode 51700580384, would move to lost+found
disconnected dir inode 51700850697, would move to lost+found
disconnected dir inode 51700850698, would move to lost+found
disconnected dir inode 51700850716, would move to lost+found
disconnected dir inode 51700850723, would move to lost+found
disconnected dir inode 51736309767, would move to lost+found
disconnected dir inode 55834578947, would move to lost+found
disconnected dir inode 55872958466, would move to lost+found
disconnected dir inode 55951396898, would move to lost+found
disconnected dir inode 55951405124, would move to lost+found
disconnected dir inode 55951405125, would move to lost+found
disconnected dir inode 55951405167, would move to lost+found
disconnected dir inode 55952322562, would move to lost+found
disconnected dir inode 55952388098, would move to lost+found
disconnected dir inode 55952388121, would move to lost+found
disconnected dir inode 55952388130, would move to lost+found
disconnected dir inode 55952388133, would move to lost+found
disconnected dir inode 55952388134, would move to lost+found
disconnected dir inode 55952388143, would move to lost+found
disconnected dir inode 55986180159, would move to lost+found
disconnected dir inode 55986327552, would move to lost+found
disconnected dir inode 55986327553, would move to lost+found
disconnected dir inode 55986327554, would move to lost+found
disconnected dir inode 55986327555, would move to lost+found
disconnected dir inode 55986327556, would move to lost+found
disconnected dir inode 55986327557, would move to lost+found
disconnected dir inode 55986327558, would move to lost+found
disconnected dir inode 55986327559, would move to lost+found
disconnected dir inode 55986327560, would move to lost+found
disconnected dir inode 55986327561, would move to lost+found
disconnected dir inode 55986327562, would move to lost+found
disconnected dir inode 55986327563, would move to lost+found
disconnected dir inode 55986327564, would move to lost+found
disconnected dir inode 55986327577, would move to lost+found
disconnected dir inode 55986327578, would move to lost+found
disconnected dir inode 55986327595, would move to lost+found
disconnected dir inode 55986327607, would move to lost+found
disconnected dir inode 55986327615, would move to lost+found
disconnected dir inode 56070602793, would move to lost+found
disconnected dir inode 56070602796, would move to lost+found
disconnected dir inode 60129546242, would move to lost+found
disconnected dir inode 60178853922, would move to lost+found
disconnected dir inode 60208181292, would move to lost+found
disconnected dir inode 60276113421, would move to lost+found
disconnected dir inode 60276125774, would move to lost+found
disconnected dir inode 60276125777, would move to lost+found
disconnected dir inode 60276125787, would move to lost+found
disconnected dir inode 60276125809, would move to lost+found
disconnected dir inode 60276203525, would move to lost+found
disconnected dir inode 60276203636, would move to lost+found
disconnected dir inode 60276891650, would move to lost+found
disconnected dir inode 60276891651, would move to lost+found
disconnected dir inode 60276891652, would move to lost+found
disconnected dir inode 60276891653, would move to lost+found
disconnected dir inode 60276891654, would move to lost+found
disconnected dir inode 60276891655, would move to lost+found
disconnected dir inode 60276891656, would move to lost+found
disconnected dir inode 60276891657, would move to lost+found
disconnected dir inode 60276891658, would move to lost+found
disconnected dir inode 60276891659, would move to lost+found
disconnected dir inode 60276891660, would move to lost+found
disconnected dir inode 60276891661, would move to lost+found
disconnected dir inode 60276891662, would move to lost+found
disconnected dir inode 60276891663, would move to lost+found
disconnected dir inode 60276891674, would move to lost+found
disconnected dir inode 60276891704, would move to lost+found
disconnected dir inode 64424513580, would move to lost+found
disconnected dir inode 64471937069, would move to lost+found
disconnected dir inode 64551399512, would move to lost+found
disconnected dir inode 64551436290, would move to lost+found
disconnected dir inode 64551436296, would move to lost+found
disconnected dir inode 64551436304, would move to lost+found
disconnected dir inode 64551743490, would move to lost+found
disconnected dir inode 64626319607, would move to lost+found
disconnected dir inode 64626319608, would move to lost+found
disconnected dir inode 64626319609, would move to lost+found
disconnected dir inode 64626319610, would move to lost+found
disconnected dir inode 64626319611, would move to lost+found
disconnected dir inode 64626319612, would move to lost+found
disconnected dir inode 64626319613, would move to lost+found
disconnected dir inode 64626319614, would move to lost+found
disconnected dir inode 64626319615, would move to lost+found
disconnected dir inode 64626319616, would move to lost+found
disconnected dir inode 64626319617, would move to lost+found
disconnected dir inode 64626319618, would move to lost+found
disconnected dir inode 64626319619, would move to lost+found
disconnected dir inode 64626319620, would move to lost+found
disconnected dir inode 64796418219, would move to lost+found
disconnected dir inode 68727828484, would move to lost+found
disconnected dir inode 68727828531, would move to lost+found
disconnected dir inode 68748414985, would move to lost+found
disconnected dir inode 68912447582, would move to lost+found
disconnected dir inode 68912447599, would move to lost+found
disconnected dir inode 68912447606, would move to lost+found
disconnected dir inode 68912492562, would move to lost+found
disconnected dir inode 68912492571, would move to lost+found
disconnected dir inode 68912726029, would move to lost+found
disconnected dir inode 68996411445, would move to lost+found
disconnected dir inode 68996411446, would move to lost+found
disconnected dir inode 68996411447, would move to lost+found
disconnected dir inode 68996411448, would move to lost+found
disconnected dir inode 68996411449, would move to lost+found
disconnected dir inode 68996411450, would move to lost+found
disconnected dir inode 68996411451, would move to lost+found
disconnected dir inode 68996411452, would move to lost+found
disconnected dir inode 68996411453, would move to lost+found
disconnected dir inode 68996411454, would move to lost+found
disconnected dir inode 68996411455, would move to lost+found
disconnected dir inode 68996796416, would move to lost+found
disconnected dir inode 68996796417, would move to lost+found
disconnected dir inode 68996796418, would move to lost+found
disconnected dir inode 68996796419, would move to lost+found
disconnected dir inode 68996796429, would move to lost+found
disconnected dir inode 68996796438, would move to lost+found
disconnected dir inode 68996796452, would move to lost+found
disconnected dir inode 68997796125, would move to lost+found
disconnected dir inode 73031290880, would move to lost+found
disconnected dir inode 73101590549, would move to lost+found
disconnected dir inode 73105666411, would move to lost+found
disconnected dir inode 73105666427, would move to lost+found
disconnected dir inode 73105666429, would move to lost+found
disconnected dir inode 73105850463, would move to lost+found
disconnected dir inode 73105850470, would move to lost+found
disconnected dir inode 73271562303, would move to lost+found
disconnected dir inode 73272119296, would move to lost+found
disconnected dir inode 73272119297, would move to lost+found
disconnected dir inode 73272119298, would move to lost+found
disconnected dir inode 73272119299, would move to lost+found
disconnected dir inode 73272119300, would move to lost+found
disconnected dir inode 73272119301, would move to lost+found
disconnected dir inode 73272119302, would move to lost+found
disconnected dir inode 73272119303, would move to lost+found
disconnected dir inode 73272119304, would move to lost+found
disconnected dir inode 73272119305, would move to lost+found
disconnected dir inode 73272119306, would move to lost+found
disconnected dir inode 73272119307, would move to lost+found
disconnected dir inode 73272119308, would move to lost+found
disconnected dir inode 73272119309, would move to lost+found
disconnected dir inode 73272119402, would move to lost+found
disconnected dir inode 73272119404, would move to lost+found
disconnected dir inode 73272119413, would move to lost+found
disconnected dir inode 73274540280, would move to lost+found
disconnected dir inode 81653158051, would move to lost+found
disconnected dir inode 81687068704, would move to lost+found
disconnected dir inode 81786920976, would move to lost+found
disconnected dir inode 81786920996, would move to lost+found
disconnected inode 81786929156, would move to lost+found
disconnected dir inode 81786929197, would move to lost+found
disconnected dir inode 81786929201, would move to lost+found
disconnected dir inode 81786929202, would move to lost+found
disconnected dir inode 81786929215, would move to lost+found
disconnected dir inode 81787150336, would move to lost+found
disconnected dir inode 81787150338, would move to lost+found
disconnected dir inode 81787150393, would move to lost+found
disconnected dir inode 81787150396, would move to lost+found
disconnected dir inode 81787162637, would move to lost+found
disconnected dir inode 81787162640, would move to lost+found
disconnected dir inode 82064572440, would move to lost+found
disconnected dir inode 82064572449, would move to lost+found
disconnected dir inode 82064572450, would move to lost+found
disconnected dir inode 82065092715, would move to lost+found
disconnected dir inode 82065092716, would move to lost+found
disconnected dir inode 82065092717, would move to lost+found
disconnected dir inode 82065092718, would move to lost+found
disconnected dir inode 82065092719, would move to lost+found
disconnected dir inode 82065092720, would move to lost+found
disconnected dir inode 82065092721, would move to lost+found
disconnected dir inode 82065092722, would move to lost+found
disconnected dir inode 82065092723, would move to lost+found
disconnected dir inode 82065092724, would move to lost+found
disconnected dir inode 82065092725, would move to lost+found
disconnected dir inode 82065092726, would move to lost+found
disconnected dir inode 82065092727, would move to lost+found
disconnected dir inode 82065092728, would move to lost+found
disconnected dir inode 82065092729, would move to lost+found
disconnected dir inode 82065301528, would move to lost+found
disconnected dir inode 82065301534, would move to lost+found
disconnected dir inode 82065301539, would move to lost+found
disconnected dir inode 82201460748, would move to lost+found
disconnected dir inode 82201460785, would move to lost+found
disconnected dir inode 82201460786, would move to lost+found
disconnected dir inode 82201460792, would move to lost+found
disconnected dir inode 85960990858, would move to lost+found
disconnected dir inode 86092185616, would move to lost+found
disconnected dir inode 86092197968, would move to lost+found
disconnected dir inode 86092197969, would move to lost+found
disconnected dir inode 86092197977, would move to lost+found
disconnected dir inode 86092197987, would move to lost+found
disconnected dir inode 86092197989, would move to lost+found
disconnected dir inode 86092198002, would move to lost+found
disconnected dir inode 86092201989, would move to lost+found
disconnected dir inode 86092201992, would move to lost+found
disconnected dir inode 86092201994, would move to lost+found
disconnected dir inode 86092206098, would move to lost+found
disconnected dir inode 86092361729, would move to lost+found
disconnected dir inode 86092361746, would move to lost+found
disconnected dir inode 86092361747, would move to lost+found
disconnected dir inode 86092734520, would move to lost+found
disconnected dir inode 86092816393, would move to lost+found
disconnected dir inode 86092816394, would move to lost+found
disconnected dir inode 86092816395, would move to lost+found
disconnected dir inode 86092816396, would move to lost+found
disconnected dir inode 86092816397, would move to lost+found
disconnected dir inode 86092816398, would move to lost+found
disconnected dir inode 86092816399, would move to lost+found
disconnected dir inode 86092816400, would move to lost+found
disconnected dir inode 86092816401, would move to lost+found
disconnected dir inode 86092816402, would move to lost+found
disconnected dir inode 86092816403, would move to lost+found
disconnected dir inode 86092816404, would move to lost+found
disconnected dir inode 86092816405, would move to lost+found
disconnected dir inode 86092816406, would move to lost+found
disconnected dir inode 86092816420, would move to lost+found
disconnected dir inode 86093082664, would move to lost+found
disconnected dir inode 86093668380, would move to lost+found
disconnected dir inode 86093668397, would move to lost+found
disconnected dir inode 90271576326, would move to lost+found
disconnected dir inode 90328010761, would move to lost+found
disconnected dir inode 90328019070, would move to lost+found
disconnected dir inode 90328121345, would move to lost+found
disconnected dir inode 90328121346, would move to lost+found
disconnected dir inode 90328121350, would move to lost+found
disconnected dir inode 90328121351, would move to lost+found
disconnected dir inode 90328121353, would move to lost+found
disconnected dir inode 90328121357, would move to lost+found
disconnected dir inode 90328121367, would move to lost+found
disconnected dir inode 90328121368, would move to lost+found
disconnected dir inode 90328121370, would move to lost+found
disconnected dir inode 90328121383, would move to lost+found
disconnected dir inode 90328141853, would move to lost+found
disconnected dir inode 90328141867, would move to lost+found
disconnected dir inode 90328141868, would move to lost+found
disconnected dir inode 90328141870, would move to lost+found
disconnected dir inode 90328141875, would move to lost+found
disconnected dir inode 90516987961, would move to lost+found
disconnected dir inode 90516987962, would move to lost+found
disconnected dir inode 90516987963, would move to lost+found
disconnected dir inode 90516987964, would move to lost+found
disconnected dir inode 90516987965, would move to lost+found
disconnected dir inode 90516987966, would move to lost+found
disconnected dir inode 90516987967, would move to lost+found
disconnected dir inode 90517016576, would move to lost+found
disconnected dir inode 90517016577, would move to lost+found
disconnected dir inode 90517016578, would move to lost+found
disconnected dir inode 90517016579, would move to lost+found
disconnected dir inode 90517016580, would move to lost+found
disconnected dir inode 90517016581, would move to lost+found
disconnected dir inode 90517016582, would move to lost+found
disconnected dir inode 90517016584, would move to lost+found
disconnected dir inode 90517016598, would move to lost+found
disconnected dir inode 90549440603, would move to lost+found
disconnected dir inode 90549440605, would move to lost+found
disconnected dir inode 90549440638, would move to lost+found
disconnected dir inode 94489284657, would move to lost+found
disconnected dir inode 94536843282, would move to lost+found
disconnected dir inode 94587891756, would move to lost+found
disconnected dir inode 94587891758, would move to lost+found
disconnected dir inode 94587891759, would move to lost+found
disconnected dir inode 94587891762, would move to lost+found
disconnected dir inode 94587891766, would move to lost+found
disconnected dir inode 94587895809, would move to lost+found
disconnected dir inode 94587895822, would move to lost+found
disconnected dir inode 94587895823, would move to lost+found
disconnected dir inode 94587895825, would move to lost+found
disconnected dir inode 94587895836, would move to lost+found
disconnected dir inode 94659702818, would move to lost+found
disconnected dir inode 94659702834, would move to lost+found
disconnected dir inode 94994862126, would move to lost+found
disconnected dir inode 95118995625, would move to lost+found
disconnected dir inode 95118995626, would move to lost+found
disconnected dir inode 95118995627, would move to lost+found
disconnected dir inode 95118995628, would move to lost+found
disconnected dir inode 95118995629, would move to lost+found
disconnected dir inode 95118995630, would move to lost+found
disconnected dir inode 95118995631, would move to lost+found
disconnected dir inode 95118995632, would move to lost+found
disconnected dir inode 95118995633, would move to lost+found
disconnected dir inode 95118995634, would move to lost+found
disconnected dir inode 95118995635, would move to lost+found
disconnected dir inode 95118995636, would move to lost+found
disconnected dir inode 95118995637, would move to lost+found
disconnected dir inode 95118995638, would move to lost+found
disconnected dir inode 95118995639, would move to lost+found
disconnected dir inode 95118995655, would move to lost+found
disconnected dir inode 95118995691, would move to lost+found
disconnected dir inode 95157329922, would move to lost+found
disconnected dir inode 95157329964, would move to lost+found
disconnected dir inode 103079219243, would move to lost+found
disconnected dir inode 103124635648, would move to lost+found
disconnected dir inode 103130472572, would move to lost+found
disconnected dir inode 103130472575, would move to lost+found
disconnected dir inode 103164653888, would move to lost+found
disconnected dir inode 103164653950, would move to lost+found
disconnected dir inode 103166758944, would move to lost+found
disconnected dir inode 103166758974, would move to lost+found
disconnected dir inode 103166816326, would move to lost+found
disconnected dir inode 103166816329, would move to lost+found
disconnected dir inode 103166816332, would move to lost+found
disconnected dir inode 103166816342, would move to lost+found
disconnected dir inode 103166820421, would move to lost+found
disconnected dir inode 103166820441, would move to lost+found
disconnected dir inode 103166820442, would move to lost+found
disconnected dir inode 103166820454, would move to lost+found
disconnected dir inode 103166828595, would move to lost+found
disconnected dir inode 103166828598, would move to lost+found
disconnected dir inode 103166832678, would move to lost+found
disconnected dir inode 103166832691, would move to lost+found
disconnected dir inode 103167139896, would move to lost+found
disconnected dir inode 103167189115, would move to lost+found
disconnected dir inode 103167189116, would move to lost+found
disconnected dir inode 103167189117, would move to lost+found
disconnected dir inode 103167189118, would move to lost+found
disconnected dir inode 103167189119, would move to lost+found
disconnected dir inode 103167189120, would move to lost+found
disconnected dir inode 103167189121, would move to lost+found
disconnected dir inode 103167189122, would move to lost+found
disconnected dir inode 103167189123, would move to lost+found
disconnected dir inode 103167189124, would move to lost+found
disconnected dir inode 103167189125, would move to lost+found
disconnected dir inode 103167189126, would move to lost+found
disconnected dir inode 103167189127, would move to lost+found
disconnected dir inode 103167189128, would move to lost+found
disconnected dir inode 103167189129, would move to lost+found
disconnected dir inode 103167189133, would move to lost+found
disconnected dir inode 103167189169, would move to lost+found
disconnected dir inode 103167508533, would move to lost+found
disconnected dir inode 107374186526, would move to lost+found
disconnected dir inode 107374198847, would move to lost+found
disconnected dir inode 107599970322, would move to lost+found
disconnected dir inode 107599970329, would move to lost+found
disconnected dir inode 107599970339, would move to lost+found
disconnected dir inode 107600003167, would move to lost+found
disconnected dir inode 107600003168, would move to lost+found
disconnected dir inode 107600060433, would move to lost+found
disconnected dir inode 107600060444, would move to lost+found
disconnected dir inode 107600539651, would move to lost+found
disconnected dir inode 107600539659, would move to lost+found
disconnected dir inode 107600724055, would move to lost+found
disconnected dir inode 107600724059, would move to lost+found
disconnected dir inode 107600814332, would move to lost+found
disconnected dir inode 107600814333, would move to lost+found
disconnected dir inode 107600814334, would move to lost+found
disconnected dir inode 107600814335, would move to lost+found
disconnected dir inode 107600814336, would move to lost+found
disconnected dir inode 107600814337, would move to lost+found
disconnected dir inode 107600814338, would move to lost+found
disconnected dir inode 107600814339, would move to lost+found
disconnected dir inode 107600814340, would move to lost+found
disconnected dir inode 107600814341, would move to lost+found
disconnected dir inode 107600814342, would move to lost+found
disconnected dir inode 107600814343, would move to lost+found
disconnected dir inode 107600814344, would move to lost+found
disconnected dir inode 107600814345, would move to lost+found
disconnected dir inode 107600814352, would move to lost+found
disconnected dir inode 107600814365, would move to lost+found
disconnected dir inode 107600814387, would move to lost+found
disconnected dir inode 107666485324, would move to lost+found
disconnected dir inode 107666485334, would move to lost+found
disconnected dir inode 107666485369, would move to lost+found
disconnected dir inode 111673475085, would move to lost+found
disconnected dir inode 111673475125, would move to lost+found
disconnected dir inode 111673516075, would move to lost+found
disconnected dir inode 111673516077, would move to lost+found
disconnected dir inode 111673516081, would move to lost+found
disconnected dir inode 111673516082, would move to lost+found
disconnected dir inode 111673516095, would move to lost+found
disconnected dir inode 111686406267, would move to lost+found
disconnected dir inode 111686406268, would move to lost+found
disconnected dir inode 111886352447, would move to lost+found
disconnected dir inode 111886520345, would move to lost+found
disconnected dir inode 111886688298, would move to lost+found
disconnected dir inode 111886688312, would move to lost+found
disconnected dir inode 111887126568, would move to lost+found
disconnected dir inode 111887126591, would move to lost+found
disconnected dir inode 111887241216, would move to lost+found
disconnected dir inode 111887241217, would move to lost+found
disconnected dir inode 111887241218, would move to lost+found
disconnected dir inode 111887241219, would move to lost+found
disconnected dir inode 111887241220, would move to lost+found
disconnected dir inode 111887241221, would move to lost+found
disconnected dir inode 111887241222, would move to lost+found
disconnected dir inode 111887241223, would move to lost+found
disconnected dir inode 111887241224, would move to lost+found
disconnected dir inode 111887241225, would move to lost+found
disconnected dir inode 111887241226, would move to lost+found
disconnected dir inode 111887241227, would move to lost+found
disconnected dir inode 111887241228, would move to lost+found
disconnected dir inode 111895687207, would move to lost+found
disconnected dir inode 111895687209, would move to lost+found
disconnected dir inode 111895687216, would move to lost+found
disconnected dir inode 111910309907, would move to lost+found
disconnected dir inode 111918694446, would move to lost+found
disconnected dir inode 111939428362, would move to lost+found
disconnected dir inode 115964121090, would move to lost+found
disconnected dir inode 115964121113, would move to lost+found
disconnected dir inode 116006125580, would move to lost+found
disconnected dir inode 116006129669, would move to lost+found
disconnected dir inode 116006129696, would move to lost+found
disconnected dir inode 116192383165, would move to lost+found
disconnected dir inode 116192383167, would move to lost+found
disconnected dir inode 116192387077, would move to lost+found
disconnected dir inode 116192387078, would move to lost+found
disconnected dir inode 116192387080, would move to lost+found
disconnected dir inode 116192387114, would move to lost+found
disconnected dir inode 116192387115, would move to lost+found
disconnected dir inode 116192391195, would move to lost+found
disconnected dir inode 116192399368, would move to lost+found
disconnected dir inode 116192399372, would move to lost+found
disconnected dir inode 116192456725, would move to lost+found
disconnected dir inode 116343926922, would move to lost+found
disconnected dir inode 116343926943, would move to lost+found
disconnected dir inode 116343926944, would move to lost+found
disconnected dir inode 116343926945, would move to lost+found
disconnected dir inode 116343926946, would move to lost+found
disconnected dir inode 116343926947, would move to lost+found
disconnected dir inode 116343926948, would move to lost+found
disconnected dir inode 116343926949, would move to lost+found
disconnected dir inode 116343926950, would move to lost+found
disconnected dir inode 116343926951, would move to lost+found
disconnected dir inode 116343926952, would move to lost+found
disconnected dir inode 116343926953, would move to lost+found
disconnected dir inode 116343926954, would move to lost+found
disconnected dir inode 116343926955, would move to lost+found
disconnected dir inode 116343926956, would move to lost+found
disconnected dir inode 116343980276, would move to lost+found
disconnected dir inode 116343980280, would move to lost+found
disconnected dir inode 116352086020, would move to lost+found
disconnected dir inode 116352086039, would move to lost+found
disconnected dir inode 116352086049, would move to lost+found
disconnected dir inode 116398080018, would move to lost+found
disconnected dir inode 116398661641, would move to lost+found
disconnected dir inode 116398661643, would move to lost+found
disconnected dir inode 120259088386, would move to lost+found
disconnected dir inode 120329281560, would move to lost+found
disconnected dir inode 120329281563, would move to lost+found
disconnected dir inode 120448295002, would move to lost+found
disconnected dir inode 120448295010, would move to lost+found
disconnected dir inode 120471560237, would move to lost+found
disconnected dir inode 120471560274, would move to lost+found
disconnected dir inode 120471564434, would move to lost+found
disconnected dir inode 120471572527, would move to lost+found
disconnected dir inode 120472088603, would move to lost+found
disconnected dir inode 120472117285, would move to lost+found
disconnected dir inode 120472117286, would move to lost+found
disconnected dir inode 120472117287, would move to lost+found
disconnected dir inode 120472117288, would move to lost+found
disconnected dir inode 120472117289, would move to lost+found
disconnected dir inode 120472117290, would move to lost+found
disconnected dir inode 120472117291, would move to lost+found
disconnected dir inode 120472117292, would move to lost+found
disconnected dir inode 120472117293, would move to lost+found
disconnected dir inode 120472117294, would move to lost+found
disconnected dir inode 120472117295, would move to lost+found
disconnected dir inode 120472117296, would move to lost+found
disconnected dir inode 120472117297, would move to lost+found
disconnected dir inode 120472117298, would move to lost+found
disconnected dir inode 120472662030, would move to lost+found
disconnected dir inode 120472662031, would move to lost+found
disconnected dir inode 120472662039, would move to lost+found
disconnected dir inode 120472662053, would move to lost+found
disconnected dir inode 120533618695, would move to lost+found
disconnected dir inode 120533618699, would move to lost+found
disconnected dir inode 120533618715, would move to lost+found
disconnected dir inode 120533618729, would move to lost+found
disconnected dir inode 120533618731, would move to lost+found
disconnected dir inode 120534142997, would move to lost+found
disconnected dir inode 124571324437, would move to lost+found
disconnected dir inode 124656844832, would move to lost+found
disconnected dir inode 124656844837, would move to lost+found
disconnected dir inode 124656869394, would move to lost+found
disconnected dir inode 124689535050, would move to lost+found
disconnected dir inode 124689535051, would move to lost+found
disconnected dir inode 124689539170, would move to lost+found
disconnected inode 124753653783, would move to lost+found
disconnected dir inode 124753793139, would move to lost+found
disconnected dir inode 124753793140, would move to lost+found
disconnected dir inode 124753793141, would move to lost+found
disconnected dir inode 124753793142, would move to lost+found
disconnected dir inode 124753793143, would move to lost+found
disconnected dir inode 124753793144, would move to lost+found
disconnected dir inode 124753793145, would move to lost+found
disconnected dir inode 124753793146, would move to lost+found
disconnected dir inode 124753793147, would move to lost+found
disconnected dir inode 124753793148, would move to lost+found
disconnected dir inode 124753793149, would move to lost+found
disconnected dir inode 124753793150, would move to lost+found
disconnected dir inode 124753793151, would move to lost+found
disconnected dir inode 124753965056, would move to lost+found
disconnected dir inode 124762431510, would move to lost+found
disconnected dir inode 124762443832, would move to lost+found
disconnected dir inode 124762443834, would move to lost+found
disconnected dir inode 128857702412, would move to lost+found
disconnected dir inode 128987127852, would move to lost+found
disconnected dir inode 128987131958, would move to lost+found
disconnected dir inode 128987131963, would move to lost+found
disconnected dir inode 128987152396, would move to lost+found
disconnected dir inode 128991920148, would move to lost+found
disconnected dir inode 129035956270, would move to lost+found
disconnected dir inode 129135882351, would move to lost+found
disconnected dir inode 129135882352, would move to lost+found
disconnected dir inode 129135882353, would move to lost+found
disconnected dir inode 129135882354, would move to lost+found
disconnected dir inode 129135882355, would move to lost+found
disconnected dir inode 129135882356, would move to lost+found
disconnected dir inode 129135882357, would move to lost+found
disconnected dir inode 129135882358, would move to lost+found
disconnected dir inode 129135882359, would move to lost+found
disconnected dir inode 129135882360, would move to lost+found
disconnected dir inode 129135882361, would move to lost+found
disconnected dir inode 129135882362, would move to lost+found
disconnected dir inode 129135882363, would move to lost+found
disconnected dir inode 129135882364, would move to lost+found
disconnected dir inode 129135882365, would move to lost+found
disconnected dir inode 129199108156, would move to lost+found
disconnected dir inode 133143990307, would move to lost+found
disconnected dir inode 133252542636, would move to lost+found
disconnected dir inode 133252546605, would move to lost+found
disconnected dir inode 133252555235, would move to lost+found
disconnected dir inode 133252555251, would move to lost+found
disconnected dir inode 133305405443, would move to lost+found
disconnected dir inode 133305425942, would move to lost+found
disconnected dir inode 133306257431, would move to lost+found
disconnected dir inode 133306257432, would move to lost+found
disconnected dir inode 133306257433, would move to lost+found
disconnected dir inode 133306257434, would move to lost+found
disconnected dir inode 133306257435, would move to lost+found
disconnected dir inode 133306257436, would move to lost+found
disconnected dir inode 133306257437, would move to lost+found
disconnected dir inode 133306257438, would move to lost+found
disconnected dir inode 133306257439, would move to lost+found
disconnected dir inode 133306257440, would move to lost+found
disconnected dir inode 133306257441, would move to lost+found
disconnected dir inode 133306257442, would move to lost+found
disconnected dir inode 133306257443, would move to lost+found
disconnected dir inode 133306257444, would move to lost+found
disconnected dir inode 133306376194, would move to lost+found
disconnected dir inode 133306376211, would move to lost+found
disconnected dir inode 133306376217, would move to lost+found
Phase 7 - verify link counts...
would have reset inode 4096 nlinks from 13 to 11
would have reset inode 4099 nlinks from 61 to 53
would have reset inode 68972563 nlinks from 9 to 8
would have reset inode 202739721 nlinks from 7 to 6
would have reset inode 202739732 nlinks from 7 to 6
would have reset inode 417902664 nlinks from 10 to 9
would have reset inode 418459710 nlinks from 6 to 5
would have reset inode 419037188 nlinks from 3 to 2
would have reset inode 419037189 nlinks from 3 to 2
would have reset inode 4355010569 nlinks from 8 to 7
would have reset inode 4355010593 nlinks from 3 to 2
would have reset inode 4479877124 nlinks from 10 to 9
would have reset inode 4479877167 nlinks from 3 to 2
would have reset inode 4479877246 nlinks from 23 to 20
would have reset inode 4488884232 nlinks from 10 to 9
would have reset inode 4488884248 nlinks from 12 to 11
would have reset inode 4488884269 nlinks from 3 to 2
would have reset inode 4488884270 nlinks from 3 to 2
would have reset inode 4488884272 nlinks from 3 to 2
would have reset inode 4488884274 nlinks from 3 to 2
would have reset inode 4579237926 nlinks from 3 to 2
would have reset inode 8589938690 nlinks from 3 to 2
would have reset inode 8843165728 nlinks from 4 to 3
would have reset inode 8843165744 nlinks from 14 to 13
would have reset inode 8843169875 nlinks from 12 to 11
would have reset inode 8843169882 nlinks from 4 to 3
would have reset inode 8843169883 nlinks from 23 to 21
would have reset inode 8843169890 nlinks from 17 to 15
would have reset inode 8859947015 nlinks from 5 to 4
would have reset inode 8859947019 nlinks from 5 to 4
would have reset inode 8859947020 nlinks from 5 to 4
would have reset inode 8879145001 nlinks from 9 to 8
would have reset inode 8889970711 nlinks from 10 to 9
would have reset inode 8891183118 nlinks from 3 to 2
would have reset inode 8891183121 nlinks from 4 to 3
would have reset inode 8891183123 nlinks from 4 to 3
would have reset inode 8891183124 nlinks from 5 to 4
would have reset inode 8891183134 nlinks from 3 to 2
would have reset inode 8891777032 nlinks from 8 to 7
would have reset inode 12884905984 nlinks from 15 to 13
would have reset inode 13011382273 nlinks from 4 to 3
would have reset inode 13011382322 nlinks from 5 to 4
would have reset inode 13027205190 nlinks from 4 to 3
would have reset inode 13027205211 nlinks from 3 to 2
would have reset inode 13027205218 nlinks from 6 to 5
would have reset inode 13027512336 nlinks from 12 to 10
would have reset inode 13027512342 nlinks from 3 to 2
would have reset inode 13027512343 nlinks from 4 to 3
would have reset inode 13074718790 nlinks from 10 to 9
would have reset inode 13074718840 nlinks from 7 to 6
would have reset inode 13091356672 nlinks from 4 to 3
would have reset inode 13091356696 nlinks from 10 to 9
would have reset inode 17179873282 nlinks from 3 to 2
would have reset inode 17179873284 nlinks from 3 to 2
would have reset inode 17241608247 nlinks from 3 to 2
would have reset inode 17319272475 nlinks from 12 to 10
would have reset inode 17336291384 nlinks from 4 to 3
would have reset inode 17420197955 nlinks from 3 to 2
would have reset inode 17420197956 nlinks from 4 to 3
would have reset inode 17420197971 nlinks from 5 to 4
would have reset inode 17420197976 nlinks from 6 to 5
would have reset inode 17420197977 nlinks from 6 to 5
would have reset inode 17420197987 nlinks from 5 to 4
would have reset inode 17420201999 nlinks from 3 to 2
would have reset inode 17420202008 nlinks from 18 to 16
would have reset inode 17420214285 nlinks from 9 to 7
would have reset inode 17436610595 nlinks from 10 to 9
would have reset inode 17436659751 nlinks from 6 to 5
would have reset inode 17436659752 nlinks from 4 to 3
would have reset inode 17437196300 nlinks from 5 to 4
would have reset inode 17437196324 nlinks from 4 to 3
would have reset inode 17437196325 nlinks from 3 to 2
would have reset inode 25769807872 nlinks from 107 to 93
would have reset inode 25769807876 nlinks from 8 to 7
would have reset inode 25925189648 nlinks from 5 to 4
would have reset inode 26008100926 nlinks from 5 to 4
would have reset inode 26154033339 nlinks from 6 to 5
would have reset inode 26260242761 nlinks from 6 to 5
would have reset inode 26260242762 nlinks from 6 to 5
would have reset inode 26260242856 nlinks from 4 to 3
would have reset inode 26260242858 nlinks from 18 to 16
would have reset inode 26260267045 nlinks from 4 to 3
would have reset inode 26260271146 nlinks from 11 to 10
would have reset inode 27415207952 nlinks from 3 to 2
would have reset inode 30064775168 nlinks from 31 to 28
would have reset inode 30064775172 nlinks from 6 to 5
would have reset inode 30191923231 nlinks from 15 to 14
would have reset inode 30191923251 nlinks from 4 to 3
would have reset inode 30191923257 nlinks from 5 to 4
would have reset inode 30191923268 nlinks from 5 to 4
would have reset inode 30191923325 nlinks from 9 to 7
would have reset inode 30191947794 nlinks from 3 to 2
would have reset inode 30191951881 nlinks from 7 to 6
would have reset inode 30191988767 nlinks from 6 to 5
would have reset inode 30192533551 nlinks from 3 to 2
would have reset inode 30192533554 nlinks from 11 to 9
would have reset inode 30192533555 nlinks from 5 to 4
would have reset inode 30192533559 nlinks from 8 to 7
would have reset inode 30192885820 nlinks from 5 to 4
would have reset inode 34359742464 nlinks from 8 to 7
would have reset inode 34359742465 nlinks from 3 to 2
would have reset inode 34422018084 nlinks from 3 to 2
would have reset inode 34465357826 nlinks from 5 to 4
would have reset inode 34465358139 nlinks from 10 to 9
would have reset inode 34465358141 nlinks from 4 to 3
would have reset inode 34493800449 nlinks from 3 to 2
would have reset inode 34493800456 nlinks from 5 to 4
would have reset inode 34493800463 nlinks from 6 to 5
would have reset inode 34782498868 nlinks from 7 to 6
would have reset inode 34782539794 nlinks from 4 to 3
would have reset inode 34782539827 nlinks from 5 to 4
would have reset inode 34782539831 nlinks from 4 to 3
would have reset inode 34782539837 nlinks from 3 to 2
would have reset inode 34847252575 nlinks from 3 to 2
would have reset inode 38654709764 nlinks from 8 to 7
would have reset inode 38704337116 nlinks from 8 to 7
would have reset inode 38704337133 nlinks from 4 to 3
would have reset inode 38719377419 nlinks from 4 to 3
would have reset inode 38719377442 nlinks from 5 to 4
would have reset inode 38719377445 nlinks from 5 to 4
would have reset inode 38720200754 nlinks from 24 to 22
would have reset inode 38720200760 nlinks from 10 to 9
would have reset inode 38720200761 nlinks from 8 to 7
would have reset inode 38720765989 nlinks from 6 to 5
would have reset inode 38720962585 nlinks from 3 to 2
would have reset inode 38825242678 nlinks from 27 to 25
would have reset inode 38829563910 nlinks from 3 to 2
would have reset inode 38829563913 nlinks from 4 to 3
would have reset inode 38829563921 nlinks from 3 to 2
would have reset inode 38829563939 nlinks from 3 to 2
would have reset inode 38829563965 nlinks from 4 to 3
would have reset inode 38829563966 nlinks from 6 to 5
would have reset inode 47272431662 nlinks from 14 to 12
would have reset inode 47280693277 nlinks from 5 to 4
would have reset inode 47280783476 nlinks from 3 to 2
would have reset inode 47332347959 nlinks from 3 to 2
would have reset inode 47332347961 nlinks from 7 to 6
would have reset inode 47332347962 nlinks from 3 to 2
would have reset inode 47335895041 nlinks from 3 to 2
would have reset inode 47336734725 nlinks from 3 to 2
would have reset inode 51539611652 nlinks from 3 to 2
would have reset inode 51539611685 nlinks from 3 to 2
would have reset inode 51602448390 nlinks from 15 to 13
would have reset inode 51699605523 nlinks from 22 to 20
would have reset inode 51699613855 nlinks from 5 to 4
would have reset inode 51700580373 nlinks from 3 to 2
would have reset inode 51736309770 nlinks from 4 to 3
would have reset inode 55834578945 nlinks from 3 to 2
would have reset inode 55951405125 nlinks from 7 to 6
would have reset inode 55951405131 nlinks from 4 to 3
would have reset inode 55951405133 nlinks from 4 to 3
would have reset inode 55952322563 nlinks from 10 to 9
would have reset inode 55952322565 nlinks from 7 to 6
would have reset inode 55952388115 nlinks from 6 to 5
would have reset inode 55952388137 nlinks from 6 to 5
would have reset inode 55986327560 nlinks from 4 to 3
would have reset inode 55986327563 nlinks from 4 to 3
would have reset inode 60208181291 nlinks from 13 to 12
would have reset inode 60208181292 nlinks from 6 to 5
would have reset inode 60276125765 nlinks from 5 to 4
would have reset inode 60276125775 nlinks from 4 to 3
would have reset inode 60276129815 nlinks from 6 to 5
would have reset inode 60276129839 nlinks from 6 to 5
would have reset inode 60276129840 nlinks from 6 to 5
would have reset inode 60276129841 nlinks from 4 to 3
would have reset inode 60276203639 nlinks from 6 to 5
would have reset inode 60276822060 nlinks from 5 to 4
would have reset inode 60276891651 nlinks from 3 to 2
would have reset inode 60276891652 nlinks from 5 to 4
would have reset inode 60276891660 nlinks from 3 to 2
would have reset inode 60276891661 nlinks from 5 to 4
would have reset inode 64424513539 nlinks from 4 to 3
would have reset inode 64471937038 nlinks from 19 to 17
would have reset inode 64484773928 nlinks from 3 to 2
would have reset inode 64551399498 nlinks from 14 to 12
would have reset inode 64551399501 nlinks from 15 to 13
would have reset inode 64551399506 nlinks from 6 to 5
would have reset inode 64551399519 nlinks from 3 to 2
would have reset inode 64551436290 nlinks from 7 to 6
would have reset inode 64551436350 nlinks from 4 to 3
would have reset inode 64551452696 nlinks from 6 to 5
would have reset inode 64796069907 nlinks from 6 to 5
would have reset inode 64796069909 nlinks from 30 to 26
would have reset inode 64796418214 nlinks from 17 to 15
would have reset inode 64796418238 nlinks from 7 to 6
would have reset inode 68748406819 nlinks from 8 to 7
would have reset inode 68840685627 nlinks from 15 to 14
would have reset inode 68912455734 nlinks from 4 to 3
would have reset inode 68912455741 nlinks from 15 to 13
would have reset inode 68912492551 nlinks from 3 to 2
would have reset inode 68912492559 nlinks from 5 to 4
would have reset inode 68912492560 nlinks from 6 to 5
would have reset inode 68912492561 nlinks from 5 to 4
would have reset inode 68912492562 nlinks from 6 to 5
would have reset inode 68912492565 nlinks from 5 to 4
would have reset inode 68912492569 nlinks from 3 to 2
would have reset inode 68912492571 nlinks from 6 to 5
would have reset inode 68912492670 nlinks from 12 to 10
would have reset inode 68912726020 nlinks from 3 to 2
would have reset inode 68996411446 nlinks from 3 to 2
would have reset inode 68996411449 nlinks from 3 to 2
would have reset inode 68996411450 nlinks from 3 to 2
would have reset inode 68996796417 nlinks from 5 to 4
would have reset inode 68996796425 nlinks from 3 to 2
would have reset inode 68997402671 nlinks from 4 to 3
would have reset inode 73014448131 nlinks from 4 to 3
would have reset inode 73014448183 nlinks from 6 to 5
would have reset inode 73031290881 nlinks from 3 to 2
would have reset inode 73105653769 nlinks from 5 to 4
would have reset inode 73105666390 nlinks from 3 to 2
would have reset inode 73105666392 nlinks from 4 to 3
would have reset inode 73105666394 nlinks from 4 to 3
would have reset inode 73105666395 nlinks from 20 to 18
would have reset inode 73105666398 nlinks from 7 to 6
would have reset inode 73105666406 nlinks from 15 to 13
would have reset inode 73105666412 nlinks from 5 to 4
would have reset inode 73105719305 nlinks from 3 to 2
would have reset inode 73105719310 nlinks from 5 to 4
would have reset inode 73105747975 nlinks from 5 to 4
would have reset inode 73272119303 nlinks from 3 to 2
would have reset inode 73272119305 nlinks from 4 to 3
would have reset inode 73272119306 nlinks from 6 to 5
would have reset inode 73272119309 nlinks from 3 to 2
would have reset inode 73306308666 nlinks from 3 to 2
would have reset inode 81786920975 nlinks from 11 to 10
would have reset inode 81786929201 nlinks from 7 to 6
would have reset inode 81786929207 nlinks from 3 to 2
would have reset inode 81786929211 nlinks from 7 to 6
would have reset inode 81786929214 nlinks from 4 to 3
would have reset inode 81786929215 nlinks from 12 to 11
would have reset inode 82064986146 nlinks from 6 to 5
would have reset inode 82065092720 nlinks from 4 to 3
would have reset inode 82065092722 nlinks from 3 to 2
would have reset inode 82065301526 nlinks from 9 to 8
would have reset inode 82201460747 nlinks from 3 to 2
would have reset inode 86092185615 nlinks from 9 to 8
would have reset inode 86092185616 nlinks from 3 to 2
would have reset inode 86092197954 nlinks from 4 to 3
would have reset inode 86092197971 nlinks from 4 to 3
would have reset inode 86092197972 nlinks from 4 to 3
would have reset inode 86092197973 nlinks from 3 to 2
would have reset inode 86092197977 nlinks from 4 to 3
would have reset inode 86092197979 nlinks from 6 to 5
would have reset inode 86092197980 nlinks from 5 to 4
would have reset inode 86092197981 nlinks from 6 to 5
would have reset inode 86092197982 nlinks from 5 to 4
would have reset inode 86092197985 nlinks from 6 to 5
would have reset inode 86092197990 nlinks from 5 to 4
would have reset inode 86092201989 nlinks from 25 to 22
would have reset inode 86092361747 nlinks from 3 to 2
would have reset inode 86092816396 nlinks from 3 to 2
would have reset inode 86093082687 nlinks from 3 to 2
would have reset inode 86093668383 nlinks from 8 to 5
would have reset inode 90194317313 nlinks from 7 to 6
would have reset inode 90271576326 nlinks from 6 to 5
would have reset inode 90328019070 nlinks from 11 to 9
would have reset inode 90328121345 nlinks from 4 to 3
would have reset inode 90328121352 nlinks from 7 to 6
would have reset inode 90328121367 nlinks from 12 to 11
would have reset inode 90328125499 nlinks from 4 to 3
would have reset inode 90328137762 nlinks from 6 to 5
would have reset inode 90328141849 nlinks from 4 to 3
would have reset inode 90328141851 nlinks from 5 to 4
would have reset inode 90328141866 nlinks from 6 to 5
would have reset inode 90516987962 nlinks from 3 to 2
would have reset inode 90516987964 nlinks from 7 to 6
would have reset inode 90517016577 nlinks from 4 to 3
would have reset inode 90517016581 nlinks from 3 to 2
would have reset inode 90549440584 nlinks from 5 to 4
would have reset inode 90549440603 nlinks from 13 to 12
would have reset inode 94489284608 nlinks from 11 to 9
would have reset inode 94489284609 nlinks from 8 to 6
would have reset inode 94489284613 nlinks from 3 to 2
would have reset inode 94489284652 nlinks from 7 to 6
would have reset inode 94489284668 nlinks from 3 to 2
would have reset inode 94536843319 nlinks from 20 to 18
would have reset inode 94562865200 nlinks from 7 to 6
would have reset inode 94587891751 nlinks from 3 to 2
would have reset inode 94587895810 nlinks from 6 to 5
would have reset inode 94587895822 nlinks from 7 to 6
would have reset inode 94659698699 nlinks from 8 to 7
would have reset inode 94659698704 nlinks from 3 to 2
would have reset inode 94659702817 nlinks from 24 to 22
would have reset inode 94659702828 nlinks from 4 to 3
would have reset inode 95118995629 nlinks from 3 to 2
would have reset inode 95118995634 nlinks from 5 to 4
would have reset inode 95118995644 nlinks from 3 to 2
would have reset inode 95157329964 nlinks from 28 to 26
would have reset inode 95375138851 nlinks from 4 to 3
would have reset inode 95375138852 nlinks from 4 to 3
would have reset inode 95375138856 nlinks from 4 to 3
would have reset inode 95375138861 nlinks from 5 to 3
would have reset inode 103079219201 nlinks from 3 to 2
would have reset inode 103166758935 nlinks from 36 to 31
would have reset inode 103166820441 nlinks from 25 to 23
would have reset inode 103166820454 nlinks from 6 to 5
would have reset inode 103166820468 nlinks from 8 to 6
would have reset inode 103167189121 nlinks from 3 to 2
would have reset inode 103167508531 nlinks from 6 to 5
would have reset inode 107374186498 nlinks from 4 to 3
would have reset inode 107374198820 nlinks from 7 to 6
would have reset inode 107599970322 nlinks from 4 to 3
would have reset inode 107600003166 nlinks from 23 to 21
would have reset inode 107600003167 nlinks from 12 to 10
would have reset inode 107663573017 nlinks from 3 to 2
would have reset inode 111686406241 nlinks from 9 to 8
would have reset inode 111886688296 nlinks from 3 to 2
would have reset inode 111887126568 nlinks from 12 to 11
would have reset inode 111887241217 nlinks from 4 to 3
would have reset inode 111887241225 nlinks from 5 to 4
would have reset inode 111887241228 nlinks from 3 to 2
would have reset inode 111895687208 nlinks from 3 to 2
would have reset inode 116192387114 nlinks from 23 to 21
would have reset inode 116343926954 nlinks from 3 to 2
would have reset inode 120329281560 nlinks from 22 to 20
would have reset inode 120362094654 nlinks from 13 to 10
would have reset inode 120448295015 nlinks from 10 to 9
would have reset inode 120472117286 nlinks from 3 to 2
would have reset inode 120472117287 nlinks from 22 to 20
would have reset inode 120472117289 nlinks from 3 to 2
would have reset inode 120472117291 nlinks from 3 to 2
would have reset inode 120533618729 nlinks from 17 to 13
would have reset inode 120533618733 nlinks from 21 to 19
would have reset inode 124571324436 nlinks from 6 to 5
would have reset inode 124656844832 nlinks from 6 to 5
would have reset inode 124656857201 nlinks from 8 to 7
would have reset inode 124656869394 nlinks from 25 to 23
would have reset inode 124689535045 nlinks from 3 to 2
would have reset inode 124689539163 nlinks from 7 to 5
would have reset inode 124753793139 nlinks from 3 to 2
would have reset inode 124753793147 nlinks from 8 to 7
would have reset inode 124753793148 nlinks from 3 to 2
would have reset inode 124753965056 nlinks from 9 to 8
would have reset inode 124762431535 nlinks from 12 to 10
would have reset inode 128857702411 nlinks from 24 to 21
would have reset inode 128857702412 nlinks from 3 to 2
would have reset inode 128857702413 nlinks from 3 to 2
would have reset inode 128987131937 nlinks from 19 to 17
would have reset inode 128987152396 nlinks from 23 to 20
would have reset inode 128991920148 nlinks from 3 to 2
would have reset inode 129135882335 nlinks from 4 to 3
would have reset inode 129135882353 nlinks from 31 to 27
would have reset inode 133143990276 nlinks from 3 to 2
would have reset inode 133143990305 nlinks from 5 to 4
would have reset inode 133252530210 nlinks from 17 to 15
would have reset inode 133252546594 nlinks from 6 to 5
would have reset inode 133252555235 nlinks from 9 to 8
would have reset inode 133306257434 nlinks from 5 to 4
would have reset inode 133306257442 nlinks from 4 to 3
would have reset inode 133306257451 nlinks from 3 to 2
would have reset inode 133306986547 nlinks from 8 to 6
would have reset inode 133306986548 nlinks from 4 to 3
would have reset inode 133306986553 nlinks from 3 to 2
No modify flag set, skipping filesystem flush and exiting.

--Apple-Mail=_BD97A2A9-D1FA-4531-8CAC-6CED9AA0264E
Content-Disposition: attachment;
	filename=xfs_repair-3.2.1.txt
Content-Type: text/plain;
	name="xfs_repair-3.2.1.txt"
Content-Transfer-Encoding: quoted-printable

Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - 13:15:50: scanning filesystem freespace - 32 of 32 allocation =
groups done
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - 13:15:50: scanning agi unlinked lists - 32 of 32 allocation =
groups done
        - process known inodes and perform inode discovery...
        - agno =3D 0
        - agno =3D 15
        - agno =3D 30
        - agno =3D 16
        - agno =3D 17
        - agno =3D 31
        - agno =3D 18
        - agno =3D 1
        - agno =3D 19
        - agno =3D 2
        - agno =3D 20
        - agno =3D 3
        - agno =3D 4
        - agno =3D 21
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
        - agno =3D 22
        - agno =3D 8
        - agno =3D 23
        - agno =3D 24
        - agno =3D 9
        - agno =3D 10
        - agno =3D 25
        - agno =3D 26
        - agno =3D 11
        - agno =3D 12
        - agno =3D 13
        - agno =3D 14
        - agno =3D 27
        - agno =3D 28
        - agno =3D 29
        - 13:15:50: process known inodes and inode discovery - 42368 of =
42368 inodes done
        - process newly discovered inodes...
        - 13:15:50: process newly discovered inodes - 32 of 32 =
allocation groups done
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - 13:15:50: setting up duplicate extent list - 32 of 32 =
allocation groups done
        - check for inodes claiming duplicate blocks...
        - agno =3D 0
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
        - agno =3D 8
        - agno =3D 9
        - agno =3D 10
        - agno =3D 11
        - agno =3D 12
        - agno =3D 13
        - agno =3D 16
        - agno =3D 17
        - agno =3D 18
        - agno =3D 20
        - agno =3D 19
        - agno =3D 22
        - agno =3D 14
        - agno =3D 24
        - agno =3D 25
        - agno =3D 26
        - agno =3D 27
        - agno =3D 28
        - agno =3D 29
        - agno =3D 23
        - agno =3D 30
        - agno =3D 31
        - agno =3D 21
        - agno =3D 15
        - 13:15:50: check for inodes claiming duplicate blocks - 42368 =
of 42368 inodes done
Phase 5 - rebuild AG headers and trees...
        - 13:15:50: rebuild AG headers and trees - 32 of 32 allocation =
groups done
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done

--Apple-Mail=_BD97A2A9-D1FA-4531-8CAC-6CED9AA0264E
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii




On 15 Aug 2015, at 00:12, Leslie Rhorer <lrhorer@mygrande.net> wrote:

> http://fletchergeek.com/images/md0.metadump.gz


--Apple-Mail=_BD97A2A9-D1FA-4531-8CAC-6CED9AA0264E
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--Apple-Mail=_BD97A2A9-D1FA-4531-8CAC-6CED9AA0264E--
