Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p65AhCOR251750 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 05:43:13 -0500
Received: from mail-qw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AECD01E58FB3
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2011 03:43:11 -0700 (PDT)
Received: from mail-qw0-f53.google.com (mail-qw0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id Qq8t3fGRBommJHxD
	for <xfs@oss.sgi.com>; Tue, 05 Jul 2011 03:43:11 -0700 (PDT)
Received: by qwb7 with SMTP id 7so3641862qwb.26
	for <xfs@oss.sgi.com>; Tue, 05 Jul 2011 03:43:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110704121307.GX561@dastard>
References: <CAHyte2beL-dkGJa=tFy2DV+reYqPSTVH-VOPyRdPZMaho7Hh4Q@mail.gmail.com>
	<20110704121307.GX561@dastard>
Date: Tue, 5 Jul 2011 12:43:10 +0200
Message-ID: <CAHyte2Zw==JF6PoTLZWXN_p-j2Ha-aGwX3_pbHei11vw--4yZw@mail.gmail.com>
Subject: Re: question about xfs_repair
From: =?ISO-8859-2?Q?=A3ukasz_Korczyk?= <korczyk.l@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6697385602565314435=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============6697385602565314435==
Content-Type: multipart/alternative; boundary=00235452ffec6d546604a7502600

--00235452ffec6d546604a7502600
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: quoted-printable

I have found this pice of code in xfs_repair.c:

/*
         * Adjust libxfs cache sizes based on system memory,
         * filesystem size and inode count.
         *
         * We'll set the cache size based on 3/4s the memory minus
         * space used by the inode AVL tree and block usage map.
         *
         * Inode AVL tree space is approximately 4 bytes per inode,
         * block usage map is currently 1 byte for 2 blocks.
         *
         * We assume most blocks will be inode clusters.
         *
         * Calculations are done in kilobyte units.
         */

        if (!bhash_option_used || max_mem_specified) {
                unsigned long   mem_used;
                unsigned long   max_mem;
                struct rlimit   rlim;

                libxfs_icache_purge();
                libxfs_bcache_purge();
                cache_destroy(libxfs_icache);
                cache_destroy(libxfs_bcache);

                mem_used =3D (mp->m_sb.sb_icount >> (10 - 2)) +
                                        (mp->m_sb.sb_dblocks >> (10 + 1)) +
                                        50000;  /* rough estimate of 50MB
overhead */
                max_mem =3D max_mem_specified ? max_mem_specified * 1024 :
                                                libxfs_physmem() * 3 / 4;

                if (getrlimit(RLIMIT_AS, &rlim) !=3D -1 &&
                                        rlim.rlim_cur !=3D RLIM_INFINITY) {
                        rlim.rlim_cur =3D rlim.rlim_max;
                        setrlimit(RLIMIT_AS, &rlim);
                        /* use approximately 80% of rlimit to avoid overrun
*/
                        max_mem =3D MIN(max_mem, rlim.rlim_cur / 1280);
                } else
                        max_mem =3D MIN(max_mem, (LONG_MAX >> 10) + 1);

                if (verbose > 1)
                        do_log(_("        - max_mem =3D %lu, icount =3D %ll=
u, "
                                "imem =3D %llu, dblock =3D %llu, dmem =3D
%llu\n"),
                                max_mem, mp->m_sb.sb_icount,
                                mp->m_sb.sb_icount >> (10 - 2),
                                mp->m_sb.sb_dblocks,
                                mp->m_sb.sb_dblocks >> (10 + 1));

                if (max_mem <=3D mem_used) {
                        /*
                         * Turn off prefetch and minimise libxfs cache if
                         * physical memory is deemed insufficient
                         */
                        if (max_mem_specified) {
                                do_abort(
        _("Required memory for repair is greater that the maximum
specified\n"
          "with the -m option. Please increase it to at least %lu.\n"),
                                        mem_used / 1024);
                        } else {
                                do_warn(
        _("Not enough RAM available for repair to enable prefetching.\n"
          "This will be _slow_.\n"
          "You need at least %luMB RAM to run with prefetching enabled.\n")=
,
                                        mem_used * 1280 / (1024 * 1024));
                        }
                        do_prefetch =3D 0;
                        libxfs_bhash_size =3D 64;
                } else {
                        max_mem -=3D mem_used;
                        if (max_mem >=3D (1 << 30))
                                max_mem =3D 1 << 30;
                        libxfs_bhash_size =3D max_mem / (HASH_CACHE_RATIO *
                                        (mp->m_inode_cluster_size >> 10));
                        if (libxfs_bhash_size < 512)
                                libxfs_bhash_size =3D 512;
                }

                if (verbose)
                        do_log(_("        - block cache size set to %d
entries\n"),
                                libxfs_bhash_size * HASH_CACHE_RATIO);

                if (!ihash_option_used)
                        libxfs_ihash_size =3D libxfs_bhash_size;

                libxfs_icache =3D cache_init(libxfs_ihash_size,
                                                &libxfs_icache_operations);
                libxfs_bcache =3D cache_init(libxfs_bhash_size,
                                                &libxfs_bcache_operations);
        }

I'm lack of programming skills to analyze the code and create formula which
would allow me to predict memory usage of xfs_repair.
Can some one explain how is it calculated, please?

My goal is to be able, to specify minimal requirements.

Cheers

=A3ukasz Korczyk




W dniu 4 lipca 2011 14:13 u=BFytkownik Dave Chinner <david@fromorbit.com>na=
pisa=B3:

> On Mon, Jul 04, 2011 at 11:41:49AM +0200, =A3ukasz Korczyk wrote:
> > Helo
> >
> > I have a question I wasn't able to find answer for.
> >
> > Which factors influence memory usage of xfs_repair?
> > Does any formula exist to count possible memory usage?
>
> # xfs_repair -n -vv -m 1 /dev/vda
> Phase 1 - find and verify superblock...
>        - max_mem =3D 1024, icount =3D 64, imem =3D 0, dblock =3D 42949672=
96, dmem =3D
> 2097152
> Required memory for repair is greater that the maximum specified
> with the -m option. Please increase it to at least 2096.
>
> So it's telling me I need at least 2096MB of RAM to repair my 16TB
> filesystem, of which 2097152KB is needed for tracking free space...
>
> I just added 50 million inodes to the filesystem (it now has 50M +
> 10 inodes in it), and the result is:
>
> # xfs_repair -vv -m 1 /dev/vda
> Phase 1 - find and verify superblock...
>        - max_mem =3D 1024, icount =3D 50401792, imem =3D 196882, dblock =
=3D
> 4294967296, dmem =3D 2097152
> Required memory for repair is greater that the maximum specified
> with the -m option. Please increase it to at least 2289.
>
> That is now needs at least another 200MB of RAM to run.
>
> It is worth noting that these numbers are the absolute minimum
> required and repair may require more RAM than this to complete
> successfully. If you only give it this much RAM, it will be slow;
> for best repair performance, the more RAM you can give it the
> better.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--00235452ffec6d546604a7502600
Content-Type: text/html; charset=ISO-8859-2
Content-Transfer-Encoding: base64

SSBoYXZlIGZvdW5kIHRoaXMgcGljZSBvZiBjb2RlIGluIHhmc19yZXBhaXIuYzo8YnI+PGJyPi8q
PGJyPqCgoKCgoKCgICogQWRqdXN0IGxpYnhmcyBjYWNoZSBzaXplcyBiYXNlZCBvbiBzeXN0ZW0g
bWVtb3J5LDxicj6goKCgoKCgoCAqIGZpbGVzeXN0ZW0gc2l6ZSBhbmQgaW5vZGUgY291bnQuPGJy
PqCgoKCgoKCgICo8YnI+oKCgoKCgoKAgKiBXZSYjMzk7bGwgc2V0IHRoZSBjYWNoZSBzaXplIGJh
c2VkIG9uIDMvNHMgdGhlIG1lbW9yeSBtaW51czxicj4KoKCgoKCgoKAgKiBzcGFjZSB1c2VkIGJ5
IHRoZSBpbm9kZSBBVkwgdHJlZSBhbmQgYmxvY2sgdXNhZ2UgbWFwLjxicj6goKCgoKCgoCAqPGJy
PqCgoKCgoKCgICogSW5vZGUgQVZMIHRyZWUgc3BhY2UgaXMgYXBwcm94aW1hdGVseSA0IGJ5dGVz
IHBlciBpbm9kZSw8YnI+oKCgoKCgoKAgKiBibG9jayB1c2FnZSBtYXAgaXMgY3VycmVudGx5IDEg
Ynl0ZSBmb3IgMiBibG9ja3MuPGJyPqCgoKCgoKCgICo8YnI+CqCgoKCgoKCgICogV2UgYXNzdW1l
IG1vc3QgYmxvY2tzIHdpbGwgYmUgaW5vZGUgY2x1c3RlcnMuPGJyPqCgoKCgoKCgICo8YnI+oKCg
oKCgoKAgKiBDYWxjdWxhdGlvbnMgYXJlIGRvbmUgaW4ga2lsb2J5dGUgdW5pdHMuPGJyPqCgoKCg
oKCgICovPGJyPjxicj6goKCgoKCgIGlmICghYmhhc2hfb3B0aW9uX3VzZWQgfHwgbWF4X21lbV9z
cGVjaWZpZWQpIHs8YnI+oKCgoKCgoKCgoKCgoKCgIHVuc2lnbmVkIGxvbmegoCBtZW1fdXNlZDs8
YnI+CqCgoKCgoKCgoKCgoKCgoCB1bnNpZ25lZCBsb25noKAgbWF4X21lbTs8YnI+oKCgoKCgoKCg
oKCgoKCgIHN0cnVjdCBybGltaXSgoCBybGltOzxicj48YnI+oKCgoKCgoKCgoKCgoKCgIGxpYnhm
c19pY2FjaGVfcHVyZ2UoKTs8YnI+oKCgoKCgoKCgoKCgoKCgIGxpYnhmc19iY2FjaGVfcHVyZ2Uo
KTs8YnI+oKCgoKCgoKCgoKCgoKCgIGNhY2hlX2Rlc3Ryb3kobGlieGZzX2ljYWNoZSk7PGJyPgqg
oKCgoKCgoKCgoKCgoKAgY2FjaGVfZGVzdHJveShsaWJ4ZnNfYmNhY2hlKTs8YnI+PGJyPqCgoKCg
oKCgoKCgoKCgoCBtZW1fdXNlZCA9IChtcC0mZ3Q7bV9zYi5zYl9pY291bnQgJmd0OyZndDsgKDEw
IC0gMikpICs8YnI+oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgIChtcC0m
Z3Q7bV9zYi5zYl9kYmxvY2tzICZndDsmZ3Q7ICgxMCArIDEpKSArPGJyPqCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoCA1MDAwMDugIC8qIHJvdWdoIGVzdGltYXRlIG9mIDUw
TUIgb3ZlcmhlYWQgKi88YnI+CqCgoKCgoKCgoKCgoKCgoCBtYXhfbWVtID0gbWF4X21lbV9zcGVj
aWZpZWQgPyBtYXhfbWVtX3NwZWNpZmllZCAqIDEwMjQgOjxicj6goKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoCBsaWJ4ZnNfcGh5c21lbSgpICogMyAvIDQ7PGJy
Pjxicj6goKCgoKCgoKCgoKCgoKAgaWYgKGdldHJsaW1pdChSTElNSVRfQVMsICZhbXA7cmxpbSkg
IT0gLTEgJmFtcDsmYW1wOzxicj4KoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgIHJsaW0ucmxpbV9jdXIgIT0gUkxJTV9JTkZJTklUWSkgezxicj6goKCgoKCgoKCgoKCgoKCg
oKCgoKCgoCBybGltLnJsaW1fY3VyID0gcmxpbS5ybGltX21heDs8YnI+oKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKAgc2V0cmxpbWl0KFJMSU1JVF9BUywgJmFtcDtybGltKTs8YnI+oKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKAgLyogdXNlIGFwcHJveGltYXRlbHkgODAlIG9mIHJsaW1pdCB0byBhdm9pZCBv
dmVycnVuICovPGJyPgqgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoCBtYXhfbWVtID0gTUlOKG1heF9t
ZW0sIHJsaW0ucmxpbV9jdXIgLyAxMjgwKTs8YnI+oKCgoKCgoKCgoKCgoKCgIH0gZWxzZTxicj6g
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoCBtYXhfbWVtID0gTUlOKG1heF9tZW0sIChMT05HX01BWCAm
Z3Q7Jmd0OyAxMCkgKyAxKTs8YnI+PGJyPqCgoKCgoKCgoKCgoKCgoCBpZiAodmVyYm9zZSAmZ3Q7
IDEpPGJyPgqgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoCBkb19sb2coXygmcXVvdDugoKCgoKCgIC0g
bWF4X21lbSA9ICVsdSwgaWNvdW50ID0gJWxsdSwgJnF1b3Q7PGJyPqCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKAgJnF1b3Q7aW1lbSA9ICVsbHUsIGRibG9jayA9ICVsbHUsIGRtZW0gPSAl
bGx1XG4mcXVvdDspLDxicj6goKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgIG1heF9tZW0s
IG1wLSZndDttX3NiLnNiX2ljb3VudCw8YnI+CqCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKAgbXAtJmd0O21fc2Iuc2JfaWNvdW50ICZndDsmZ3Q7ICgxMCAtIDIpLDxicj6goKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgIG1wLSZndDttX3NiLnNiX2RibG9ja3MsPGJyPqCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAgbXAtJmd0O21fc2Iuc2JfZGJsb2NrcyAmZ3Q7Jmd0OyAo
MTAgKyAxKSk7PGJyPjxicj6goKCgoKCgoKCgoKCgoKAgaWYgKG1heF9tZW0gJmx0Oz0gbWVtX3Vz
ZWQpIHs8YnI+CqCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgIC8qPGJyPqCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoCAqIFR1cm4gb2ZmIHByZWZldGNoIGFuZCBtaW5pbWlzZSBsaWJ4ZnMgY2FjaGUgaWY8
YnI+oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgICogcGh5c2ljYWwgbWVtb3J5IGlzIGRlZW1lZCBp
bnN1ZmZpY2llbnQ8YnI+oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgICovPGJyPqCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgIGlmIChtYXhfbWVtX3NwZWNpZmllZCkgezxicj4KoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoCBkb19hYm9ydCg8YnI+oKCgoKCgoCBfKCZxdW90O1JlcXVpcmVkIG1l
bW9yeSBmb3IgcmVwYWlyIGlzIGdyZWF0ZXIgdGhhdCB0aGUgbWF4aW11bSBzcGVjaWZpZWRcbiZx
dW90Ozxicj6goKCgoKCgoKAgJnF1b3Q7d2l0aCB0aGUgLW0gb3B0aW9uLiBQbGVhc2UgaW5jcmVh
c2UgaXQgdG8gYXQgbGVhc3QgJWx1LlxuJnF1b3Q7KSw8YnI+CqCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoCBtZW1fdXNlZCAvIDEwMjQpOzxicj6goKCgoKCgoKCgoKCgoKCg
oKCgoKCgoCB9IGVsc2Ugezxicj6goKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgIGRvX3dh
cm4oPGJyPqCgoKCgoKAgXygmcXVvdDtOb3QgZW5vdWdoIFJBTSBhdmFpbGFibGUgZm9yIHJlcGFp
ciB0byBlbmFibGUgcHJlZmV0Y2hpbmcuXG4mcXVvdDs8YnI+CqCgoKCgoKCgoCAmcXVvdDtUaGlz
IHdpbGwgYmUgX3Nsb3dfLlxuJnF1b3Q7PGJyPqCgoKCgoKCgoCAmcXVvdDtZb3UgbmVlZCBhdCBs
ZWFzdCAlbHVNQiBSQU0gdG8gcnVuIHdpdGggcHJlZmV0Y2hpbmcgZW5hYmxlZC5cbiZxdW90Oyks
PGJyPqCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoCBtZW1fdXNlZCAqIDEy
ODAgLyAoMTAyNCAqIDEwMjQpKTs8YnI+oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAgfTxicj4KoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKAgZG9fcHJlZmV0Y2ggPSAwOzxicj6goKCgoKCgoKCgoKCgoKCg
oKCgoKCgoCBsaWJ4ZnNfYmhhc2hfc2l6ZSA9IDY0Ozxicj6goKCgoKCgoKCgoKCgoKAgfSBlbHNl
IHs8YnI+oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAgbWF4X21lbSAtPSBtZW1fdXNlZDs8YnI+oKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKAgaWYgKG1heF9tZW0gJmd0Oz0gKDEgJmx0OyZsdDsgMzApKTxi
cj4KoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoCBtYXhfbWVtID0gMSAmbHQ7Jmx0OyAz
MDs8YnI+oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAgbGlieGZzX2JoYXNoX3NpemUgPSBtYXhfbWVt
IC8gKEhBU0hfQ0FDSEVfUkFUSU8gKjxicj6goKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKAgKG1wLSZndDttX2lub2RlX2NsdXN0ZXJfc2l6ZSAmZ3Q7Jmd0OyAxMCkpOzxicj4K
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAgaWYgKGxpYnhmc19iaGFzaF9zaXplICZsdDsgNTEyKTxi
cj6goKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgIGxpYnhmc19iaGFzaF9zaXplID0gNTEy
Ozxicj6goKCgoKCgoKCgoKCgoKAgfTxicj48YnI+oKCgoKCgoKCgoKCgoKCgIGlmICh2ZXJib3Nl
KTxicj6goKCgoKCgoKCgoKCgoKCgoKCgoKCgoCBkb19sb2coXygmcXVvdDugoKCgoKCgIC0gYmxv
Y2sgY2FjaGUgc2l6ZSBzZXQgdG8gJWQgZW50cmllc1xuJnF1b3Q7KSw8YnI+CqCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKAgbGlieGZzX2JoYXNoX3NpemUgKiBIQVNIX0NBQ0hFX1JBVElP
KTs8YnI+PGJyPqCgoKCgoKCgoKCgoKCgoCBpZiAoIWloYXNoX29wdGlvbl91c2VkKTxicj6goKCg
oKCgoKCgoKCgoKCgoKCgoKCgoCBsaWJ4ZnNfaWhhc2hfc2l6ZSA9IGxpYnhmc19iaGFzaF9zaXpl
Ozxicj48YnI+oKCgoKCgoKCgoKCgoKCgIGxpYnhmc19pY2FjaGUgPSBjYWNoZV9pbml0KGxpYnhm
c19paGFzaF9zaXplLDxicj4KoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKAgJmFtcDtsaWJ4ZnNfaWNhY2hlX29wZXJhdGlvbnMpOzxicj6goKCgoKCgoKCgoKCg
oKAgbGlieGZzX2JjYWNoZSA9IGNhY2hlX2luaXQobGlieGZzX2JoYXNoX3NpemUsPGJyPqCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgICZhbXA7bGlieGZzX2Jj
YWNoZV9vcGVyYXRpb25zKTs8YnI+CqCgoKCgoKAgfTxicj48YnI+SSYjMzk7bSBsYWNrIG9mIHBy
b2dyYW1taW5nIHNraWxscyB0byBhbmFseXplIHRoZSBjb2RlIGFuZCBjcmVhdGUgZm9ybXVsYSB3
aGljaCB3b3VsZCBhbGxvdyBtZSB0byBwcmVkaWN0IG1lbW9yeSB1c2FnZSBvZiB4ZnNfcmVwYWly
Ljxicj5DYW4gc29tZSBvbmUgZXhwbGFpbiBob3cgaXMgaXQgY2FsY3VsYXRlZCwgcGxlYXNlPzxi
cj48YnI+TXkgZ29hbCBpcyB0byBiZSBhYmxlLCB0byBzcGVjaWZ5IG1pbmltYWwgcmVxdWlyZW1l
bnRzLiA8YnI+Cjxicj5DaGVlcnMgPGJyPjxicj6jdWthc3ogS29yY3p5azxicj48YnI+PGJyPjxi
cj48YnI+PGRpdiBjbGFzcz0iZ21haWxfcXVvdGUiPlcgZG5pdSA0IGxpcGNhIDIwMTEgMTQ6MTMg
db95dGtvd25payBEYXZlIENoaW5uZXIgPHNwYW4gZGlyPSJsdHIiPiZsdDs8YSBocmVmPSJtYWls
dG86ZGF2aWRAZnJvbW9yYml0LmNvbSI+ZGF2aWRAZnJvbW9yYml0LmNvbTwvYT4mZ3Q7PC9zcGFu
PiBuYXBpc2GzOjxicj4KPGJsb2NrcXVvdGUgY2xhc3M9ImdtYWlsX3F1b3RlIiBzdHlsZT0iYm9y
ZGVyLWxlZnQ6IDFweCBzb2xpZCByZ2IoMjA0LCAyMDQsIDIwNCk7IG1hcmdpbjogMHB0IDBwdCAw
cHQgMC44ZXg7IHBhZGRpbmctbGVmdDogMWV4OyI+PGRpdiBjbGFzcz0iaW0iPk9uIE1vbiwgSnVs
IDA0LCAyMDExIGF0IDExOjQxOjQ5QU0gKzAyMDAsIKN1a2FzeiBLb3JjenlrIHdyb3RlOjxicj4K
Jmd0OyBIZWxvPGJyPgomZ3Q7PGJyPgomZ3Q7IEkgaGF2ZSBhIHF1ZXN0aW9uIEkgd2FzbiYjMzk7
dCBhYmxlIHRvIGZpbmQgYW5zd2VyIGZvci48YnI+CiZndDs8YnI+CiZndDsgV2hpY2ggZmFjdG9y
cyBpbmZsdWVuY2UgbWVtb3J5IHVzYWdlIG9mIHhmc19yZXBhaXI/PGJyPgomZ3Q7IERvZXMgYW55
IGZvcm11bGEgZXhpc3QgdG8gY291bnQgcG9zc2libGUgbWVtb3J5IHVzYWdlPzxicj4KPGJyPgo8
L2Rpdj4jIHhmc19yZXBhaXIgLW4gLXZ2IC1tIDEgL2Rldi92ZGE8YnI+ClBoYXNlIDEgLSBmaW5k
IGFuZCB2ZXJpZnkgc3VwZXJibG9jay4uLjxicj4KIKAgoCCgIKAtIG1heF9tZW0gPSAxMDI0LCBp
Y291bnQgPSA2NCwgaW1lbSA9IDAsIGRibG9jayA9IDQyOTQ5NjcyOTYsIGRtZW0gPSAyMDk3MTUy
PGJyPgpSZXF1aXJlZCBtZW1vcnkgZm9yIHJlcGFpciBpcyBncmVhdGVyIHRoYXQgdGhlIG1heGlt
dW0gc3BlY2lmaWVkPGJyPgp3aXRoIHRoZSAtbSBvcHRpb24uIFBsZWFzZSBpbmNyZWFzZSBpdCB0
byBhdCBsZWFzdCAyMDk2Ljxicj4KPGJyPgpTbyBpdCYjMzk7cyB0ZWxsaW5nIG1lIEkgbmVlZCBh
dCBsZWFzdCAyMDk2TUIgb2YgUkFNIHRvIHJlcGFpciBteSAxNlRCPGJyPgpmaWxlc3lzdGVtLCBv
ZiB3aGljaCAyMDk3MTUyS0IgaXMgbmVlZGVkIGZvciB0cmFja2luZyBmcmVlIHNwYWNlLi4uPGJy
Pgo8YnI+CkkganVzdCBhZGRlZCA1MCBtaWxsaW9uIGlub2RlcyB0byB0aGUgZmlsZXN5c3RlbSAo
aXQgbm93IGhhcyA1ME0gKzxicj4KMTAgaW5vZGVzIGluIGl0KSwgYW5kIHRoZSByZXN1bHQgaXM6
PGJyPgo8YnI+CiMgeGZzX3JlcGFpciAtdnYgLW0gMSAvZGV2L3ZkYTxicj4KUGhhc2UgMSAtIGZp
bmQgYW5kIHZlcmlmeSBzdXBlcmJsb2NrLi4uPGJyPgogoCCgIKAgoC0gbWF4X21lbSA9IDEwMjQs
IGljb3VudCA9IDUwNDAxNzkyLCBpbWVtID0gMTk2ODgyLCBkYmxvY2sgPSA0Mjk0OTY3Mjk2LCBk
bWVtID0gMjA5NzE1Mjxicj4KUmVxdWlyZWQgbWVtb3J5IGZvciByZXBhaXIgaXMgZ3JlYXRlciB0
aGF0IHRoZSBtYXhpbXVtIHNwZWNpZmllZDxicj4Kd2l0aCB0aGUgLW0gb3B0aW9uLiBQbGVhc2Ug
aW5jcmVhc2UgaXQgdG8gYXQgbGVhc3QgMjI4OS48YnI+Cjxicj4KVGhhdCBpcyBub3cgbmVlZHMg
YXQgbGVhc3QgYW5vdGhlciAyMDBNQiBvZiBSQU0gdG8gcnVuLjxicj4KPGJyPgpJdCBpcyB3b3J0
aCBub3RpbmcgdGhhdCB0aGVzZSBudW1iZXJzIGFyZSB0aGUgYWJzb2x1dGUgbWluaW11bTxicj4K
cmVxdWlyZWQgYW5kIHJlcGFpciBtYXkgcmVxdWlyZSBtb3JlIFJBTSB0aGFuIHRoaXMgdG8gY29t
cGxldGU8YnI+CnN1Y2Nlc3NmdWxseS4gSWYgeW91IG9ubHkgZ2l2ZSBpdCB0aGlzIG11Y2ggUkFN
LCBpdCB3aWxsIGJlIHNsb3c7PGJyPgpmb3IgYmVzdCByZXBhaXIgcGVyZm9ybWFuY2UsIHRoZSBt
b3JlIFJBTSB5b3UgY2FuIGdpdmUgaXQgdGhlPGJyPgpiZXR0ZXIuPGJyPgo8YnI+CkNoZWVycyw8
YnI+Cjxicj4KRGF2ZS48YnI+Cjxmb250IGNvbG9yPSIjODg4ODg4Ij4tLTxicj4KRGF2ZSBDaGlu
bmVyPGJyPgo8YSBocmVmPSJtYWlsdG86ZGF2aWRAZnJvbW9yYml0LmNvbSI+ZGF2aWRAZnJvbW9y
Yml0LmNvbTwvYT48YnI+CjwvZm9udD48L2Jsb2NrcXVvdGU+PC9kaXY+PGJyPgo=
--00235452ffec6d546604a7502600--


--===============6697385602565314435==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6697385602565314435==--
