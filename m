Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p45MhRng164791 for <xfs@oss.sgi.com>; Thu, 5 May 2011 17:43:27 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A51A3435521
	for <xfs@oss.sgi.com>; Thu,  5 May 2011 15:47:04 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id AicEdQuZbap07EbS
	for <xfs@oss.sgi.com>; Thu, 05 May 2011 15:47:04 -0700 (PDT)
Received: by bwg12 with SMTP id 12so2351081bwg.26
	for <xfs@oss.sgi.com>; Thu, 05 May 2011 15:47:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTinCh1xrSv_ZFJin-OcD1xQb6V+EDw@mail.gmail.com>
References: <BANLkTikh1i3aYgXNZut+AGT-1kz=aqv-Eg@mail.gmail.com>
	<20110419082705.GI23985@dastard>
	<20110419130737.45beb611@destiny.ordissimo>
	<4DB084CE.8020600@sandeen.net>
	<20110422130920.7be686c6@destiny.ordissimo>
	<20110504091141.GA30330@infradead.org>
	<BANLkTinCh1xrSv_ZFJin-OcD1xQb6V+EDw@mail.gmail.com>
From: Anisse Astier <anisse@astier.eu>
Date: Fri, 6 May 2011 00:46:44 +0200
Message-ID: <BANLkTinkR3i6=5_nbipkGEzh4wj0JWwnpA@mail.gmail.com>
Subject: Re: xfs_repair crashing (versions 3.1.4 and 3.1.5)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Wed, May 4, 2011 at 12:24 PM, Anisse Astier <anisse@astier.eu> wrote:
> On Wed, May 4, 2011 at 11:11 AM, Christoph Hellwig <hch@infradead.org> wr=
ote:
>> On Fri, Apr 22, 2011 at 01:09:20PM +0200, Anisse Astier wrote:
>>> Yep, I figured that much, it just took me a while to get up & running
>>> another system capable of building xfsprogs.
>>>
>>> Now that I have that, and that I commented the do_warn, xfs_repair is
>>> still running after the previous failing point:
>>> [???]
>>> =A0 =A0 =A0 =A0 - agno =3D 17
>>> bad key in bmbt root (is 73434, would reset to 74194) in inode 22831781=
00 data fork
>>> bad fwd (right) sibling pointer (saw 145202888 should be NULLDFSBNO)
>>> bad data fork in inode 2283178100
>>> would have cleared inode 2283178100
>>> =A0 =A0 =A0 =A0 - agno =3D 18
>>> [???] (ongoing)
>>>
>>> Once this is done, I'll test with %llu instead of %u.
>>>
>>> But please be patient, it's a 900GB filesystem (half-full) with just an=
 800
>>> MHz ARM9 processor doing the work, so xfs_repair takes hours to complet=
e.
>>> Plus I won't have time to do many tests before next week.
>>>
>>> To be continued.
>>
>> Any updates?
>
> Well, Dave had it all figured, and replacing %u by %llu fixes indeed
> the problem.
>
> Just for future reference, the stack of crashing process:
> #0 =A0strlen () at ../ports/sysdeps/arm/strlen.S:29
> #1 =A00x40204f78 in _IO_vfprintf_internal (s=3D0xbe9a9730,
> format=3D0xbe9a7676 "27", ap=3D<value optimized out>) at vfprintf.c:1614
> #2 =A00x40205f70 in buffered_vfprintf (s=3D0x402f2668, format=3D0x88168874
> <Address 0x88168874 out of bounds>, args=3D...) at vfprintf.c:2254
> #3 =A00x40201a44 in _IO_vfprintf_internal (s=3D0x402f2668, format=3D0x7c1=
98
> "\tin inode %u (%s fork) bmap btree block %llu\n", ap=3D<value optimized
> out>) at vfprintf.c:1306
> #4 =A00x0003cd48 in do_warn (msg=3D0x7b4dc "data") at xfs_repair.c:379
> #5 =A00x00017088 in process_btinode (mp=3D<value optimized out>, agno=3D1=
7,
> ino=3D<value optimized out>, dip=3D<value optimized out>, type=3D34387,
> dirty=3D0xbe9aa418, tot=3D0x5,
> =A0 =A0nex=3D0xbe9aa418, blkmapp=3D0xbe9aa2d8, whichfork=3D-1097162040,
> check_dups=3D-1097162016) at dinode.c:1284
> #6 =A00x00017a04 in process_inode_data_fork (mp=3D<value optimized out>,
> agno=3D17, ino=3D1476724, dino=3D0x1db7800, type=3D5, dirty=3D0xbe9aa418,
> totblocks=3D0xbe9aa2d8, nextents=3D0xbe9aa2c8,
> =A0 =A0dblkmap=3D0xbe9aa2e0, check_dups=3D0) at dinode.c:2048
> #7 =A00x0001a5f0 in process_dinode_int (mp=3D<value optimized out>,
> dino=3D0x1db7800, agno=3D<value optimized out>, ino=3D<value optimized ou=
t>,
> was_free=3D0, dirty=3D0x1ad34, used=3D0x0,
> =A0 =A0verify_mode=3D-1097161704, uncertain=3D0, ino_discovery=3D1,
> check_dups=3D0, extra_attr_check=3D1, isa_dir=3D0x0, parent=3D0xbe9aa408)=
 at
