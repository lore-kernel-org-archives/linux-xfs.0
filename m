Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Apr 2008 14:26:50 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3NLQVxY010847
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2008 14:26:31 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E683DD9FC
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2008 14:27:10 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id LDRDxa68s0cu0wIZ for <xfs@oss.sgi.com>; Wed, 23 Apr 2008 14:27:10 -0700 (PDT)
Date: Wed, 23 Apr 2008 17:27:10 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: xfsprogs 2.9.8 source tarball released
In-Reply-To: <480FA0ED.90609@sandeen.net>
Message-ID: <alpine.DEB.1.10.0804231726300.14175@p34.internal.lan>
References: <op.t91vzgbk3jf8g2@pc-bnaujok.melbourne.sgi.com> <480FA0ED.90609@sandeen.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>



On Wed, 23 Apr 2008, Eric Sandeen wrote:

> Barry Naujok wrote:
>> ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs_2.9.8-1.tar.gz
>>
>> Changes since 2.9.7:
>>
>>          - Add support for sb_features2 in wrong location in mkfs.xfs,
>>            xfs_repair and xfs_db.
>>          - Improve memory limits for libxfs cache in xfs_repair and added
>>            a -m option to manually limit usage of xfs_repair.
>>          - Add -c option to xfs_admin to turn lazy-counters on/off.
>>          - Added support for mdp in libdisk/mkfs.xfs, thanks to
>>            Hubert Verstraete.
>>          - Add -p option to fsck.xfs, thanks to Markus Rothe.
>>          - Cleanup sys v3 bzero/bcopy calls, thanks to Nigel Kukard.
>>
>>
>
> This is in Fedora Rawhide now too, for anyone interested.
>
> -Eric
>
>

Does not compile on Debian Testing / x86_64:

xfsprogs-2.9.8$ make
=== include ===
rm -f xfs disk
ln -s . xfs
ln -s . disk
=== libxfs ===
/usr/bin/libtool --mode=compile gcc -I. -g -O2 -DNDEBUG -DVERSION=\"2.9.8\" -DLOCALEDIR=\"/usr/local/share/locale\" -DPACKAGE=\"xfsprogs\" -I../include -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall   -c logitem.c
  gcc -I. -g -O2 -DNDEBUG -DVERSION=\"2.9.8\" -DLOCALEDIR=\"/usr/local/share/locale\" -DPACKAGE=\"xfsprogs\" -I../include -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall -c logitem.c  -fPIC -DPIC -o .libs/logitem.o
logitem.c:21: error: expected '=', ',', ';', 'asm' or '__attribute__' before '*' token
logitem.c:22: error: expected '=', ',', ';', 'asm' or '__attribute__' before '*' token
logitem.c:33: error: expected '=', ',', ';', 'asm' or '__attribute__' before '*' token
logitem.c:132: error: expected ')' before '*' token
logitem.c:178: error: expected '=', ',', ';', 'asm' or '__attribute__' before '*' token
logitem.c:197: error: expected ')' before '*' token
logitem.c:239: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'xfs_buf_t'
logitem.c:314: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'xfs_buf_t'
logitem.c:398: error: expected ')' before '*' token
logitem.c:451: error: expected ')' before '*' token
logitem.c:467: error: expected ')' before '*' token
make[1]: *** [logitem.lo] Error 1
make: *** [default] Error 2
Command exited with non-zero status 2
0.07user 0.07system 0:00.15elapsed 94%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+25010minor)pagefaults 0swaps