> dinode.c:2631
> #8 =A00x0001ad34 in process_dinode (mp=3D0x7c198, dino=3D0x1b,
> agno=3D2283178100, ino=3D0, was_free=3D0, dirty=3D0xbe9aa418, used=3D0xbe=
9aa41c,
> ino_discovery=3D1, check_dups=3D0,
> =A0 =A0extra_attr_check=3D1, isa_dir=3D0xbe9aa414, parent=3D0xbe9aa408) a=
t dinode.c:2773
> #9 =A00x00010630 in process_inode_chunk (mp=3D0xbe9aa508, agno=3D17,
> num_inos=3D<value optimized out>, first_irec=3D<value optimized out>,
> ino_discovery=3D1, check_dups=3D0,
> =A0 =A0extra_attr_check=3D1, bogus=3D0x0) at dino_chunks.c:777
> #10 0x000110ec in process_aginodes (mp=3D0xbe9aa508, pf_args=3D0xed5c8,
> agno=3D17, ino_discovery=3D1, check_dups=3D0, extra_attr_check=3D1) at
> dino_chunks.c:1024
> #11 0x00028724 in process_ag_func (wq=3D0x400608, agno=3D17, arg=3D0xed5c=
8)
> at phase3.c:154
> #12 0x00028e24 in process_ags (mp=3D0xbe9aa508) at phase3.c:193
> #13 phase3 (mp=3D0xbe9aa508) at phase3.c:232
> #14 0x0003ddd8 in main (argc=3D<value optimized out>, argv=3D<value
> optimized out>) at xfs_repair.c:712
>
>>
>> In the meantime I cooked up a little patch (below) to add format string
>> checking to the repair-internal varargs printing helpers, which produces
>> a lot of warnings. =A0A lot of that is different underlying types for
>> fixes-size 64-bit types, but there's quite a few legit errors there as
>> well.
>>
>>
>> Index: xfsprogs-dev/repair/err_protos.h
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --- xfsprogs-dev.orig/repair/err_protos.h =A0 =A0 =A0 2011-04-22 12:45:2=
5.018475622 +0200
>> +++ xfsprogs-dev/repair/err_protos.h =A0 =A02011-04-22 12:47:22.01450846=
7 +0200
>> @@ -17,10 +17,14 @@
>> =A0*/
>>
>> =A0/* abort, internal error */
>> -void =A0__attribute__((noreturn)) do_abort(char const *, ...);
>> +void =A0__attribute__((noreturn)) do_abort(char const *, ...)
>> + =A0 =A0 =A0 __attribute__((format(printf,1,2)));
>> =A0/* abort, system error */
>> -void =A0__attribute__((noreturn)) do_error(char const *, ...);
>> +void =A0__attribute__((noreturn)) do_error(char const *, ...)
>> + =A0 =A0 =A0 __attribute__((format(printf,1,2)));
>> =A0/* issue warning */
>> -void do_warn(char const *, ...);
>> +void do_warn(char const *, ...)
>> + =A0 =A0 =A0 __attribute__((format(printf,1,2)));
>> =A0/* issue log message */
>> -void do_log(char const *, ...);
>> +void do_log(char const *, ...)
>> + =A0 =A0 =A0 __attribute__((format(printf,1,2)));
>>
>
> I'll give it a try.
Before:

Building repair
    [DEP]
    [CC]     agheader.o
    [CC]     attr_repair.o
    [CC]     avl.o
    [CC]     avl64.o
    [CC]     bmap.o
    [CC]     btree.o
    [CC]     dino_chunks.o
    [CC]     dinode.o
    [CC]     dir.o
    [CC]     dir2.o
    [CC]     globals.o
    [CC]     incore.o
    [CC]     incore_bmc.o
    [CC]     init.o
    [CC]     incore_ext.o
    [CC]     incore_ino.o
    [CC]     phase1.o
    [CC]     phase2.o
    [CC]     phase3.o
    [CC]     phase4.o
    [CC]     phase5.o
    [CC]     phase6.o
    [CC]     phase7.o
    [CC]     progress.o
    [CC]     prefetch.o
    [CC]     rt.o
    [CC]     sb.o
    [CC]     scan.o
    [CC]     threads.o
    [CC]     versions.o
    [CC]     xfs_repair.o
    [LD]     xfs_repair

After:

Building repair
    [DEP]
    [CC]     agheader.o
    [CC]     attr_repair.o
    [CC]     avl.o
    [CC]     avl64.o
    [CC]     bmap.o
bmap.c: In function 'blkmap_getn':
bmap.c:145: warning: format '%u' expects type 'unsigned int', but
argument 2 has type 'xfs_dfilblks_t'
    [CC]     btree.o
    [CC]     dino_chunks.o
    [CC]     dinode.o
dinode.c: In function 'process_btinode':
dinode.c:1272: warning: format '%d' expects type 'int', but argument 4
has type '__uint64_t'
dinode.c:1287: warning: format '%u' expects type 'unsigned int', but
argument 2 has type 'long long unsigned int'
    [CC]     dir.o
    [CC]     dir2.o
    [CC]     globals.o
    [CC]     incore.o
    [CC]     incore_bmc.o
    [CC]     init.o
    [CC]     incore_ext.o
    [CC]     incore_ino.o
    [CC]     phase1.o
    [CC]     phase2.o
    [CC]     phase3.o
    [CC]     phase4.o
    [CC]     phase5.o
    [CC]     phase6.o
phase6.c: In function 'longform_dir2_entry_check':
phase6.c:2479: warning: format '%u' expects type 'unsigned int', but
argument 2 has type 'xfs_fsize_t'
phase6.c: In function 'shortform_dir_entry_check':
phase6.c:2815: warning: too many arguments for format
    [CC]     phase7.o
    [CC]     progress.o
    [CC]     prefetch.o
    [CC]     rt.o
    [CC]     sb.o
sb.c: In function 'get_sb':
sb.c:491: warning: too many arguments for format
    [CC]     scan.o
scan.c: In function 'scanfunc_allocbt':
scan.c:567: warning: format '%d' expects type 'int', but argument 4
has type 'const char *'
scan.c:573: warning: format '%d' expects type 'int', but argument 4
has type 'const char *'
scan.c: In function 'validate_agf':
scan.c:1114: warning: format '%u' expects type 'unsigned int', but
argument 3 has type '__uint64_t'
    [CC]     threads.o
    [CC]     versions.o
    [CC]     xfs_repair.o
xfs_repair.c: In function 'calc_mkfs':
xfs_repair.c:457: warning: format '%lu' expects type 'long unsigned
int', but argument 4 has type 'xfs_agino_t'
xfs_repair.c:462: warning: format '%lu' expects type 'long unsigned
int', but argument 2 has type 'xfs_agino_t'
xfs_repair.c:466: warning: format '%lu' expects type 'long unsigned
int', but argument 2 has type 'xfs_agino_t'
xfs_repair.c:480: warning: format '%lu' expects type 'long unsigned
int', but argument 4 has type 'xfs_agino_t'
xfs_repair.c:485: warning: format '%lu' expects type 'long unsigned
int', but argument 2 has type 'xfs_agino_t'
xfs_repair.c:489: warning: format '%lu' expects type 'long unsigned
int', but argument 2 has type 'xfs_agino_t'
xfs_repair.c:503: warning: format '%lu' expects type 'long unsigned
int', but argument 4 has type 'xfs_agino_t'
xfs_repair.c:508: warning: format '%lu' expects type 'long unsigned
int', but argument 2 has type 'xfs_agino_t'
xfs_repair.c:512: warning: format '%lu' expects type 'long unsigned
int', but argument 2 has type 'xfs_agino_t'
    [LD]     xfs_repair


Stating the obvious here, but we can see the supposed crash cause in
dinode.c (%u instead %llu) is preceded by a similar error (%d instead
of %llu).
There are also other warnings that need fixing.

Anisse

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
